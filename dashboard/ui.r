##########################################################################
#
# File:    ui.R
# Author:  Carnegie Mellon Heinz Capstone Team for PBS
# Purpose: This file is responsible for the user interface of the 
#          Shiny Dashboard
#
##########################################################################

# Load the required libraries
if(!require(shiny)) install.packages("shiny")
if(!require(shinydashboard)) install.packages("shinydashboard")
if(!require(leaflet)) install.packages("leaflet")

# Define the header of the dashboard
header  <- dashboardHeader(title = "PBS DASHBOARD")

# Define the dashboard sidebar
sidebar <- dashboardSidebar(
  sidebarMenu(id="tabs",
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Load Sales Data", tabName = "loadSales", icon = icon("upload")),
    menuItem("Customer Distribution", tabName = "demandmap", icon = icon("globe", lib = "glyphicon")),
    menuItem("Select Shows", tabName = "contentpopularity", icon = icon("list", lib = "glyphicon")),
    menuItem("Show Popularity", tabName = "popularitymap", icon = icon("map-marker", lib = "glyphicon")),
    menuItem("% Sales of Shows", tabName = "popularitystate", icon = icon("globe", lib = "glyphicon"))
    
  )
)

# Define the dashboard body
body    <- dashboardBody(
  tabItems(
    # First tab content
    tabItem(tabName = "dashboard",
            fluidPage(
              fluidRow(
                column(12, HTML("<h2><b>PBS SALES ANALYSIS</b></h2>"),align="center",
                       tags$p(),
                       tags$img(src = "pbs_logo.png", width = 500),
                       #h5("Analysis of Sales Data"),
                       tags$p(),
                       tags$p(),
                       tags$p()
                )
              ),
              fluidRow(
                column(12,
                       tags$br(),
                       HTML("
                            <p><b><i><h4>Carnegie Mellon Heinz Capstone Team</h3></i></b>
                            <i>Hao Fu</i><br>
                            <i>Praveen Thoranathula</i><br>
                            <i>Sai Krishna</i><br>
                            <i>Shuyin Zhang</i><br>
                            <i>Sunny Chopra</i><br>
                            <i><b>Guided by: </b> Prof. Mike Smith and Prof. Brett Danaher</i><p/>
                            "), align="left",
                       tags$div(tags$img(src = "cmu.png", width = 150), align="right")
                       )
                    )
                )
          ),
    # Second tab content
    tabItem(tabName = "loadSales",
            fluidRow(
              box(
                title = "Sales input", 
                status = "primary",
                width = 4,
                fileInput('file1', 'Choose CSV File',
                          accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
                #tags$hr(),
                actionButton("submit", "Fetch"),
                tags$style(type='text/css', "#search_button { padding-bottom: 35px; }")
              ),
              box(
                title = "Data", 
                status = "primary",
                width = 8,
                tags$div(style="width:auto; height:auto; overflow:auto;padding:5px;",
                         dataTableOutput('contents1')
                )
              )
            )
    ),
    # Third tab content
    tabItem(tabName = "demandmap", fluidPage(leafletOutput('myDemandMap'))
    ),    
    # Fourth tab content
    tabItem(tabName = "contentpopularity", 
            h2("Choose the Shows you want"),
            fluidRow(
              box(
                title = "Shows",
                width = 4,
                uiOutput("choose_columns1"),
                actionButton("stateButton", "Update Results", icon = NULL),
                textOutput("showsop")
              )
            )
    ),
    # Fifth tab content
    tabItem(tabName = "popularitymap", fluidPage(leafletOutput("mypopularitymap"))
            
    ),
    # Sixth tab content
    tabItem(tabName = "popularitystate", fluidPage(leafletOutput("mypopularitystate"))
            
    )
  )
)

# Call the Shiny ui function to create the ui with the defined header, sidebar and body
ui <- dashboardPage(header,sidebar,body)

##########################################################################
#                                                                        #
#                      E N D   O F   P R O G R A M                       #
#                                                                        #
##########################################################################
