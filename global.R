library(abjData)
library(abjutils)

pnud_muni <- abjData::pnud_muni
data <- readRDS("healthexp.Rds")
data$Region <- as.factor(data$Region)
