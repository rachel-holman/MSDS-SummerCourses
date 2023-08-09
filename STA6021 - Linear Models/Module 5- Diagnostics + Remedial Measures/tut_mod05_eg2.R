#############
##Example 2##
#############

## store data file with the variable name Data
Data<-read.table("windmill.txt", header=TRUE, sep="")

#####################################
##Scatterplot for model diagnostics##
#####################################

library(tidyverse)

##scatterplot, and overlay regression line
ggplot2::ggplot(Data, aes(x=wind,y=output))+
  geom_point()+
  geom_smooth(method = "lm", se=FALSE)+
  labs(x="Wind Speed", y="DC Output", title="Scatterplot of Electric Output against Wind Speed")


##Looks non linear. For wind velocity between 4 and 8, plots are above the regression line.
##Otherwise, the plots are below the regression line.
##Assumption 1 not met.
##Assumption 2 difficult to see in this picture

#######################################
##Residual plot for model diagnostics##
#######################################

##Fit a regression model
result<-lm(output~wind, data=Data)
par(mfrow = c(2, 2))
plot(result)

##Curved pattern. So non linear relationship. 
##Assumption 1 not met.
##Vertical spread is constant though. 
##Assumption 2 met. 
##So no need to transform y, need to transform x. 

##Based on scatterplot, try inverse transform
##Log transform or squareroot transform could be tried as well
##inverse relationship makes sense in engineering context
Data$xstar<-1/(Data$wind)

##regress y on xstar
result.xstar<-lm(output~xstar, data=Data)
par(mfrow = c(2, 2))
plot(result.xstar)

##improvement. Residuals more evenly scattered across horizontal line
##Vertical spread appears constant.
##Assumptions 1 and 2 both met.

##confirm assumption 2 with Box Cox plot
library(MASS)
MASS::boxcox(result.xstar)
##1 inside interval, so no need to transform y. 