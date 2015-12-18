##########################################################################
# 
# File:    server.R
# Author:  Carnegie Mellon Heinz Capstone Team for PBS
# Purpose: This file is responsible for the backend server of the 
#          Shiny Dashboard. It receives each and every action performed
#          in the ui and takes necessary actions accordingly
#
##########################################################################
#####  S E R V E R #####

# Load the required libraries
if(!require(shiny)) install.packages("shiny")
if(!require(shinydashboard)) install.packages("shinydashboard")
if(!require(leaflet)) install.packages("leaflet")
if(!require(ggmap)) install.packages("ggmap")
if(!require(ggplot2)) install.packages("ggplot2")
if(!require(plyr)) install.packages("plyr")
if(!require(data.table)) install.packages("data.table")

# Install this package if any error is thrown
#if(!require(rgdal)) install.packages("rgdal")

options(shiny.maxRequestSize=10000*1024^2)

# Server code for all the tabs
server <- function(input, output, session) {
  
  ## SECOND TAB CONTENT
  
  ## Show the output of the booker data which was just loaded
  output$contents1 <- renderDataTable({
    #input$submit
    cat("FUNC 1")
    loadData()
    
  }, options = list(pageLength = 10))
  
  loadData <- reactive({
    inFile1 <- input$file1
    if(is.null(inFile1)) {
      return(NULL)
    } else {
        cat("DATA LOAD RUNNING")
        #density.map.data <<- read.csv(inFile1$datapath, header=T, sep=',', quote='"')
        density.map.data <<- data.frame(fread(inFile1$datapath, header=T, sep=','))
        
        density.map.data$Artist...Show <<- as.factor(density.map.data$Artist...Show)
        cat("DATA LOADED")
        cust.density <<- subset(density.map.data, select= c(Customer.Identifier,Postal.Code,Artist...Show,Units,Customer.Price,Download.Date..PST.))
        cust.density$Postal.Code <<- substr(cust.density$Postal.Code,1,5)
        cust.density$Postal.Code <<- as.numeric(cust.density$Postal.Code, na.rm = TRUE)
        cust.density$Postal.Code <<- sprintf("%05d",cust.density$Postal.Code)
        cust.density$Toal.Price  <<- as.numeric(cust.density$Units*cust.density$Customer.Price, na.rm=TRUE)        
        temp_data <<- data.frame(density.map.data[1:10,])
    }
    
  })
  
  ## THIRD TAB CONTENT
  output$myDemandMap <- renderLeaflet({
    
    data(zipcode)
    
    cat("Finished Global\n")
    
    cat("STARTED LEAFLET NO 1")
    #density.map.data <<- bookerMerchant_orig
    
    cust.map <<- cust.density #merge(cust.density,zipcode,by.x="Postal.Code",by.y="zip")
    
    
    cust.zipcode <<- ddply(cust.map,"Postal.Code",summarise,cnt=length(Customer.Identifier))
    colnames(cust.zipcode) <<- c("ZIPCODE","Count")
    
    cat("\n Zip merge")
    cust.count <<- merge(zipcode,cust.zipcode,by.x="zip",by.y="ZIPCODE")
    
    shows <<- data.frame(Shows = unique(cust.map$Artist...Show))
    
    generateLeaflet(cust.count)
  })
  
  ## FOURTH TAB CONTENT
  output$choose_columns1 <- renderUI({
    checkboxGroupInput('show', 'SHOW\'s :', as.character(shows$Shows), selected = c("Downton Abbey"))
  })
  
  output$showsop <- renderText({
    show_range      <- input$show
  })
  
  # Switch the tabs between fourth and fifth Automatically
  observeEvent(input$stateButton, {
    newtab1 <- switch(input$tabs,
                      "contentpopularity" = "popularitymap",
                      "popularitymap" = "contentpopularity")
    updateTabItems(session,"tabs", newtab1)
  })
  
  
  ## FIFTH TAB CONTENT
  output$mypopularitymap <- renderLeaflet({
    
    runPop()
    
  })
  
  showPop <- reactive({
    show_range      <- input$show
    ## Update all df's with states only for those states
    show.popularity <<- subset(cust.map, Artist...Show %in% c(show_range))
    show_range
  })
  
  runPop <- reactive({
    showPop()
    show.zipcode <<- ddply(show.popularity,"Postal.Code",summarise,cnt=length(Customer.Identifier))
    
    colnames(show.zipcode) <<- c("ZIPCODE","Count")
    
    cat("\n Zip merge")
    show.count <<- merge(zipcode,show.zipcode,by.x="zip",by.y="ZIPCODE")

    cat("\nGenerate Populatiry")
    generateLeaflet(show.count)
  })
  
  generateLeaflet <- function(spatialDF) {
    cat("STARTED LEAFLET")
    spatialDF <- na.omit(spatialDF)
    leaflet(spatialDF) %>% addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                                    attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>') %>%
      addCircles(~longitude,~latitude, weight = 1, radius=~Count,stroke=FALSE, fillOpacity=0.4,
                 popup = ~paste(city," - Count: ",Count,sep="")) %>%
      setView(lng = mean(as.numeric(spatialDF$longitude),na.rm=TRUE), lat = mean(as.numeric(spatialDF$latitude),na.rm=TRUE), zoom = 4)
    
  }

  ## SIXTH TAB CONTENT
  output$mypopularitystate <- renderLeaflet({
    
    
   runState()
    
  })
  
  
  runState <- reactive ({
    show_range      <- input$show
    states <<- readShapeSpatial("ShapeFiles/cb_2014_us_state_500k.shp")
    proj4string(states) <<- CRS("+proj=longlat +datum=WGS84")
    
    
    state.count <<- ddply(show.count,"state",summarise,Count=sum(Count))
    state_total <<- ddply(cust.count,"state",summarise,Total_Cnt=sum(Count))
    
    
    state.count <<- merge(state.count,state_total,by="state")
    
    state.count$percent.sales <<- (state.count$Count/state.count$Total_Cnt)*100
    states <<- merge(states,state.count,by.x="STUSPS",by.y="state",all.y=TRUE)
    states <<- states[which(states$Count > 0),]
    
    
    
    pal <- colorNumeric(
      palette = "YlOrRd",
      domain = states$percent.sales
    ) 
    leaflet(states) %>% addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                                 attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>') %>%
      addPolygons(
        stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
        color = ~pal(percent.sales),
        popup = ~paste(paste(STUSPS," - Count: ",Count,sep=""), paste("Percent Sales: ", round(percent.sales,0), "%",sep=""),sep = "\n")
      ) %>%
      addLegend("bottomright", pal = pal, values = ~percent.sales,
                title = "Popularity",
                labFormat = labelFormat(),
                opacity = 1
      ) %>%
      setView(lng= -98.35,lat=39.5,zoom=4)
    
  })
  
  
}
