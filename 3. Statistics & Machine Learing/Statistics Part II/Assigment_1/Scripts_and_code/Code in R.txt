# first we import the 2 excel sheets:
library(readxl)
library(glmnet)
library(stats)
library(car)
library(corrplot)
library(PseudoR2)
library(ggplot2)
install.packages('ResourceSelection')
library(ResourceSelection)
install.packages('lmtest')
library(lmtest)
install.packages('PredictABEL')
library(PredictABEL)
install.packages('vcdExtra')
library(vcdExtra)
install.packages('performance')
library(performance)
install.packages('generalhoslem')
library(generalhoslem)

county_facts <- read_excel("C:/Users/vlass/OneDrive/Υπολογιστής/Metaptyxiako/2nd Trimester/Statistics 2/Assigment_1/Data.xlsx", sheet = "county_facts")
votes <- read_excel("C:/Users/vlass/OneDrive/Υπολογιστής/Metaptyxiako/2nd Trimester/Statistics 2/Assigment_1/Data.xlsx", sheet = "votes")
################################################################################################################################################################## 
######################################################                                            ################################################################ 
###################################################### PART I Data Cleaning and Data Manipulation ################################################################
######################################################                                            ################################################################ 
################################################################################################################################################################## 

# the assignment commands that we analyze the votes for the Republican party. With that being said all other rows will be dropped
votes = subset(votes, party=="Republican")

# also we want as response whether Trump got more than 50% in each county. The fraction_votes metric will help us in this.

# we create a column taking values 0 for not more than 50% and 1 for more than 50%
votes$predictor <- ifelse(votes$candidate == 'Donald Trump' & votes$fraction_votes>=0.50 , 1, 0)

# From the votes data frame we want to remove all the lines that are not containing the Donald Trump:
votes<- subset(votes,candidate == 'Donald Trump')

# now we will merge the 2 data frames:
data <- merge(votes, county_facts, by= "fips", all = FALSE)

# lets clean our data set to have a better view:
data = subset(data, select = -c(state_abbreviation.x, area_name, state_abbreviation.y, party, fraction_votes, candidate) )

library(dplyr)
data <- data %>% select(c(predictor, ), everything())

# lets remove the 2 data frames that we do not need:
remove(county_facts, votes)

# We will use 2 data frames. This first 'data' will be used for the model. The second 'descriptive' will be used for descriptive statistics

descriptive<- data

# the 'data' data frame will be used for our model. So it should not contain any characters. Lets clean the data frame:
# we create unique IDs for the states:
length(unique(data$state))
states<-unique(data$state)
state_id<-1:38
states<- data.frame(states,state_id)

data <- merge(data, states, by.x= "state", by.y = 'states' , all = FALSE)

data <- data %>% select(c(predictor,state_id, ), everything())

data = subset(data, select = -c(state, county) )

remove(state_id, states)

# Finally we want to make some columns as factors:
data$predictor <-as.factor(data$predictor)
data$state_id <-as.factor(data$state_id)
data$fips <-as.factor(data$fips)

# we rename the data frame
md_data<-data
remove(data)

# we remove the fips and the votes:
md_data = subset(md_data, select = -c(fips,votes) )

# we create a data frame with only the continuous variables:
continuous_data <- subset(md_data, select = -c(predictor,state_id))


# We will create a dataset with logs for some of the metrics. We will log the variables that their values exceed 1.000

LOL_df<- subset(md_data, select = -state_id)

LOL_df$PST045214<- log(LOL_df$PST045214)
LOL_df$PST040210<- log(LOL_df$PST040210)
LOL_df$POP010210<- log(LOL_df$POP010210)
LOL_df$VET605213<- log(LOL_df$VET605213)
LOL_df$HSG010214<- log(LOL_df$HSG010214)
LOL_df$HSG495213<- log(LOL_df$HSG495213)
LOL_df$HSD410213<- log(LOL_df$HSD410213)
LOL_df$INC910213<- log(LOL_df$INC910213)
LOL_df$INC110213<- log(LOL_df$INC110213)
LOL_df$BZA010213<- log(LOL_df$BZA010213)
LOL_df$BZA110213<- log(LOL_df$BZA110213)
LOL_df$NES010213<- log(LOL_df$NES010213)
LOL_df$SBO001207<- log(LOL_df$SBO001207)
LOL_df$MAN450207<- log(LOL_df$MAN450207)
LOL_df$WTN220207<- log(LOL_df$WTN220207)
LOL_df$RTN130207<- log(LOL_df$RTN130207)
LOL_df$RTN131207<- log(LOL_df$RTN131207)
LOL_df$AFN120207<- log(LOL_df$AFN120207)
LOL_df$BPS030214<- log(LOL_df$BPS030214)
LOL_df$LND110210<- log(LOL_df$LND110210)

# replace inf with NAs.
LOL_df[sapply(LOL_df, is.infinite)] <- NA

# where ever there is NA we use the column mean
LOL_df["PST045214"][is.na(LOL_df["PST045214"])] <- mean(LOL_df$PST045214, na.rm=TRUE)
LOL_df["PST040210"][is.na(LOL_df["PST040210"])] <- mean(LOL_df$PST040210, na.rm=TRUE)
LOL_df["POP010210"][is.na(LOL_df["POP010210"])] <- mean(LOL_df$POP010210, na.rm=TRUE)
LOL_df["VET605213"][is.na(LOL_df["VET605213"])] <- mean(LOL_df$VET605213, na.rm=TRUE)
LOL_df["HSG010214"][is.na(LOL_df["HSG010214"])] <- mean(LOL_df$HSG010214, na.rm=TRUE)
LOL_df["HSG495213"][is.na(LOL_df["HSG495213"])] <- mean(LOL_df$HSG495213, na.rm=TRUE)
LOL_df["HSD410213"][is.na(LOL_df["HSD410213"])] <- mean(LOL_df$HSD410213, na.rm=TRUE)
LOL_df["INC910213"][is.na(LOL_df["INC910213"])] <- mean(LOL_df$INC910213, na.rm=TRUE)
LOL_df["INC110213"][is.na(LOL_df["INC110213"])] <- mean(LOL_df$INC110213, na.rm=TRUE)
LOL_df["BZA010213"][is.na(LOL_df["BZA010213"])] <- mean(LOL_df$BZA010213, na.rm=TRUE)
LOL_df["BZA110213"][is.na(LOL_df["BZA110213"])] <- mean(LOL_df$BZA110213, na.rm=TRUE)
LOL_df["NES010213"][is.na(LOL_df["NES010213"])] <- mean(LOL_df$NES010213, na.rm=TRUE)
LOL_df["SBO001207"][is.na(LOL_df["SBO001207"])] <- mean(LOL_df$SBO001207, na.rm=TRUE)
LOL_df["MAN450207"][is.na(LOL_df["MAN450207"])] <- mean(LOL_df$MAN450207, na.rm=TRUE)
LOL_df["WTN220207"][is.na(LOL_df["WTN220207"])] <- mean(LOL_df$WTN220207, na.rm=TRUE)
LOL_df["RTN130207"][is.na(LOL_df["RTN130207"])] <- mean(LOL_df$RTN130207, na.rm=TRUE)
LOL_df["RTN131207"][is.na(LOL_df["RTN131207"])] <- mean(LOL_df$RTN131207, na.rm=TRUE)
LOL_df["AFN120207"][is.na(LOL_df["AFN120207"])] <- mean(LOL_df$AFN120207, na.rm=TRUE)
LOL_df["BPS030214"][is.na(LOL_df["BPS030214"])] <- mean(LOL_df$BPS030214, na.rm=TRUE)
LOL_df["LND110210"][is.na(LOL_df["LND110210"])] <- mean(LOL_df$LND110210, na.rm=TRUE)


# ΓΙΑ ΠΛΑΚΑ ΝΑ ΔΩ ΤΙ ΘΑ ΒΓΑΛΕΙ:

model_lol<-glm(formula = predictor ~ ., family = "binomial", data = LOL_df)
summary(model_lol)

model_BIC_LOL <- step(model_lol, direction='both', k = log(length(LOL_df$predictor)))


model_lol<-glm(predictor ~ AGE295214 + RHI125214 + RHI225214 + RHI325214 + RHI625214 + 
                 RHI725214 + RHI825214 + POP715213 + EDU685213 + HSG445213 + 
                 HSG495213 + PVY020213 + BZA010213 + NES010213 + SBO515207 + 
                 SBO415207 + WTN220207 + RTN131207 + LND110210 + POP060210, family = "binomial", data = LOL_df)

model_lol<-glm(predictor ~ AGE295214  + RHI325214 + RHI625214 + 
                 RHI725214 + RHI825214 + POP715213 + EDU685213 + HSG445213 + 
                 HSG495213 + PVY020213  + NES010213 + SBO515207 + 
                 SBO415207 + WTN220207 + RTN131207 + LND110210 + POP060210, family = "binomial", data = LOL_df)
vif(model_lol)
summary(model_lol)

model_lol<-glm(predictor ~ AGE295214  + RHI325214  + 
                 RHI725214 + RHI825214 + POP715213 + EDU685213 + HSG445213 + 
                 HSG495213 + PVY020213  + NES010213  + 
                 SBO415207 + WTN220207  + LND110210 , family = "binomial", data = LOL_df)
summary(model_lol)

with(model_lol, pchisq(deviance, df.residual, lower.tail = FALSE))


# R squared:
PseudoR2(model_lol, which = 'CoxSnell') # 0,14
PseudoR2(model_lol, which = 'Nagelkerke') # 0,19
PseudoR2(model_lol, which = 'McFaddenAdj') # 0,11


###############################################################################################################################################
###############################################################################################################################################

# ΛΟΓΟ ΤΩΝ FIPS KAI COUNTY CODES ΓΙΝΕΤΑΙ ΤΗΣ ΤΡΕΛΗΣ. ΙΣΩΣ ΧΡΕΑΣΤΕΙ ΝΑ ΤΑ ΒΓΑΛΩ

###############################################################################################################################################
###############################################################################################################################################
###################################################################################################################################################################
###################################################################################################################################################################
library(stats)
model_full<-glm(formula = predictor ~ ., family = "binomial", data = md_data)
summary(model_full)
###################################################################################################################################################################
###################################################################################################################################################################


################################################################################################################################################################## 
######################################################                                            ################################################################ 
######################################################       PART ΙΙ Descriptive Statistics       ###############################################################
######################################################                                            ################################################################ 
################################################################################################################################################################## 


#lets see the correlation between the independent continuous variables:
library(corrplot)
cor.table <- cor(continuous_data)
corrplot(cor.table)

# for VIF 
library(car)
vif(model)

# in which States Donald Trump had more than 50% of the votes for the Republicans ????
more_than_50  <- aggregate(descriptive$predictor, by=list(descriptive$state), FUN=sum)
more_than_50$group<- 'more'

library(dplyr)
less_than_50<-descriptive %>%
  group_by(state) %>%
  summarize(count = sum(predictor == 0) )
less_than_50$group<- 'less'

plot_dataframe <- merge(more_than_50, less_than_50, by.x = "Group.1", by.y = 'state', all = FALSE)


colnames(plot_dataframe)[colnames(plot_dataframe) == "x"] ="more_votes"
colnames(plot_dataframe)[colnames(plot_dataframe) == "count"] ="less_votes"



colnames(more_than_50)[colnames(more_than_50) == "x"] ="count"
colnames(more_than_50)[colnames(more_than_50) == "Group.1"] ="state"

colnames(less_than_50)[colnames(less_than_50) == "count"] ="less_votes"
colnames(less_than_50)[colnames(less_than_50) == "count"] ="less_votes"


df_union<-union(more_than_50,less_than_50)


# Grouped
q <-ggplot(df_union, aes(fill= group, y= state, x= count)) + 
  geom_bar(position="dodge", stat="identity")
q + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))


# να βαλω CORRELATION PLOTS !!!!

# ΕΠΕΙΔΗ εχω πολλα δεδομενα δεν θα κανω descriptive statistics ακομα.
# 1α θα βρω το καταλληλο μοντελο και τα καταλλη variables και απο εκει και περα θα αποφασισω.





# goodness of fit tests:
with(model_BIC_LOL, pchisq(deviance, df.residual, lower.tail = FALSE))
s

install.packages('DescTools')

library(DescTools)


PseudoR2(full_model, which = "CoxSnell")


# Representing the respone with the other most important variables
# the three models have the these same variables: this means that their very important. 
AGE295214,RHI325214,RHI825214,POP715213,EDU685213,HSG445213,HSG495213,PVY020213,SBO415207


plot(md_data2$predictor, md_data2$AGE295214)
md_data2$predictor

plot(md_data2$predictor,md_data2$AGE295214, , type = "b", frame = FALSE, pch = 19, 
     col = "red", xlab = "x", ylab = "y")


# searching the State ID to State Name, this is used for table 10 in the paper.
md_data['PST045214'][md_data$state_id == 29, ]
descriptive['state'][descriptive$PST045214 == 101714, ]




summary(md_data$AGE135214)
summary(md_data$AGE295214)
summary(md_data$AGE775214)
md_data$predictor



boxplot(md_data$AGE135214, md_data$AGE295214, md_data$AGE775214)


boxplot(md_data$EDU685213)


# Graph 3
boxplot(md_data$EDU685213 ~ md_data$predictor, data = md_data,
        xlab = 'Trumps_Dominance', ylab = '% of person with BD, >25y', las = 1)



kruskal.test(md_data$predictor ~ md_data$EDU685213)



# Graph 4 
boxplot(md_data$AGE295214 ~ md_data$predictor, data = md_data,
        xlab = 'Trumps_Dominance', ylab = '% of person under the age of 18 for 2014', las = 1)
median(md_data['AGE295214'][md_data$predictor == 0,])
median(md_data['AGE295214'][md_data$predictor == 1,])
kruskal.test(md_data$predictor ~ md_data$AGE295214)


# Graph 5 
boxplot(md_data$PVY020213 ~ md_data$predictor, data = md_data,
        xlab = 'Trumps_Dominance', ylab = 'Persons below poverty level, %, 2009-2013', las = 1)
median(md_data['PVY020213'][md_data$predictor == 0,])
median(md_data['PVY020213'][md_data$predictor == 1,])
kruskal.test(md_data$predictor ~ md_data$PVY020213)


# Graph 6
boxplot(md_data$RHI325214 ~ md_data$predictor, data = md_data,
        xlab = 'Trumps_Dominance', ylab = 'American Indian and Alaska Native alone, %, 2014', las = 1 , ylim=c(0.1, 5))
median(md_data['RHI325214'][md_data$predictor == 0,])
median(md_data['RHI325214'][md_data$predictor == 1,])
kruskal.test(md_data$predictor ~ md_data$RHI325214)


################################################################################################################################################################## 
######################################################                                            ################################################################ 
######################################################              PART ΙΙI Modeling             ###############################################################
######################################################                                            ################################################################ 
################################################################################################################################################################## 


md_data = subset(md_data, select = -state_id )
######################################################################################################################################      
################################################    FIRST MODEL STEPS ################################################################    
######################################################################################################################################      
# in this model we first make a lasso to the full model
# then we use bic to pick our variables
# finally we remove any variables that cause multicoliniarity

# use lasso for min

y<- md_data$predictor

x <- subset(md_data, select = -predictor)
x<- data.matrix(x)

library(glmnet)
cv_model <- cv.glmnet(x, y,family = 'binomial' ,alpha = 1)
min<-cv_model$lambda.min

plot(cv_model) 
coef(cv_model)

best_min<-glmnet(x, y,family = 'binomial' ,alpha = 1, lambda = min )

coef(best_min)

# we remove variables according to lasso
dataFrame_lasso_min <- subset(md_data, select = -c(RHI225214,POP815213,HSG010214,SBO001207,WTN220207))

# we run the regression
library(stats)
model<-glm(formula = predictor ~ ., family = "binomial", data = dataFrame_lasso_min)
summary(model)

# we use bic criterion:
model_BIC <- step(model, direction='both', k = log(length(dataFrame_lasso_min$predictor)))

# model after BIC criterion, direction 'both':
model_BIC<-glm(formula = predictor ~ PST045214 + AGE295214 + RHI125214 + RHI325214 + RHI625214 + 
                 RHI725214 + RHI825214 + POP715213 + EDU685213 + VET605213 + 
                 LFE305213 + HSG445213 + HSG096213 + HSG495213 + INC910213 + 
                 PVY020213 + BZA010213 + BZA110213 + NES010213 + SBO115207 + 
                 SBO415207 + MAN450207 + BPS030214, family = "binomial", data = dataFrame_lasso_min)
summary(model_BIC)
vif(model_BIC)



#####################################################    HYPOTHESIS TESTING   ##############################################################
# we have HUGE multicoliniarity

vif(model_BIC)
summary(model_BIC)

# i will start removing variables: removed: PST045214
model_BIC<-glm(formula = predictor ~  AGE295214 + RHI125214 + RHI325214 + RHI625214 + 
                 RHI725214 + RHI825214 + POP715213 + EDU685213 + VET605213 + 
                 LFE305213 + HSG445213 + HSG096213 + HSG495213 + INC910213 + 
                 PVY020213 + BZA010213 + BZA110213 + NES010213 + SBO115207 + 
                 SBO415207 + MAN450207 + BPS030214, family = "binomial", data = dataFrame_lasso_min)
vif(model_BIC)

# i will start removing variables: removed: RHI125214   
model_BIC<-glm(formula = predictor ~  AGE295214  + RHI325214 + RHI625214 + 
                 RHI725214 + RHI825214 + POP715213 + EDU685213 + VET605213 + 
                 LFE305213 + HSG445213 + HSG096213 + HSG495213 + INC910213 + 
                 PVY020213 + BZA010213 + BZA110213 + NES010213 + SBO115207 + 
                 SBO415207 + MAN450207 + BPS030214, family = "binomial", data = dataFrame_lasso_min)
vif(model_BIC)

# i will start removing variables: removed: BZA010213   
model_BIC<-glm(formula = predictor ~  AGE295214  + RHI325214 + RHI625214 + 
                 RHI725214 + RHI825214 + POP715213 + EDU685213 + VET605213 + 
                 LFE305213 + HSG445213 + HSG096213 + HSG495213 + INC910213 + 
                 PVY020213 + BZA110213 + NES010213 + SBO115207 + 
                 SBO415207 + MAN450207 + BPS030214, family = "binomial", data = dataFrame_lasso_min)
vif(model_BIC)

# i will start removing variables: removed: BZA110213   
model_BIC<-glm(formula = predictor ~  AGE295214  + RHI325214 + RHI625214 + 
                 RHI725214 + RHI825214 + POP715213 + EDU685213 + VET605213 + 
                 LFE305213 + HSG445213 + HSG096213 + HSG495213 + INC910213 + 
                 PVY020213 + NES010213 + SBO115207 + 
                 SBO415207 + MAN450207 + BPS030214, family = "binomial", data = dataFrame_lasso_min)
vif(model_BIC)
summary(model_BIC)

# Now we remove variables that are ot statistical significant such as: RHI725214, INC910213, NES010213, MAN450207
################################################################################################################################################
##########################################  this is the FIRST final model ###########################################################
################################################################################################################################################
model_BIC<-glm(formula = predictor ~  AGE295214  + RHI325214 + RHI625214  
                  + RHI825214 + POP715213 + EDU685213 + VET605213 + 
                 LFE305213 + HSG445213 + HSG096213 + HSG495213  + 
                 PVY020213  + SBO115207 + 
                 SBO415207  + BPS030214, family = "binomial", data = dataFrame_lasso_min)
vif(model_BIC)
summary(model_BIC)


############################################# LOGISTIC REGRESSIONS ASSUMPTIONS: ######################################################
# Binary values in dependent variables                     CKECK

# Independent variables. We dont have times series data    CHECK

# Multicoliniaroty                                         CHECK

# indepedent variables to be linearly releated to the log odds  NOT CHECKED




# Goodness of fit test with Chi-squared:
# we reject the null meaning that the model fits well the data
with(model_BIC, pchisq(deviance, df.residual, lower.tail = FALSE))


performance_hosmer(model_BIC, n_bins =10)
# R squared:
PseudoR2(model_BIC, which = 'CoxSnell') # 0,13
PseudoR2(model_BIC, which = 'Nagelkerke') # 0,18
PseudoR2(model_BIC, which = 'McFaddenAdj') # 0,10

######################################################################################################################################      
################################################    SECOND MODEL STEPS  ##############################################################
######################################################################################################################################      
# we used BIC criterion, we logged the variables that have large values.


LOL_df<- subset(md_data, select = -state_id)

LOL_df$PST045214<- log(LOL_df$PST045214)
LOL_df$PST040210<- log(LOL_df$PST040210)
LOL_df$POP010210<- log(LOL_df$POP010210)
LOL_df$VET605213<- log(LOL_df$VET605213)
LOL_df$HSG010214<- log(LOL_df$HSG010214)
LOL_df$HSG495213<- log(LOL_df$HSG495213)
LOL_df$HSD410213<- log(LOL_df$HSD410213)
LOL_df$INC910213<- log(LOL_df$INC910213)
LOL_df$INC110213<- log(LOL_df$INC110213)
LOL_df$BZA010213<- log(LOL_df$BZA010213)
LOL_df$BZA110213<- log(LOL_df$BZA110213)
LOL_df$NES010213<- log(LOL_df$NES010213)
LOL_df$SBO001207<- log(LOL_df$SBO001207)
LOL_df$MAN450207<- log(LOL_df$MAN450207)
LOL_df$WTN220207<- log(LOL_df$WTN220207)
LOL_df$RTN130207<- log(LOL_df$RTN130207)
LOL_df$RTN131207<- log(LOL_df$RTN131207)
LOL_df$AFN120207<- log(LOL_df$AFN120207)
LOL_df$BPS030214<- log(LOL_df$BPS030214)
LOL_df$LND110210<- log(LOL_df$LND110210)

# replace inf with NAs.
LOL_df[sapply(LOL_df, is.infinite)] <- NA

# where ever there is NA we use the column mean
LOL_df["PST045214"][is.na(LOL_df["PST045214"])] <- mean(LOL_df$PST045214, na.rm=TRUE)
LOL_df["PST040210"][is.na(LOL_df["PST040210"])] <- mean(LOL_df$PST040210, na.rm=TRUE)
LOL_df["POP010210"][is.na(LOL_df["POP010210"])] <- mean(LOL_df$POP010210, na.rm=TRUE)
LOL_df["VET605213"][is.na(LOL_df["VET605213"])] <- mean(LOL_df$VET605213, na.rm=TRUE)
LOL_df["HSG010214"][is.na(LOL_df["HSG010214"])] <- mean(LOL_df$HSG010214, na.rm=TRUE)
LOL_df["HSG495213"][is.na(LOL_df["HSG495213"])] <- mean(LOL_df$HSG495213, na.rm=TRUE)
LOL_df["HSD410213"][is.na(LOL_df["HSD410213"])] <- mean(LOL_df$HSD410213, na.rm=TRUE)
LOL_df["INC910213"][is.na(LOL_df["INC910213"])] <- mean(LOL_df$INC910213, na.rm=TRUE)
LOL_df["INC110213"][is.na(LOL_df["INC110213"])] <- mean(LOL_df$INC110213, na.rm=TRUE)
LOL_df["BZA010213"][is.na(LOL_df["BZA010213"])] <- mean(LOL_df$BZA010213, na.rm=TRUE)
LOL_df["BZA110213"][is.na(LOL_df["BZA110213"])] <- mean(LOL_df$BZA110213, na.rm=TRUE)
LOL_df["NES010213"][is.na(LOL_df["NES010213"])] <- mean(LOL_df$NES010213, na.rm=TRUE)
LOL_df["SBO001207"][is.na(LOL_df["SBO001207"])] <- mean(LOL_df$SBO001207, na.rm=TRUE)
LOL_df["MAN450207"][is.na(LOL_df["MAN450207"])] <- mean(LOL_df$MAN450207, na.rm=TRUE)
LOL_df["WTN220207"][is.na(LOL_df["WTN220207"])] <- mean(LOL_df$WTN220207, na.rm=TRUE)
LOL_df["RTN130207"][is.na(LOL_df["RTN130207"])] <- mean(LOL_df$RTN130207, na.rm=TRUE)
LOL_df["RTN131207"][is.na(LOL_df["RTN131207"])] <- mean(LOL_df$RTN131207, na.rm=TRUE)
LOL_df["AFN120207"][is.na(LOL_df["AFN120207"])] <- mean(LOL_df$AFN120207, na.rm=TRUE)
LOL_df["BPS030214"][is.na(LOL_df["BPS030214"])] <- mean(LOL_df$BPS030214, na.rm=TRUE)
LOL_df["LND110210"][is.na(LOL_df["LND110210"])] <- mean(LOL_df$LND110210, na.rm=TRUE)


# ΓΙΑ ΠΛΑΚΑ ΝΑ ΔΩ ΤΙ ΘΑ ΒΓΑΛΕΙ:

model_lol<-glm(formula = predictor ~ ., family = "binomial", data = LOL_df)
summary(model_lol)

model_BIC_LOL <- step(model_lol, direction='both', k = log(length(LOL_df$predictor)))


model_lol<-glm(predictor ~ AGE295214 + RHI125214 + RHI225214 + RHI325214 + RHI625214 + 
                 RHI725214 + RHI825214 + POP715213 + EDU685213 + HSG445213 + 
                 HSG495213 + PVY020213 + BZA010213 + NES010213 + SBO515207 + 
                 SBO415207 + WTN220207 + RTN131207 + LND110210 + POP060210, family = "binomial", data = LOL_df)

model_lol<-glm(predictor ~ AGE295214  + RHI325214 + RHI625214 + 
                 RHI725214 + RHI825214 + POP715213 + EDU685213 + HSG445213 + 
                 HSG495213 + PVY020213  + NES010213 + SBO515207 + 
                 SBO415207 + WTN220207 + RTN131207 + LND110210 + POP060210, family = "binomial", data = LOL_df)
vif(model_lol)
summary(model_lol)

########################################################################################################################################################################  
##########################################  this is the SECOND final model ###########################################################
########################################################################################################################################################################  

model_lol<-glm(predictor ~ AGE295214  + RHI325214  + 
                 RHI725214 + RHI825214 + POP715213 + EDU685213 + HSG445213 + 
                 HSG495213 + PVY020213  + NES010213  + 
                 SBO415207 + WTN220207  + LND110210 , family = "binomial", data = LOL_df)
summary(model_lol)
vif(model_lol)

# Goodness of fit test with Chi-squared:
# we reject the null meaning that the model fits well the data
with(model_lol, pchisq(deviance, df.residual, lower.tail = FALSE))

performance_hosmer(model_lol, n_bins =10)

# R squared:
PseudoR2(model_lol, which = 'CoxSnell') # 0,14
PseudoR2(model_lol, which = 'Nagelkerke') # 0,19
PseudoR2(model_lol, which = 'McFaddenAdj') # 0,11


residualPlots(model_lol)


######################################################################################################################################      
################################################  THIRD MODEL STEPS  ##############################################################
######################################################################################################################################    
# in this model i just removed all the variables that cause multicoliniarity


# ας φτιαξουμε ενα μοντελο με τα ΠΑΝΤΑ και θα βγαζω οπου εχω υψηλο VIF

# now we have 0 multicoliniarity
hahaha_model<-glm(formula = predictor ~ ., family = "binomial", data = md_data2)
vif(hahaha_model)
md_data2<- subset(md_data2, select = - NES010213   )



md_data2<- subset(md_data2, select = -AFN120207 )
########################################################################################################################################################################  
################################################  THIRD MODEL  ######################################################################
########################################################################################################################################################################  
hahaha_model<-glm(formula = predictor ~ ., family = "binomial", data = md_data2)


md_datalool<-subset(md_data, select = c(colnames(md_data2),'state_id'))

summary(hahaha_model)


# Goodness of fit test with Chi-squared:
# we reject the null meaning that the model fits well the data
with(hahaha_model, pchisq(deviance, df.residual, lower.tail = FALSE))


performance_hosmer(hahaha_model, n_bins =10)

# R squared:
PseudoR2(hahaha_model, which = 'CoxSnell') # 0,16
PseudoR2(hahaha_model, which = 'Nagelkerke') # 0,22
PseudoR2(hahaha_model, which = 'McFaddenAdj') # 0,12


################################################################################################################################################################################################  
loool_model<-glm(formula = predictor ~ ., family = "binomial", data = md_datalool)


md_datalool$state_id<- as.factor(md_datalool$state_id)


summary(loool_model)



########################################################################################################################################################################  
################################################  FORTH  MODEL, with states  ######################################################################
########################################################################################################################################################################  

state_df<- subset(state_df, select = -POP645213   )

state_model<-glm(formula = predictor ~ ., family = "binomial", data = state_df)
vif(state_model)
summary(state_model)

model_BIC_state <- step(state_model, direction='both', k = log(length(state_df$predictor)))

model_BIC_state<- glm(predictor ~ state_id + AGE295214 + AGE775214 + EDU685213 + HSG495213 + 
                        PVY020213, family = "binomial", data = state_df)
summary(model_BIC_state)


performance_hosmer(model_BIC_state, n_bins =10)

PseudoR2(model_BIC_state, which = 'CoxSnell') # 0,57
PseudoR2(model_BIC_state, which = 'Nagelkerke') # 0,78
PseudoR2(model_BIC_state, which = 'McFaddenAdj') # 0,62


with(model_BIC_state, pchisq(deviance, df.residual, lower.tail = FALSE))


# the three models have the these same variables: this means that their very important. 
AGE295214,RHI325214,RHI825214,POP715213,EDU685213,HSG445213,HSG495213,PVY020213,SBO415207




residualPlots(model_BIC_state)






########################################################################################################################################################################  
################################################  FITH  MODEL, with states AND LOGS ######################################################################
########################################################################################################################################################################  

df_state_logs<- subset(df_state_logs, select = -BZA110213                      )


state_model_logs<-glm(formula = predictor ~ ., family = "binomial", data = df_state_logs)
vif(state_model_logs)
summary(state_model_logs)


model_BIC_LOL_states_logs <- step(state_model_logs, direction='both', k = log(length(df_state_logs$predictor)))

state_model_logs<-glm(formula = predictor ~ state_id + AGE295214 + EDU685213 + INC910213 + INC110213 + 
                        PVY020213, family = "binomial", data = df_state_logs)

# These are the tests that i need 
################################################################
performance_hosmer(state_model_logs, n_bins =10)
PseudoR2(state_model_logs, which = 'CoxSnell') # 0,57
PseudoR2(state_model_logs, which = 'Nagelkerke') # 0,78
PseudoR2(state_model_logs, which = 'McFaddenAdj') # 0,62
################################################################





############################################################################################################################################
#############################################   Sixth Model, from null using BIC Criterion  #####################################################################
############################################################################################################################################
# lets run a bic from the null to full model with STATES:

mfull<-glm(predictor ~ ., family = "binomial", data = md_data)
mnull<-glm(predictor ~ 1, family = "binomial", data = md_data)




step(mnull, scope=list(lower=mnull,upper=mfull), direction='forward', ,k = log(length(md_data$predictor)))



BIC_State_forward<-glm(formula = predictor ~ state_id + EDU685213 + AGE775214 + 
                         PVY020213 + INC910213 + AGE295214, family = "binomial", data = md_data)

summary(BIC_State_forward)
vif(BIC_State_forward)



performance_hosmer(BIC_State_forward, n_bins =10)
PseudoR2(BIC_State_forward, which = 'CoxSnell') # 0,57
PseudoR2(BIC_State_forward, which = 'Nagelkerke') # 0,78
PseudoR2(BIC_State_forward, which = 'McFaddenAdj') # 0,62










################################################################################################################################################
################################################################################################################################################
################################################################################################################################################


summary(state_model_logs)
summary(model_lol)












# lets try and RECORD the combination of variables that have multicoliarity:
cor.table
cor.table_DF<-data.frame(cor.table)
cor.table <- cor(continuous_data)

corrplot(cor.table)

################# ΕΔΩ ΜΠΟΡΩ ΝΑ ΒΛΕΠΩ ΓΙΑ ΚΑΘΕ ΜΕΤΡΙΚΟ ΜΕ ΠΟΙΟ ΑΛΛΟ ΜΕΤΡΙΚΟ ΕΧΕΙ ΥΨΗΛΟ CORRELATION #################################################
# ΑΥΤΟ ΕΙΝΑΙ ΠΟΛΥ ΣΩΣΤΟ !! 
for (i in 1:nrow(cor.table_DF)) {
  # Check if the condition is met
  if (cor.table_DF[i, "AGE135214"] == 0) {
    # If the condition is met, print the column name
    print(colnames(cor.table_DF)[i])
  }
}
colnames(cor.table_DF)

# zero values means HIGH CORRELATION 
cor.table_DF[cor.table_DF>=0.65] <- 0
cor.table_DF[cor.table_DF<= -0.65] <- 0

# Get the row index as a vector
row_index <- rownames(cor.table_DF)

# Convert the row index into a new column
cor.table_DF <- cbind(row_index, cor.table_DF)


cor.table_DF <- rbind(colnames(cor.table_DF), cor.table_DF)

#lets see the correlation between the independent continuous variables:
library(corrplot)
cor.table <- cor(lol)
corrplot(cor.table)


# ΔΟΚΙΜΑΣΕ ΜΕ ΕΝΑ if statement να διωξεις οτι column εχει πανω απο 0,6 correlation 

cor.table

############################################################################################################################################################# 

model_BIC,
model_lol
loool_model
model_BIC_state



plotCalibration(data = md_data2, cOutcome = 3, predRisk = fitted(hahaha_model), groups= 5)

# These are the tests that i need 
################################################################
performance_hosmer(model_BIC_state, n_bins =10)
PseudoR2(model_BIC_state, which = 'CoxSnell') # 0,57
PseudoR2(model_BIC_state, which = 'Nagelkerke') # 0,78
PseudoR2(model_BIC_state, which = 'McFaddenAdj') # 0,62
################################################################




###############################################################################################################################################################################
############################################          Assumption Control      ##########################################################################################
######################################################################################################################################################


test_df<- subset(md_data, select = c(predictor , state_id , EDU685213 , AGE775214 , 
                                       PVY020213 , INC910213 , AGE295214))


test_df$EDU685213int<- log(test_df$EDU685213) * test_df$EDU685213
test_df$AGE775214int<- log(test_df$AGE775214) * test_df$AGE775214
test_df$PVY020213int<- log(test_df$PVY020213) * test_df$PVY020213
test_df$INC910213int<- log(test_df$INC910213) * test_df$INC910213
test_df$AGE295214int<- log(test_df$AGE295214) * test_df$AGE295214



# checking for the liniearity assumption 
model_l<- glm(formula = predictor ~ state_id + EDU685213 + EDU685213int + AGE775214 +  AGE775214int + 
                PVY020213 + PVY020213int + INC910213 + INC910213int + AGE295214 + AGE295214int, family = "binomial", data = test_df)


summary(model_l)











vif(lm(formula = EDU685213 ~   AGE775214 + 
                         PVY020213 + INC910213 + AGE295214,  data = md_data))













