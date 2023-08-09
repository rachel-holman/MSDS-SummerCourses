library(tidyverse)
Data<-read.table("wine.txt", header=TRUE, sep="")

##is Region a factor?
class(Data$Region)
##convert Region to factor
Data$Region<-factor(Data$Region) 
##check Region is now the correct type
class(Data$Region)

##how are levels described
levels(Data$Region)
##Give names to the levels
levels(Data$Region) <- c("North", "Central", "Napa") 
levels(Data$Region)

##scatterplot of Quality against Flavor, 
##separated by Region
ggplot2::ggplot(Data, aes(x=Flavor, y=Quality, color=Region))+
  geom_point()+
  geom_smooth(method=lm, se=FALSE)+
  labs(title="Scatterplot of Wine Quality against Flavor, by Region")

##slopes almost parallel

##check dummy coding
contrasts(Data$Region)
##Set a different reference class
Data$Region<-relevel(Data$Region, ref = "Napa") 
contrasts(Data$Region)

##consider model with interactions 
##(when slopes are not parallel)
result<-lm(Quality~Flavor*Region, data=Data)
summary(result)
##notice hierarchical principle is used

##fit regression with no interaction
reduced<-lm(Quality~Flavor+Region, data=Data)
##general linear F test for interaction terms
anova(reduced,result)
##go with reduced model with no interactions. 
##Not surprising given scatterplot

plot(reduced)
##seems fine

##output for reduced model with no interactions
summary(reduced)

##sample size
n<-dim(Data)[1]
p<-4
g<-3

##new t multiplier with Bonferroni
t.bon<-qt(1-0.05/(2*g), n-p)

##obtain the variance-covariance matrix of the coefficients
vcov(reduced)

##multiple comparisons. 
##Can only be used when there are no interactions
library(multcomp)
pairwise<-multcomp::glht(reduced, linfct = mcp(Region= "Tukey"))
summary(pairwise)
