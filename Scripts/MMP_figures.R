library(tidyverse)
library(unmarked)

x <- read_csv("./MMP_all_visits/ampm.csv")

ggplot(x, aes(x = reorder(species, Predicted), y = Predicted, fill = ampm)) + geom_col(position = "dodge") 
+ geom_errorbar(aes(ymin = lower, ymax=upper), colour="black", width=.1)


ggplot(x, aes(x= reorder(species, Predicted), y=Predicted, fill=ampm)) + 
  geom_bar(position=position_dodge(), stat="identity",
           colour="black", # Use black outlines,
           size=.3) + 
  scale_fill_manual(values = c("grey75", "grey35", "white")) + # Thinner lines
  geom_errorbar(aes(ymin=lower, ymax=upper),
                size=.3,    # Thinner lines
                width=.2,
                position=position_dodge(.9)) +
  xlab("") +
  ylab("Mean Dectection Probability") +
  guides(fill=guide_legend(title="")) +
  theme_classic()

#######################################
# GRAPHS FOR PROB OF DET BY DATE
#------------------------------------------

newdata <- data.frame(date = seq(0.1, 6.0, length = 60), TTD = 15.429, ampm = "AM")

write_csv(newdata, "newdata.csv")

newdata <- read_csv("newdata.csv")

newdata <- as.data.frame(newdata)

newdata$date2 <- as.Date(newdata$date, format = "%d-%B")

ambim2 <- readRDS("./MMP_all_visits/ambim2.rds")
hogrm2 <- readRDS("./MMP_all_visits/hogrm2.rds")
pbgrm4 <- readRDS("./MMP_all_visits/pbgrm4.rds")
rngrm4 <- readRDS("./MMP_all_visits/rngrm4.rds")


ambi_date <- predict(ambim2, newdata = newdata, "det", appendData = "TRUE")
amco_date <- predict(amcom4, newdata = newdata, "det", appendData = "TRUE")
hogr_date <- predict(hogrm2, newdata = newdata, "det", appendData = "TRUE")
nesp_date <- predict(nespm9, newdata = newdata, "det", appendData = "TRUE")
pbgr_date <- predict(pbgrm4, newdata = newdata, "det", appendData = "TRUE")
rngr_date <- predict(rngrm4, newdata = newdata, "det", appendData = "TRUE")
sora_date <- predict(soram6, newdata = newdata, "det", appendData = "TRUE")
vira_date <- predict(viram3, newdata = newdata, "det", appendData = "TRUE")

## grebe plot
ggplot() + geom_ribbon(data = pbgr_date, aes(y = Predicted, x = date2, ymin = lower, ymax = upper), alpha =0.25, fill = "steelblue3") + 
  geom_line(data = pbgr_date, aes(date2, Predicted), colour = "steelblue3") +
  geom_ribbon(data = hogr_date, aes(y = Predicted, x = date2, ymin = lower, ymax = upper), alpha = 0.25, fill = "maroon1") +
  geom_line(data = hogr_date, aes(date2, Predicted), colour = "maroon1") + 
  geom_ribbon(data = rngr_date, aes(y = Predicted, x = date2, ymin = lower, ymax = upper), alpha = 0.25, fill = "orange3") + 
  geom_line(data = rngr_date, aes(date2, Predicted), colour = "orange3") + labs(x = "", y = "Detection Probability") + theme_bw()

##rail plot

ggplot() + geom_ribbon(data = amco_date, aes(y = Predicted, x = date2, ymin = lower, ymax = upper), alpha =0.25, fill = "#E69F00") + 
  geom_line(data = amco_date, aes(date2, Predicted), colour = "#E69F00") + 
  geom_ribbon(data = sora_date, aes(y = Predicted, x = date2, ymin = lower, ymax = upper), alpha = 0.25, fill = "#56B4E9") +
  geom_line(data = sora_date, aes(date2, Predicted), colour = "#56B4E9") + 
  geom_ribbon(data = vira_date, aes(y = Predicted, x = date2, ymin = lower, ymax = upper), alpha = 0.25, fill = "#009E73") + 
  geom_line(data = vira_date, aes(date2, Predicted), colour = "#009E73") + labs(x = "", y = "Detection Probability") + theme_bw()

#######################################
# GRAPHS FOR PROB OF Occupancy by wetland count and wetland area
#-------------------------------------------------------------------

areadata <- data.frame(AREAwet.s = seq(0, 4, length = 100), COUNTwet.s = 2.9854, q_crop = 0.4587, crop_4m = 29.987, 
                       q_allwet = 0.08219, prcp = 7.111, tmean.s = 14.49, forest_4m = 3.748, q_grass = 0.09455, 
                       allwet_4m = 4.219, q_water = 0.3122 )

countdata <- data.frame(COUNTwet.s= seq(0, 11, length = 100), AREAwet.s = 1.6628, q_crop = 0.4587, crop_4m = 29.987, 
                       q_allwet = 0.08219, prcp = 7.111, tmean.s = 14.49, forest_4m = 3.748, q_grass = 0.09455, 
                       allwet_4m = 4.219, q_water = 0.3122 )


ambi_area <- predict(ambim4, newdata = areadata, "state", appendData = "TRUE")
ambi_area$AREAwet.s <- ambi_area$AREAwet.s*100

amco_area <- predict(amcom4, newdata = areadata, "state", appendData = "TRUE")
amco_area$AREAwet.s <- amco_area$AREAwet.s*100

hogr_area <- predict(hogrm2, newdata = areadata, "state", appendData = "TRUE")
hogr_area$AREAwet.s <- hogr_area$AREAwet.s*100

nesp_area <- predict(nespm9, newdata = areadata, "state", appendData = "TRUE")
nesp_area$AREAwet.s <- nesp_area$AREAwet.s*100

pbgr_area <- predict(pbgrm4, newdata = areadata, "state", appendData = "TRUE")
pbgr_area$AREAwet.s <- pbgr_area$AREAwet.s*100

rngr_area <- predict(rngrm4, newdata = areadata, "state", appendData = "TRUE")
rngr_area$AREAwet.s <- rngr_area$AREAwet.s*100

sora_area <- predict(soram6, newdata = areadata, "state", appendData = "TRUE")
sora_area$AREAwet.s <- sora_area$AREAwet.s*100

vira_area <- predict(viram3, newdata = areadata, "state", appendData = "TRUE")
vira_area$AREAwet.s <- vira_area$AREAwet.s*100

ambi_count <- predict(ambim4, newdata = countdata, "state", appendData = "TRUE")
ambi_count$COUNTwet.s <- ambi_count$COUNTwet.s*100

amco_count <- predict(amcom4, newdata = countdata, "state", appendData = "TRUE")
amco_count$COUNTwet.s <- amco_count$COUNTwet.s*100

hogr_count <- predict(hogrm2, newdata = countdata, "state", appendData = "TRUE")
hogr_count$COUNTwet.s <- hogr_count$COUNTwet.s*100

nesp_count <- predict(nespm9, newdata = countdata, "state", appendData = "TRUE")
nesp_count$COUNTwet.s <- nesp_count$COUNTwet.s*100

pbgr_count <- predict(pbgrm4, newdata = countdata, "state", appendData = "TRUE")
pbgr_count$COUNTwet.s <- pbgr_count$COUNTwet.s*100

rngr_count <- predict(rngrm4, newdata = countdata, "state", appendData = "TRUE")
rngr_count$COUNTwet.s <- rngr_count$COUNTwet.s*100

sora_count <- predict(soram6, newdata = countdata, "state", appendData = "TRUE")
sora_count$COUNTwet.s <- sora_count$COUNTwet.s*100
vira_count <- predict(viram3, newdata = countdata, "state", appendData = "TRUE")
vira_count$COUNTwet.s <- vira_count$COUNTwet.s*100

## grebe area plot
library(ggtext)
library(viridis)

hogr_area$Species <- "Horned Grebe"
pbgr_area$Species <- "Pied-billed Grebe"
rngr_area$Species <- "Red-necked Grebe"

grebe <- rbind(hogr_area, pbgr_area, rngr_area)
grebe$Species <- as.factor(grebe$Species)

heatramp<- colorRampPalette(c("#ABD9E9","#FFFFBF","#FEE090","#FDAE61","#F46D43", "#D73027", "#A50026") )

wetland <- ggplot(data =grebe, aes(AREAwet.s, Predicted, ymin = lower, ymax = upper, colour = factor(Species), fill = Species)) + 
  geom_line() + geom_ribbon(alpha = 0.25) + scale_color_manual(values = c("#A50026", "#FDAE61", "#FEE090"), aesthetics = c("colour", "fill")) + 
  labs(y = "Probability of occurrence", x = expression(paste("Wetland basin area (ha) within 5 ", mile^2)))  +
  guides(colour = "none") +
  theme_bw() +
  theme(legend.position = c(0.25, 0.8))+
  theme(panel.grid.minor = element_line(linetype = "blank"),
        panel.grid.major = element_line(linetype = "blank"),
        axis.title.x  = element_text(size=10),
        axis.line.y = element_line(linewidth=0.1),
        axis.line.x=element_line(linewidth=0.1))

ggsave(path = "./Tables and Figures",filename = "grebe_wetland_area.png", width = 10, height = 8)

#---------------------------------------------------------------------------------------

ggplot() + geom_ribbon(data = pbgr_area, aes(y = Predicted, x = AREAwet.s, ymin = lower, ymax = upper), alpha =0.25, fill = "steelblue3") + 
  geom_line(data = pbgr_area, aes(AREAwet.s, Predicted), colour = "steelblue3") +
  geom_ribbon(data = hogr_area, aes(y = Predicted, x = AREAwet.s, ymin = lower, ymax = upper), alpha = 0.25, fill = "maroon1") +
  geom_line(data = hogr_area, aes(AREAwet.s, Predicted), colour = "purple") + 
  geom_ribbon(data = rngr_area, aes(y = Predicted, x = AREAwet.s, ymin = lower, ymax = upper), alpha = 0.25, fill = "orange3") + 
  geom_line(data = rngr_area, aes(AREAwet.s, Predicted), colour = "orange3") + labs(title = "Grebes", x = "Wetland Basin Area (ha) within 5 mile2", y = "Probability of Occurrence") + 
  theme_bw() + theme()

##rail area plot

ggplot() + geom_ribbon(data = amco_area, aes(y = Predicted, x = AREAwet.s, ymin = lower, ymax = upper), alpha =0.25, fill = "#E69F00") + 
  geom_line(data = amco_area, aes(AREAwet.s, Predicted), colour = "#E69F00") + 
  geom_ribbon(data = sora_area, aes(y = Predicted, x = AREAwet.s, ymin = lower, ymax = upper), alpha = 0.25, fill = "#56B4E9") +
  geom_line(data = sora_area, aes(AREAwet.s, Predicted), colour = "#56B4E9") + 
  geom_ribbon(data = vira_area, aes(y = Predicted, x = AREAwet.s, ymin = lower, ymax = upper), alpha = 0.25, fill = "#009E73") + 
  geom_line(data = vira_area, aes(AREAwet.s, Predicted), colour = "#009E73") + labs(title = "Rails", x = "Wetland Basin Area (ha) within 5mile2", y = "Occupancy") + theme_bw()

##bittern sparrow wren area plot

ggplot() + geom_ribbon(data = ambi_area, aes(y = Predicted, x = AREAwet.s, ymin = lower, ymax = upper), alpha =0.25, fill = "#E69F00") + 
  geom_line(data = ambi_area, aes(AREAwet.s, Predicted), colour = "#D55E00") + 
  geom_ribbon(data = nesp_area, aes(y = Predicted, x = AREAwet.s, ymin = lower, ymax = upper), alpha = 0.25, fill = "#56B4E9") +
  geom_line(data = nesp_area, aes(AREAwet.s, Predicted), colour = "#0072B2") + 
  labs(title = "Others", x = "Wetland Basin Area (ha) within 5mile2", y = "Occupancy") + theme_bw()

## grebe count plot
ggplot() + geom_ribbon(data = pbgr_count, aes(y = Predicted, x = COUNTwet.s, ymin = lower, ymax = upper), alpha =0.25, fill = "steelblue3") + 
  geom_line(data = pbgr_count, aes(COUNTwet.s, Predicted), colour = "steelblue3") +
  geom_ribbon(data = hogr_count, aes(y = Predicted, x = COUNTwet.s, ymin = lower, ymax = upper), alpha = 0.25, fill = "maroon1") +
  geom_line(data = hogr_count, aes(COUNTwet.s, Predicted), colour = "maroon1") + 
  geom_ribbon(data = rngr_count, aes(y = Predicted, x = COUNTwet.s, ymin = lower, ymax = upper), alpha = 0.25, fill = "orange3") + 
  geom_line(data = rngr_count, aes(COUNTwet.s, Predicted), colour = "orange3") + labs(title = "Grebes", x = "Number of Wetlands within 5 mile2", y = "Occupancy") + theme_bw()

##rail count plot

ggplot() + geom_ribbon(data = amco_count, aes(y = Predicted, x = COUNTwet.s, ymin = lower, ymax = upper), alpha =0.25, fill = "#E69F00") + 
  geom_line(data = amco_count, aes(COUNTwet.s, Predicted), colour = "#E69F00") + 
  geom_ribbon(data = sora_count, aes(y = Predicted, x = COUNTwet.s, ymin = lower, ymax = upper), alpha = 0.25, fill = "#56B4E9") +
  geom_line(data = sora_count, aes(COUNTwet.s, Predicted), colour = "#56B4E9") + 
  geom_ribbon(data = vira_count, aes(y = Predicted, x = COUNTwet.s, ymin = lower, ymax = upper), alpha = 0.25, fill = "#009E73") + 
  geom_line(data = vira_count, aes(COUNTwet.s, Predicted), colour = "#009E73") + labs(title = "Rails", x = "Number of Wetlands within 5mile2", y = "Occupancy") + theme_bw()

##bittern sparrow wren count plot

ggplot() + geom_ribbon(data = ambi_count, aes(y = Predicted, x = COUNTwet.s, ymin = lower, ymax = upper), alpha =0.25, fill = "#E69F00") + 
  geom_line(data = ambi_count, aes(COUNTwet.s, Predicted), colour = "#D55E00") + 
  geom_ribbon(data = nesp_count, aes(y = Predicted, x = COUNTwet.s, ymin = lower, ymax = upper), alpha = 0.25, fill = "#56B4E9") +
  geom_line(data = nesp_count, aes(COUNTwet.s, Predicted), colour = "#0072B2") +
  ylim(0,1) +
  labs(title = "Others", x = "Number of Wetlands within 5mile2", y = "Occupancy") + theme_bw()

#######################################
# Bar chart for naive vs predicted occupancy
#-------------------------------------------------------------------

pred <- read_csv("naive_pred_occu.csv")

ggplot(pred, aes(x = reorder(Species,Naïve),  y = Naïve, fill = Type)) + geom_bar(position=position_dodge(), stat="identity",
                                                                  colour="black", # Use black outlines,
                                                                  size=.3) + 
  scale_fill_manual(values = c("grey75", "grey35")) + # Thinner lines
  geom_errorbar(aes(ymin=lower, ymax=upper),
                size=.3,    # Thinner lines
                width=.2,
                position=position_dodge(.9)) +
  xlab("") +
  ylab("Occupancy") +
  guides(fill=guide_legend(title="")) +
  theme_bw()


##k fold

ambim2 <- readRDS("./MMP_all_visits/ambim2.rds")
hogrm2 <- readRDS("./MMP_all_visits/hogrm2.rds")
pbgrm4 <- readRDS("./MMP_all_visits/pbgrm4.rds")
rngrm4 <- readRDS("./MMP_all_visits/rngrm4.rds")

library(unmarked)

kfold = crossVal(ambim2, method="Kfold", folds=10)

kfold = crossVal(rngrm4, method="Kfold", folds=10, statistic = RMSE_MAE2)

kfold

unmarked:::RMSE_MAE

#Function to calculate RMSE and MAE
#Default function for statistic argument
#Returns a named list
RMSE_MAE2 <- function(object){
  
  res <- residuals(object)
  if(is.list(res)) res <- unlist(res)
  
  mae <- mean(abs(res), na.rm=T)
  rmse <- sqrt(mean(res^2, na.rm=T))
  mse <- mean(res^2, na.rm=T)
  
  c(`Root mean square error`=rmse, `Mean absolute error`=mae, `Mean square error` = mse)
}

