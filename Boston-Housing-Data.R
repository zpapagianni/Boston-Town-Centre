library(ggplot2)
library(tidyverse) 
library(kableExtra)
library(grid)
library(gridExtra)
library(dplyr)
library(spData)
library(ggmap)
library(maps)
library(mapview)
library(leaflet)
library(ggmap)
library(viridis)

register_google(key = "AIzaSyA-0NQyKizPR9jdAYCfTiyB5IhVfbdU2xI")
#Load data ---------------------------------------
BostonData<-boston.c %>% select(TOWN, LON, LAT,CMEDV) 
summary(BostonData)
BostonData$TOWN<-as.character(BostonData$TOWN)

#Check for NA values
colSums(is.na(BostonData))

#Plot Data
ggplot(data=BostonData,aes(x=LON,y=LAT,color=TOWN))+geom_point(show.legend = FALSE)+
  xlab("Longtitude")+
  ylab('Latitude')+
  theme_bw()

#Contruct bounding box
maxLong = max(BostonData$LON)
maxLat = max(BostonData$LAT)
minLong = min(BostonData$LON)
minLat = min(BostonData$LAT)

#Get the coordinates and towns names
coord<-BostonData %>% select(LON, LAT,TOWN) 

#Get the mean coordinates and towns names
mcoord<-BostonData %>% select(LON, LAT,TOWN) %>% 
  group_by(TOWN) %>% summarise(lon=mean(LON),lat=mean(LAT))

#Get Boston's map and add points from data
leaflet() %>% addTiles() %>% setView(-70, 42, 19) %>% 
  fitBounds(minLong,minLat,maxLong,maxLat) %>% 
  addMarkers(data = mcoord,label = ~ TOWN,labelOptions = labelOptions(noHide = T))

#Save map
m<-leaflet() %>% addTiles() %>%  
  fitBounds(minLong,minLat,maxLong,maxLat) %>% 
  addCircleMarkers(data = mcoord,label = ~ TOWN,labelOptions = labelOptions(noHide = T),layerId = ~TOWN,fillColor = 
                     'green',opacity = 0.5,color = 'red',fillOpacity = 1)
m
mapshot(m, file = "maps.png")

#Zoomed map
zoom<-coord %>% filter(TOWN=='Beverly')
zoom_level<-12
mzoom<-leaflet() %>% addTiles() %>%  
  setView(zoom$LON[1], zoom$LAT[1], zoom = zoom_level) %>% 
  addCircleMarkers(data = mcoord,label = ~ TOWN,labelOptions = labelOptions(noHide = T),layerId = ~TOWN,fillColor = 
                     'green',opacity = 0.5,color = 'red',fillOpacity = 1)
mzoom
mapshot(mzoom, file = "mapszoom.png")

##Cambridge coordinates
cambridge<-BostonData[BostonData$TOWN=="Cambridge",] %>% select(LON, LAT,TOWN) 
cambridgemap<-leaflet() %>% addTiles() %>%  
  setView(zoom$LON[1], zoom$LAT[1], zoom = zoom_level) %>% 
  addCircleMarkers(data = mcoord,label = ~ TOWN,labelOptions = labelOptions(noHide = T),layerId = ~TOWN,fillColor = 
                     'green',opacity = 0.5,color = 'red',fillOpacity = 1)

##Compare towns
cambridgemap<-leaflet() %>% addTiles() %>%
  addCircleMarkers(lat = 42.373611,lng = -71.110558, weight = 1,
             fillColor = 'blue',opacity = 0.5,color = 'red',fillOpacity = 1) %>% 
  addCircleMarkers(data = cambridge,label = ~ TOWN,labelOptions = labelOptions(noHide = T),layerId = ~TOWN,fillColor = 
                           'green',opacity = 0.5,color = 'red',fillOpacity = 1)
cambridgemap
mapshot(cambridge, file = "cambridgemap.png")


###Correction of data ---------------------------------------
centre.coord <- read_csv("BostonTownCentres.csv")
#Join data frames
join.coord<-centre.coord %>% left_join(BostonData, by=c('town'='TOWN'))
nrow(join.coord)==nrow(BostonData)
setdiff(unique(BostonData$TOWN), unique(join.coord$town))
join.coord<-NA

BostonData$TOWN[BostonData$TOWN=='Sargus']<-'Saugus'
join.coord<-centre.coord %>% left_join(BostonData, by=c('town'='TOWN'))
nrow(join.coord)==nrow(BostonData)

#Map
##Extract bounds for map
maxLong = max(centre.coord$lon)
maxLat = max(centre.coord$lat)
minLong = min(centre.coord$lon)
minLat = min(centre.coord$lat)

#Create map
m.correct<-leaflet() %>% addTiles() %>%  
  fitBounds(minLong,minLat,maxLong,maxLat) %>% 
  addCircleMarkers(data = centre.coord,label = ~ town,labelOptions = labelOptions(noHide = T),layerId = ~town,fillColor = 
                     'green',opacity = 0.5,color = 'red',fillOpacity = 1)
m.correct
##Save map
mapshot(m.correct, file = "correctmap.png")

#Zoomed map
zoom<-centre.coord %>% filter(TOWN=='Cambridge')
zoom_level<-12
mzoom.correct<-leaflet() %>% addTiles() %>%  
  setView(zoom$lon[1], zoom$lat[1], zoom = zoom_level) %>% 
  addCircleMarkers(data = centre.coord,label = ~ town,labelOptions = labelOptions(noHide = T),layerId = ~town,fillColor = 
                     'green',opacity = 0.5,color = 'red',fillOpacity = 1)
mzoom.correct
mapshot(mzoom.correct, file = "mapszoomcorrect.png")



#Calculate the wrong centroid
centroid<-BostonData %>% group_by(TOWN) %>% summarise(centre_lon=mean(LON),centre_lat=mean(LAT))
new_cord<-data.frame(cor_lon=as.double(),cor_lat=as.double())
for (name in centroid$TOWN){
  temp<-BostonData %>% filter(TOWN==name)
  temp.centre<-centroid %>% filter(TOWN==name)
  cor.centroid<-centre.coord %>% filter(town==name)
  dislon<-temp$LON-temp.centre$centre_lon
  dislat<-temp$LAT-temp.centre$centre_lat
  cor_lon<-cor.centroid$lon+dislon
  cor_lat<-dislat+cor.centroid$lat
  new_cord<-rbind(new_cord, cbind(cor_lon,cor_lat))
}

join.coord<-cbind(join.coord,new_cord)

#Map
##Extract bounds for map
maxLong = max(join.coord$cor_lon)
maxLat = max(join.coord$cor_lat)
minLong = min(join.coord$cor_lon)
minLat = min(join.coord$cor_lat)

#Create map
m.final<-leaflet(data = join.coord) %>% addTiles() %>%  
  fitBounds(minLong,minLat,maxLong,maxLat) %>% 
  addCircleMarkers(~cor_lon,~cor_lat,label = ~ town,labelOptions = labelOptions(noHide = T),layerId = ~town,fillColor = 
                     'green',opacity = 0.5,color = 'red',fillOpacity = 1)
m.final
##Save map
mapshot(m.final, file = "finalmap.png")

#Zoomed map
mzoom.correct<-leaflet() %>% addTiles() %>%  
  setView(zoom$lon[1], zoom$lat[1], zoom = zoom_level) %>% 
  addCircleMarkers(data=join.coord,~cor_lon,~cor_lat,label = ~ town,labelOptions = labelOptions(noHide =T),
                   layerId = ~town,fillColor ='green',opacity = 0.5,color = 'red',fillOpacity =1)

mzoom.correct
mapshot(mzoom.correct, file = "mapszoomcorrect.png")

Boston_Loc<-geocode("Boston")
Boston <- get_googlemap(center=c(lon = -71.05888, lat = 42.36008), zoom = 10)
mean_cmedv<- join.coord %>% group_by(town) %>% summarise(mc=round(mean(CMEDV),2),mlon=mean(cor_lon),mlat=mean(cor_lat))

ggmap(Boston)+ geom_polygon(data = join.coord, aes(x = cor_lon, y = cor_lat, group = town,fill=CMEDV))+
  theme_void()+
  scale_fill_viridis(breaks=c(50,45,40,35,30,25,20,15,10,5), 
                     guide = guide_legend(label.position = "right", title.position = 'top', nrow=11)) +
  labs(title = "Value of owner-occupied housing in Greater Boston in 1970",subtitle = "Median Value per city district") +
  theme(text = element_text(color = "#22211d"),
    legend.background = element_rect(fill = "#f5f5f2", color = NA),
    plot.title = element_text(size= 14, hjust=0.01, color = "#4e4d47",
                              margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")))+
  geom_text(data=mean_cmedv,aes(label = mc, x = mlon, y = mlat),size=3) 




