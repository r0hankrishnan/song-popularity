library(shiny)
library(bs4Dash)
library(tidyverse)
library(randomForest)
library(DT)
library(plotly)

# --- Load data and model ---
songs <- read.csv("~/Documents/GitHub/song-popularity/data/clean_data.csv") %>%
  select(-id)

rf.mod <- randomForest(
  popularity ~ ., 
  data = songs,
  mtry = 5, 
  ntree = 501, 
  importance = TRUE
)

# --- UI ---
ui <- dashboardPage(
  title = "Song Popularity Dashboard",
  
  header = dashboardHeader(title = "Song Popularity"),
  
  sidebar = dashboardSidebar(
    sidebarMenu(
      menuItem("Predict & Visualize", tabName = "predict", icon = icon("chart-line"))
    )
  ),
  
  body = dashboardBody(
    tabItems(
      tabItem(tabName = "predict",
              fluidRow(
                # Inputs
                box(
                  title = "Inputs", width = 4, status = "primary", solidHeader = TRUE,
                  numericInput("duration_ms", "Duration (ms)", value = 50000, min = 1000, step = 1000),
                  checkboxInput("explicit", "Explicit?", value = TRUE),
                  sliderInput("danceability", "Danceability", 0, 1, 0.25),
                  sliderInput("energy", "Energy", 0, 1, 0.25),
                  numericInput("key", "Key", value = 3, min = 0, max = 11),
                  numericInput("loudness", "Loudness (dB)", value = -50),
                  selectInput("mode", "Mode", choices = c(0, 1), selected = 1),
                  sliderInput("speechiness", "Speechiness", 0, 1, 0.25),
                  sliderInput("acousticness", "Acousticness", 0, 1, 0.25),
                  sliderInput("instrumentalness", "Instrumentalness", 0, 1, 0.25),
                  sliderInput("liveness", "Liveness", 0, 1, 0.25),
                  sliderInput("valence", "Valence", 0, 1, 0.25),
                  numericInput("tempo", "Tempo (BPM)", value = 153),
                  numericInput("time_signature", "Time Signature", value = 4),
                  selectInput("track_genre", "Genre", choices = unique(songs$track_genre), selected = "pop"),
                  actionButton("predict", "Predict Popularity", class = "btn-primary")
                ),
                
                # Outputs
                box(
                  width = 8, status = "info", solidHeader = TRUE,
                  div(
                    style = "font-size: 3em; font-weight: bold; text-align: center; margin-bottom: 20px;",
                    textOutput("prediction")
                  ),
                  div(
                    style = "overflow-y: auto; max-height: 300px; margin-bottom: 20px;",
                    DTOutput("input_table")
                  ),
                  plotlyOutput("scatter_plot", height = "500px")
                )
              )
      )
    )
  )
)

# --- SERVER ---
server <- function(input, output, session) {
  
  # User inputs (force correct types to match training data)
  userData <- reactive({
    tibble(
      duration_ms = as.numeric(input$duration_ms),
      explicit = as.logical(input$explicit),
      danceability = as.numeric(input$danceability),
      energy = as.numeric(input$energy),
      key = as.integer(input$key),
      loudness = as.numeric(input$loudness),
      mode = as.integer(input$mode),
      speechiness = as.numeric(input$speechiness),
      acousticness = as.numeric(input$acousticness),
      instrumentalness = as.numeric(input$instrumentalness),
      liveness = as.numeric(input$liveness),
      valence = as.numeric(input$valence),
      tempo = as.numeric(input$tempo),
      time_signature = as.integer(input$time_signature),
      track_genre = as.character(input$track_genre)
    )
  })
  
  # Prediction
  predData <- eventReactive(input$predict, {
    df <- userData()
    df$popularity <- predict(rf.mod, df)
    df
  })
  
  # Prediction output
  output$prediction <- renderText({
    if (is.null(predData())) "—" else round(predData()$popularity, 2)
  })
  
  # Input summary
  output$input_table <- renderDT({
    userData() %>%
      pivot_longer(everything(), names_to = "Attribute", values_to = "Value") %>%
      datatable(options = list(dom = "t", pageLength = 20))
  })
  
  # Scatter plot
  output$scatter_plot <- renderPlotly({
    p <- ggplot(songs, aes(x = duration_ms, y = popularity)) +
      geom_point(alpha = 0.5, color = "black") +
      labs(x = "Duration (ms)", y = "Popularity")
    
    if (!is.null(predData())) {
      # Only take numeric cols needed
      pred_point <- predData() %>% select(duration_ms, popularity)
      p <- p + geom_point(
        data = pred_point,
        aes(x = duration_ms, y = popularity),
        color = "red", size = 3
      )
    }
    
    ggplotly(p)
  })
}

shinyApp(ui, server)
