## CGAMP BRT Figures
heatramp<- colorRampPalette(c("#ABD9E9","#FFFFBF","#FEE090","#FDAE61","#F46D43", "#D73027", "#A50026") )

library(tidyverse)
library(dismo)
library(gbm)
library(ggBRT)

load("Data/BRTModelFiles/BAIS_tc5_lr0.05_bf0.75.rdata")

bais <- model

load("Data/BRTModelFiles/SPPI_tc5_lr0.05_bf0.75.rda")

sppi <- model

load("Data/BRTModelFiles/CCLO_tc4_lr0.05_bf0.75.rda")

cclo <- model

load("Data/BRTModelFiles/LBCU_tc2_lr0.01_bf0.75.rda")

lbcu <- model

load("Data/BRTModelFiles/MAGO_tc3_lr0.05_bf0.75.rda")

mago <- model

load("Data/BRTModelFiles/WILL_tc4_lr0.01_bf0.75.rda")

will <- model


summary(model)



## read bootstrap models in as a list

BAISf <- list.files(path = "C:/Users/McmanusJ/OneDrive - EC-EC/Priority Areas Analysis/Data/GRASS_BRT/Analysis/BRT_Output/Models_bootstrap",
                    pattern = "BAIS" , full.names = TRUE)
BAIS <- lapply(BAISf, readRDS)


CCLOf <- list.files(path = "C:/Users/McmanusJ/OneDrive - EC-EC/Priority Areas Analysis/Data/GRASS_BRT/Analysis/BRT_Output/Models_bootstrap",
                    pattern = "CCLO" , full.names = TRUE)
CCLO <- lapply(CCLOf, readRDS)

BOBOf <- list.files(path = "C:/Users/McmanusJ/OneDrive - EC-EC/Priority Areas Analysis/Data/GRASS_BRT/Analysis/BRT_Output/Models_bootstrap",
                    pattern = "BOBO" , full.names = TRUE)
BOBO <- lapply(BOBOf, readRDS)

SPPIf <- list.files(path = "C:/Users/McmanusJ/OneDrive - EC-EC/Priority Areas Analysis/Data/GRASS_BRT/Analysis/BRT_Output/Models_bootstrap",
                    pattern = "SPPI" , full.names = TRUE)
SPPI <- lapply(SPPIf, readRDS)

LARBf <- list.files(path = "C:/Users/McmanusJ/OneDrive - EC-EC/Priority Areas Analysis/Data/GRASS_BRT/Analysis/BRT_Output/Models_bootstrap",
                    pattern = "CCLO" , full.names = TRUE)
LARB <- lapply(CCLOf, readRDS)

MAGOf <- list.files(path = "C:/Users/McmanusJ/OneDrive - EC-EC/Priority Areas Analysis/Data/GRASS_BRT/Analysis/BRT_Output/Models_bootstrap",
                    pattern = "MAGO" , full.names = TRUE)
MAGO <- lapply(MAGOf, readRDS)

WILLf <- list.files(path = "C:/Users/McmanusJ/OneDrive - EC-EC/Priority Areas Analysis/Data/GRASS_BRT/Analysis/BRT_Output/Models_bootstrap",
                    pattern = "WILL" , full.names = TRUE)
WILL <- lapply(WILLf, readRDS)

LBCUf <- list.files(path = "C:/Users/McmanusJ/OneDrive - EC-EC/Priority Areas Analysis/Data/GRASS_BRT/Analysis/BRT_Output/Models_bootstrap",
                    pattern = "LBCU" , full.names = TRUE)
LBCU <- lapply(LBCUf, readRDS)

## first check relative influence of variables

BAIS_RI <- lapply(BAIS, summary)

bais_relin <- bind_rows(BAIS_RI) %>% group_by(var) %>% summarise(BAIS_mean = round(mean(rel.inf), 2))


CCLO_RI <- lapply(CCLO, summary)

cclo_relin <- bind_rows(CCLO_RI) %>% group_by(var) %>% summarise(CCLO_mean = round(mean(rel.inf), 2))


SPPI_RI <- lapply(SPPI, summary)

sppi_relin <- bind_rows(SPPI_RI) %>% group_by(var) %>% summarise(SPPI_mean = round(mean(rel.inf), 2))

MAGO_RI <- lapply(MAGO, summary)

MAGO_relin <- bind_rows(MAGO_RI) %>% group_by(var) %>% summarise(MAGO_mean = round(mean(rel.inf), 2))

WILL_RI <- lapply(WILL, summary)

WILL_relin <- bind_rows(WILL_RI) %>% group_by(var) %>% summarise(WILL_mean = round(mean(rel.inf), 2))

LBCU_RI <- lapply(LBCU, summary)

LBCU_relin <- bind_rows(LBCU_RI) %>% group_by(var) %>% summarise(LBCU_mean = round(mean(rel.inf), 2))

all <- bind_cols(bais_relin, sppi_relin, cclo_relin, MAGO_relin, WILL_relin, LBCU_relin)

write_csv(all, "all_spp_relin.csv")

install.packages("remotes")
install.packages("devtools") # in case "devtools" has not already been installed
library(devtools)
devtools::install_github("JBjouffray/ggBRT") # will take several minutes to install


ggInfluence(model)

?ggPD()
  
p1 <- ggPD(model, n.plots=1, common.scale= FALSE, rug = T)

ggPD(sppi, n.plots=1, common.scale= FALSE, rug = T)

ggMultiPD(sppi, bais, predictor = "grass_25", legend.pos = "top", col.lines =c("blue","red"))

ggMultiPDfit(bais, sppi, predictor = "grass_25", legend.pos = "top", col.dots =c("blue","red"), cex.dot=1.5, cex.smooth = 0.8)

ggPDfit(bais, n.plots = 1)

p1 <- ggPD(bais, n.plots = 1, rug = T)

p1

# Boostrap the BRT 1000 times to build confidence intervals
bais.prerun<- plot.gbm.4list(bais)
bais.boot <- gbm.bootstrap.functions(bais, list.predictors=bais.prerun, n.reps=100)

saveRDS(bais.boot, "Output/bais.boot.rds")

cclo.prerun<- plot.gbm.4list(cclo)
cclo.boot <- gbm.bootstrap.functions(cclo, list.predictors=cclo.prerun, n.reps=100)

saveRDS(cclo.boot, "Output/cclo.boot.rds")

sppi.prerun<- plot.gbm.4list(sppi)
sppi.boot <- gbm.bootstrap.functions(sppi, list.predictors=sppi.prerun, n.reps=100)

saveRDS(sppi.boot, "Output/sppi.boot.rds")

mago.prerun<- plot.gbm.4list(mago)
mago.boot <- gbm.bootstrap.functions(mago, list.predictors=mago.prerun, n.reps=100)

saveRDS(mago.boot, "Output/mago.boot.rds")

will.prerun<- plot.gbm.4list(will)
will.boot <- gbm.bootstrap.functions(will, list.predictors=will.prerun, n.reps=100)

saveRDS(will.boot, "Output/will.boot.rds")

lbcu.prerun<- plot.gbm.4list(lbcu)
lbcu.boot <- gbm.bootstrap.functions(lbcu, list.predictors=lbcu.prerun, n.reps=100)

saveRDS(lbcu.boot, "Output/lbcu.boot.rds")

#read in saved boot files  

bais.boot <- readRDS( "Output/bais.boot.rds")
sppi.boot <- readRDS("Output/sppi.boot.rds")
cclo.boot <- readRDS("Output/cclo.boot.rds")

lbcu.boot <- readRDS("Output/lbcu.boot.rds")
will.boot <- readRDS("Output/will.boot.rds")
mago.boot <- readRDS("Output/mago.boot.rds")

####################################
# Draw partial dependency plots a given predictor (i.e., "Complexity")
ggPD_boot(lbcu, predictor="DD_0_", list.4.preds=lbcu.prerun,
          booted.preds=lbcu.boot$function.preds, type.ci = "ribbon",rug = T)

ggPD_boot(will, predictor="MAP_", list.4.preds=will.prerun,
          booted.preds=will.boot$function.preds, type.ci = "ribbon",rug = T)

ggPD_boot(mago, predictor="NDVIe_9", list.4.preds=mago.prerun,
          booted.preds=mago.boot$function.preds, type.ci = "ribbon",rug = T)

## ok that didn't work quite right, why? try manually

bais.object <- bais
bais.booted.preds <- bais.boot$function.preds
cis <- c(0.025, 0.975)
bais.gbm.call <- bais.object$gbm.call
bais.pred.names <- bais.gbm.call$predictor.names


requireNamespace("splines")
bais.gbm.x <- bais.gbm.call$gbm.x
bais.response.name <- bais.gbm.call$response.name
bais.nt<- bais.object$n.trees
bais.data <- bais.gbm.call$dataframe

bais.k <- match(bais.object$contributions$var[1], bais.pred.names)

#var.name <- x.label
bais.pred.data <- bais.data[, bais.gbm.call$gbm.x[bais.k]]
bais.response.matrix <- gbm::plot.gbm(bais.object, i.var = bais.k, n.trees = bais.nt, return.grid = TRUE)
bais.predictors <- bais.response.matrix[, 1]

#if (is.factor(data[, gbm.call$gbm.x[k]])) {
 # predictors[[j]] <- factor(predictors[[j]], levels = levels(data[,gbm.call$gbm.x[k]]))
#}

bais.responses <- bais.response.matrix[, 2] - mean(bais.response.matrix[, 2])

bais.num.values <- nrow(bais.response.matrix)

temp <-apply(bais.booted.preds[,bais.k,]- mean(bais.booted.preds[,bais.k,]), 1, function(x){quantile(x, cis[1],na.rm=T)})
bais.responses.lower <- temp[1:bais.num.values]

temp <-apply(bais.booted.preds[,bais.k,]- mean(bais.booted.preds[,bais.k,]), 1, function(x){quantile(x, cis[2],na.rm=T)})
bais.responses.upper <- temp[1:bais.num.values]

bais.ymin = min(bais.responses.lower)
bais.ymax = max(bais.responses.upper)

bais.dat<-data.frame(bais.pred.data)

bais.k <- match(bais.object$contributions$var[1], bais.pred.names)
bais.var.name <- bais.gbm.call$predictor.names[bais.k]

bais.fittedFunc <-data.frame(bais.predictors,bais.responses)
colnames(bais.fittedFunc)<-c("x","y")

bais.fittedFunc.lower <-data.frame(bais.predictors,bais.responses.lower)
colnames(bais.fittedFunc.lower)<-c("x","y")

bais.fittedFunc.upper <-data.frame(bais.predictors,bais.responses.upper)
colnames(bais.fittedFunc.upper)<-c("x","y")

bais.fittedVal <- data.frame(bais.object$fitted, bais.dat)
colnames(bais.fittedVal)<-c("y","x")

bais.ribbon <-data.frame("x"=bais.fittedFunc.lower$x,"ylow"= bais.fittedFunc.lower$y,
                         "yup"= bais.fittedFunc.upper$y)

#aesthetics

col.ci= "grey80"
cex.ci=0.3
lty.ci=2
alpha.ci=0.5
col.line="darkorange"
cex.line=0.5

bais.ggPD <- ggplot()+
    geom_ribbon(data= bais.ribbon, aes(x=x,ymin=ylow,ymax=yup),fill=col.ci,alpha=alpha.ci)+
    geom_line(data= bais.fittedFunc, aes(x=x,y=y),color=col.line, linewidth =cex.line)+
    ylab("Fitted function")+
    xlab(paste(bais.var.name, "  (", round(bais.object$contributions[,2], 1), "%)", sep = ""))+
    theme_bw()+
    theme(panel.grid.minor = element_line(linetype = "blank"),
          panel.grid.major = element_line(linetype = "blank"),
          axis.title.x  = element_text(size=10),
          axis.line.y = element_line(linewidth=0.1),
          axis.line.x=element_line(linewidth=0.1))

bais.ggPD  
  
#smooth
bais.ggPD + geom_smooth(data=bais.fittedFunc,aes(x=x,y=y),span= 0.3, size= 0.3,color= "blue",se=F,linetype=2)
  
########################
# SPPI

sppi.object <- sppi
sppi.booted.preds <- sppi.boot$function.preds
cis <- c(0.025, 0.975)
sppi.gbm.call <- sppi.object$gbm.call
sppi.pred.names <- sppi.gbm.call$predictor.names


requireNamespace("splines")
sppi.gbm.x <- sppi.gbm.call$gbm.x
sppi.response.name <- sppi.gbm.call$response.name
sppi.nt<- sppi.object$n.trees
sppi.data <- sppi.gbm.call$dataframe

sppi.k <- match(sppi.object$contributions$var[1], sppi.pred.names)

#var.name <- x.label
sppi.pred.data <- sppi.data[, sppi.gbm.call$gbm.x[sppi.k]]
sppi.response.matrix <- gbm::plot.gbm(sppi.object, i.var = sppi.k, n.trees = sppi.nt, return.grid = TRUE)
sppi.predictors <- sppi.response.matrix[, 1]

#if (is.factor(data[, gbm.call$gbm.x[k]])) {
# predictors[[j]] <- factor(predictors[[j]], levels = levels(data[,gbm.call$gbm.x[k]]))
#}

sppi.responses <- sppi.response.matrix[, 2] - mean(sppi.response.matrix[, 2])

sppi.num.values <- nrow(sppi.response.matrix)

temp <-apply(sppi.booted.preds[,sppi.k,]- mean(sppi.booted.preds[,sppi.k,]), 1, function(x){quantile(x, cis[1],na.rm=T)})
sppi.responses.lower <- temp[1:sppi.num.values]

temp <-apply(sppi.booted.preds[,sppi.k,]- mean(sppi.booted.preds[,sppi.k,]), 1, function(x){quantile(x, cis[2],na.rm=T)})
sppi.responses.upper <- temp[1:sppi.num.values]

sppi.ymin = min(sppi.responses.lower)
sppi.ymax = max(sppi.responses.upper)

sppi.dat<-data.frame(sppi.pred.data)

sppi.k <- match(sppi.object$contributions$var[1], sppi.pred.names)
sppi.var.name <- sppi.gbm.call$predictor.names[sppi.k]

sppi.fittedFunc <-data.frame(sppi.predictors,sppi.responses)
colnames(sppi.fittedFunc)<-c("x","y")

sppi.fittedFunc.lower <-data.frame(sppi.predictors,sppi.responses.lower)
colnames(sppi.fittedFunc.lower)<-c("x","y")

sppi.fittedFunc.upper <-data.frame(sppi.predictors,sppi.responses.upper)
colnames(sppi.fittedFunc.upper)<-c("x","y")

sppi.fittedVal <- data.frame(sppi.object$fitted, sppi.dat)
colnames(sppi.fittedVal)<-c("y","x")

sppi.ribbon <-data.frame("x"=sppi.fittedFunc.lower$x,"ylow"= sppi.fittedFunc.lower$y,
                         "yup"= sppi.fittedFunc.upper$y)

#aesthetics

col.ci= "grey80"
cex.ci=0.3
lty.ci=2
alpha.ci=0.5
col.line="darkorange"
cex.line=0.5

sppi.ggPD <- ggplot()+
  geom_ribbon(data= sppi.ribbon, aes(x=x,ymin=ylow,ymax=yup),fill=col.ci,alpha=alpha.ci)+
  geom_line(data= sppi.fittedFunc, aes(x=x,y=y),color=col.line, linewidth =cex.line)+
  ylab("Fitted function")+
  xlab(paste(sppi.var.name, "  (", round(sppi.object$contributions[,2], 1), "%)", sep = ""))+
  theme_bw()+
  theme(panel.grid.minor = element_line(linetype = "blank"),
        panel.grid.major = element_line(linetype = "blank"),
        axis.title.x  = element_text(size=10),
        axis.line.y = element_line(linewidth=0.1),
        axis.line.x=element_line(linewidth=0.1))

sppi.ggPD  

#smooth
sppi.ggPD + geom_smooth(data=sppi.fittedFunc,aes(x=x,y=y),span= 0.3, size= 0.3,color= "blue",se=F,linetype=2)

##############################
# CCLO

cclo.object <- cclo
cclo.booted.preds <- cclo.boot$function.preds
cis <- c(0.025, 0.975)
cclo.gbm.call <- cclo.object$gbm.call
cclo.pred.names <- cclo.gbm.call$predictor.names


requireNamespace("splines")
cclo.gbm.x <- cclo.gbm.call$gbm.x
cclo.response.name <- cclo.gbm.call$response.name
cclo.nt<- cclo.object$n.trees
cclo.data <- cclo.gbm.call$dataframe

cclo.k <- match(cclo.object$contributions$var[1], cclo.pred.names)

#var.name <- x.label
cclo.pred.data <- cclo.data[, cclo.gbm.call$gbm.x[cclo.k]]
cclo.response.matrix <- gbm::plot.gbm(cclo.object, i.var = cclo.k, n.trees = cclo.nt, return.grid = TRUE)
cclo.predictors <- cclo.response.matrix[, 1]

#if (is.factor(data[, gbm.call$gbm.x[k]])) {
# predictors[[j]] <- factor(predictors[[j]], levels = levels(data[,gbm.call$gbm.x[k]]))
#}

cclo.responses <- cclo.response.matrix[, 2] - mean(cclo.response.matrix[, 2])

cclo.num.values <- nrow(cclo.response.matrix)

temp <-apply(cclo.booted.preds[,cclo.k,]- mean(cclo.booted.preds[,cclo.k,]), 1, function(x){quantile(x, cis[1],na.rm=T)})
cclo.responses.lower <- temp[1:cclo.num.values]

temp <-apply(cclo.booted.preds[,cclo.k,]- mean(cclo.booted.preds[,cclo.k,]), 1, function(x){quantile(x, cis[2],na.rm=T)})
cclo.responses.upper <- temp[1:cclo.num.values]

cclo.ymin = min(cclo.responses.lower)
cclo.ymax = max(cclo.responses.upper)

cclo.dat<-data.frame(cclo.pred.data)

cclo.k <- match(cclo.object$contributions$var[1], cclo.pred.names)
cclo.var.name <- cclo.gbm.call$predictor.names[cclo.k]

cclo.fittedFunc <-data.frame(cclo.predictors,cclo.responses)
colnames(cclo.fittedFunc)<-c("x","y")

cclo.fittedFunc.lower <-data.frame(cclo.predictors,cclo.responses.lower)
colnames(cclo.fittedFunc.lower)<-c("x","y")

cclo.fittedFunc.upper <-data.frame(cclo.predictors,cclo.responses.upper)
colnames(cclo.fittedFunc.upper)<-c("x","y")

cclo.fittedVal <- data.frame(cclo.object$fitted, cclo.dat)
colnames(cclo.fittedVal)<-c("y","x")

cclo.ribbon <-data.frame("x"=cclo.fittedFunc.lower$x,"ylow"= cclo.fittedFunc.lower$y,
                         "yup"= cclo.fittedFunc.upper$y)

#aesthetics

col.ci= "grey80"
cex.ci=0.3
lty.ci=2
alpha.ci=0.5
col.line="darkorange"
cex.line=0.5

cclo.ggPD <- ggplot()+
  geom_ribbon(data= cclo.ribbon, aes(x=x,ymin=ylow,ymax=yup),fill=col.ci,alpha=alpha.ci)+
  geom_line(data= cclo.fittedFunc, aes(x=x,y=y),color=col.line, linewidth =cex.line)+
  ylab("Fitted function")+
  xlab(paste(cclo.var.name, "  (", round(cclo.object$contributions[,2], 1), "%)", sep = ""))+
  theme_bw()+
  theme(panel.grid.minor = element_line(linetype = "blank"),
        panel.grid.major = element_line(linetype = "blank"),
        axis.title.x  = element_text(size=10),
        axis.line.y = element_line(linewidth=0.1),
        axis.line.x=element_line(linewidth=0.1))

cclo.ggPD  

#smooth
cclo.ggPD + geom_smooth(data=cclo.fittedFunc,aes(x=x,y=y),span= 0.3, size= 0.3,color= "blue",se=F,linetype=2)

#####
# Plot with all three

heatramp<- colorRampPalette(c("#ABD9E9","#FFFFBF","#FEE090","#FDAE61","#F46D43", "#D73027", "#A50026") )

sppi.fittedFunc$Species1 <- "Sprague's Pipit"
bais.fittedFunc$Species2 <- "Baird's Sparrow"
cclo.fittedFunc$Species3 <- "Chestnut-collared Longspur"

upland <- ggplot()+
  geom_ribbon(data= sppi.ribbon, aes(x=x,ymin=ylow,ymax=yup, fill = "Species1"),alpha= 0.1)+
  geom_line(data= sppi.fittedFunc, aes(x=x,y=y, color=  "Species1"), linewidth =cex.line)+
  geom_ribbon(data= bais.ribbon, aes(x=x,ymin=ylow,ymax=yup, fill = "Species2"), alpha= 0.1)+
  geom_line(data= bais.fittedFunc, aes(x=x,y=y, color= "Species2"), linewidth =cex.line)+
  geom_ribbon(data= cclo.ribbon, aes(x=x,ymin=ylow,ymax=yup, fill = "Species3"),alpha= 0.1)+
  geom_line(data= cclo.fittedFunc, aes(x=x,y=y, color= "Species3"), linewidth =cex.line)+
  scale_x_continuous(labels = function(x) x/25*100) +
  scale_color_manual(name = "Species", labels = c("Sprague's Pipit", "Baird's Sparrow", "Chestnut-collared Longspur"), values = c("Species1" = "#D73027", "Species2" = "#ABD9E9", "Species3" = "#FEE090"))+
  scale_fill_manual(name = "Species",labels = c("Sprague's Pipit", "Baird's Sparrow", "Chestnut-collared Longspur"), values = c("Species1" = "#D73027", "Species2" = "#ABD9E9", "Species3" = "#FEE090"))+
  labs(x = expression(paste("Percent grassland cover within 16", km^2)), y = "Fitted function") +
  theme_bw()+
  theme(legend.position = c(0.28, 0.8))+
  theme(panel.grid.minor = element_line(linetype = "blank"),
        panel.grid.major = element_line(linetype = "blank"),
        axis.title.x  = element_text(size=10),
        axis.line.y = element_line(linewidth=0.1),
        axis.line.x=element_line(linewidth=0.1))


upland

library(ggpubr)

ggarrange(wetland, upland, ncol = 2, labels = c("A", "B"))


ggsave("habitat_figure.png", width = 10, height = 6)

#######
# LBCU


lbcu.object <- lbcu
lbcu.booted.preds <- lbcu.boot$function.preds
cis <- c(0.025, 0.975)
lbcu.gbm.call <- lbcu.object$gbm.call
lbcu.pred.names <- lbcu.gbm.call$predictor.names


requireNamespace("splines")
lbcu.gbm.x <- lbcu.gbm.call$gbm.x
lbcu.response.name <- lbcu.gbm.call$response.name
lbcu.nt<- lbcu.object$n.trees
lbcu.data <- lbcu.gbm.call$dataframe

lbcu.k <- match(lbcu.object$contributions$var[3], lbcu.pred.names)

#var.name <- x.label
lbcu.pred.data <- lbcu.data[, lbcu.gbm.call$gbm.x[lbcu.k]]
lbcu.response.matrix <- gbm::plot.gbm(lbcu.object, i.var = lbcu.k, n.trees = lbcu.nt, return.grid = TRUE)
lbcu.predictors <- lbcu.response.matrix[, 1]

#if (is.factor(data[, gbm.call$gbm.x[k]])) {
# predictors[[j]] <- factor(predictors[[j]], levels = levels(data[,gbm.call$gbm.x[k]]))
#}

lbcu.responses <- lbcu.response.matrix[, 2] - mean(lbcu.response.matrix[, 2])

lbcu.num.values <- nrow(lbcu.response.matrix)

temp <-apply(lbcu.booted.preds[,lbcu.k,]- mean(lbcu.booted.preds[,lbcu.k,]), 1, function(x){quantile(x, cis[1],na.rm=T)})
lbcu.responses.lower <- temp[1:lbcu.num.values]

temp <-apply(lbcu.booted.preds[,lbcu.k,]- mean(lbcu.booted.preds[,lbcu.k,]), 1, function(x){quantile(x, cis[2],na.rm=T)})
lbcu.responses.upper <- temp[1:lbcu.num.values]

lbcu.ymin = min(lbcu.responses.lower)
lbcu.ymax = max(lbcu.responses.upper)

lbcu.dat<-data.frame(lbcu.pred.data)

lbcu.k <- match(lbcu.object$contributions$var[3], lbcu.pred.names)
lbcu.var.name <- lbcu.gbm.call$predictor.names[lbcu.k]

lbcu.fittedFunc <-data.frame(lbcu.predictors,lbcu.responses)
colnames(lbcu.fittedFunc)<-c("x","y")

lbcu.fittedFunc.lower <-data.frame(lbcu.predictors,lbcu.responses.lower)
colnames(lbcu.fittedFunc.lower)<-c("x","y")

lbcu.fittedFunc.upper <-data.frame(lbcu.predictors,lbcu.responses.upper)
colnames(lbcu.fittedFunc.upper)<-c("x","y")

lbcu.fittedVal <- data.frame(lbcu.object$fitted, lbcu.dat)
colnames(lbcu.fittedVal)<-c("y","x")

lbcu.ribbon <-data.frame("x"=lbcu.fittedFunc.lower$x,"ylow"= lbcu.fittedFunc.lower$y,
                         "yup"= lbcu.fittedFunc.upper$y)

#aesthetics

col.ci= "grey80"
cex.ci=0.3
lty.ci=2
alpha.ci=0.5
col.line="darkorange"
cex.line=0.5

lbcu.ggPD <- ggplot()+
  geom_ribbon(data= lbcu.ribbon, aes(x=x,ymin=ylow,ymax=yup),fill=col.ci,alpha=alpha.ci)+
  geom_line(data= lbcu.fittedFunc, aes(x=x,y=y),color=col.line, linewidth =cex.line)+
  ylab("Fitted function")+
  xlab(paste(lbcu.var.name, ""))+
  theme_bw()+
  theme(panel.grid.minor = element_line(linetype = "blank"),
        panel.grid.major = element_line(linetype = "blank"),
        axis.title.x  = element_text(size=10),
        axis.line.y = element_line(linewidth=0.1),
        axis.line.x=element_line(linewidth=0.1))

lbcu.ggPD  

#smooth
lbcu.ggPD + geom_smooth(data=lbcu.fittedFunc,aes(x=x,y=y),span= 0.3, size= 0.3,color= "blue",se=F,linetype=2)

###################
# WILL

will.object <- will
will.booted.preds <- will.boot$function.preds
cis <- c(0.025, 0.975)
will.gbm.call <- will.object$gbm.call
will.pred.names <- will.gbm.call$predictor.names


requireNamespace("splines")
will.gbm.x <- will.gbm.call$gbm.x
will.response.name <- will.gbm.call$response.name
will.nt<- will.object$n.trees
will.data <- will.gbm.call$dataframe

will.k <- match(will.object$contributions$var[3], will.pred.names)

#var.name <- x.label
will.pred.data <- will.data[, will.gbm.call$gbm.x[will.k]]
will.response.matrix <- gbm::plot.gbm(will.object, i.var = will.k, n.trees = will.nt, return.grid = TRUE)
will.predictors <- will.response.matrix[, 1]

#if (is.factor(data[, gbm.call$gbm.x[k]])) {
# predictors[[j]] <- factor(predictors[[j]], levels = levels(data[,gbm.call$gbm.x[k]]))
#}

will.responses <- will.response.matrix[, 2] - mean(will.response.matrix[, 2])

will.num.values <- nrow(will.response.matrix)

temp <-apply(will.booted.preds[,will.k,]- mean(will.booted.preds[,will.k,]), 1, function(x){quantile(x, cis[1],na.rm=T)})
will.responses.lower <- temp[1:will.num.values]

temp <-apply(will.booted.preds[,will.k,]- mean(will.booted.preds[,will.k,]), 1, function(x){quantile(x, cis[2],na.rm=T)})
will.responses.upper <- temp[1:will.num.values]

will.ymin = min(will.responses.lower)
will.ymax = max(will.responses.upper)

will.dat<-data.frame(will.pred.data)

will.k <- match(will.object$contributions$var[3], will.pred.names)
will.var.name <- will.gbm.call$predictor.names[will.k]

will.fittedFunc <-data.frame(will.predictors,will.responses)
colnames(will.fittedFunc)<-c("x","y")

will.fittedFunc.lower <-data.frame(will.predictors,will.responses.lower)
colnames(will.fittedFunc.lower)<-c("x","y")

will.fittedFunc.upper <-data.frame(will.predictors,will.responses.upper)
colnames(will.fittedFunc.upper)<-c("x","y")

will.fittedVal <- data.frame(will.object$fitted, will.dat)
colnames(will.fittedVal)<-c("y","x")

will.ribbon <-data.frame("x"=will.fittedFunc.lower$x,"ylow"= will.fittedFunc.lower$y,
                         "yup"= will.fittedFunc.upper$y)

#aesthetics

col.ci= "grey80"
cex.ci=0.3
lty.ci=2
alpha.ci=0.5
col.line="darkorange"
cex.line=0.5

will.ggPD <- ggplot()+
  geom_ribbon(data= will.ribbon, aes(x=x,ymin=ylow,ymax=yup),fill=col.ci,alpha=alpha.ci)+
  geom_line(data= will.fittedFunc, aes(x=x,y=y),color=col.line, linewidth =cex.line)+
  ylab("Fitted function")+
  xlab(paste(will.var.name, ""))+
  theme_bw()+
  theme(panel.grid.minor = element_line(linetype = "blank"),
        panel.grid.major = element_line(linetype = "blank"),
        axis.title.x  = element_text(size=10),
        axis.line.y = element_line(linewidth=0.1),
        axis.line.x=element_line(linewidth=0.1))

will.ggPD  

#smooth
will.ggPD + geom_smooth(data=will.fittedFunc,aes(x=x,y=y),span= 0.3, size= 0.3,color= "blue",se=F,linetype=2)

###################
# MAGO

mago.object <- mago
mago.booted.preds <- mago.boot$function.preds
cis <- c(0.025, 0.975)
mago.gbm.call <- mago.object$gbm.call
mago.pred.names <- mago.gbm.call$predictor.names


requireNamespace("splines")
mago.gbm.x <- mago.gbm.call$gbm.x
mago.response.name <- mago.gbm.call$response.name
mago.nt<- mago.object$n.trees
mago.data <- mago.gbm.call$dataframe

mago.k <- match(mago.object$contributions$var[3], mago.pred.names)

#var.name <- x.label
mago.pred.data <- mago.data[, mago.gbm.call$gbm.x[mago.k]]
mago.response.matrix <- gbm::plot.gbm(mago.object, i.var = mago.k, n.trees = mago.nt, return.grid = TRUE)
mago.predictors <- mago.response.matrix[, 1]

#if (is.factor(data[, gbm.call$gbm.x[k]])) {
# predictors[[j]] <- factor(predictors[[j]], levels = levels(data[,gbm.call$gbm.x[k]]))
#}

mago.responses <- mago.response.matrix[, 2] - mean(mago.response.matrix[, 2])

mago.num.values <- nrow(mago.response.matrix)

temp <-apply(mago.booted.preds[,mago.k,]- mean(mago.booted.preds[,mago.k,]), 1, function(x){quantile(x, cis[1],na.rm=T)})
mago.responses.lower <- temp[1:mago.num.values]

temp <-apply(mago.booted.preds[,mago.k,]- mean(mago.booted.preds[,mago.k,]), 1, function(x){quantile(x, cis[2],na.rm=T)})
mago.responses.upper <- temp[1:mago.num.values]

mago.ymin = min(mago.responses.lower)
mago.ymax = max(mago.responses.upper)

mago.dat<-data.frame(mago.pred.data)

mago.k <- match(mago.object$contributions$var[3], mago.pred.names)
mago.var.name <- mago.gbm.call$predictor.names[mago.k]

mago.fittedFunc <-data.frame(mago.predictors,mago.responses)
colnames(mago.fittedFunc)<-c("x","y")

mago.fittedFunc.lower <-data.frame(mago.predictors,mago.responses.lower)
colnames(mago.fittedFunc.lower)<-c("x","y")

mago.fittedFunc.upper <-data.frame(mago.predictors,mago.responses.upper)
colnames(mago.fittedFunc.upper)<-c("x","y")

mago.fittedVal <- data.frame(mago.object$fitted, mago.dat)
colnames(mago.fittedVal)<-c("y","x")

mago.ribbon <-data.frame("x"=mago.fittedFunc.lower$x,"ylow"= mago.fittedFunc.lower$y,
                         "yup"= mago.fittedFunc.upper$y)

#aesthetics

col.ci= "grey80"
cex.ci=0.3
lty.ci=2
alpha.ci=0.5
col.line="darkorange"
cex.line=0.5

mago.ggPD <- ggplot()+
  geom_ribbon(data= mago.ribbon, aes(x=x,ymin=ylow,ymax=yup),fill=col.ci,alpha=alpha.ci)+
  geom_line(data= mago.fittedFunc, aes(x=x,y=y),color=col.line, linewidth =cex.line)+
  ylab("Fitted function")+
  xlab(paste(mago.var.name, ""))+
  theme_bw()+
  theme(panel.grid.minor = element_line(linetype = "blank"),
        panel.grid.major = element_line(linetype = "blank"),
        axis.title.x  = element_text(size=10),
        axis.line.y = element_line(linewidth=0.1),
        axis.line.x=element_line(linewidth=0.1))

mago.ggPD  

#smooth
mago.ggPD + geom_smooth(data=mago.fittedFunc,aes(x=x,y=y),span= 0.3, size= 0.3,color= "blue",se=F,linetype=2)


#########################################################################3
 
response(cclo)




 if (rug==T){
    ggPD[[i]]<-ggPD[[i]]+geom_rug(data=fittedVal[[i]],aes(x=x,y=y),sides=rug.pos,position="jitter",color=col.rug)
  }

getVar = function(gbm.object,predictor_of_interest){
  gbm.call <- gbm.object$gbm.call
  gbm.x <- gbm.call$gbm.x
  pred.names <- gbm.call$predictor.names
  response.name <- gbm.call$response.name
  data <- gbm.call$dataframe
  k <- match(predictor_of_interest, pred.names)
  var.name <- gbm.call$predictor.names[k]
  pred.data <- data[, gbm.call$gbm.x[k]]
  response.matrix <- gbm::plot.gbm(gbm.object, k, return.grid = TRUE)
  data.frame(predictors = response.matrix[, 1],
             responses = response.matrix[, 2] - mean(response.matrix[,2])
  )
}





## why don't plot.gbm or the other function below work? Missing gbm.call
# part of the model object. Also might be something going on with var.levels.



par("mar")
par(mar=c(1,1,1,1))

gbm.plot(model, n.plots = 1, smooth = TRUE)

# Initialize an empty result matrix
pred.matrix <- matrix(0, nrow = nrow(model$data$x.order), ncol = ncol(model$data$x.order)) # x is a vector of data; x.order is a matrix with indices for positions in the x vector (best I can tell). 

# Loop through the columns of the index matrix
for (col_idx in 1:ncol(model$data$x.order)) {
  # Use matrix indexing to assign values from the vector to the result matrix
  pred.matrix[, col_idx] <- model$data$x[model$data$x.order[, col_idx] + 1]  # Adding 1 to convert from 0-based to 1-based indexing
}
colnames(pred.matrix) <- colnames(model$data$x.order)
pred.matrix <- data.frame(pred.matrix)

# load package for PDP (Interpretable Machine Learning package)
library(iml) 
predictor <- Predictor$new(model, data = pred.matrix, y = model$data$y)
pdp <- FeatureEffect$new(predictor, feature = "grass_25", method = "pdp")
pdp$plot()

gbm.object <- bais
##function for pulling out what we need for dependency plot
getVar = function(gbm.object,predictor_of_interest){
  gbm.call <- gbm.object$gbm.call
  gbm.x <- gbm.call$gbm.x
  pred.names <- gbm.call$predictor.names
  response.name <- gbm.call$response.name
  data <- gbm.call$dataframe
  k <- match(predictor_of_interest, pred.names)
  var.name <- gbm.call$predictor.names[k]
  pred.data <- data[, gbm.call$gbm.x[k]]
  response.matrix <- gbm::plot.gbm(gbm.object, k, return.grid = TRUE)
  data.frame(predictors = response.matrix[, 1],
             responses = response.matrix[, 2] - mean(response.matrix[,2])
  )
}

## use the function to get predictions for one variable across all bootstrap models

library(ggplot2)

da <- as.data.frame(getVar(bais,"grass_25"))
da = do.call(rbind,da)


ggplot(da,aes(x=predictors,y=responses)) +
  stat_summary(geom="ribbon",fun.ymin="min",fun.ymax="max",alpha=0.3) +
  stat_summary(geom="line",fun="mean", col = "darkorange")+ 
  labs(x = "grass_25 (29.7%)", y = "Fitted function") +theme_bw()


##boostrap and store in dataframe for plotting...


gbm.call <- gbm.object$gbm.call
pred.names <- gbm.call$predictor.names

  requireNamespace("splines")
  gbm.x <- gbm.call$gbm.x
  response.name <- gbm.call$response.name
  nt<-gbm.object$n.trees
  data <- gbm.call$dataframe
  
  max.vars <- length(gbm.object$contributions$var)

  predictors <- list(rep(NA, n.plots))
  responses <- list(rep(NA, n.plots))
  responses.lower <- list(rep(NA, n.plots))
  responses.upper <- list(rep(NA, n.plots))
  
k <- match(predictor_of_interest, pred.names)
    
  
var.name <- gbm.call$predictor.names[k]
   
      var.name <- x.label
    
pred.data <- data[, gbm.call$gbm.x[k]]

response.matrix <- gbm::plot.gbm(gbm.object, i.var = k, n.trees = nt, return.grid = TRUE,...)
    predictors <- response.matrix[, 1]
    if (is.factor(data[, gbm.call$gbm.x[k]])) {
      predictors <- factor(predictors, levels = levels(data[,gbm.call$gbm.x[k]]))
    }
    
    responses <- response.matrix[, 2] - mean(response.matrix[, 2])
    
    num.values <- nrow(response.matrix)
    
    temp <-apply(booted.preds[,k,]- mean(booted.preds[,k,]), 1, function(x){quantile(x, cis[1],na.rm=T)})
    responses.lower <- temp[1:num.values]
    
    temp <-apply(booted.preds[,k,]- mean(booted.preds[,k,]), 1, function(x){quantile(x, cis[2],na.rm=T)})
    responses.upper <- temp[1:num.values]
    
  
      ymin = min(responses.lower[[j]])
      ymax = max(responses.upper[[j]])
      dat<-data.frame(pred.data)

    
    fittedFunc<-list()
    fittedFunc.lower<-list()
    fittedFunc.upper<-list()
    fittedVal<-list()
    ribbon<-list()
    ggPD<-list()
    

    #  k <- match(gbm.object$contributions$var[i], pred.names)
      var.name <- gbm.call$predictor.names[k]
      
      fittedFunc <-data.frame(predictors,responses)
      colnames(fittedFunc)<-c("x","y")
      
      fittedFunc.lower <-data.frame(predictors,responses.lower)
      colnames(fittedFunc.lower)<-c("x","y")
      
      fittedFunc.upper <-data.frame(predictors,responses.upper)
      colnames(fittedFunc.upper)<-c("x","y")
      
      fittedVal[[i]]<-data.frame(gbm.object$fitted,dat[i])
      colnames(fittedVal[[i]])<-c("y","x")
      
      ribbon[[i]]<-data.frame("x"=fittedFunc.lower[[i]]$x,"ylow"=fittedFunc.lower[[i]]$y,"yup"=fittedFunc.upper[[i]]$y)
      
      if (is.factor(fittedFunc[[i]]$x)) {
        ggPD[[i]]<- ggplot(fittedFunc[[i]], aes(x=x,y=y))+
          geom_boxplot(color=col.line,size=cex.line)+
          geom_boxplot(data=fittedFunc.lower[[i]], aes(x=x,y=y),color=col.ci)+
          geom_boxplot(data=fittedFunc.upper[[i]], aes(x=x,y=y),color=col.ci)+
          ylab(y.label)+
          xlab(paste(var.name, "  (", round(gbm.object$contributions[i,2], 1), "%)", sep = ""))+
          theme_bw()+
          theme(panel.grid.minor = element_line(linetype = "blank"),
                panel.grid.major = element_line(linetype = "blank"),
                axis.text.x  = element_text(size=6),
                axis.title.x  = element_text(size=10),
                axis.line.y = element_line(size=0.1),
                axis.line.x=element_line(size=0.1))
        
        if (common.scale==T){
          ggPD[[i]]<-ggPD[[i]]+ylim(c(ymin,ymax))}
      }
      
      if (type.ci=="lines"){
        ggPD[[i]]<- ggplot(fittedFunc[[i]], aes(x=x,y=y))+
          geom_line(color=col.line,size=cex.line)+
          geom_line(data=fittedFunc.lower[[i]],aes(x=x,y=y),size=cex.ci,color=col.ci,linetype=lty.ci)+
          geom_line(data=fittedFunc.upper[[i]],aes(x=x,y=y),size=cex.ci,color=col.ci,linetype=lty.ci)+
          ylab(y.label)+
          xlab(paste(var.name, "  (", round(gbm.object$contributions[i,2], 1), "%)", sep = ""))+
          theme_bw()+
          theme(panel.grid.minor = element_line(linetype = "blank"),
                panel.grid.major = element_line(linetype = "blank"),
                axis.title.x  = element_text(size=10),
                axis.line.y = element_line(size=0.1),
                axis.line.x=element_line(size=0.1))
        
        if (smooth==T){
          ggPD[[i]]<-ggPD[[i]]+geom_smooth(span=span,size=cex.smooth,color=col.smooth,se=F,linetype=2)
        }
        
        if (rug==T){
          ggPD[[i]]<-ggPD[[i]]+geom_rug(data=fittedVal[[i]],aes(x=x,y=y),sides=rug.pos,position="jitter",color=col.rug)
        }
        
        if (common.scale==T){
          ggPD[[i]]<-ggPD[[i]]+ylim(c(ymin,ymax))
        }
      }
      
      if (type.ci=="ribbon"){
        ggPD[[i]]<- ggplot()+
          geom_ribbon(data=ribbon[[i]],aes(x=x,ymin=ylow,ymax=yup),fill=col.ci,alpha=alpha.ci)+
          geom_line(data=fittedFunc[[i]], aes(x=x,y=y),color=col.line,size=cex.line)+
          ylab(y.label)+
          xlab(paste(var.name, "  (", round(gbm.object$contributions[i,2], 1), "%)", sep = ""))+
          theme_bw()+
          theme(panel.grid.minor = element_line(linetype = "blank"),
                panel.grid.major = element_line(linetype = "blank"),
                axis.title.x  = element_text(size=10),
                axis.line.y = element_line(size=0.1),
                axis.line.x=element_line(size=0.1))
        
        if (smooth==T){
          ggPD[[i]]<-ggPD[[i]]+geom_smooth(data=fittedFunc[[i]],aes(x=x,y=y),span=span,size=cex.smooth,color=col.smooth,se=F,linetype=2)
        }
        
        if (rug==T){
          ggPD[[i]]<-ggPD[[i]]+geom_rug(data=fittedVal[[i]],aes(x=x,y=y),sides=rug.pos,position="jitter",color=col.rug)
        }
        
        if (common.scale==T){
          ggPD[[i]]<-ggPD[[i]]+ylim(c(ymin,ymax))
        }
      }
    }
    list(ggPD=ggPD)
  }
  
  else{
    
    if (is.character(predictor)){
      predictor<-match(predictor,gbm.object$contributions$var)}
    
    k <- match(gbm.object$contributions$var[predictor], pred.names)
    var.name <- gbm.call$predictor.names[k]
    
    fittedFunc<-data.frame(predictors[predictor],responses[predictor])
    colnames(fittedFunc)<-c("x","y")
    
    fittedFunc.lower<-data.frame(predictors[predictor],responses.lower[predictor])
    colnames(fittedFunc.lower)<-c("x","y")
    
    fittedFunc.upper<-data.frame(predictors[predictor],responses.upper[predictor])
    colnames(fittedFunc.upper)<-c("x","y")
    
    ribbon<-data.frame("x"=fittedFunc.lower$x,"ylow"=fittedFunc.lower$y,"yup"=fittedFunc.upper$y)
    
    fittedVal<-data.frame(gbm.object$fitted,dat[predictor])
    colnames(fittedVal)<-c("y","x")
    
    if (is.factor(fittedFunc$x)) {
      ggPD<- ggplot(fittedFunc, aes(x=x,y=y))+
        geom_boxplot(color=col.line,size=cex.line)+
        geom_boxplot(data=fittedFunc.lower, aes(x=x,y=y),color=col.ci)+
        geom_boxplot(data=fittedFunc.upper, aes(x=x,y=y),color=col.ci)+
        ylab(y.label)+
        xlab(paste(var.name, "  (", round(gbm.object$contributions[predictor,2], 1), "%)", sep = ""))+
        theme_bw()+
        theme(panel.grid.minor = element_line(linetype = "blank"),
              panel.grid.major = element_line(linetype = "blank"),
              axis.text.x  = element_text(size=6),
              axis.title.x  = element_text(size=10),
              axis.line.y = element_line(size=0.1),
              axis.line.x=element_line(size=0.1))
      
      if (common.scale==T){
        ggPD<-ggPD+ylim(c(ymin,ymax))}
    }
    
    if (type.ci=="lines"){
      ggPD<- ggplot(fittedFunc, aes(x=x,y=y))+
        geom_line(color=col.line,size=cex.line)+
        geom_line(data=fittedFunc.lower,aes(x=x,y=y),size=cex.ci,color=col.ci,linetype=lty.ci)+
        geom_line(data=fittedFunc.upper,aes(x=x,y=y),size=cex.ci,color=col.ci,linetype=lty.ci)+
        ylab(y.label)+
        xlab(paste(var.name, "  (", round(gbm.object$contributions[predictor,2], 1), "%)", sep = ""))+
        theme_bw()+
        theme(panel.grid.minor = element_line(linetype = "blank"),
              panel.grid.major = element_line(linetype = "blank"),
              axis.title.x  = element_text(size=10),
              axis.line.y = element_line(size=0.1),
              axis.line.x=element_line(size=0.1))
      
      if (smooth==T){
        ggPD<-ggPD+geom_smooth(span=span,size=cex.smooth,color=col.smooth,se=F,linetype=2)
      }
      
      if (rug==T){
        ggPD<-ggPD+geom_rug(data=fittedVal,aes(x=x,y=y),sides=rug.pos,position="jitter",color=col.rug)
      }
      
      if (common.scale==T){
        ggPD<-ggPD+ylim(c(ymin,ymax))
      }
    }
    
    if (type.ci=="ribbon"){
      ggPD<- ggplot()+
        geom_ribbon(data=ribbon,aes(x=x,ymin=ylow,ymax=yup),fill=col.ci,alpha=alpha.ci)+
        geom_line(data=fittedFunc,aes(x=x,y=y),color=col.line,size=cex.line)+
        ylab(y.label)+
        xlab(paste(var.name, "  (", round(gbm.object$contributions[predictor,2], 1), "%)", sep = ""))+
        theme_bw()+
        theme(panel.grid.minor = element_line(linetype = "blank"),
              panel.grid.major = element_line(linetype = "blank"),
              axis.title.x  = element_text(size=10),
              axis.line.y = element_line(size=0.1),
              axis.line.x=element_line(size=0.1))
      
      if (smooth==T){
        ggPD<-ggPD+geom_smooth(data=fittedFunc,aes(x=x,y=y),span=span,size=cex.smooth,color=col.smooth,se=F,linetype=2)
      }
      
      if (rug==T){
        ggPD<-ggPD+geom_rug(data=fittedVal,aes(x=x,y=y),sides=rug.pos,position="jitter",color=col.rug)
      }
      
      if (common.scale==T){
        ggPD<-ggPD+ylim(c(ymin,ymax))
      }
    }
    list(ggPD=ggPD)
  }
}

plot<-ggPD_boot.plots(gbm.object)

if(is.null(predictor)){
  do.call(grid.arrange,c(plot$ggPD,list(nrow=nrow,ncol=ncol)))}
else grid.draw(plot$ggPD)
}