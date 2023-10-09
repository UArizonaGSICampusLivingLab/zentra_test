setwd("C:/Users/mbarr/OneDrive/Documents/AA Meredith Lab/R_shiny")
library("shiny")
library("shinydashboard")
library(ggplot2)
library(readr)
cleanzentra <- read_csv("cleanzentra.csv")
View(cleanzentra)



#can have it update w api every time someone opens it 
#api - one computer talks to another. ui is whatwe interact with. api is a piece of code to do the action web address

ui <- dashboardPage(
  skin = "red",
  dashboardHeader(title = "U of A Living Lab"),
  dashboardSidebar(
  ),
  
  dashboardBody(
    

    
    fluidRow(
      box(title = "Select Variables",
        width = 5,
        status = "primary",
        solidHeader = FALSE,
        collapsible = TRUE,
        selectInput("graph 1", "Select Variables Graph 1", 
                    choices = c("Rainfall", 
                                "Water Content", 
                                "Water Content In Basin", 
                                "Water Content High Ground", 
                                "Water Content 15cm",
                                "Water Content 50cm"),
                                multiple = TRUE),
        
        
        
        
        
      ),
        
      box(title = "Soil Water Moisture",
          width = 7,
          status = "primary",
          solidHeader = FALSE,
          collapsible = TRUE,
          sliderInput("TimeRange", "Select Time Range", min = 845, max = 1991, value = c(900,1000), step = 10)),
      
    ),
    
    
    
      
      
    
    fluidRow(
      box(title = "Soil Water Content",
        width = 12,
        status = "primary",
        solidHeader = FALSE,
        collapsible = TRUE,
        plotOutput("timenum_watercontent")
      )
    )
  )
)


server <- function(input, output) {
  
  output$out_timenum <- renderText(input$TimeRange)
  
  output$timenum_watercontent <- renderPlot({
    
    cleanzentra <- read_csv("cleanzentra.csv")
    cleanzentramod <- cleanzentra[cleanzentra$timeseriesnumber>=input$TimeRange[1]&cleanzentra$timeseriesnumber<=input$TimeRange[2],]
    ggplot(data = cleanzentramod, aes(x = timeseriesnumber)) + 
      geom_line(aes(y = atercontentp1), color = "red") +
      geom_line(aes(y = watercontentp2), color = "blue")
    
  })
  
}

shinyApp(ui = ui, server = server)

