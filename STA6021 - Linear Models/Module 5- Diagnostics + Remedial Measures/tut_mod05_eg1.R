#############
##Example 1##
#############
## store data file with the variable name Data
Data<-read.table("mazda.txt", header=TRUE, sep="")

#####################################
##Scatterplot for model diagnostics##
#####################################

library(tidyverse)

##scatterplot, and overlay regression line
ggplot2::ggplot(Data, aes(x=Age,y=Price))+
  geom_point()+
  geom_smooth(method = "lm", se=FALSE)+
  labs(x="Age", y="Sales Price", title="Scatterplot of Sales Price against Age")

#######################################
##Residual plot for model diagnostics##
#######################################

result<-lm(Price~Age, data=Data)
par(mfrow = c(2, 2))
plot(result)

##notice fanning out pattern. Need to transform y.

##########################
##Box Cox to transform y##
##########################

library(MASS) ##to use boxcox function
MASS::boxcox(result)

##adjust lambda for better visualization. Choose lambda between -0.5 and 0.5
MASS::boxcox(result, lambda = seq(-0.5, 0.5, 1/10)) 


##transform y and then regress ystar on x
ystar<-log(Data$Price)
Data<-data.frame(Data,ystar)
result.ystar<-lm(ystar~Age, data=Data)
par(mfrow = c(2, 2))
plot(result.ystar)

##Looks good. No need for any more transformations on x or y

##If you want, can produce Box Cox plot. 

##Print out regression coefficients. Can interpret since we used log

result.ystar

#########################
##ACF Plot of residuals##
#########################

acf(result.ystar$residuals, main="ACF Plot of Residuals with ystar")
