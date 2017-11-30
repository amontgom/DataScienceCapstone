#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tm)
library(stringr)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
    # Application title
    titlePanel("Predicting the Next Word: Data Science Specialization Capstone -- Coursera"),
  
    # Sidebar with input for the predictor
    sidebarLayout(
        sidebarPanel(
            helpText("Please enter the phrase to be predicted."), br(),
            textInput("inputText", "Enter your phrase here:", value = ""), br(),
            helpText("After you enter your phrase, the predicted next word
                    will be displayed on the right side.")
        ),
    
        #Show the next-word prediction
        mainPanel(
        h2("Using backoff to predict the next word:"),
        verbatimTextOutput("nextWord"), br(),
        h3("The phrase you entered:"),
        h4(code(textOutput('words'))), hr(), br(), br(),
        img(src = 'courseraLogo.png', height = 122, width = 467),
        img(src = 'swiftkeyLogo.png', height = 300, width = 300)
        )
    )
))
