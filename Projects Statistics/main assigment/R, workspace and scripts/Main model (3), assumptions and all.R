
############################### BEST MODEL FOR PREDICTION PURPOSE #########################################################
################## AIC METHOD, LOGGING EVERYTIHING, USE MEAN OF COLUMN FOR REPLCING THE N/As####################
# MODEL3  Residual standard error: 0.8414, Adjusted R-squared:  0.1501 
# RMSE = 0.8446748

######################################### REMOVING UNSTATISTICAL SIGNIFICANT VARIABLES #####################################
summary(model3)
model3_TRY<- lm(formula = shares ~ n_tokens_content + n_unique_tokens + n_non_stop_words + 
                  num_hrefs + num_imgs + num_keywords + data_channel_is_lifestyle + 
                  data_channel_is_entertainment + data_channel_is_bus + data_channel_is_socmed + 
                  data_channel_is_world + kw_min_min + kw_min_max + kw_min_avg + 
                  kw_avg_avg + self_reference_max_shares + self_reference_avg_sharess + 
                  weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                  weekday_is_thursday + weekday_is_friday  + LDA_03 + 
                  global_rate_negative_words + min_positive_polarity + avg_negative_polarity,  
                data = training_data2)
summary(model3_TRY)

model_Cross_Validation3_TRY<-train(shares ~ n_tokens_content + n_unique_tokens + n_non_stop_words + 
                                     num_hrefs + num_imgs + num_keywords + data_channel_is_lifestyle + 
                                     data_channel_is_entertainment + data_channel_is_bus + data_channel_is_socmed + 
                                     data_channel_is_world + kw_min_min + kw_min_max + kw_min_avg + 
                                     kw_avg_avg + self_reference_max_shares + self_reference_avg_sharess + 
                                     weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                                     weekday_is_thursday + weekday_is_friday  + LDA_03 + 
                                     global_rate_negative_words + min_positive_polarity + avg_negative_polarity,  
                                   data = training_data2, method = 'lm', trControl=mycontrol)
####################################################  ASSUMPTIONS ###############################################################

###################################################   MULTICOLINIARITY   #########################################################
summary(model3)
install.packages('caTools')
library(caTools)
library(car)

vif(model3_TRY)
# Removing self_reference_max_shares because of correlation with self_reference_avg_sharess

model3_TRY<- lm(formula = shares ~ n_tokens_content + n_unique_tokens + n_non_stop_words + 
                  num_hrefs + num_imgs + num_keywords + data_channel_is_lifestyle + 
                  data_channel_is_entertainment + data_channel_is_bus + data_channel_is_socmed + 
                  data_channel_is_world + kw_min_min + kw_min_max + kw_min_avg + 
                  kw_avg_avg  + self_reference_avg_sharess + 
                  weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                  weekday_is_thursday + weekday_is_friday  + LDA_03 + 
                  global_rate_negative_words + min_positive_polarity + avg_negative_polarity,  
                data = training_data2)
summary(model3_TRY)
# removed because statistical assignificant: data_channel_is_lifestyle, data_channel_is_bus
# New Main Model 
model3_TRY<- lm(formula = shares ~ n_tokens_content + n_unique_tokens + n_non_stop_words  
                + num_imgs + num_keywords  + 
                  data_channel_is_entertainment  + data_channel_is_socmed + 
                  data_channel_is_world + kw_min_min + kw_min_max + kw_min_avg + 
                  kw_avg_avg  + self_reference_avg_sharess + 
                  weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                  weekday_is_thursday + weekday_is_friday   + 
                  global_rate_negative_words + min_positive_polarity + avg_negative_polarity,  
                data = training_data2)
summary(model3_TRY)
hist(model3_TRY$residuals)
# lets make a cross validation
library(caret)
model_Cross_Validation3_TRY<-train(shares ~ n_tokens_content + n_unique_tokens + n_non_stop_words  
                                   + num_imgs + num_keywords  + 
                                     data_channel_is_entertainment  + data_channel_is_socmed + 
                                     data_channel_is_world + kw_min_min + kw_min_max + kw_min_avg + 
                                     kw_avg_avg  + self_reference_avg_sharess + 
                                     weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                                     weekday_is_thursday + weekday_is_friday   + 
                                     global_rate_negative_words + min_positive_polarity + avg_negative_polarity,  
                                   data = training_data2, method = 'lm', trControl=mycontrol)
summary(model3_TRY)
plot(model3_TRY)

par(mfrow=c(2,2))

######################################### LINIEARITY MET #############################################
# according to this plot linearity(mostly) is met. 
plot(model3_TRY)


######################################### Normallity of residuals #############################################
# normallity is not exactly met.
plot(model3_TRY)


################################# Homoskedasticity ###################################################
# assumption met(mostly).




######################################################################################################
######################################################################################################
##################################### CHANGING THE TEST DATA TYPES ###################################
test_data2<- Main_Test

#making the factors 
test_data2$data_channel_is_bus<- as.factor(test_data2$data_channel_is_bus)
test_data2$data_channel_is_lifestyle<- as.factor(test_data2$data_channel_is_lifestyle)
test_data2$data_channel_is_entertainment<- as.factor(test_data2$data_channel_is_entertainment)
test_data2$data_channel_is_socmed<- as.factor(test_data2$data_channel_is_socmed)
test_data2$data_channel_is_tech<- as.factor(test_data2$data_channel_is_tech)
test_data2$data_channel_is_world<- as.factor(test_data2$data_channel_is_world)


test_data2$is_weekend<- as.factor(test_data2$is_weekend)
test_data2$weekday_is_monday<- as.factor(test_data2$weekday_is_monday)
test_data2$weekday_is_tuesday<- as.factor(test_data2$weekday_is_tuesday)
test_data2$weekday_is_wednesday<- as.factor(test_data2$weekday_is_wednesday)
test_data2$weekday_is_thursday<- as.factor(test_data2$weekday_is_thursday)
test_data2$weekday_is_friday<- as.factor(test_data2$weekday_is_friday)
test_data2$weekday_is_saturday<- as.factor(test_data2$weekday_is_saturday)
test_data2$weekday_is_sunday<- as.factor(test_data2$weekday_is_sunday)


# making the same changes to the test data set
test_data2$shares<- log(test_data2$shares)
test_data2$n_tokens_title <-log(test_data2$n_tokens_title)
test_data2$n_tokens_content <-log(test_data2$n_tokens_content)
test_data2$num_hrefs <-log(test_data2$num_hrefs)
test_data2$num_self_hrefs <-log(test_data2$num_self_hrefs)
test_data2$num_imgs <-log(test_data2$num_imgs)
test_data2$num_videos <-log(test_data2$num_videos)
test_data2$average_token_length <-log(test_data2$average_token_length)
test_data2$num_keywords <-log(test_data2$num_keywords)
test_data2$kw_min_min <-log(test_data2$kw_min_min)
test_data2$kw_max_min <-log(test_data2$kw_max_min)
test_data2$kw_avg_min <-log(test_data2$kw_avg_min)
test_data2$kw_min_max <-log(test_data2$kw_min_max)
test_data2$kw_max_max <-log(test_data2$kw_max_max)
test_data2$kw_avg_max <-log(test_data2$kw_avg_max)
test_data2$kw_min_avg <-log(test_data2$kw_min_avg)
test_data2$kw_max_avg <-log(test_data2$kw_max_avg)
test_data2$kw_avg_avg <-log(test_data2$kw_avg_avg)
test_data2$self_reference_min_shares <-log(test_data2$self_reference_min_shares)
test_data2$self_reference_max_shares <-log(test_data2$self_reference_max_shares)
test_data2$self_reference_avg_sharess <-log(test_data2$self_reference_avg_sharess)


# replace inf with NA 
test_data2[sapply(test_data2, is.infinite)] <- NA

# replacing NA with means of each column 
mean(test_data2$n_tokens_content, na.rm = TRUE)
test_data2["n_tokens_content"][is.na(test_data2["n_tokens_content"])] <- mean(test_data2$n_tokens_content, na.rm=TRUE)
test_data2["n_tokens_title"][is.na(test_data2["n_tokens_title"])] <- mean(test_data2$n_tokens_title, na.rm=TRUE)
test_data2["num_hrefs"][is.na(test_data2["num_hrefs"])] <- mean(test_data2$num_hrefs, na.rm=TRUE)
test_data2["num_self_hrefs"][is.na(test_data2["num_self_hrefs"])] <- mean(test_data2$num_self_hrefs, na.rm=TRUE)
test_data2["num_imgs"][is.na(test_data2["num_imgs"])] <- mean(test_data2$num_imgs, na.rm=TRUE)
test_data2["num_videos"][is.na(test_data2["num_videos"])] <- mean(test_data2$num_videos, na.rm=TRUE)
test_data2["average_token_length"][is.na(test_data2["average_token_length"])] <- mean(test_data2$average_token_length, na.rm=TRUE)
test_data2["num_keywords"][is.na(test_data2["num_keywords"])] <- mean(test_data2$num_keywords, na.rm=TRUE)
test_data2["kw_min_min"][is.na(test_data2["kw_min_min"])] <- mean(test_data2$kw_min_min, na.rm=TRUE)
test_data2["kw_max_min"][is.na(test_data2["kw_max_min"])] <- mean(test_data2$kw_max_min, na.rm=TRUE)
test_data2["kw_avg_min"][is.na(test_data2["kw_avg_min"])] <- mean(test_data2$kw_avg_min, na.rm=TRUE)
test_data2["kw_min_max"][is.na(test_data2["kw_min_max"])] <- mean(test_data2$kw_min_max, na.rm=TRUE)
test_data2["kw_max_max"][is.na(test_data2["kw_max_max"])] <- mean(test_data2$kw_max_max, na.rm=TRUE)
test_data2["kw_avg_max"][is.na(test_data2["kw_avg_max"])] <- mean(test_data2$kw_avg_max, na.rm=TRUE)
test_data2["kw_min_avg"][is.na(test_data2["kw_min_avg"])] <- mean(test_data2$kw_min_avg, na.rm=TRUE)
test_data2["kw_max_avg"][is.na(test_data2["kw_max_avg"])] <- mean(test_data2$kw_max_avg, na.rm=TRUE)
test_data2["kw_avg_avg"][is.na(test_data2["kw_avg_avg"])] <- mean(test_data2$kw_avg_avg, na.rm=TRUE)
test_data2["self_reference_min_shares"][is.na(test_data2["self_reference_min_shares"])] <- mean(test_data2$self_reference_min_shares, na.rm=TRUE)
test_data2["self_reference_max_shares"][is.na(test_data2["self_reference_max_shares"])] <- mean(test_data2$self_reference_max_shares, na.rm=TRUE)
test_data2["self_reference_avg_sharess"][is.na(test_data2["self_reference_avg_sharess"])] <- mean(test_data2$self_reference_avg_sharess, na.rm=TRUE)


######################################################################################################
######################################################################################################
##################################### PREDICTION #####################################################

# lets make a prediction:
Test_Prediction<-predict(model3_TRY, newdata = test_data2)
summary(model3_TRY)
# accuracy: 
MSE<-mean((test_data2$shares - Test_Prediction)^2)



######################################################################################################
############################################################################################################################################################################################################
############################################################################################################################################################################################################
######################################################################################################

cof_ma<-as.matrix(model3_TRY$coefficients)


cof_ma <- cof_ma[order(cof_ma[, 1]), ]

plot(model3_TRY)


residualPlot(model3_TRY, type='rstudent')



summary(model3_TRY)

install.packages('olsrr')


library(olsrr)

ols_plot_cooksd_bar(model3_TRY, type = 2)

ols_plot_cooksd_bar(model3_TRY, type = 3, print_plot = TRUE)
ols_plot_cooksd_bar(model3_TRY)
?ols_plot_cooksd_bar

cooksD<-cooks.distance(model3_TRY)
3*mean(cooksD)

influential <- cooksD[(cooksD > (3 * mean(cooksD, na.rm = TRUE)))]
names_of_influential <- names(influential)

outliers <- training_data2_influential[names_of_influential,]
hitters_without_outliers <- training_data2_influential %>% anti_join(outliers)








