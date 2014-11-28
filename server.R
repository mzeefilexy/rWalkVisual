library(shiny)
library(lattice)



shinyServer(function(input, output,session) {  
  # Naismith, Aitken-Langmuir hiking function as presented in
  # https://trac.osgeo.org/grass/browser/grass/branches/releasebranch_7_0/raster/r.walk/main.c?rev=62044
  # http://grass.osgeo.org/grass70/manuals/r.walk.html
  # unit : meters, seconds
  langmuirGrass<-function(deltaV,deltaH=100,a=.72,b=6,c=1.99,d=-1.9998,slope_factor=-0.2125){
    # a default =  1/(5*(10/36)) or 0.72 seconds for 1 meter
    atand<-function(x){atan(x)*180/pi}# arc tan in degree
    mstokmh<-function(x){x/1000*3600}
    slopeP<-deltaV/deltaH
    slopeD=atand(slopeP) 
    if(slopeP>=0){
      t=deltaV*b
    }else if(slopeP < slope_factor){
      t=deltaV*d
    }else{
      t=deltaV * c
    }
    totTime=deltaH*a+t # total time for deltaH
    speed<-mstokmh(deltaH/totTime)
    #message('Slope[%]= ',slopeP,'; ',deltaH,' [m] in ', round(totTime*100)/100, ' [s]. Mean: ',speed,' km/h' )
    speed
  }
  
  observe({
    # a=0.72,b=6,c=1.99,d=-1.9998,slope_factor=-0.2125
    resetValues<-input$resetLangmuir
    updateSliderInput(session,'a',value=0.72)
    updateSliderInput(session,'b',value=6)
    updateSliderInput(session,'c',value=1.99)
    updateSliderInput(session,'d',value=-1.9998)
    updateSliderInput(session,'slope_factor',value=-0.2125)
  })
  
  output$langmuirPlot<-renderPlot({
    
  walkModel<-data.frame(
    speed=sapply(deltaV,langmuirGrass,
                deltaH=100,
                a=input$a,
                b=input$b,
                c=input$c,
                d=input$d, 
                slope_factor=input$slope_factor
                ),
    slope=seq(-40, 40,by =2))
  
  xyplot(speed~slope,walkModel,
         type='l',
         ylab='[Km/h]',
         xlab='Slope [%]', panel = function( x,y,...) {
           panel.abline( h=y[ which(x==0) ],v=x[which(x==0)], lty = "dotted", col = "black")
           panel.xyplot( x,y,...)
         }
         )
    
  })
  
})