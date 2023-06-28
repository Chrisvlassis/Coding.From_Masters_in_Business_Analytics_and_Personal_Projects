# making the neccesary factors for TRAINING 
Main_Training$weekday_is_friday <- as.factor(Main_Training$weekday_is_friday)
Main_Training$weekday_is_monday <- as.factor(Main_Training$weekday_is_monday)
Main_Training$weekday_is_saturday <- as.factor(Main_Training$weekday_is_saturday)
Main_Training$weekday_is_sunday<- as.factor(Main_Training$weekday_is_sunday)
Main_Training$weekday_is_thursday<- as.factor(Main_Training$weekday_is_thursday)
Main_Training$weekday_is_tuesday<- as.factor(Main_Training$weekday_is_tuesday)
Main_Training$weekday_is_wednesday<- as.factor(Main_Training$weekday_is_wednesday)
Main_Training$is_weekend<- as.factor(Main_Training$is_weekend)

Main_Training$data_channel_is_bus <- as.factor(Main_Training$data_channel_is_bus )
Main_Training$data_channel_is_lifestyle <- as.factor(Main_Training$data_channel_is_lifestyle)
Main_Training$data_channel_is_entertainment <- as.factor(Main_Training$data_channel_is_entertainment)
Main_Training$data_channel_is_socmed <- as.factor(Main_Training$data_channel_is_socmed)
Main_Training$data_channel_is_tech <- as.factor(Main_Training$data_channel_is_tech)
Main_Training$data_channel_is_world <- as.factor(Main_Training$data_channel_is_world )


# making the necessary factors for TEST  


# we have logs of shares for both training and test data
Training_log_Shares<- Main_Training
Training_log_Shares$shares<- log(Training_log_Shares$shares)

Test_log_shares<-Main_Test
Test_log_shares$shares<- log(Test_log_shares$shares)

################################################################################################################
################################################################################################################
################################################################################################################
################################### METHOD AIC, LOGED SHARES ###################################################
# lets try 1st model:
library(car)
mfull<-lm(shares~., data = Training_log_Shares)
step(mfull, direction='back')

# model creating with AIC:
model1<-lm(formula = shares ~ n_tokens_content + n_unique_tokens + n_non_stop_words + 
             num_hrefs + num_imgs + data_channel_is_lifestyle + data_channel_is_entertainment + 
             data_channel_is_bus + data_channel_is_socmed + data_channel_is_world + 
             kw_min_min + kw_min_max + kw_avg_max + kw_min_avg + kw_max_avg + 
             kw_avg_avg + self_reference_avg_sharess + weekday_is_monday + 
             weekday_is_tuesday + weekday_is_wednesday + weekday_is_thursday + 
             weekday_is_friday + LDA_01 + LDA_03 + global_rate_negative_words + 
             min_positive_polarity + max_positive_polarity + avg_negative_polarity, 
           data = Training_log_Shares)
summary(model1)
plot(model1)
# Residual standard error 0.8505, Adj R Squared 0.1316

model_Cross_Validation1<-train(shares ~ n_tokens_content + n_unique_tokens + n_non_stop_words + 
                                num_hrefs + num_imgs + data_channel_is_lifestyle + data_channel_is_entertainment + 
                                data_channel_is_bus + data_channel_is_socmed + data_channel_is_world + 
                                kw_min_min + kw_min_max + kw_avg_max + kw_min_avg + kw_max_avg + 
                                kw_avg_avg + self_reference_avg_sharess + weekday_is_monday + 
                                weekday_is_tuesday + weekday_is_wednesday + weekday_is_thursday + 
                                weekday_is_friday + LDA_01 + LDA_03 + global_rate_negative_words + 
                                min_positive_polarity + max_positive_polarity + avg_negative_polarity, 
                              data = Training_log_Shares, method = 'lm', trControl=mycontrol)

# RMSE= 0.8564537
################################################################################################################
################################################################################################################
################################################################################################################
#  # i make a cross validation here. 


# lets make a cross validation:
install.packages('caret')
library(caret)
install.packages('caret', dependencies = c('Depends', 'Suggests'))

mycontrol<- trainControl(method = 'cv', number = 10)

model_Cross_Validation<-train(shares ~ n_tokens_content + n_unique_tokens + n_non_stop_words + 
                                num_hrefs + num_imgs + data_channel_is_lifestyle + data_channel_is_entertainment + 
                                data_channel_is_bus + data_channel_is_socmed + data_channel_is_world + 
                                kw_min_min + kw_min_max + kw_avg_max + kw_min_avg + kw_max_avg + 
                                self_reference_avg_sharess + weekday_is_monday + 
                                weekday_is_tuesday + weekday_is_wednesday + weekday_is_thursday + 
                                weekday_is_friday + LDA_01 + LDA_03 + global_rate_negative_words + 
                                min_positive_polarity + max_positive_polarity + avg_negative_polarity, 
                              data = Training_log_Shares, method = 'lm', trControl=mycontrol)

# lets make a prediction:
Training_Prediction<-predict(model1, newdata = Training_log_Shares)

# accuracy: 
mean((Training_log_Shares$shares - Training_Prediction)^2)

# this is the prediction for the test data 
Test_Prediction<-predict(model1, newdata = Test_log_shares)
# accuracy: 
mean((Test_log_shares$shares - Test_Prediction)^2)



################################################################################################################
################################################################################################################
################################################################################################################
################################### METHOD AIC, NO CHANGES ON DATA ###################################################
mfull<-lm(shares~., data = Main_Training)
step(mfull, direction='both')

model2<-lm(formula = shares ~ n_tokens_content + num_imgs + num_keywords + 
             data_channel_is_lifestyle + data_channel_is_entertainment + 
             data_channel_is_bus + data_channel_is_socmed + data_channel_is_tech + 
             data_channel_is_world + kw_min_min + weekday_is_saturday + 
             LDA_01 + global_rate_positive_words + rate_positive_words + 
             rate_negative_words + min_positive_polarity, data = Main_Training)
summary(model2)
# Residual standard error: 0.8657, Adjusted R-squared:  0.1004 

model_Cross_Validation2<-train(shares ~ n_tokens_content + num_imgs + num_keywords + 
                                 data_channel_is_lifestyle + data_channel_is_entertainment + 
                                 data_channel_is_bus + data_channel_is_socmed + data_channel_is_tech + 
                                 data_channel_is_world + kw_min_min + weekday_is_saturday + 
                                 LDA_01 + global_rate_positive_words + rate_positive_words + 
                                 rate_negative_words + min_positive_polarity, data = Main_Training, method = 'lm', trControl=mycontrol)
model_Cross_Validation2
################################################################################################################
################################################################################################################
################################################################################################################
################## AIC METHOD, LOGGING EVERYTIHING, USE MEAN OF COLUMN FOR REPLCING THE N/As####################
training_data2

# FIRST we have to replace inf with mean of columns. to do that we need first some other transformations

#step1
# replace inf with NA 
training_data2[sapply(training_data2, is.infinite)] <- NA

# replacing NA with means of each column 
mean(training_data2$n_tokens_content, na.rm = TRUE)
training_data2["n_tokens_content"][is.na(training_data2["n_tokens_content"])] <- mean(training_data2$n_tokens_content, na.rm=TRUE)
training_data2["n_tokens_title"][is.na(training_data2["n_tokens_title"])] <- mean(training_data2$n_tokens_title, na.rm=TRUE)
training_data2["num_hrefs"][is.na(training_data2["num_hrefs"])] <- mean(training_data2$num_hrefs, na.rm=TRUE)
training_data2["num_self_hrefs"][is.na(training_data2["num_self_hrefs"])] <- mean(training_data2$num_self_hrefs, na.rm=TRUE)
training_data2["num_imgs"][is.na(training_data2["num_imgs"])] <- mean(training_data2$num_imgs, na.rm=TRUE)
training_data2["num_videos"][is.na(training_data2["num_videos"])] <- mean(training_data2$num_videos, na.rm=TRUE)
training_data2["average_token_length"][is.na(training_data2["average_token_length"])] <- mean(training_data2$average_token_length, na.rm=TRUE)
training_data2["num_keywords"][is.na(training_data2["num_keywords"])] <- mean(training_data2$num_keywords, na.rm=TRUE)
training_data2["kw_min_min"][is.na(training_data2["kw_min_min"])] <- mean(training_data2$kw_min_min, na.rm=TRUE)
training_data2["kw_max_min"][is.na(training_data2["kw_max_min"])] <- mean(training_data2$kw_max_min, na.rm=TRUE)
training_data2["kw_avg_min"][is.na(training_data2["kw_avg_min"])] <- mean(training_data2$kw_avg_min, na.rm=TRUE)
training_data2["kw_min_max"][is.na(training_data2["kw_min_max"])] <- mean(training_data2$kw_min_max, na.rm=TRUE)
training_data2["kw_max_max"][is.na(training_data2["kw_max_max"])] <- mean(training_data2$kw_max_max, na.rm=TRUE)
training_data2["kw_avg_max"][is.na(training_data2["kw_avg_max"])] <- mean(training_data2$kw_avg_max, na.rm=TRUE)
training_data2["kw_min_avg"][is.na(training_data2["kw_min_avg"])] <- mean(training_data2$kw_min_avg, na.rm=TRUE)
training_data2["kw_max_avg"][is.na(training_data2["kw_max_avg"])] <- mean(training_data2$kw_max_avg, na.rm=TRUE)
training_data2["kw_avg_avg"][is.na(training_data2["kw_avg_avg"])] <- mean(training_data2$kw_avg_avg, na.rm=TRUE)
training_data2["self_reference_min_shares"][is.na(training_data2["self_reference_min_shares"])] <- mean(training_data2$self_reference_min_shares, na.rm=TRUE)
training_data2["self_reference_max_shares"][is.na(training_data2["self_reference_max_shares"])] <- mean(training_data2$self_reference_max_shares, na.rm=TRUE)
training_data2["self_reference_avg_sharess"][is.na(training_data2["self_reference_avg_sharess"])] <- mean(training_data2$self_reference_avg_sharess, na.rm=TRUE)


mfull<-lm(shares~., data = training_data2)
step(mfull, direction='both')

model3<- lm(formula = shares ~ n_tokens_content + n_unique_tokens + n_non_stop_words + 
              num_hrefs + num_imgs + num_keywords + data_channel_is_lifestyle + 
              data_channel_is_entertainment + data_channel_is_bus + data_channel_is_socmed + 
              data_channel_is_world + kw_min_min + kw_min_max + kw_min_avg + 
              kw_avg_avg + self_reference_max_shares + self_reference_avg_sharess + 
              weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
              weekday_is_thursday + weekday_is_friday + LDA_01 + LDA_03 + 
              global_rate_negative_words + min_positive_polarity + avg_negative_polarity + 
              abs_title_subjectivity, data = training_data2)
summary(model3)
# Residual standard error: 0.8414, Adjusted R-squared:  0.1501 

model_Cross_Validation3<-train(shares ~ n_tokens_content + n_unique_tokens + n_non_stop_words + 
                                 num_hrefs + num_imgs + num_keywords + data_channel_is_lifestyle + 
                                 data_channel_is_entertainment + data_channel_is_bus + data_channel_is_socmed + 
                                 data_channel_is_world + kw_min_min + kw_min_max + kw_min_avg + 
                                 kw_avg_avg + self_reference_max_shares + self_reference_avg_sharess + 
                                 weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                                 weekday_is_thursday + weekday_is_friday + LDA_01 + LDA_03 + 
                                 global_rate_negative_words + min_positive_polarity + avg_negative_polarity + 
                                 abs_title_subjectivity, data = training_data2, method = 'lm', trControl=mycontrol)
model_Cross_Validation3

################################################################################################################
################################################################################################################
################################################################################################################
################################### LASSO REGRESSION, TO RAW DATA ##############################################
install.packages('glmnet')
library(glmnet)
mfull <- lm(shares~., data = Main_Training)
X <- model.matrix(mfull)[,-1]
lasso <- glmnet(X, Main_Training$shares)
plot(lasso, xvar = "lambda", label = T)
#Use cross validation to find a reasonable value for lambda 
lasso1 <- cv.glmnet(X, Main_Training$shares, alpha = 1)
lasso1$lambda
lasso1$lambda.min
lasso1$lambda.1se
plot(lasso1)
coef(lasso1, s = "lambda.min")
plot(lasso1$glmnet.fit, xvar = "lambda")
abline(v=log(c(lasso1$lambda.min, lasso1$lambda.1se)), lty =2)


lasso_coefs<- as.matrix(coef(lasso1, s = "lambda.min"))
lasso_coefs<-as.data.frame(lasso_coefs)

lasso_coefs<-subset(lasso_coefs, s1!=0 )

# MODEL under LASSO 
model4<-lm(shares ~ n_tokens_content+num_hrefs+num_imgs+num_keywords+data_channel_is_entertainment+
     data_channel_is_world+kw_min_min+kw_avg_avg+self_reference_avg_sharess+weekday_is_tuesday+
   weekday_is_saturday+LDA_03+rate_positive_words+min_positive_polarity+max_negative_polarity,  data = Main_Training)
summary(model4)


# AFTER AIC
step(model4, direction='both')
model5<-lm(formula = shares ~ n_tokens_content + num_imgs + num_keywords + 
             data_channel_is_entertainment + data_channel_is_world + kw_min_min + 
             weekday_is_saturday + LDA_03 + min_positive_polarity, data = Main_Training)
summary(model5)
# Residual standard error: 0.8515, Adjusted R-squared:  0.1295 

model_Cross_Validation4<-train(shares ~ n_tokens_content + num_imgs + num_keywords + 
                                 data_channel_is_entertainment + data_channel_is_world + kw_min_min + 
                                 weekday_is_saturday + LDA_03 + min_positive_polarity, data = Main_Training, 
                               method = 'lm', trControl=mycontrol)

model_Cross_Validation4

################################################################################################################
################################################################################################################
################################################################################################################
################################### LASSO REGRESSION, METHOD AIC, LOGED SHARES ###################################################



mfull<-lm(shares~.,data = Training_log_Shares)
X <- model.matrix(mfull)[,-1]
lasso <- glmnet(X, Training_log_Shares$shares)
plot(lasso, xvar = "lambda", label = T)
#Use cross validation to find a reasonable value for lambda 
lasso1 <- cv.glmnet(X, Training_log_Shares$shares, alpha = 1)
lasso1$lambda
lasso1$lambda.min
lasso1$lambda.1se
plot(lasso1)
coef(lasso1, s = "lambda.min")

plot(lasso1$glmnet.fit, xvar = "lambda")
abline(v=log(c(lasso1$lambda.min, lasso1$lambda.1se)), lty =2)


lasso_coefs<- as.matrix(coef(lasso1, s = "lambda.min"))
lasso_coefs<-as.data.frame(lasso_coefs)

lasso_coefs<-subset(lasso_coefs, s1!=0 )


# MODEL under LASSO 
model6<- lm(shares~ +n_tokens_title+n_tokens_content+n_unique_tokens+n_non_stop_words+n_non_stop_unique_tokens+
              +num_hrefs+num_self_hrefs+num_imgs+num_videos+num_keywords+data_channel_is_lifestyle+
              +data_channel_is_entertainment+data_channel_is_bus+data_channel_is_socmed+data_channel_is_tech
            +data_channel_is_world+kw_min_min+kw_min_max+kw_max_max+kw_avg_max+kw_min_avg+kw_max_avg+kw_avg_avg
            +self_reference_max_shares+self_reference_avg_sharess+weekday_is_monday+weekday_is_tuesday+weekday_is_wednesday
            +weekday_is_friday+weekday_is_saturday+is_weekend+LDA_00+LDA_04+LDA_01+global_subjectivity+global_sentiment_polarity
            +global_rate_negative_words+min_positive_polarity+max_positive_polarity+avg_negative_polarity+max_negative_polarity
            +abs_title_subjectivity+abs_title_sentiment_polarity, data = Training_log_Shares)
summary(model6)
# AFTER AIC
step(model6, direction='both')
model7<-lm(formula = shares ~ n_tokens_content + n_unique_tokens + n_non_stop_words + 
             num_hrefs + data_channel_is_lifestyle + data_channel_is_entertainment + 
             data_channel_is_bus + data_channel_is_socmed + data_channel_is_world + 
             kw_min_min + kw_min_max + kw_avg_max + kw_min_avg + kw_max_avg + 
             kw_avg_avg + self_reference_avg_sharess + weekday_is_wednesday + 
             is_weekend + LDA_00 + LDA_04 + global_rate_negative_words + 
             min_positive_polarity + max_positive_polarity + avg_negative_polarity, 
           data = Training_log_Shares)
summary(model7)
# Residual standard error: 0.8505, Adjusted R-squared:  0.1316

model_Cross_Validation5<-train(shares ~ n_tokens_content + n_unique_tokens + n_non_stop_words + 
                                 num_hrefs + data_channel_is_lifestyle + data_channel_is_entertainment + 
                                 data_channel_is_bus + data_channel_is_socmed + data_channel_is_world + 
                                 kw_min_min + kw_min_max + kw_avg_max + kw_min_avg + kw_max_avg + 
                                 kw_avg_avg + self_reference_avg_sharess + weekday_is_wednesday + 
                                 is_weekend + LDA_00 + LDA_04 + global_rate_negative_words + 
                                 min_positive_polarity + max_positive_polarity + avg_negative_polarity, 
                               data = Training_log_Shares, 
                               method = 'lm', trControl=mycontrol)
model_Cross_Validation5

################################################################################################################
################################################################################################################
################################################################################################################
################################### LASSO REGRESSION, METHOD AIC, LOGED EVERYTHING ###################################################

mfull<-lm(shares~.,data = training_data2)
X <- model.matrix(mfull)[,-1]
lasso <- glmnet(X, training_data2$shares)
plot(lasso, xvar = "lambda", label = T)
#Use cross validation to find a reasonable value for lambda 
lasso1 <- cv.glmnet(X, training_data2$shares, alpha = 1)
lasso1$lambda
lasso1$lambda.min
plot(lasso1)
coef(lasso1, s = "lambda.min")

plot(lasso1$glmnet.fit, xvar = "lambda")
abline(v=log(c(lasso1$lambda.min, lasso1$lambda.1se)), lty =2)


lasso_coefs<- as.matrix(coef(lasso1, s = "lambda.min"))
lasso_coefs<-as.data.frame(lasso_coefs)

lasso_coefs<-subset(lasso_coefs, s1!=0 )

# MODEL under LASSO 
model8<-lm(shares~ n_tokens_title+num_hrefs+num_imgs+num_keywords+data_channel_is_lifestyle+data_channel_is_entertainment
           +data_channel_is_socmed+data_channel_is_tech+data_channel_is_world+kw_min_min+kw_avg_min
           +kw_min_max+kw_avg_max+kw_min_avg+kw_avg_avg+self_reference_min_shares+self_reference_avg_sharess
           +weekday_is_wednesday+weekday_is_friday+is_weekend+LDA_01+global_subjectivity+global_rate_negative_words+
             min_positive_polarity+avg_negative_polarity+max_negative_polarity+abs_title_subjectivity, data = training_data2)
summary(model8)

# AFTER AIC
step(model8, direction='both')
model9<- lm(formula = shares ~ num_imgs + num_keywords + data_channel_is_entertainment + 
              data_channel_is_socmed + data_channel_is_tech + data_channel_is_world + 
              kw_min_min + kw_min_max + kw_min_avg + kw_avg_avg + self_reference_min_shares + 
              self_reference_avg_sharess + weekday_is_wednesday + is_weekend + 
              global_rate_negative_words + min_positive_polarity + avg_negative_polarity + 
              abs_title_subjectivity, data = training_data2)
summary(model9)
# Residual standard error: 0.8429, Adjusted R-squared:  0.1471

model_Cross_Validation6<-train(shares ~ num_imgs + num_keywords + data_channel_is_entertainment + 
                                 data_channel_is_socmed + data_channel_is_tech + data_channel_is_world + 
                                 kw_min_min + kw_min_max + kw_min_avg + kw_avg_avg + self_reference_min_shares + 
                                 self_reference_avg_sharess + weekday_is_wednesday + is_weekend + 
                                 global_rate_negative_words + min_positive_polarity + avg_negative_polarity + 
                                 abs_title_subjectivity, data = training_data2, 
                               method = 'lm', trControl=mycontrol)
model_Cross_Validation6




