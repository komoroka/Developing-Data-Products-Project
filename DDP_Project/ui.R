

library(shiny)

# Define UI for application that draws a time series plot
shinyUI(fluidPage(

    # Application title
    titlePanel("Developing Data Products Course Project : NASDAQ Stock Price Comparisons"),
    h4("This application allows you to compare the the prices of multiple NASDAQ stocks over time."),
    h4("Select the companies of your choice along with a date range press the 'Get Prices' button to generate a daily time series for each of these stocks."),

        # Sidebar multi select box and date range input
    sidebarLayout(
        sidebarPanel(
           uiOutput('var1_select'),
           dateRangeInput("daterange1", "Date range:",
                          start = Sys.Date()-365,
                          end = Sys.Date(),
                          min = '2015-01-01',
                          max = Sys.Date()),
           actionButton('run','Get Prices')
        ),

        # Show a plot of the time series for the relevant stocks
        mainPanel(
            plotOutput("plot1")
        )
    )
))
