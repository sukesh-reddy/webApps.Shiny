###########################################
# data Driven Application
# Modelling
############################################



# Importing libraries
library(shiny)
library(shinythemes)
library(randomForest)
library(data.table)
library(RCurl)

# reading the data
weather <- read.csv(text = getURL('https://raw.githubusercontent.com/dataprofessor/data/master/weather-weka.csv'))

# modelling
# model <- randomForest(play~.,data=weather,ntree=500,mtry=4,importance=T)

# Save model to RDS file
# saveRDS(model, "model.rds")

# Read in the RF model
# model <- readRDS("model.rds")

#################
# Shiny App
# User interface
#################

ui <- fluidPage(theme = shinytheme('united'),
                headerPanel('Play Golf?'),
                sidebarPanel(HTML('<h3>Input Parameters</h3>'),
                             selectInput('outlook',label = "Outlook:",
                                         choices=list('Sunny'='sunny', "Overcast" = "overcast", "Rainy" = "rainy"),
                                         selected = 'Rainy'),
                             sliderInput('temperature',"Temperature:",
                                         min=64,max=86,
                                         value=70),
                             sliderInput('humidity',"Humidity:",
                                         min=65,max=86,
                                         value=90),
                             selectInput("windy", label = "Windy:", 
                                         choices = list("Yes" = "TRUE", "No" = "FALSE"), 
                                         selected = "TRUE"),
                             actionButton('submitbutton','Submit',class='btn btn-primary')),
                mainPanel(tags$label(h3('Status/output')),
                          verbatimTextOutput('contents'),
                          tableOutput('tabledata')
                          )
                )
# Server Function
server <- function(input,output,session){
  
  datasetInput <- reactive({
    df <- data.frame(
      Name=c('outlook',
              'temperature',
              'humidity',
              'windy'),
      Value = as.character(c(input$outlook,
                             input$temperature,
                             input$humidity,
                             input$windy)),
      stringsAsFactors = F)
    play <- 'play'
    df <- rbind(df,play)
    input <- transpose(df)
    write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    
    test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
    
    test$outlook <- factor(test$outlook, levels = c("overcast", "rainy", "sunny"))
    
    
    Output <- data.frame(Prediction=predict(model,test), round(predict(model,test,type="prob"), 3))
    print(Output)
  })
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}

####################################
# Create the shiny app             #
####################################
shinyApp(ui = ui, server = server)
