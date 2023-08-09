#######################
##Teacher pay example##
#######################

library(ggplot2) ##for visuals
library(MASS) ##for boxcox

Data<-read.table("teacher_pay.txt", header=TRUE, sep="")

class(Data$AREA) ##notice its integer. Need to convert to factor
Data$AREA<-factor(Data$AREA) ##convert to factor
levels(Data$AREA)
levels(Data$AREA) <- c("North", "South", "West") ##Give names to the classes

##scatterplot
ggplot2::ggplot(Data, aes(x=SPEND, y=PAY, color=AREA))+
  geom_point()+
  geom_smooth(method=lm, se=FALSE)+
  labs(title="Scatterplot of Pay against Expenditure, by Area")+
  geom_text(label=rownames(Data))

result<-lm(PAY~AREA*SPEND, data=Data)

plot(result)

MASS::boxcox(result) 

##make judgment call to not transform y since res plot looks ok and 1 is almost inside CI for boxcox

##calculations to evaluate leverages and outliers
hii<-lm.influence(result)$hat ##leverages
ext.student<-rstudent(result) ##ext studentized res
n<-nrow(Data)
p<-6

hii[hii>2*p/n]
sort(hii)
##notice NJ that much bigger than a few other states

ext.student[abs(ext.student)>3]
sort(abs(ext.student))

##identify states with high DFFITS
DFFITS<-dffits(result)
DFFITS[abs(DFFITS)>2*sqrt(p/n)]
sort(abs(DFFITS))
Data[abs(DFFITS)>2*sqrt(p/n),]
##NJ, DE, DC, WY, AK

##compute yhat and yhat(i) for the states found above
y<-Data$PAY
yhat<-y-result$res 
del.res<-result$res/(1-hii) ##deleted residual
yhat.i<-y-del.res ##yhat(i)
##compare yhat and yhat(i) for the states found above
cbind(yhat,yhat.i, yhat-yhat.i)[abs(DFFITS)>2*sqrt(p/n),]

##Find large DFBETAS
DFBETAS<-dfbetas(result)
abs(DFBETAS)>2/sqrt(n)
##NJ, IN, SD, DC, AK

##see actual values for DFBETAS of these states
DFBETAS["NJ",]
DFBETAS["IN",]
DFBETAS["SD",]
DFBETAS["DE",]
DFBETAS["DC",]
DFBETAS["WY",]
DFBETAS["AK",]

##Display Cook's distances
COOKS<-cooks.distance(result)
COOKS[COOKS>1]
sort(COOKS)
##AK

##make judgment call to consider AK different from the rest of the states
##remove DC since its more like a city

##remove AK & DC
data.no.akdc<-Data[-c(50,24),] ##remove row 50 and 24, which is AK and DC
result.no.akdc<-lm(PAY~AREA*SPEND, data=data.no.akdc) 

plot(result.no.akdc)
MASS::boxcox(result.no.akdc)

##plots without AK & DC

ggplot(data.no.akdc, aes(x=SPEND, y=PAY, color=AREA))+
  geom_point()+
  geom_smooth(method=lm, se=FALSE)+
  labs(title="Scatterplot of Pay against Expenditure, by Area")+
  xlim(2000, 8500)+
  ylim(15000,42000)

ggplot2::ggplot(Data, aes(x=SPEND, y=PAY, color=AREA))+
  geom_point()+
  geom_smooth(method=lm, se=FALSE)+
  labs(title="Scatterplot of Pay against Expenditure, by Area")+
  xlim(2000, 8500)+
  ylim(15000,42000)

##no interactions
result.no.akdc.reduced<-lm(PAY~AREA+SPEND, data=data.no.akdc)
##general linear F test
anova(result.no.akdc.reduced, result.no.akdc)

plot(result.no.akdc.reduced)
MASS::boxcox(result.no.akdc.reduced)

library(car)
car::avPlots(result.no.akdc.reduced)

