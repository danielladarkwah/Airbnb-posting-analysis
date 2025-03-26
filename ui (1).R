#install.packages("shinydashboard")
library(shiny)
library(ggplot2)
library(igraph)
library(ggraph)
library(dplyr)
library(plotly)
library(DT)  # For rendering tables
library(corrplot) 
library(shinydashboard)



# Define the header, sidebar, and body of the dashboard
header <- dashboardHeader(title = "Airbnb Data Visualization Dashboard")
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Correlation Heatmap", tabName = "correlationHeatmap", icon = icon("area-chart")),
    menuItem("Guest Satisfaction", tabName = "guestSatisfaction", icon = icon("bar-chart")),
    menuItem("Country Sentiments", tabName = "countrySentiments", icon = icon("globe")),
    menuItem("Common Words Network", tabName = "commonWords", icon = icon("sitemap")),
    menuItem("Property Type Sentiments", tabName = "propertyTypeSentiments", icon = icon("building"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "dashboard",
            fluidRow(
              box(plotOutput("plotCountrySentiments"), width = 6),
              box(plotOutput("plotGuestSatisfaction"), width = 6)
            ),
            fluidRow(
              box(plotOutput("plotCommonWords"), width = 6),
              box(plotOutput("plotAvgSentPropertyType"), width = 6)
            )
    ),
    tabItem(tabName = "correlationHeatmap", 
            box(plotOutput("plotCorrelationHeatmap"), width = 12)
    ),
    tabItem(tabName = "guestSatisfaction", 
            box(plotOutput("plotGuestSatisfaction"), width = 12)
    ),
    tabItem(tabName = "countrySentiments", 
            box(plotOutput("plotCountrySentiments"), width = 12)
    ),
    tabItem(tabName = "commonWords", 
            box(plotOutput("plotCommonWords"), width = 12)
    ),
    tabItem(tabName = "propertyTypeSentiments", 
            box(plotOutput("plotAvgSentPropertyType"), width = 12)
    )
  )
)

# Create the dashboard
ui <- dashboardPage(header, sidebar, body)





#Load datasets outside of the server function so they load when the app starts
property_type_sentiments <- read.csv("average_sentiment_per_property_type.csv")
common_words <- read.csv("bigram_counts.csv")
country_sentiments <- read.csv("average_sentiment_per_country.csv")
top_termsPT <- read.csv("top_terms_per_topic.csv")
guest_satisfaction <- read.csv("review_scores_by_property.csv")
correlaton <- read.csv("correlation_matrix.csv")



# Define the user interface for the dashboard
ui <- fluidPage(
  titlePanel("Airbnb Data Visualization Dashboard"),
  tabsetPanel(
    tabPanel("Correlation Heatmap", plotOutput("plotCorrelationHeatmap")),
    tabPanel("Guest Satisfaction", plotOutput("plotGuestSatisfaction")),
    tabPanel("Top Terms per Topic", plotOutput("plotTopTerms")),
    tabPanel("Country Sentiments", plotOutput("plotCountrySentiments")),
    tabPanel("Common Words", plotOutput("plotCommonWords")),
    tabPanel("Average Sentiment per Property Type", plotOutput("plotAvgSentPropertyType"))
  )
)

# Define server logic to create plots
server <- function(input, output) {
  # Load pre-processed dataframes here or inside the respective render functions
  
  # Define consistent colors for high and low values
  low_value_color <- "grey"
  high_value_color <- "steelblue"  # Adjust as needed
  
  # Correlation Heatmap Visualization# Load the correlation CSV
  correlation_data <- read.csv("correlation_matrix.csv", check.names = FALSE, stringsAsFactors = FALSE)
  
  # Drop the first column if it's just row names, then convert all to numeric
  correlation_data <- correlation_data[,-1]
  correlation_matrix <- data.matrix(correlation_data)
  
  # Compute the correlation matrix
  corr_matrix <- cor(correlation_matrix, use = "complete.obs")
  
  # Visualize the correlation matrix with corrplot
  output$plotCorrelationHeatmap <- renderPlot({
    corrplot(corr_matrix, method = "color", tl.cex = 0.7, tl.col = "black", cl.lim = c(-1, 1))
  })
  
  # Guest Satisfaction Visualization
  output$plotGuestSatisfaction <- renderPlot({
    guest_satisfaction <- head(guest_satisfaction, 10)
    ggplot(guest_satisfaction, aes(x = reorder(property_type, average_review_score), y = average_review_score, fill = average_review_score)) +
      geom_col() +
      coord_flip() +
      scale_fill_gradient(low = "grey", high = "blue") +
      labs(x = "Property Type", y = "Average Review Score")
  })
  
  # Top Terms per Topic Visualization
  output$plotTopTerms <- renderPlot({
    top_termsPT <- head(top_termsPT, 10)
    ggplot(top_termsPT, aes(x = reorder(term, scaled_beta), y = scaled_beta, fill = scaled_beta)) +
      geom_col() +
      coord_flip() +
      scale_fill_gradient(low = "grey", high = "blue") +
      labs(x = "Term", y = "Scaled Beta")
  })
  
  # Country Sentiments Visualization
  output$plotCountrySentiments <- renderPlot({
    ggplot(country_sentiments, aes(x = reorder(address.country, average_sentiment), y = average_sentiment, fill = average_sentiment)) +
      geom_col() +
      coord_flip() +
      scale_fill_gradient(low = "grey", high = "blue") +
      labs(x = "Country", y = "Average Sentiment")
  })
  
  # Network Graph for Bigrams
  output$plotCommonWords <- renderPlot({
    # Assuming 'common_words' has columns 'word1', 'word2', and 'n' and is already loaded
    # Create a graph from the bigram data
    bigram_graph <- graph_from_data_frame(dplyr::top_n(common_words, 50, n))
    # Plot the network
    ggraph(bigram_graph, layout = "fr") +
      geom_edge_link(aes(edge_width = n), edge_colour = low_value_color) +
      geom_node_point(size = 5, color = high_value_color) +
      geom_node_text(aes(label = name), check_overlap = TRUE, color = high_value_color) +
      theme_void()
  })
  
  # Average Sentiment per Property Type Visualization
  output$plotAvgSentPropertyType <- renderPlot({
    property_type_sentiments <- head(property_type_sentiments, 10)
    ggplot(property_type_sentiments, aes(x = reorder(property_type, average_sentiment), y = average_sentiment, fill = average_sentiment)) +
      geom_col() +
      coord_flip() +
      scale_fill_gradient(low = "grey", high = "purple") +
      labs(x = "Property Type", y = "Average Sentiment")
  })
}

# Run the dashboard
shinyApp(ui = ui, server = server)
