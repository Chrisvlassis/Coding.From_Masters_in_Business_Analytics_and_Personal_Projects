

# SO, lets try log EVERY BIG VARIABLE. FOR THIS REASON WE CREATE A NEW DATA FRAME

training_data2

# Logging all continous variables:
training_data2$n_tokens_title <-log(training_data2$n_tokens_title)
training_data2$n_tokens_content <-log(training_data2$n_tokens_content)
training_data2$num_hrefs <-log(training_data2$num_hrefs)
training_data2$num_self_hrefs <-log(training_data2$num_self_hrefs)
training_data2$num_imgs <-log(training_data2$num_imgs)
training_data2$num_videos <-log(training_data2$num_videos)
training_data2$average_token_length <-log(training_data2$average_token_length)
training_data2$num_keywords <-log(training_data2$num_keywords)
training_data2$kw_min_min <-log(training_data2$kw_min_min)
training_data2$kw_max_min <-log(training_data2$kw_max_min)
training_data2$kw_avg_min <-log(training_data2$kw_avg_min)
training_data2$kw_min_max <-log(training_data2$kw_min_max)
training_data2$kw_max_max <-log(training_data2$kw_max_max)
training_data2$kw_avg_max <-log(training_data2$kw_avg_max)
training_data2$kw_min_avg <-log(training_data2$kw_min_avg)
training_data2$kw_max_avg <-log(training_data2$kw_max_avg)
training_data2$kw_avg_avg <-log(training_data2$kw_avg_avg)
training_data2$self_reference_min_shares <-log(training_data2$self_reference_min_shares)
training_data2$self_reference_max_shares <-log(training_data2$self_reference_max_shares)
training_data2$self_reference_avg_sharess <-log(training_data2$self_reference_avg_sharess)
######################################

# removing NaNs
training_data3<- na.omit(training_data2)

# removing Inf
training_data4<- training_data3[!is.infinite(rowSums(training_data3)),]


LOL_MODEL<-lm(training_data4$log_SHARES ~., data = training_data4)
summary(LOL_MODEL)

step(LOL_MODEL, direction = 'both')

LOL_MODEL2<-lm(formula = training_data4$log_SHARES ~ n_tokens_content + n_unique_tokens + 
                 n_non_stop_unique_tokens + num_hrefs + data_channel_is_entertainment + 
                 data_channel_is_socmed + data_channel_is_tech + data_channel_is_world + 
                 kw_min_max + kw_avg_max + self_reference_max_shares + weekday_is_saturday + 
                 LDA_02 + global_sentiment_polarity + global_rate_positive_words + 
                 rate_positive_words + avg_positive_polarity + max_positive_polarity + 
                 avg_negative_polarity + min_negative_polarity + max_negative_polarity + 
                 abs_title_subjectivity + n_tokens_title, data = training_data4)
summary(LOL_MODEL2)

# prediction for the same data
training_data4$predicted_shares <- predict(LOL_MODEL2, newdata = training_data4)
cor(training_data4$predicted_shares, training_data4$log_SHARES)

# making the same changes to the test data set
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


# removing NaNs
test_data3<- na.omit(test_data2)

# removing Inf
test_data4<- test_data3[!is.infinite(rowSums(test_data3)),]


test_data4$predicted_shares <- predict(LOL_MODEL2, newdata = test_data4)
cor(test_data4$predicted_shares, test_data4$log_shares)
















