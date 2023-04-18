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
library(shinydashboard)
library(plotly)

# Define UI for application
# fluidPage(theme = shinytheme("flatly"))
          

    # Application title
header <- dashboardHeader(title = "HASQI CepCorr Calculation Factors")
    
    #create conditional sidebars
sidebar <- dashboardSidebar(
      conditionalPanel(condition = "input.tabselected==1",
                       selectInput("notch_fct", "Receiver Notch:",
                                   choices = c('NoNotch', 'YesNotch'), selected = 'NoNotch'),
                       selectInput("wb_lp_fct", "Filter Bandwidth:",
                                   choices = c('WB', 'LP'), selected = 'WB'),
                       selectInput("ref_fct", "Reference Level:",
                                   choices = c('65', 'Match'), selected = '65'),
                       radioButtons("lin_nonlin_fct", "Nonlinear or Linear Fitting?",
                                    choices = c('Nonlinear', 'Linear', 'Both Nonlinear and Linear'), selected = 'Nonlinear'),
                       radioButtons("qn_fct", "Include Quiet and Noise?",
                                    choices = c('Quiet', 'Quiet and Noise'), selected = 'Quiet'),
                       radioButtons("min_max_fct", "Included Processing Levels:",
                                    choices = c('All Processing Levels', 'Min and Max Processing Levels'), 
                                    selected = 'All Processing Levels'),
                       ),
      conditionalPanel(condition="input.tabselected==2",
                       selectInput("notch_sii", "Receiver Notch:",
                                   choices = c('NoNotch', 'YesNotch'), selected = 'NoNotch'),
                       selectInput("wb_lp_sii", "Filter Bandwidth:",
                                   choices = c('WB', 'LP'), selected = 'WB'),
                       selectInput("ref_sii", "Reference Level:",
                                   choices = c('65', 'Match'), selected = '65'),
                       radioButtons("lin_nonlin_sii", "Nonlinear or Linear Fitting?",
                                    choices = c('Nonlinear', 'Linear'), selected = 'Nonlinear'),
                       radioButtons("min_max_sii", "Included Processing Levels:",
                                    choices = c('All Processing Levels', 'Min and Max Processing Levels'), 
                                    selected = 'All Processing Levels'),
                       radioButtons("level_sii", "Select Input Level:",
                                    choices = c(55, 65, 75), selected = 65),
      ),
      conditionalPanel(condition="input.tabselected==3",
                       selectInput("notch_rmse", "Receiver Notch:",
                                   choices = c('NoNotch', 'YesNotch'), selected = 'NoNotch'),
                       selectInput("wb_lp_rmse", "Filter Bandwidth:",
                                   choices = c('WB', 'LP'), selected = 'WB'),
                       selectInput("ref_rmse", "Reference Level:",
                                   choices = c('65', 'Match'), selected = '65'),
                       radioButtons("lin_nonlin_rmse", "Nonlinear or Linear Fitting?",
                                    choices = c('Nonlinear', 'Linear'), selected = 'Nonlinear'),
                       radioButtons("min_max_rmse", "Included Processing Levels:",
                                    choices = c('All Processing Levels', 'Min and Max Processing Levels'), 
                                    selected = 'All Processing Levels'),
                       radioButtons("level_rmse", "Select Input Level:",
                                    choices = c(55, 65, 75), selected = 65),
      )
    )

#Body
body <- dashboardBody(
  mainPanel(
    tabsetPanel(
      tabPanel("HASQI CepCorr Calculations", value = 1,
               h4(plotlyOutput("factorPlot"))),
      tabPanel("CepCorr vs. SII", value = 2,
               h4(plotlyOutput("siiPlot"))),
      tabPanel("CepCorr vs. RMSE", value = 3,
               h4(plotlyOutput("rmsePlot"))),
      id = "tabselected"
               
    )
  )
)

ui <- fluidPage(theme = shinytheme("flatly"), 
                dashboardPage(header, sidebar, body))


    