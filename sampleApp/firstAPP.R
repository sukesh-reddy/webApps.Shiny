############################
# My First Web App
###########################

# Load R Packages
# install.packages(c('shiny','shinythemes'))
library(shiny)
library(shinythemes)


# Define UI 

ui <- fluidPage(theme = shinytheme('superhero'), #For available themes you can go to https://rstudio.github.io/shinythemes/
                navbarPage(
                  'My First App',
                  tabPanel("Navbar 1",
                           sidebarPanel(
                             tags$h3("Input:"),
                             textInput('txt1',"Given Name:",""),
                             textInput('txt2',"Surname:","")
                           ),
                           mainPanel(
                             h1('Header 1'),
                             h4('Output1'),
                             verbatimTextOutput('txtoutput')
                           )),
                  tabPanel("Navbar 2", "This panel is intentionally left blank"),
                  tabPanel("Navbar 3", "This panel is intentionally left blank")
                ))


# Define Server Function
server <- function(input,output){
  output$txtoutput <- renderText({
    paste(input$txt1,input$txt2,sep=" ")
  }) 
  
}


# Create shiny object (fusion the UI and Server)
shinyApp(ui=ui,server = server)