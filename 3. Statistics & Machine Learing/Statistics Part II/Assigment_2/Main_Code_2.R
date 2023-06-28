library(readxl)
library(glmnet)
library(stats)
library(car)
library(corrplot)
library(ggplot2)
library(ResourceSelection)
library(lmtest)
library(PredictABEL)
library(vcdExtra)
library(performance)
library(generalhoslem)
library(cvms)
library(tibble) 
library(rpart)
library(rpart.plot)
library(caret)
library(e1071)


county_facts <- read_excel("C:/Users/vlass/OneDrive/Υπολογιστής/Metaptyxiako/2nd_Trimester/Statistics 2/Assigment_2/Data.xlsx", sheet = "county_facts")
votes <- read_excel("C:/Users/vlass/OneDrive/Υπολογιστής/Metaptyxiako/2nd_Trimester/Statistics 2/Assigment_2/Data.xlsx", sheet = "votes")

################################################################################################################################################################## 
######################################################                                            ################################################################ 
###################################################### PART I Data Cleaning and Data Manipulation ################################################################
######################################################                                            ################################################################ 
################################################################################################################################################################## 

# the assignment commands that we analyze the votes for the Republican party. With that being said all other rows will be dropped
votes = subset(votes, party=="Republican")

# also we want as response whether Trump got more than 50% in each county. The fraction_votes metric will help us in this.

# we create a column taking values 0 for not more than 50% and 1 for more than 50%
votes$response <- ifelse(votes$candidate == 'Donald Trump' & votes$fraction_votes>=0.50 , 1, 0)

# From the votes data frame we want to remove all the lines that are not containing the Donald Trump:
votes<- subset(votes,candidate == 'Donald Trump')

# now we will merge the 2 data frames:
data <- merge(votes, county_facts, by= "fips", all = FALSE)

# lets clean our data set to have a better view:
data = subset(data, select = -c(state_abbreviation.x, area_name, state_abbreviation.y, party, fraction_votes, candidate) )

library(dplyr)
data <- data %>% select(c(response, ), everything())
remove(county_facts)
remove(votes)


# lets remove the fips codes:
main_data = subset(data, select = -c(fips,county))


# changing to factors:
main_data$state <- factor(main_data$state)
main_data$response <- factor(main_data$response)

remove(data)






# We have a good ratio for our binary data! No need to oversample or undersample.
sum(main_data$response == 0) / length(main_data$response) * 100
sum(main_data$response == 1) / length(main_data$response) * 100




# We split the data to training and test data sets
library(caret)
# We create a seed
set.seed(100) 
trainIndex <- createDataPartition(main_data$response, p = 0.7, list = FALSE)
train <- main_data[trainIndex, ]
test <- main_data[-trainIndex, ]
remove(trainIndex)


################################################################################################################################################################## 
######################################################                                            ################################################################ 
######################################################             PART II Modelling              ################################################################
######################################################                                            ################################################################ 
################################################################################################################################################################## 


######################################################### First Model: ######################################################################
################################################ From Lasso to Prediction ############################################################


# We make the lasso Regression:
set.seed(100) 
x <- model.matrix(response ~ ., data = train)[,-1]
y <- train$response
lasso <- cv.glmnet(x, y, alpha = 1, family = 'binomial')

plot(lasso$lambda, lasso$cvm, xlab = "Lambda", ylab = "Misclassification Error", type = "l")
min_lambda <- lasso$lambda[which.min(lasso$cvm)]
abline(v = min_lambda, col = "red")




# We use lasso for lambda min to make a prediction:
x_test <- model.matrix(response ~ ., data = test)[,-1]
# We lambda min since gives the minimum classification error
y_test_pred <- predict(lasso, newx = x_test, s = "lambda.min", type = 'class')

# Lets see the accuracy of the model:
y_test <- test$response
accuracy <- mean(y_test == y_test_pred)
accuracy # 0.899 (90%)  very good accuracy! 




# We can see from the matrix that our model has done a good job! 
confusion_matrix <- table(y_test, y_test_pred)

# The classification error: 
classification_error <- (sum(confusion_matrix) - sum(diag(confusion_matrix))) / sum(confusion_matrix) # 0.10 (10%) VERY GOOD! 



# The accuracy:
accuracy_2 <-  sum(diag(confusion_matrix)) / sum(confusion_matrix) # 0.899 (90%) very good accuracy! 

# From the 813 observations, from the test dataset, the model managed to correctly predict the 741 observations. 
# The false negatives are 57 & false positives are 25 



# Lets plot: We plot the confusion Matrix:
cfm <- as_tibble(confusion_matrix)

plot_confusion_matrix(cfm, 
                      target_col = "y_test", 
                      prediction_col = "y_test_pred",
                      counts_col = "n")





########################################################  Second Model: ######################################################################
######################################################    Random Forest   ###############################################################

set.seed(100) 
library(randomForest)
# Create a random forest model
Random_Forest <- randomForest(response ~ ., data = train, ntree = 1000, mtry = 10)

# Make predictions on the test set
predictions_RF <- predict(Random_Forest, newdata = test)
# We can see from the matrix that our model has done pretty good job!
confusion_matrix_Random_Forest <- table(y_test, predictions_RF)

# The classification error: 
classification_error_RF <- (sum(confusion_matrix_Random_Forest) - sum(diag(confusion_matrix_Random_Forest))) / sum(confusion_matrix_Random_Forest) # 0.10 (12%) PRETTY GOOD! 

# The accuracy:
accuracy_RF <-  sum(diag(confusion_matrix_Random_Forest)) / sum(confusion_matrix_Random_Forest) # 0.87 (87%) pretty good accuracy! 

# From the 813 observations, from the test dataset, the model managed to correctly predict the 713 observations. 
# The false positives are 36 & false negatives are 51 


# Lets plot: We plot the confusion Matrix:
cfm_RF <- as_tibble(confusion_matrix_Random_Forest)

plot_confusion_matrix(cfm_RF, 
                      target_col = "y_test", 
                      prediction_col = "predictions_RF",
                      counts_col = "n")




######################################################### Third Model: ######################################################################
######################################################    Decision Tree   ###############################################################

set.seed(100) 
ctrl <- trainControl(method = 'cv', number = 10)

DT_1 <- train(response ~ ., data = train, method = 'rpart', trControl = ctrl, tuneLength = 12)
DT_1$bestTune

plot(DT_1)

# We make a prediction
DT_1$finalModel
pr<- predict(DT_1, test)

# We create the confusion matrix
DT_conf_matr<-confusionMatrix(table(test$response, pr))


confusion_matrix_DT <- table(y_test, pr)

# The classification error: 
classification_error_DT <- (sum(confusion_matrix_DT) - sum(diag(confusion_matrix_DT))) / sum(confusion_matrix_DT) # 0.16 (16%) PRETTY GOOD! 

# The accuracy:
accuracy_DT <-  sum(diag(confusion_matrix_DT)) / sum(confusion_matrix_DT) # 0.84 (84%) pretty good accuracy! 

0.8400984 + 0.1599016

# Lets plot: We plot the confusion Matrix:
cfm_DT <- as_tibble(confusion_matrix_DT)

plot_confusion_matrix(cfm_DT, 
                      target_col = "y_test", 
                      prediction_col = "pr",
                      counts_col = "n")







######################################################### Forth Model: ######################################################################
######################################################       SVM         ###############################################################


############################################ THIS MODEL WAS NOT USED IN THE PAPER ######################################################
# Lets scale our data:


# Lets create two new data frames, one for test one for training:
train_scaled <- train
test_scaled <- test


# For the training:
cont_data <- sapply(train_scaled, is.numeric)

train_scaled[cont_data] <- lapply(train_scaled[cont_data], scale)

# For the test:
cont_data <- sapply(test_scaled, is.numeric)

test_scaled[cont_data] <- lapply(test_scaled[cont_data], scale)




# Now that we have scaled, lets run a SVM model
set.seed(100) 
svm_model <- svm(response ~ ., data = train_scaled, scale = TRUE)


predictions_svm <- predict(svm_model, test_scaled)

confusion_matrix_svm <- table(Predicted = predictions_svm, Actual = test_scaled$response)

confusion_matrix_svm 

# The classification error: 
classification_error_svm <- (sum(confusion_matrix_svm) - sum(diag(confusion_matrix_svm))) / sum(confusion_matrix_svm) # 15% good

# The accuracy:
accuracy_svm <-  sum(diag(confusion_matrix_svm)) / sum(confusion_matrix_svm) # 0.84 (84%) good accuracy! 




############################################ THIS MODEL WAS NOT USED IN THE PAPER ######################################################




####################################################################################################################################
####################################################### CLUSTERING #################################################################
####################################################################################################################################


county_facts <- read_excel("C:/Users/vlass/OneDrive/Υπολογιστής/Metaptyxiako/2nd_Trimester/Statistics 2/Assigment_2/Data.xlsx", sheet = "county_facts")


# As we found the dataset that is provided has falsely made some aggregations that there should not be there!
# More specificly it sums all the values for every state althought the granularity level should be on county level
# Not only this, it contains values for cities where should be ONLY counties,
# to solve this issue we remove any row that did not contain at 'County' at the end. This we did for the area_name column 

library(dplyr)

# Filter rows that end with 'County' in the 'county_name' column
county_facts <- county_facts %>%
  filter(grepl("County$", area_name))




# We create two different data frames.
# The one will contain the demographic data, for the clustering 
# The other will contain the economic data for the description of the clusters:


# Demographic data frame: 
demographic_data <- subset(county_facts, select = c(PST045214,PST040210, PST120214, POP010210,
                                                    AGE135214, AGE295214, AGE775214, SEX255214,
                                                    RHI125214, RHI225214, RHI325214, RHI425214,
                                                    RHI525214, RHI625214, RHI725214, RHI825214,
                                                    POP715213, POP645213, POP815213, EDU635213,
                                                    EDU685213, VET605213))

# Economic related data frame: 
economic_data <- subset(county_facts, select = -c(PST045214,PST040210, PST120214, POP010210,
                                                  AGE135214, AGE295214, AGE775214, SEX255214,
                                                  RHI125214, RHI225214, RHI325214, RHI425214,
                                                  RHI525214, RHI625214, RHI725214, RHI825214,
                                                  POP715213, POP645213, POP815213, EDU635213,
                                                  EDU685213, VET605213))


#---------------------------------------------------------------------------------------------------------------------------#
######################################### Clustering with Euclidean Distance and Linkage = ward #############################
#---------------------------------------------------------------------------------------------------------------------------#
library('pgmm')
library('cluster')
library('mclust')
library('NbClust')
library('jpeg')

# we need to scale the data:
x <- scale(demographic_data)

# I CAN USE DIFERENT METHODS SUCH AS:  AVERAGE, SIMPLE, COMPLETE, CENTROID 
# we create a clustering model:

# dist(x) calculates euclidean distance
# the method argument concerns the linkage 
hc1 <- hclust(dist(x), method="ward.D")

# plot the dendrogram
plot(hc1)





# silhouette values. We want a high value. A high value indicates good clustering
# plot the silhouette values



# i want to create the -Silhouettes - Number of clusters Graph

# So, i need a loop to keep track for each cluster the average silhouette width:

# We will calculate the average width for clusters 2 to 10.


sil_clust <- data.frame(col1 = numeric(), col2 = numeric())

for (i in 1:15){
  # create the silhouete objects:
  trial<-silhouette(cutree(hc1, k=i), dist(x))
  # transform it to data frame
  trial<-as.data.frame(trial)
  # find the mean width
  y<-mean(trial$sil_width)
  # add it to the data frame
  sil_clust <- rbind(sil_clust, c(i, y))
  
}

# Lets plot them: 
plot(sil_clust$X1, sil_clust$NA_real_., xlab = "Number of Clusters", ylab = "Average Sihlouette Width")
lines(sil_clust$X1, sil_clust$NA_real_.)

# plot the silhouete widts for the best average silhouete widths:! 
par(mfrow=c(1,2))

plot(silhouette(cutree(hc1, k = 2), dist(x)), col=2:3,main ='ward',border = NA)
plot(silhouette(cutree(hc1, k = 3), dist(x)), col=2:4,main ='ward',border = NA)
plot(silhouette(cutree(hc1, k = 10), dist(x)), col=2:11,main ='ward',border = NA)


# plot the dendrogram for the best average silhouette widths! 
plot(hc1)

# change k to see the red borders for different number of clusters
rect.hclust(hc1, k=2, border="red")



# as we can see 5 clusters is maximizing the average width. 
# So 5 clusters is the best number of clusters according to the average width criterion. 
# and it makes sense to use 5 clusters ! 
# so if this method is used, we will create the 5 clusters according to this model

#################################### ΝΟΤΕ  #################################### 

# if we use some other linkage  such as complete or average we take silly and weird results. the best linkage is the ward
hc2 <- hclust(dist(x), method="complete")

# plot the dendogram
plot(hc2)
rect.hclust(hc2, k=5, border="red")
plot(silhouette(cutree(hc2, k = 5), dist(x)), border = NA, main = 'Euclidean distance, with complete linkage for 5 clusters')



# if we use some other linkage such as complete or average we take silly and weird results. the best linkage is the ward
hc3 <- hclust(dist(x), method="average")

# plot the dendogram
plot(hc3)
rect.hclust(hc3, k=5, border="red")
plot(silhouette(cutree(hc3, k = 5), dist(x)), border = NA)

# As can been seen these clusters do not make any sense. The average silhouette width is hight but there are no practical groups created
# So, for the euclidean distance and for linkage complete or average the results should not be used for the assignment ! 

#------------------------------------------------------------------------------------------------------------------------------------------#
#--- note: we tried many combination of clusters but the results are always silly and do not make practical sense ! -----------------------#
#------------------------------------------------------------------------------------------------------------------------------------------#


#################################### ΝΟΤΕ  #################################### 



#---------------------------------------------------------------------------------------------------------------------------#
#########################################  Clustering with Manhattan distance and linkage = ward  ###########################
#---------------------------------------------------------------------------------------------------------------------------#

# We use the manhatan method and the linkage is the ward! 
manh1 <- hclust(dist(x, method = 'manhattan'), method="ward.D")
plot(manh1)


# Linkages such as complete and average give weird results although they have high average silhoute width. They wont be used as the main clustes!

# i want to create the -Silhouettes - Number of clusters Graph

# So, i need a loop to keep track for each cluster the average silhouette width:

# We will calculate the average width for clusters 2 to 10.


sil_clust_manh <- data.frame(col1 = numeric(), col2 = numeric())

for (i in 1:15){
  # create the silhouete objects:
  trial<-silhouette(cutree(manh1, k=i), dist(x))
  # transform it to data frame
  trial<-as.data.frame(trial)
  # find the mean width
  y<-mean(trial$sil_width)
  # add it to the data frame
  sil_clust_manh <- rbind(sil_clust_manh, c(i, y))
  
}

# Lets plot them: 
plot(sil_clust_manh$X1, sil_clust_manh$NA_real_., xlab = "Number of Clusters", ylab = "Average Sihlouette Width")
lines(sil_clust_manh$X1, sil_clust_manh$NA_real_.)

# according to the Average silhouette width plot, the best number of clusters is 2 or 4 or 5
# We will see more information about these clusters to see what makes more practical sense: 



# lets plot the silhouettes for those clusters with the best result: 
par(mfrow=c(1,3))
plot(silhouette(cutree(manh1, k = 2), dist(x, method = 'manhattan')), col=2:3,main ='ward',border = NA)
plot(silhouette(cutree(manh1, k = 3), dist(x, method = 'manhattan')), col=2:4,main ='ward',border = NA)
plot(silhouette(cutree(manh1, k = 4), dist(x, method = 'manhattan')), col=2:5,main ='ward',border = NA)

plot(manh1)
rect.hclust(manh1, k=4, border="red")


#################################### ΝΟΤΕ  #################################### 


# if we use some other linkage  such as complete or average we take silly and weird results. the best linkage is the ward
manh2 <- hclust(dist(x, method = 'manhattan'), method="average")
# plot the dendogram
plot(manh2)
rect.hclust(manh2, k=5, border="red")
plot(silhouette(cutree(manh2, k = 5), dist(x, method = 'manhattan')), border = NA, main = 'Manhatan distance, with average linkage for 5 clusters')



# if we use some other linkage such as complete or average we take silly and weird results. the best linkage is the ward
manh3 <- hclust(dist(x, method = 'manhattan'), method="complete")

# plot the dendogram
plot(manh3)
rect.hclust(manh3, k=5, border="red")
plot(silhouette(cutree(manh3, k = 5), dist(x, method = 'manhattan')), border = NA)

# As can been seen these clusters do not make any sense. The average silhouette width is hight but there are no practical groups created
# So, for the manhatan distance and for linkage complete or average the results should not be used for the assignment ! 

#------------------------------------------------------------------------------------------------------------------------------------------#
#--- note: we tried many combination of clusters but the results are always silly and do not make practical sense ! -----------------------#
#------------------------------------------------------------------------------------------------------------------------------------------#

#################################### ΝΟΤΕ  #################################### 






######################################### Clustering with K-means and for linkage the ward ################################################

#------------------------------------------------------------------------------------------------------------------------------------------#
######################################### IT WAS NOT USED IN THE PAPER  ################################################
#------------------------------------------------------------------------------------------------------------------------------------------#

silhouette(k_means$cluster,dist(x))


# i want to create the -Silhouettes - Number of clusters Graph

# So, i need a loop to keep track for each cluster the average silhouette width:

# We will calculate the average width for clusters 2 to 10.


sil_clust_k_means <- data.frame(col1 = numeric(), col2 = numeric())

for (i in 1:10){
  # create the k_means model 
  k_means <- kmeans(x, i)
  # create the silhouete objects:
  trial<-silhouette(k_means$cluster,dist(x))
  # transform it to data frame
  trial<-as.data.frame(trial)
  # find the mean width
  y<-mean(trial$sil_width)
  # add it to the data frame
  sil_clust_k_means <- rbind(sil_clust_k_means, c(i, y))
}

# Lets plot them: 
plot(sil_clust_k_means$X1, sil_clust_k_means$NA_real_., xlab = "Number of Clusters", ylab = "Average Sihlouette Width")
lines(sil_clust_k_means$X1, sil_clust_k_means$NA_real_.)


#------------------------------------------------------------------------------------------------------------------------------------------#
######################################### IT WAS NOT USED IN THE PAPER  ################################################
#------------------------------------------------------------------------------------------------------------------------------------------#



#-------------------------------------------------------------#
#      Its time to decide which clusters are the best         #
#-------------------------------------------------------------#

plot(silhouette(cutree(manh1, k = 4), dist(x, method = 'manhattan')), col=2:5,main ='ward',border = NA)









#---------------------------------------------------------------------------------------------------------------------------------#
########################## its time to bring the groups to the economic data and analyze them ! ##########################
#---------------------------------------------------------------------------------------------------------------------------------#



clusters <- as.data.frame(silhouette(cutree(manh1, k=4), dist(x, method = 'manhattan')))

# Now that we have created our 4 clusters we want to 'connect' those clusters with the economic data:

# lets create a column with the row number for the clusters data frame:

clusters$line_number <- 1:nrow(clusters)

# lets create a column with the row number for the economic data:

economic_data$line_number <- 1:nrow(economic_data)


# i will merge the clusters data frame with the economic related:
merged_df <- merge(clusters, economic_data, by = 'line_number', all = TRUE)


# We remove unnecessary columns 
merged_df <- subset(merged_df, select = -c(neighbor,sil_width,line_number))

# Now we are ready to analyze the clusters with the use of the economic related data!







#---------------------------------------------------------------------------------------------------------------------------------#
#################################### ANALYZING THE CLUSTERS WITH THE USE OF THE ECONOMIC DATA  #################################### 
#---------------------------------------------------------------------------------------------------------------------------------#

# The merged data frame contains all the relative information that we need.
# we can use it to analyze the groups that were created from the demographic data

#---------------------------------------------------------------------------------------------------------------------------------#
################### because we have many economic data, we will explain a fraction of them: ######################################  
#---------------------------------------------------------------------------------------------------------------------------------#

# How many counties are found in each group? 
aggregate(fips ~ cluster, data = merged_df, length)

############################ These are the meτrics that we will analyze ###########################

# Lets compare the retail sales of 2007 (it is on 1000$)
aggregate(RTN130207 ~ cluster, data = merged_df, mean)
aggregate(RTN130207 ~ cluster, data = merged_df, median)

result_1 <- pairwise.wilcox.test(merged_df$RTN130207, merged_df$cluster)

# Lets compare the Accommodation and food services sales for 2007 ($1,000)
aggregate(BZA010213 ~ cluster, data = merged_df, mean)
aggregate(BZA010213 ~ cluster, data = merged_df, median)

result_2 <- pairwise.wilcox.test(merged_df$BZA010213, merged_df$cluster)

# Lets compare the total number of firms of 2007
aggregate(SBO001207 ~ cluster, data = merged_df, mean)
aggregate(SBO001207 ~ cluster, data = merged_df, median)

result_3 <- pairwise.wilcox.test(merged_df$SBO001207, merged_df$cluster)

# Lets compare the total number of Housing units for 2014
aggregate(HSG010214 ~ cluster, data = merged_df, mean)
aggregate(HSG010214 ~ cluster, data = merged_df, median)

result_4 <- pairwise.wilcox.test(merged_df$HSG010214, merged_df$cluster)

# Lets compare Population per square mile, 2010
aggregate(POP060210 ~ cluster, data = merged_df, mean)
aggregate(POP060210 ~ cluster, data = merged_df, median)

result_5 <- pairwise.wilcox.test(merged_df$POP060210, merged_df$cluster)


result_1
result_2
result_3
result_4
result_5

############################ These are the meτrics that we will analyze ###########################



# lets see which counties are contained in the fourth cluster


merged_df$area_name[merged_df$cluster == 4]









merged_df$RTN130207
# For creating box plots:
####################################################################
# Get the unique cluster values
clusters <- unique(merged_df$cluster)

# Loop over the clusters and create a box plot for each one
lapply(clusters, function(cluster) {
  # Subset the data for the current cluster
  data <- subset(merged_df, cluster == cluster)
  
  # Create the box plot
  boxplot(data$POP060210 ~ data$cluster, main = paste("Cluster", cluster),
          xlab = "Cluster", ylab = "RTN130207")
})
####################################################################




















