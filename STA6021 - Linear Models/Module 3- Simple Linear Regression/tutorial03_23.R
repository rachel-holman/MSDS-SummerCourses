library(tidyverse)
library(openintro)
Data<-openintro::elmhurst

##scatterplot of gift aid against family income
ggplot2::ggplot(Data, aes(x=family_income,y=gift_aid))+
  geom_point()+
  geom_smooth(method = "lm", se=FALSE)+
  labs(x="Family Income", y="Gift Aid", title="Scatterplot of Gift Aid against Family")

##regress gift aid against family income
result<-lm(gift_aid~family_income, data=Data)

##look at information regarding regresion
summary(result)

##see what can be extracted from summary(result)
names(summary(result))

##extract coefficients
summary(result)$coefficients
##extract slope
summary(result)$coefficients[2,1]
##extract intercept
summary(result)$coefficients[1,1]

##############
##prediction##
##############

##create data point for prediction
newdata<-data.frame(family_income=50)
##predicted gift aid when x=50
predict(result,newdata)

###############
##ANOVA Table##
###############

anova.tab<-anova(result)
anova.tab

##correlation
cor(Data$family_income,Data$gift_aid)
