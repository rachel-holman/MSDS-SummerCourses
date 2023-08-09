library(openintro)
Data<-openintro::cherry

library(GGally)
##scatterplot matrix
GGally::ggpairs(Data)

##Fit MLR model, using + in between predictors
result<-lm(volume~diam+height, data=Data)
##or
##result<-lm(volume~., data=Data)

summary(result)

##CI for coefficients
confint(result,level = 0.95)

##Find CI for mean response and PI for a response for particular values of the predictors
newdata<-data.frame(diam=10, height=80)

predict(result, newdata, level=0.95, interval="confidence")
predict(result, newdata, level=0.95, interval="prediction")
