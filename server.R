#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(rcartocolor)

########################
# Read in the dataframe
########################

#set wd to folder where .pdf file is located
setwd("/Users/emilu/Desktop/Hearlab/FF/dfs")

#path to csv df
metric_path <- file.path("..", "dfs")

#read in the df for processing diffs
csshiny_df <- read_csv(file.path(metric_path, "CS_shiny.csv"))

csshiny_df$Processing <- factor(csshiny_df$Processing, levels = 
                                  c('3', '2', '1', '110', '100', '90', '80', '70', '60'))

csshiny_df$Quiet_Noise <- factor(csshiny_df$Quiet_Noise, levels = 
                                  c('Quiet', 'Noise10'))


# Define server logic required to draw a histogram
function(input, output, session) {

    plot_data <- reactive({
      df <- csshiny_df %>%
        filter(Notch == input$Notch) %>%
        filter(WB_LP == input$WB_LP) %>%
        filter(RefMatch == input$RefMatch)
      
      if (input$Lin_nonlin %in% c("Linear", "Nonlinear")) {
        df <- df %>% filter(Lin_nonlin == input$Lin_nonlin)
      }
      
      if (input$Quiet_Noise == "Quiet") {
        df <- df %>% filter(Quiet_Noise == input$Quiet_Noise)
      }
      
      if (input$ProcMinMax == "Min and Max Processing Levels") {
        df <- df %>% filter(ProcMinMax %in% c("Min", "Max"))
      }
      
      return(df)
    })
    
    output$factorPlot <- renderPlotly({
        
      if (input$Quiet_Noise == "Quiet and Noise") {
        factor_plot <- ggplot(plot_data(), aes(x = Level, y = HASQICepCorr,
                                      group = interaction(Processing, Quiet_Noise),
                                      color = Processing, linetype = Quiet_Noise)) 
        
      } else if (input$Lin_nonlin == "Both Nonlinear and Linear") {
        factor_plot <- ggplot(plot_data(), aes(x = Level, y = HASQICepCorr,
                                      group = interaction(Processing, Lin_nonlin),
                                      color = Processing, linetype = Lin_nonlin))
      } else {
        
        factor_plot <- ggplot(plot_data(), aes(x = Level, y = HASQICepCorr, color = Processing)) 
      }
   
      factor_plot <- factor_plot +
        geom_point() +
        geom_line() +
        scale_color_carto_d(palette = 'Prism') +
        theme_minimal() +
        labs(x = "Level (dB)") +
        labs(y = "HASQI CepCorr") +
        scale_y_continuous(breaks = c(0, 0.20, 0.40, 0.60, 0.80, 1.00), limits = c(0, 1.00)) +
        facet_wrap(~ParticipantID) 
      
      factor_plot <- ggplotly(factor_plot)
      
      factor_plot
    })

    output$siiPlot <- renderPlotly({
      
      if (input$Quiet_Noise == "Quiet and Noise") {
        sii_plot <- ggplot(plot_data(), aes(x = Level, y = HASQICepCorr,
                                               group = interaction(Processing, Quiet_Noise),
                                               color = Processing, linetype = Quiet_Noise)) 
        
      } else if (input$Lin_nonlin == "Both Nonlinear and Linear") {
        sii_plot <- ggplot(plot_data(), aes(x = Level, y = HASQICepCorr,
                                               group = interaction(Processing, Lin_nonlin),
                                               color = Processing, linetype = Lin_nonlin))
      } else {
        
        sii_plot <- ggplot(plot_data(), aes(x = Level, y = HASQICepCorr, color = Processing)) 
      }
      
      sii_plot <- sii_plot +
        geom_point() +
        geom_line() +
        scale_color_carto_d(palette = 'Prism') +
        theme_minimal() +
        labs(x = "Level (dB)") +
        labs(y = "HASQI CepCorr") +
        scale_y_continuous(breaks = c(0, 0.20, 0.40, 0.60, 0.80, 1.00), limits = c(0, 1.00)) +
        facet_wrap(~ParticipantID) 
      
      sii_plot <- ggplotly(sii_plot)
      
      sii_plot
    })
}
