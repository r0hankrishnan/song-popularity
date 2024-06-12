library(shinydashboard)
library(tidyverse)
library(randomForest)

songs <- read.csv("~/Documents/GitHub/song-popularity/data/clean_data.csv")
songs <- songs %>% select(-id)
range(songs$danceability)
keyChoice <- sort(as.vector(unique(songs$key)))
timeChoice <- sort(as.vector(unique(songs$time_signature)))
genreChoice <- as.vector(unique(songs$track_genre))


ui <- dashboardPage(
  skin = "black",

  dashboardHeader(title = "Song Popularity Prediction", titleWidth = 250),
  dashboardSidebar(
    tags$head(tags$style(".wrapper {overflow: visible !important;}")),
    #Input variables
    numericInput(inputId = "duration_ms", label = "Song Duration (ms)",
                min = 0, max = 1000000, value = 0),
    
    checkboxInput(inputId = "explicit", label = "Is the Song Explicit?",
                  value = FALSE),
    
    numericInput(inputId = "danceability", 
                 label = "Song Danceability Score (0 to 1)",
                min = 0, max = 1.00, value = 0),
    
    numericInput(inputId = "energy", label = "Song Energy Score (0 to 1)",
                 min = 0, max = 1.00, value = 0),
    
    selectInput(inputId = "key", label = "What is the Song's Key?",
                choices = keyChoice, selected = NULL, width = "100%"),
    
    numericInput(inputId = "loudness", label = "Song Loudness (0 to -100)", 
                 min = -100, max = 0, value = 0),
    
    selectInput(inputId = "mode", label = "Song Mode", 
                choices = c(0,1), selected = 0, width = "100%"),
    
    numericInput(inputId = "speechiness", label = "Song Speechiness (0 to 1)",
                 min = 0, max = 1, value = 0),
    
    numericInput(inputId = "acousticness", label = "Song Acousticness (0 to 1)",
                 min = 0, max = 1, value = 0),
    
    numericInput(inputId = "instrumentalness", 
                 label = "Song Instrumentalness (0 to 1)",
                 min = 0, max = 1, value = 0),
    
    numericInput(inputId = "liveness", 
                 label = "Song Liveness (0 to 1)",
                 min = 0, max = 1, value = 0),
    
    numericInput(inputId = "valence", 
                 label = "Song Valence (0 to 1)",
                 min = 0, max = 1, value = 0),
    
    numericInput(inputId = "tempo", 
                 label = "Song Tempo",
                 min = 0, max = 300, value = 0),
    
    selectInput(inputId = "time_signature",
                label = "Song Time Signature",
                choices = timeChoice, selected = NULL, width = "100%"),
    
    selectInput(inputId = "track_genre",
                label = "What is the Song's Genre?",
                choice = genreChoice, selected = NULL, width = "100%"),
    
    actionButton(inputId = "action",
                 label = "Run Popularity Prediction")
  ),
  
  dashboardBody(
    box(textOutput("text_result"))
   
  
  )
    )

server <- function(input, output) {
  testData <- eventReactive(input$action, {
    newData <- data.frame(
      duration_ms = input$duration_ms,
      explicit = input$explicit,
      danceability = input$danceability,
      energy = input$energy,
      key = as.numeric(input$key),
      loudness = input$loudness,
      mode = as.numeric(input$mode),
      speechiness = input$speechiness,
      acousticness = input$acousticness,
      instrumentalness = input$instrumentalness,
      liveness = input$liveness,
      valence = input$valence,
      tempo = input$tempo,
      time_signature = as.numeric(input$time_signature),
      track_genre = input$track_genre
    )
  })
  
  prediction <- eventReactive(input$action, {
    rf_model <- readRDS("~/Documents/GitHub/song-popularity/song-popularity-dashboard/randomforest.RDS")
    
    
    pred <- predict(rf_model, testData(), type = "response")
    
    pred
  })
  
  output$text_result <- renderText({
    predNum <- as.numeric(prediction())
    
    paste0("The song's predicted popularity is: ", round(predNum,2))
  })
  
}

shinyApp(ui, server)
