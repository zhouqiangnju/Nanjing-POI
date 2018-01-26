library(sf)
library(openxlsx)
library(Rgctc2)
library(maptools)

worldgaze<-st_read('F:/Administrator/Documents/Mapproject/worldgaze.shp')
library(ggplot2)
world_gaze_list<-split(worldgaze,worldgaze$CATEGORY)
ggplot(nj_railroad)+geom_sf()+coord_sf()
world_airport<-worldgaze[which(worldgaze$CATEGORY=='Airport'),]
china<-worldgaze[which(worldgaze$WITHIN=='China'),]
nj_railroad<-st_read('F:/Administrator/Documents/R/Map/十个城市的轨道交通站点和线路数据/十个城市的轨道交通站点和线路数据/南京/南京_轨道线路数据(2016).shp')
nj_re<-openxlsx::read.xlsx ('F:/Administrator/Documents/R/Map/南京POI数据_262000+高德地图_火星坐标系_13个标签/住宿_5900+.xlsx')
nj_re$lng_wgs84<-gcj02_wgs84_lng(nj_re$lng,nj_re$lat)
nj_re$lat_wgs84<-gcj02_wgs84_lat(nj_re$lng,nj_re$lat)
for(i in 1:dim(nj_re)[1]){
  nj_re$geo[[i]]<-st_point(c(nj_re$lng_wgs84[i],nj_re$lat_wgs84[i]),dim = 'XY')
}
 nj_re$geo<-st_sfc(nj_re$geo,crs = 4326)
nj_re.sf<-st_sf(nj_re) 
write.csv(nj_re,'nj_re.csv')
plot(nj_re$lng_wgs84,nj_re$lat_wgs84)
ggplot(nj_re.sf)+geom_sf()
nj_re_map<-as(nj_re.sf,'Spatial')
st_write(nj_re.sf,"nj_re.sf.shp")
writeSpatialShape(nj_re_map,"njre_map.shp")
njre<-st_read('nj_re.sf.shp')
ggplot(njre)+geom_sf()+coord_sf()
