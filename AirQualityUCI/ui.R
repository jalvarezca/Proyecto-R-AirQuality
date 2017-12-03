#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


library(shiny)
library(shinydashboard)
#library(DT)
#library(data.table)

dashboardPage(skin = "blue",
              dashboardHeader(title = "AirQualityCapstone"),
              dashboardSidebar(
                sidebarMenu(
                  menuItem("Histogramas", tabName = "dashboard", icon = icon("bar-chart-o")),
                  menuItem("Line Plot", tabName = "linePlot", icon = icon("dashboard"))
                )
              ),
              ## Body content
              dashboardBody(
                tabItems(
                  # First tab content
                  tabItem(tabName = "dashboard",
                          fluidRow(
                            box(
                              title = "Controls1", 
                              status = "warning", 
                              solidHeader = TRUE,  
                              collapsible = TRUE,
                              sliderInput("slider1", "Number of observations:", 1, 30, 10)
                            )
                          ),
                          fluidRow(
                            box(title = "CO agrupado por dia", 
                                status = "primary",
                                solidHeader = TRUE,
                                collapsible = FALSE,
                                background = "light-blue",
                                width = 400,
                                plotOutput("plotCODia", height = 350)
                            )
                          ),
                          fluidRow(
                            box(
                              title = "Controls 2", 
                              status = "warning", 
                              solidHeader = TRUE,  
                              collapsible = FALSE,
                              sliderInput("slider2", "Number of observations2:", 1, 30, 10)
                            )
                          ),
                          fluidRow(
                            box(title = "CO por Mes", 
                                status = "primary",
                                solidHeader = TRUE,
                                collapsible = FALSE,
                                background = "light-blue",
                                width = 400,
                                plotOutput("plotCOMes", height = 350)
                            )
                          )
                          
                  )
                  ,

                  ## Second tab content
                  tabItem(tabName = "linePlot",
                          fluidRow(
                            box(
                              title = "Controls 3",
                              status = "warning",
                              solidHeader = TRUE,
                              collapsible = FALSE,
                              sliderInput("slider3", "Range:",
                                          min = 1917, max = 2014,
                                          value = c(1920,2010))
                            )
                          #,
                          #   box(
                          #     title = "Plot of year, sum of gross and qty of movies",
                          #     status = "primary",
                          #     soludHeader = TRUE,
                          #     collapsible = FALSE,
                          #     background = "green",
                          #     width=12,
                          #     plotOutput(outputId = "lineplot", height=600))
                           )
                  )
                )
              )
)

