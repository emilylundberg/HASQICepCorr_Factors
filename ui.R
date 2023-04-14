#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(plotly)

# Define UI for application that draws a histogram
fluidPage(theme = shinytheme("flatly"),

    # Application title
    titlePanel("HASQI CepCorr Calculation Factors"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("Notch", "Receiver Notch:",
                        choices = c('NoNotch', 'YesNotch'), selected = 'NoNotch'),
            selectInput("WB_LP", "Filter Bandwidth:",
                        choices = c('WB', 'LP'), selected = 'WB'),
            selectInput("RefMatch", "Reference Level:",
                        choices = c('65', 'Match'), selected = '65'),
            radioButtons("Lin_nonlin", "Nonlinear or Linear Fitting?",
                         choices = c('Nonlinear', 'Linear', 'Both Nonlinear and Linear'), selected = 'Nonlinear'),
            radioButtons("Quiet_Noise", "Include Quiet and Noise?",
                        choices = c('Quiet', 'Quiet and Noise'), selected = 'Quiet'),
            radioButtons("ProcMinMax", "Included Processing Levels:",
                         choices = c('All Processing Levels', 'Min and Max Processing Levels'), 
                         selected = 'All Processing Levels')
        ),

        # Show a plot of the generated distribution
        mainPanel(
          
            tabsetPanel(type = "tabs",
                        tabPanel("HASQI CepCorr", plotlyOutput("factorPlot")),
                        tabPanel("SII Comparison", plotlyOutput("siiPlot"))
        )
    )
)
