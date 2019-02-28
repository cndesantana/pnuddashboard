library(abjData)
library(abjutils)
library(scales)
library(brmap)
library(maptools)
library(rgdal) # ensure rgdal is loaded
library(readxl)
library(tidyverse)
#library(tmap)
library(colorRamps)
library(leaflet)
library(htmlwidgets)
library(colorRamps)
library(lubridate)
library(stringi)
library(stringr)
library(htmltools)
library(dplyr)

corpositivo <- "#20B2AA";
cornegativo <- "#c00000";
corneutro <- "#FFA500";


pnud_muni <- abjData::pnud_muni

datadir <- "/home/charles/GitRepos/armagedon/Regionais/2019/"
reladir <- "/home/charles/"
rootdir <- "/home/charles/GitRepos/armagedon/NucleoPolitico/MapasRui/"
colfunc <- colorRampPalette(c(corpositivo, corneutro, cornegativo))
dados_cidades_populacao_regiao <- read_xlsx(paste(datadir,"Cidades_Por_Regiao_Populacao.xlsx",sep=""))
names(dados_cidades_populacao_regiao) <- c("municipio","pop","reg")
municBR   <- readShapePoly(fn=file.path(datadir,'geodata/municipios_2010.shp'))
new_brmap_municipio_pop_reg <- brmap_municipio %>% 
  filter(cod_estado == 29) %>% 
  left_join(as_tibble(dados_cidades_populacao_regiao))
new_brmap_municipio_pop_reg$municipio <- toupper(new_brmap_municipio_pop_reg$municipio)

mydata <- pnud_muni %>% filter(uf == 29)

for(year in c(1991, 2000, 2010)){
  mymap <- left_join(new_brmap_municipio_pop_reg, mydata, by = c('municipio'='municipio')) %>% 
    filter(ano == year)
  palette_is <- rev(colfunc(31))
  posColorIS <- round((mymap$espvida)-50+1)
  m <- leaflet() %>%
    addPolygons(data = mymap,
                color = palette_is[posColorIS+1],
                fillColor = palette_is[posColorIS+1], 
                opacity = 1.0, fillOpacity = 1, 
                popup = paste(mymap$municipio," / Região ",mymap$reg, " / EV = ",mymap$espvida,sep="")) %>%
    addLegend(position="bottomright", 
              colors=palette_is[seq(1,30,by=5)], 
              labels=seq(51,80,by=5), 
              opacity = 1.0, title=paste("Esperança de Vida",year))
  saveWidget(m, paste(reladir,paste0("mapa_EsperancaDeVida_",year,".html"),sep=""), selfcontained = FALSE)
}

auxiliar <- left_join(new_brmap_municipio_pop_reg, mydata, by = c('municipio'='municipio'))
auxiliar <- auxiliar %>%  group_by(ano,reg) %>% mutate(espvida = mean(espvida))

for(year in c(1991, 2000, 2010)){
  mymap <- auxiliar %>% 
    filter(ano == year)
  palette_is <- rev(colfunc(31))
  posColorIS <- round((mymap$espvida)-50+1)
  m <- leaflet() %>%
    addPolygons(data = mymap,
                color = palette_is[posColorIS+1],
                fillColor = palette_is[posColorIS+1], 
                opacity = 1.0, fillOpacity = 1, 
                popup = paste(mymap$municipio," / Região ",mymap$reg, " / EV = ",mymap$espvida,sep="")) %>%
    addLegend(position="bottomright", 
              colors=palette_is[seq(1,30,by=5)], 
              labels=seq(51,80,by=5), 
              opacity = 1.0, title=paste("Esperança de Vida",year))
  saveWidget(m, paste(reladir,paste0("mapa_EsperancaDeVida_porregiao",year,".html"),sep=""), selfcontained = FALSE)
}
