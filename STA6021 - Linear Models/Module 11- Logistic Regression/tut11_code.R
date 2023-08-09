library(tidyverse)
Data<-read.table("students.txt", header=T, sep="")
##first column is index, remove it
Data<-Data[,-1]
##some NAs in data. Remove them
Data<-Data[complete.cases(Data),]

##convert categorical to factors. needed for contrasts
Data$Gender<-factor(Data$Gender)
Data$Smoke<-factor(Data$Smoke)
Data$Marijuan<-factor(Data$Marijuan)
Data$DrivDrnk<-factor(Data$DrivDrnk)

##set seed so results (split) are reproducible
set.seed(6021)

##evenly split data into train and test sets
sample.data<-sample.int(nrow(Data), floor(.50*nrow(Data)), replace = F)
train<-Data[sample.data, ]
test<-Data[-sample.data, ]

##################
##Visualizations##
##################

##involving categorical predictors

chart1<-ggplot2::ggplot(train, aes(x=Gender, fill=DrivDrnk))+
  geom_bar(position = "fill")+
  labs(x="Gender", y="Proportion",
       title="Proportion of Driven Drunk by Gender")

chart2<-ggplot2::ggplot(train, aes(x=Smoke, fill=DrivDrnk))+
  geom_bar(position = "fill")+
  labs(x="Smokes?", y="Proportion",
       title="Proportion of Driven Drunk by Smoking Status")

chart3<-ggplot2::ggplot(train, aes(x=Marijuan, fill=DrivDrnk))+
  geom_bar(position = "fill")+
  labs(x="Use Marijuana?", y="Proportion",
       title="Proportion of Driven Drunk by Marijuana Status")

##put barcharts in a matrix
library(gridExtra)
gridExtra::grid.arrange(chart1, chart2, chart3, ncol = 2, nrow = 2)

##two way tables of counts
table(train$Gender, train$DrivDrnk)
table(train$Smoke, train$DrivDrnk)
table(train$Marijuan, train$DrivDrnk)

##two way tables using proportions
prop.table(table(train$Gender, train$DrivDrnk),1)
prop.table(table(train$Smoke, train$DrivDrnk),1)
prop.table(table(train$Marijuan, train$DrivDrnk),1)

##involving quantitative predictors

dp1<-ggplot2::ggplot(train,aes(x=GPA, color=DrivDrnk))+
  geom_density()+
  labs(title="Density Plot of GPA by Driven Drunk")

dp2<-ggplot2::ggplot(train,aes(x=PartyNum, color=DrivDrnk))+
  geom_density()+
  labs(title="Density Plot of Number of Party Days by Driven Drunk")

dp3<-ggplot2::ggplot(train,aes(x=DaysBeer, color=DrivDrnk))+
  geom_density()+
  labs(title="Density Plot of Number of Days drank Beer by Driven Drunk")

dp4<-ggplot2::ggplot(train,aes(x=StudyHrs, color=DrivDrnk))+
  geom_density()+
  labs(title="Density Plot of Study Hours by Driven Drunk")

gridExtra::grid.arrange(dp1, dp2, dp3, dp4, ncol = 2, nrow = 2)

##correlations between quatitative predictors
round(cor(train[,5:8]),3)

##fit logistic regression
result<-glm(DrivDrnk~., family=binomial, data=train)
summary(result)

library(faraway)
faraway::vif(result)

reduced<-glm(DrivDrnk~Smoke+Marijuan+DaysBeer, family=binomial, data=train)

##test to compare reduced and full model
##test stat
TS<-reduced$deviance-result$deviance
##pvalue
1-pchisq(TS,4)
##critical value
qchisq(1-0.05,4)

##predictions in logistic regression
logodds<-predict(reduced,newdata=test)
preds<-predict(reduced,newdata=test, type="response")