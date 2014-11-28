library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(
  
  #  Application title
  headerPanel("GRASS r.walk visual formula"),
  #h2('Naismith, Aitken-Langmuir hiking function'),
  
  # Sidebar with sliders that demonstrate various available options
  sidebarPanel(
    
    
    # base speed#
    # conversion back to kmh: 1/a/1000*3600
    sliderInput("a", "Base 1/speed [s/m] (a)", 
                min=0, max=2, value=0,step=0.001),
    
    # upHill
    sliderInput("b", "Uphill coef. (b)", 
                min = -10, max = 10, value = 0, step= 0.0001),
    
    # downhill
    sliderInput("c", "Downhill coef. (c)",
                min = -10, max = 10, value = 0, step= 0.0001),
    
    # downhill steep
    sliderInput("d", "Downhill (steep) coef. (d)",
                min = -10, max = 10, value = 0 , step= 0.0001),
    
    # slope factor
    sliderInput("slope_factor", "Slope factor (slope_factor)",
                min = -10, max = 10, value=0, step= 0.0001),
    actionButton("resetLangmuir", "Reset original value")
  ),
  
  
  # Show a table summarizing the values entered
  mainPanel(
    plotOutput("langmuirPlot")
  )
))