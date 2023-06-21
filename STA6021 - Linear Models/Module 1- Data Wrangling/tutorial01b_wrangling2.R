#############################
##Data Wrangling with dplyr##
#############################

##load tidyverse or dplyr package

##library(dplyr) or
library(tidyverse) 

##loading tidyverse automatically loads dplyr

Data<-read.csv("ClassDataPrevious.csv", header=TRUE)

#########################################
##view specific row(s) and/or column(s)##
#########################################

##view specific column(s)
select(Data,Year)

Data%>%
  select(Year)

#######################################
##select observations by condition(s)##
#######################################

filter(Data, Sport=="Soccer")

SoccerPeeps<-Data%>%
  filter(Sport=="Soccer")

SoccerPeeps_2nd<-Data%>%
  filter(Sport=="Soccer" & Year=="Second")

Sleepy<-Data%>%
  filter(Sleep>8)

Sleepy_or_Soccer<-Data%>%
  filter(Sport=="Soccer" | Sleep>8)

#############################
##change names of column(s)##
#############################

Data<-Data%>%
  rename(Yr=Year, Comp=Computer) #new name = old name

################
##missing data##
################

##find which rows have missing data
is.na(Data) 
Data[!complete.cases(Data),] #find rows with missing data

##remove observations with missing values. CAUTION!
Data_nomiss<-Data %>% 
  drop_na()

########################
##Summarize a variable##
########################

Data%>%
  summarize(mean(Sleep),mean(Courses),mean(Age),mean(Lunch))

##find means of numeric columns
Data%>%
  summarize(mean(Sleep,na.rm = T),mean(Courses),mean(Age),mean(Lunch,na.rm = T))

Data%>%
  summarize(avgSleep=mean(Sleep,na.rm = T),avgCourse=mean(Courses),avgAge=mean(Age),avgLun=mean(Lunch,na.rm = T))
##means are suspiciously high, perhaps due to data entry errors
##find medians instead
Data%>%
  summarize(medSleep=median(Sleep,na.rm = T),medCourse=median(Courses),medAge=median(Age),medLun=median(Lunch,na.rm = T))

###################################
##Summarize a variable, by groups##
###################################

Data%>%
  group_by(Yr)%>%
  summarize(medSleep=median(Sleep,na.rm=T))

##change the ordering of the factor Yr that is more pleasing
Data<- Data%>%
  mutate(Yr = Yr%>%
           fct_relevel(c("First","Second","Third","Fourth"))
         )

Data%>%
  group_by(Yr)%>%
  summarize(medSleep=median(Sleep,na.rm=T))

##find median sleep by Yr and Computer 
Data%>%
  group_by(Yr,Comp)%>%
  summarize(medSleep=median(Sleep,na.rm=T))

#######################################################
##Create a new variable based on existing variable(s)##
#######################################################

##convert Sleep to minutes and add new variable
Data<-Data%>%
  mutate(Sleep_mins = Sleep*60)

##create sleep deprived variable: yes if sleep less than 7 hours, 
##no otherwise
Data<-Data%>%
  mutate(deprived=ifelse(Sleep<7, "yes", "no"))


##create courseload category: light if 3 courses or less, 
##regular if 4 or 5 courses, heavy if more than 5 courses 
Data<-Data%>%
  mutate(CourseLoad=cut(Courses, breaks = c(-Inf, 3, 5, Inf), labels = c("light", "regular", "heavy")))

##collapse classes of Yr: 1st and 2nd years to under,
##3rd and 4th years to upper
Data<-Data%>%
  mutate(lowup=fct_collapse(Yr,lower=c("First","Second"),upper=c("Third","Fourth")))

################################
##Merge data frames and vectors##
################################


##merge data frames with different rows, same columns
dat1<-Data[1:3,1:3]
dat3<-Data[6:8,1:3]
res.dat2<-bind_rows(dat1,dat3)

##merge data frames with same rows, different columns
D1<-Data%>%
  select(Yr)
D2<-Data%>%
  select(Sport)
new.Data<-bind_cols(D1,D2)
head(new.Data)

##or use data.frame()
new.Data2<-data.frame(D1,D2)
head(new.Data2)

#################################
##export data frame to .csv file##
#################################

write.csv(Data, file="newdata.csv", row.names=FALSE)

#######################
##sort data by column##
#######################

##sort in ascending order by Age
Data_by_age<-Data%>%
  arrange(Age)

##sort in descending order by Age
Data_by_age_des<-Data%>%
  arrange(desc(Age))

##sort in ascending order by Age and then Sleep
Data_by_age_sleep<-Data%>%
  arrange(Age,Sleep)


