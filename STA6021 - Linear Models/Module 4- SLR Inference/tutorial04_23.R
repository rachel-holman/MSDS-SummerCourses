library(tidyverse)
library(openintro)
Data<-openintro::elmhurst

##Fit a regression model
result<-lm(gift_aid~family_income, data=Data)

##look at t stats and F stat
summary(result)

##pvalue
2*pt(-abs(-3.985), df = 50-2)

##critical value
qt(1-0.05/2, df = 50-2)

##to produce 95% CIs for all regression coefficients
confint(result,level = 0.95)

##to produce 95% CI for the mean response when x=80, 
newdata<-data.frame(family_income=80)
predict(result,newdata,level=0.95, interval="confidence")

##and the 95% PI for the response of an observation when x=80
predict(result,newdata,level=0.95, interval="prediction")

##regular scatterplot
##with regression line overlaid, and bounds of CI for mean y
ggplot2::ggplot(Data, aes(x=family_income, y=gift_aid))+
  geom_point() +
  geom_smooth(method=lm)+
  labs(x="Family Income", 
       y="Gift Aid", 
       title="Scatterplot of Gift Aid against Family Income")

##find PIs for each observation
preds <- predict(result, interval="prediction")

##add preds to data frame
Data<-data.frame(Data,preds)

##overlay PIs via geom_line()
ggplot2::ggplot(Data, aes(x=family_income, y=gift_aid))+
  geom_point() +
  geom_line(aes(y=lwr), color = "red", linetype = "dashed")+
  geom_line(aes(y=upr), color = "red", linetype = "dashed")+
  geom_smooth(method=lm)+
  labs(x="Family Income", 
       y="Gift Aid", 
       title="Scatterplot of Gift Aid against Family Income")
