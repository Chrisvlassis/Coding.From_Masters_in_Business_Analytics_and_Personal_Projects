# Load mongolite
install.packages("mongolite")
library("mongolite")
install.packages("jsonlite")
library("jsonlite")
install.packages("stringr")
library("stringr")

# Open a connection to MongoDB
m <- mongo(collection = "main_data",  db = "assigment_1", url = "mongodb://localhost")

# read the file paths: 
files_list<- read.delim("C:\\DATA_FOR_MONGO_ASSIGMENT\\BIKES\\full_paths_2.txt", header = FALSE)


# Lets see how the data are presented:
example_1 <- fromJSON(readLines(files_list[1,]))
example_2 <- fromJSON(readLines(files_list[2,]))
example_3 <- fromJSON(readLines(files_list[3,]))
example_4 <- fromJSON(readLines(files_list[4,]))
example_5 <- fromJSON(readLines(files_list[10,]))

####################################################### TESTING PHASE ########################################################



testing_list <- read.delim("C:\\DATA_FOR_MONGO_ASSIGMENT\\BIKES\\testing_file_paths.txt", header = FALSE)


example_1 <- fromJSON(readLines(testing_list[1,]))
example_3 <- fromJSON(readLines(testing_list[3,]))




######################## THIS WILL BE USED FOR CLEANIG THE PRICES !!!!! ##############################
######### REPLACE example_3 WITH bike_data

# First we need to check if the price exists:
# Then, if price contains any characters of the alphabet, set it to NULL and create the Negotiable! 
# else, make the number numeric
if ("Price" %in% names(example_3$ad_data)) {
  if (grepl("[a-z]", example_3$ad_data$Price)) {
    example_3$ad_data$Price <- NA
    print('haha')
  } else {
    numeric_value <- as.numeric(gsub("[^0-9]+", "", example_3$ad_data$Price))
    print(numeric_value)
  }
}

######################## THIS WILL BE USED FOR CLEANIG THE PRICES !!!!! ##############################



######################## We use this to find the Negotiable: 

# We can find the Negotiable with parenthesis and the end of the model.
# We will create a new attribute called model:
for (i in 1:nrow(files_list)) {
  bike_data <- fromJSON(readLines(files_list[i,], encoding = "UTF-8"))
  if( grepl("Negotiable", bike_data$metadata$model, ignore.case = TRUE)){
    bike_data$metadata$Negotiable <- TRUE
  }
}
######################## We use this to find the Negotiable  !!!!! ##############################





############################### THIS WILL BE OUR LOOP   !!!!! ##############################
for (i in 1:nrow(files_list)) {
  bike_data <- fromJSON(readLines(files_list[i,], encoding = "UTF-8"))
}
############################### THIS WILL BE OUR LOOP   !!!!! ##############################




############################### lets create the Age    !!!!! ##############################



example_1$ad_data$Age <- as.numeric(format(Sys.Date(), "%Y")) - as.numeric((strsplit(example_1$ad_data$Registration, " / "))[[1]][[2]])




###############################lets create the Age  !!!!! ##############################


############################### Lets clean the Mileage !!!! ######################################################


gsub("[^0-9]", "", example_5$ad_data$Mileage)


############################### Lets clean the Mileage !!!! ######################################################



############################## lets try and combine everything #########################################

# We will use some data to test: 

testing_list <- read.delim("C:\\DATA_FOR_MONGO_ASSIGMENT\\BIKES\\testing_file_paths.txt", header = FALSE)

# NOTE: Before one if we use  big if that will check if the attribute can be found. If we do not to that we will get an error
# e.g if ("model" %in% names(bike_data$ad_data))


for (i in 1:nrow(files_list)) {
  bike_data <- fromJSON(readLines(files_list[i,], encoding = "UTF-8"))
  if ("model" %in% names(bike_data$ad_data)) { 
# if the price is Negotiable we create a new Attribute:
    if( grepl("Negotiable", bike_data$metadata$model, ignore.case = TRUE)){
      bike_data$metadata$Negotiable <- TRUE
  }
  if ("Price" %in% names(bike_data$ad_data)) {
# if price contains letters, set it to NA. if it contains any non-numeric characters remove them and set price to numeric
    if (grepl("[a-z]", bike_data$ad_data$Price)) {
      bike_data$ad_data$Price <- NA
    } else {
      numeric_value <- as.numeric(gsub("[^0-9]+", "", bike_data$ad_data$Price))
    }
  
    m$insert(bike_data)
    }
  if ("Registration" %in% names(bike_data$ad_data)) { 
# We create the Age of the bike. from current year we substract the year of the Registration
    bike_data$ad_data$Age <- as.numeric(format(Sys.Date(), "%Y")) - as.numeric((strsplit(bike_data$ad_data$Registration, " / "))[[1]][[2]])
  }
  }
  m$insert(bike_data)
}





  
####################################################################################################################################################################################


















