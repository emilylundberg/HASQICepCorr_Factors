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
server <- function(input, output, session) {

    plot_data_fct <- reactive({
      df <- csshiny_df %>%
        filter(Notch == input$notch_fct) %>%
        filter(WB_LP == input$wb_lp_fct) %>%
        filter(RefMatch == input$ref_fct) 
      
      if (input$lin_nonlin_fct %in% c("Linear", "Nonlinear")) {
        df <- df %>% filter(Lin_nonlin == input$lin_nonlin_fct)
      }
      
      if (input$qn_fct == "Quiet") {
        df <- df %>% filter(Quiet_Noise == input$qn_fct)
      }
      
      if (input$min_max_fct == "Min and Max Processing Levels") {
        df <- df %>% filter(ProcMinMax %in% c("Min", "Max"))
      }
      
      return(df)
    })
    
    plot_data_sii <- reactive({
      df <- csshiny_df %>%
        filter(Notch == input$notch_sii) %>%
        filter(WB_LP == input$wb_lp_sii) %>%
        filter(RefMatch == input$ref_sii) %>%
        filter(Level == input$level_sii) %>% 
        filter(Lin_nonlin == input$lin_nonlin_sii) %>% 
        filter(Quiet_Noise == 'Quiet') %>%
        mutate(Processing = as_factor(Processing))
      
      if (input$min_max_sii == "Min and Max Processing Levels") {
        df <- df %>% filter(ProcMinMax %in% c("Min", "Max"))
      }
      
      return(df)
    })
    
    plot_data_rmse <- reactive({
      df <- csshiny_df %>%
        filter(Notch == input$notch_rmse) %>%
        filter(WB_LP == input$wb_lp_rmse) %>%
        filter(RefMatch == input$ref_rmse) %>%
        filter(Level == input$level_rmse) %>% 
        filter(Lin_nonlin == input$lin_nonlin_rmse) %>% 
        filter(Quiet_Noise == 'Quiet') %>%
        mutate(Processing = as_factor(Processing))
      
      if (input$min_max_rmse == "Min and Max Processing Levels") {
        df <- df %>% filter(ProcMinMax %in% c("Min", "Max"))
      }
      
      return(df)
      
    })
    
    
    output$factorPlot <- renderPlotly({
        
      if (input$qn_fct == "Quiet and Noise") {
        factor_plot <- ggplot(plot_data_fct(), aes(x = Level, y = HASQICepCorr,
                                      group = interaction(Processing, Quiet_Noise),
                                      color = Processing, linetype = Quiet_Noise)) 
        
      } else if (input$lin_nonlin_fct == "Both Nonlinear and Linear") {
        factor_plot <- ggplot(plot_data_fct(), aes(x = Level, y = HASQICepCorr,
                                      group = interaction(Processing, Lin_nonlin),
                                      color = Processing, linetype = Lin_nonlin))
      } else {
        
        factor_plot <- ggplot(plot_data_fct(), aes(x = Level, y = HASQICepCorr, color = Processing)) 
      }
   
      factor_plot <- factor_plot +
        geom_point() +
        geom_line() +
        scale_color_carto_d(palette = 'Prism') +
        theme_minimal() +
        labs(x = "Level (dB)") +
        labs(y = "HASQI CepCorr") +
        scale_y_continuous(breaks = c(0, 0.20, 0.40, 0.60, 0.80, 1.00), limits = c(0, 1.00)) +
        scale_x_continuous(breaks = c(55, 65, 75), limits = c(55, 75)) +
        facet_wrap(~ParticipantID) 
      
      factor_plot <- ggplotly(factor_plot)
      
      factor_plot
    })

    output$siiPlot <- renderPlotly({
      
      sii_plot <- ggplot(plot_data_sii(), aes(x = sii, y = HASQICepCorr, color = Processing))  +
        geom_point() +
        scale_color_carto_d(palette = 'Prism') +
        theme_minimal() +
        labs(x = "SII") +
        labs(y = "HASQI CepCorr") +
        scale_y_continuous(breaks = c(0, 0.20, 0.40, 0.60, 0.80, 1.00), limits = c(0, 1.00)) +
        scale_x_continuous(breaks = c(0, 20, 40, 60, 80, 100), limits = c(0, 100)) +
        facet_wrap(~ParticipantID) 
      
      sii_plot <- ggplotly(sii_plot)
      
      sii_plot
    })
    
    output$rmsePlot <- renderPlotly({
      
      rmse_plot <- ggplot(plot_data_rmse(), aes(x = rmse, y = HASQICepCorr, color = Processing))  +
        geom_point() +
        scale_color_carto_d(palette = 'Prism') +
        theme_minimal() +
        labs(x = "RMSE") +
        labs(y = "HASQI CepCorr") +
        scale_y_continuous(breaks = c(0, 0.20, 0.40, 0.60, 0.80, 1.00), limits = c(0, 1.00)) +
       # scale_x_continuous(breaks = c(0, 20, 40, 60, 80, 100), limits = c(0, 30)) +
        facet_wrap(~ParticipantID) 
      
      rmse_plot <- ggplotly(rmse_plot)
      
      rmse_plot
    })
}
