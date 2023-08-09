Data<-read.table("nfl.txt", header=TRUE)

round(cor(Data),3)

##fit MLR
result<-lm(y~x1+x5+x7+x8, data=Data)
summary(result)

reduced<-lm(y~x8, data=Data)

##general linear F test to compare reduced model with full model
anova(reduced, result)

##approach 2
anova(result) ##output doesn't give us needed info

##rearrange. put predictors to drop last in lm()
full<-lm(y~x8+x1+x5+x7, data=Data)

anova(full)

##fit MLR with all predictors
all<-lm(y~., data=Data)

##look at t tests, and F test
summary(all)

##correlation matrix, round to 3 decimal
round(cor(Data[,-1]),3)

##VIFs
library(faraway)
faraway::vif(all)