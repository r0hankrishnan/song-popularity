#install.packages("shinydashboard")
library(shiny)
library(data.table)
library(randomForest)
library(shinydashboard)

#Read in RF model
setwd("~/Documents/GitHub/song-popularity")
model <- readRDS("~/Documents/GitHub/song-popularity/models/rfModel.rds")
explicitChoice <- c(TRUE, FALSE)
keyChoice <- c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
timesigChoice <- c(1, 3, 4, 5)
genreChoice <- c("jazz", "pop", "rock")
varnames <- colnames(train)[-1]

ui <- pageWithSidebar(
  #Page Header
  headerPanel("Song Popularity Predictor"),
  
  #Input values
  sidebarPanel(
    tags$label(h3("Input Data")),
    numericInput("duration_ms", label = "Song duration", value = 0.0),
    # radioButtons("explicit", label = "Is the song explicit?", 
    #              choices = explicitChoice, selected = character(0),
    #              inline = FALSE),
    # numericInput("danceability", label = "Song danceability", value = 0.0),
    # numericInput("energy", label = "Song energy", value = 0.0),
    # selectInput("key", label = "Song key", choices = keyChoice,
    #              selected = NULL),
    # numericInput("loudness", label = "Song loudness", value = 0.0),
    # numericInput("mode", label = "Song mode", value = 0.0),
    # numericInput("speechiness", label = "Song speechiness", value = 0.0),
    # numericInput("acousticness", label = "Song acousticness", value = 0.0),
    # numericInput("instrumentalness", label = "Song instrumentalness", 
    #              value = 0.0),
    # numericInput("liveness", label = "Song liveness", value = 0.0),
    # numericInput("valence", label = "Song valence", value = 0.0),
    # numericInput("tempo", label = "Song tempo", value = 0.0),
    # selectInput("time_signature", label = "Song time signature", 
    #             choices = timesigChoice, selected = NULL),
    # selectInput("track_genre", label = "Song genre",
    #             choices = genreChoice, selected = NULL),
    
    #Submit values
    actionButton("submitbutton", "Submit", class = "btn btn-primary")
  ),
  
  mainPanel(
    tags$label(h3("Status/Output")),
    verbatimTextOutput("contents"),
    tableOutput("tabledata")
  )
)



server <- function(input, output, session) { 
  print(input$duration_ms)
  #Input data
  # datasetInput <- reactive({
  #   
  #   df <- data.frame(
  #     Name = varnames,
  #     Value = as.character(c(input$duration_ms,
  #               input$explicit,
  #               input$danceability,
  #               input$energy,
  #               input$key,
  #               input$loudness,
  #               input$mode,
  #               input$speechiness,
  #               input$acousticness,
  #               input$instrumentalness,
  #               input$liveness,
  #               input$valence,
  #               input$tempo,
  #               input$time_signature,
  #               input$track_genre)),
  #     stringsAsFactors = FALSE
  #   )
  #   
  #   #popularity <- 0
  #   #df <- rbind(df, popularity)
  #   input <- transpose(df)
  #   write.table(input, "input.csv", sep = ",", quote = FALSE, 
  #               row.names = FALSE, col.names = FALSE)
  #   
  #   test <- read.csv(paste("input", ".csv", sep = ""), header = TRUE)
  #   output <- data.frame(prediction = predict(model, test), 
  #                        round(predict(model, test, type = "prob"), 3))
  #   print(output)
  # })
  # 
  # #Status/Output text box
  # output$contents <- renderPrint({
  #   if(input$submitbutton > 0){
  #     isolate("Calculation complete.")
  #   } else{
  #     return("Server is ready for calculation.")
  #   }
  # })
  # 
  # #Prediction results table
  # output$tabledata <- renderTable({
  #   if(input$submitbutton > 0){
  #     datasetInput()
  #  }
  #})
  }

shinyApp(ui, server)
