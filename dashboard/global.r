##########################################################################
#
# File:    gloabal.R
# Author:  Carnegie Mellon Heinz Capstone Team for PBS
# Purpose: This file contains all the global information required even 
#           before the satrt of the dashboard.
#           This file is always executed first
#
##########################################################################

if(!require(plyr)) install.packages("plyr")
#if(!require(plotGoogleMaps)) install.packages("plotGoogleMaps")
if(!require(zipcode)) install.packages("zipcode")
if(!require(maptools)) install.packages("maptools")
if(!require(sp)) install.packages("sp")
if(!require(leaflet)) install.packages("leaflet")
#if(Sys.getenv('SHINY_PORT') == "") options(shiny.maxRequestSize=10000*1024^2)
