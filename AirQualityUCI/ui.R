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
                  menuItem("Analisis de CO", tabName = "CO", icon = icon("bar-chart-o")),
                  menuItem("Analisis de NMHC", tabName = "NMHC", icon = icon("bar-chart-o")),
                  menuItem("Analisis de C6H6", tabName = "C6H6", icon = icon("bar-chart-o"))
                )
              ),
              ## Body content
              dashboardBody(
                tabItems(
                  # Primer Tab - Analisi de CO
                  tabItem(tabName = "CO",
                          fluidRow(
                            box(title = "CO por dia", 
                                status = "primary",
                                solidHeader = TRUE,
                                collapsible = FALSE,
                                background = "light-blue",
                                width = 400,
                                plotOutput("plotCODia", height = 350)
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

                  ## Segundo Tab Ananlisis de NMHC
                  tabItem(tabName = "NMHC",
                          fluidRow(
                            box(title = "NMHC por dia", 
                                status = "primary",
                                solidHeader = TRUE,
                                collapsible = FALSE,
                                background = "light-blue",
                                width = 400,
                                plotOutput("plotNMHCDia", height = 350)
                            )
                          ),
                          
                          fluidRow(
                            box(title = "NMHC por Mes", 
                                status = "primary",
                                solidHeader = TRUE,
                                collapsible = FALSE,
                                background = "light-blue",
                                width = 400,
                                plotOutput("plotNMHCMes", height = 350)
                            )
                          )
                )
                ,
                ## Tercer Tab Ananlisis de C6H6
                tabItem(tabName = "C6H6",
                        fluidRow(
                          box(title = "C6H6 por dia", 
                              status = "primary",
                              solidHeader = TRUE,
                              collapsible = FALSE,
                              background = "light-blue",
                              width = 400,
                              plotOutput("plotC6H6Dia", height = 350)
                          )
                        ),
                        
                        fluidRow(
                          box(title = "C6H6 por Mes", 
                              status = "primary",
                              solidHeader = TRUE,
                              collapsible = FALSE,
                              background = "light-blue",
                              width = 400,
                              plotOutput("plotC6H6Mes", height = 350)
                          )
                        )
                )
                
            )
        )
)

