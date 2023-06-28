remove(alldata_onlinenews_14_TRAINING)

####################################################### CATEGORICAL VARIABLES ###############################################
Main_Test['n_non_stop_words']


cor(Main_Training)


# creating a bar plot to count Articles per Article Type:
Main_Training_for_bar_plot<- Main_Training[,c("data_channel_is_lifestyle", "data_channel_is_entertainment",
                                           "data_channel_is_bus", "data_channel_is_socmed",
                                           "data_channel_is_tech", "data_channel_is_world")]


Main_Training_for_bar_plot$Type<- ifelse(Main_Training_for_bar_plot$data_channel_is_lifestyle == 1, 'Lifestyle',
                                  ifelse(Main_Training_for_bar_plot$data_channel_is_entertainment == 1, 'Entertaiment', 
                                  ifelse(Main_Training_for_bar_plot$data_channel_is_bus == 1, 'Business',
                                  ifelse(Main_Training_for_bar_plot$data_channel_is_socmed == 1, 'Social',
                                  ifelse(Main_Training_for_bar_plot$data_channel_is_tech == 1, 'Technology',
                                  ifelse(Main_Training_for_bar_plot$data_channel_is_world == 1, 'world', 'No Knoweledge'
                                         ))))))
# creating the bar plots for Articles per Article type                          
library(tidyverse)
ploted<-ggplot(Main_Training_for_bar_plot, aes( x = Main_Training_for_bar_plot$Type, fill=Main_Training_for_bar_plot$Type )) +
  geom_bar() + 
  theme_minimal() +
  xlab('Channel Type') +
  theme(axis.text.x = element_text(size = 8))   

ploted <- ploted + guides(fill=guide_legend(title="Channel Type"))


#####################################################################################################################
#####################################################################################################################
#####################################################################################################################


# creating a bar plot to count Articles per day of published :
Main_Training_for_bar_plot_day<- Main_Training[,c('shares','weekday_is_monday', "weekday_is_tuesday",
                                                  "weekday_is_wednesday", "weekday_is_thursday",
                                                  "weekday_is_friday", "weekday_is_saturday",
                                                  "weekday_is_sunday")]


Main_Training_for_bar_plot_day$Day<- ifelse(Main_Training_for_bar_plot_day$weekday_is_monday == 1, 'Monday',
                                     ifelse(Main_Training_for_bar_plot_day$weekday_is_tuesday == 1, 'Tuesday', 
                                     ifelse(Main_Training_for_bar_plot_day$weekday_is_wednesday == 1, 'Wednesday',
                                     ifelse(Main_Training_for_bar_plot_day$weekday_is_thursday == 1, 'Thursday',
                                     ifelse(Main_Training_for_bar_plot_day$weekday_is_friday == 1, 'Friday',
                                     ifelse(Main_Training_for_bar_plot_day$weekday_is_saturday == 1, 'Saturday',
                                     ifelse(Main_Training_for_bar_plot_day$weekday_is_sunday == 1, 'Sunday', 'No knowledge')
                                                                     ))))))
Main_Training_for_bar_plot_day$Day<- as.factor(Main_Training_for_bar_plot_day$Day)


library(tidyverse)
ploted<-ggplot(Main_Training_for_bar_plot_day, aes( x = Main_Training_for_bar_plot_day$Day, fill=Main_Training_for_bar_plot_day$Day )) +
  geom_bar() + 
  theme_minimal() +
  xlab('Day') +
  theme(axis.text.x = element_text(size = 8))   

ploted <- ploted + guides(fill=guide_legend(title="Day"))



#####################################################################################################################
#####################################################################################################################
#####################################################################################################################

# pairwise comaprison, i will need this script DONT DELETE IT. 
# μην ξεχασω να αλλαξβ σε factor την κατηγορηματικη μεταβλητη 

library(sjPlot)

y<- Main_Training$shares
x<- Main_Training_for_bar_plot$Type

p.adjust(Main_Training_for_bar_plot2222$shares, Main_Training_for_bar_plot2222$Type)



Main_Training_for_bar_plot2222<- Main_Training[,c("shares","data_channel_is_lifestyle", "data_channel_is_entertainment",
                                              "data_channel_is_bus", "data_channel_is_socmed",
                                              "data_channel_is_tech", "data_channel_is_world")]




Main_Training_for_bar_plot2222$Type<- ifelse(Main_Training_for_bar_plot2222$data_channel_is_lifestyle == 1, 'Lifestyle',
                                      ifelse(Main_Training_for_bar_plot2222$data_channel_is_entertainment == 1, 'Entertaiment', 
                                      ifelse(Main_Training_for_bar_plot2222$data_channel_is_bus == 1, 'Business',
                                      ifelse(Main_Training_for_bar_plot2222$data_channel_is_socmed == 1, 'Social',
                                      ifelse(Main_Training_for_bar_plot2222$data_channel_is_tech == 1, 'Technology',
                                      ifelse(Main_Training_for_bar_plot2222$data_channel_is_world == 1, 'world', 'No Knoweledge'
                                                                     ))))))

Main_Training_for_bar_plot2222$Type<- as.factor(Main_Training_for_bar_plot2222$Type)


pairwise.t.test(Main_Training_for_bar_plot2222$shares, Main_Training_for_bar_plot2222$Type)




cur.formula<-as.formula('Main_Training_for_bar_plot2222$shares ~ Main_Training_for_bar_plot2222$Type ')
res.anova<- aov(cur.formula, data = Main_Training_for_bar_plot2222)
summary(res.anova)


################################# PARWISE TESTS FOR CATEGORICAL VARIABLES AND SHARES #####################
################################# CHANNEL CATEGORY ########################################

# no normallity
hist(Main_Training_for_bar_plot2222$shares)
# large sample 
# symmetry test

# ALL ASSYMENTRIC
symmetry.test(Main_Training_for_bar_plot2222['shares'][Main_Training_for_bar_plot2222$Type == 'Lifestyle',])
symmetry.test(Main_Training_for_bar_plot2222['shares'][Main_Training_for_bar_plot2222$Type == 'Entertaiment',])
symmetry.test(Main_Training_for_bar_plot2222['shares'][Main_Training_for_bar_plot2222$Type == 'Business',])
symmetry.test(Main_Training_for_bar_plot2222['shares'][Main_Training_for_bar_plot2222$Type == 'Social',])
symmetry.test(Main_Training_for_bar_plot2222['shares'][Main_Training_for_bar_plot2222$Type == 'Technology',])
symmetry.test(Main_Training_for_bar_plot2222['shares'][Main_Training_for_bar_plot2222$Type == 'world',])
symmetry.test(Main_Training_for_bar_plot2222['shares'][Main_Training_for_bar_plot2222$Type == 'No Knoweledge',])

# KRUSKA TEST
# there is difference between the medians 
kruskal.test(Main_Training_for_bar_plot2222$shares ~ Main_Training_for_bar_plot2222$Type, 
             data = Main_Training_for_bar_plot2222)

# lets check the pairs 
pairwise.wilcox.test(Main_Training_for_bar_plot2222$shares,Main_Training_for_bar_plot2222$Type) 



# We reject the null because P-value(2.2e-16)<α(0.05). Therefore, we have statistical significant evidence
# at a=5% to show that there is difference between the medians of beginning and current salary

# NO significant difference in the medians

# Lifestyle     Business 
# No Knoweledge Lifestyle 
# Social   No Knoweledge     
# Technology    Lifestyle 
# Technology    No Knoweledge
# world    Entertaiment      


# significant difference in the medians: 

# Entertaiment   Business 
# Lifestyle     Entertaiment 
# No Knoweledge Business 
# No Knoweledge Entertaiment 
# Social    Business      
#  Social  Entertaiment       
# Social        Lifestyle 
# Technology    Business 
#Technology    Entertaiment 
# Technology    Social  
# world        Business  
# world     Lifestyle      
# world       No Knoweledge  
# world        Social  
# world Technology


# calculate means
Means_Channels<-aggregate(Main_Training_for_bar_plot2222$shares, list(Main_Training_for_bar_plot2222$Type), FUN=mean) 
Means_Channels[order(Means_Channels$x),]



# box plot for shares and channgel types. no usefull information 
boxplot(Main_Training_for_bar_plot2222$shares~Main_Training_for_bar_plot2222$Type,
        data=Main_Training_for_bar_plot2222,
        xlab = 'Channel Types', ylab = 'Shares', main = 'Shares for Channel Types', ylim = c(0,10000000))
        
library(corrplot)
corrplot(cor(Data_Training_Continious),        # Correlation matrix
         method = "shade", # Correlation plot method
         type = "full",    # Correlation plot style (also "upper" and "lower")
         diag = TRUE,      # If TRUE (default), adds the diagonal
         tl.col = "black", # Labels color
         bg = "white",     # Background color
         title = "",       # Main title
         col = NULL)


cor(Data_Training_Continious)


corrplot(cor(Data_Training_Continious), #Change font size of text labels
         tl.cex = 0.7)



################################# PARWISE TESTS FOR CATEGORICAL VARIABLES AND SHARES #####################
################################# CHANNEL CATEGORY ########################################


# all asymetric 
symmetry.test(Main_Training_for_bar_plot_day['shares'][Main_Training_for_bar_plot_day$Day == 'Monday',])


# KRUSKA TEST
# there is difference between the medians 
kruskal.test(Main_Training_for_bar_plot_day$shares ~ Main_Training_for_bar_plot_day$Day, 
             data = Main_Training_for_bar_plot_day)

# lets check the pairs 
pairwise.wilcox.test(Main_Training_for_bar_plot_day$shares,Main_Training_for_bar_plot_day$Day) 

# NO significant difference in the medians

# Monday  Friday     
# Sunday   Saturday 
# Thursday  Friday  
# Thursday  Monday  
# Tuesday Friday  
# Tuesday   Monday  
# Tuesday Thursday 
# Wednesday  Friday  
# Wednesday Monday  
# Wednesday Thursday 
# Wednesday Tuesday


# significant difference in the medians: 

# Saturday  Friday  
# Saturday  Monday  
# Sunday    Friday  
# Sunday    Monday  
# Thursday  Saturday 
# Thursday  Sunday  
# Tuesday   Saturday 
# Tuesday   Sunday  
#    Wednesday Saturday 
# Wednesday Sunday  


# calculate means
aggregate(Main_Training_for_bar_plot_day$shares, list(Main_Training_for_bar_plot_day$Day), FUN=mean) 

Means_Channels<-aggregate(Main_Training_for_bar_plot_day$shares, list(Main_Training_for_bar_plot_day$Day), FUN=mean) 
Means_Channels[order(Means_Channels$x),]




####################################################### CONTINOUS - DICSRETE VARIABLES ###############################################


# 1 HISTOGRAMS 
hist(Data_Training_Continious[,c(3,4)])
Data_Training_Continious$self_reference_avg_sharess
lol1<-ggplot(Data_Training_Continious, aes(x=shares)) + geom_histogram()
lol2<-ggplot(Data_Training_Continious, aes(x=n_tokens_content)) + geom_histogram()
lol3<-ggplot(Data_Training_Continious, aes(x=n_tokens_title)) + geom_histogram()
lol4<-ggplot(Data_Training_Continious, aes(x=num_hrefs)) + geom_histogram()
lol5<-ggplot(Data_Training_Continious, aes(x=num_self_hrefs)) + geom_histogram()
lol6<-ggplot(Data_Training_Continious, aes(x=num_imgs)) + geom_histogram()
lol7<-ggplot(Data_Training_Continious, aes(x=num_videos)) + geom_histogram()
lol8<-ggplot(Data_Training_Continious, aes(x=average_token_length)) + geom_histogram()
lol9<-ggplot(Data_Training_Continious, aes(x=num_keywords)) + geom_histogram()
lol10<-ggplot(Data_Training_Continious, aes(x=kw_min_min)) + geom_histogram()
lol11<-ggplot(Data_Training_Continious, aes(x=kw_min_max)) + geom_histogram()
lol12<-ggplot(Data_Training_Continious, aes(x=kw_avg_min)) + geom_histogram()

lol13<-ggplot(Data_Training_Continious, aes(x=kw_max_min)) + geom_histogram()
lol14<-ggplot(Data_Training_Continious, aes(x=kw_max_max)) + geom_histogram()
lol15<-ggplot(Data_Training_Continious, aes(x=kw_avg_max)) + geom_histogram()
lol16<-ggplot(Data_Training_Continious, aes(x=kw_min_avg)) + geom_histogram()
lol17<-ggplot(Data_Training_Continious, aes(x=kw_max_avg)) + geom_histogram()
lol18<-ggplot(Data_Training_Continious, aes(x=kw_avg_avg)) + geom_histogram()
lol19<-ggplot(Data_Training_Continious, aes(x=self_reference_min_shares)) + geom_histogram()
lol20<-ggplot(Data_Training_Continious, aes(x=self_reference_max_shares)) + geom_histogram()
lol21<-ggplot(Data_Training_Continious, aes(x=self_reference_avg_sharess)) + geom_histogram()


ggarrange(lol2,lol1,lol3,lol4,lol5,lol6,lol7,lol8,lol9,lol10,lol11,lol12)
ggarrange(lol13,lol14,lol15,lol16,lol17,lol18,lol19,lol20,lol21)


# 2 PLOTS SHARES WITH ALL OTHER VARIABLES


plot(Data_Training_Continious$n_tokens_title, Data_Training_Continious$shares)
plot(Data_Training_Continious$n_tokens_content, Data_Training_Continious$shares)
plot(Data_Training_Continious$num_hrefs, Data_Training_Continious$shares)
plot(Data_Training_Continious$num_self_hrefs, Data_Training_Continious$shares)
plot(Data_Training_Continious$num_imgs, Data_Training_Continious$shares)
plot(Data_Training_Continious$num_videos, Data_Training_Continious$shares)
plot(Data_Training_Continious$average_token_length, Data_Training_Continious$shares)
plot(Data_Training_Continious$num_keywords, Data_Training_Continious$shares)
plot(Data_Training_Continious$kw_min_min, Data_Training_Continious$shares)
plot(Data_Training_Continious$kw_max_min, Data_Training_Continious$shares)


sc1<-ggplot(Data_Training_Continious, aes(x=n_tokens_title, y=shares)) + geom_point()
sc2<-ggplot(Data_Training_Continious, aes(x=n_tokens_content, y=shares)) + geom_point()
sc3<-ggplot(Data_Training_Continious, aes(x=num_hrefs, y=shares)) + geom_point()
sc4<-ggplot(Data_Training_Continious, aes(x=num_self_hrefs, y=shares)) + geom_point()
sc5<-ggplot(Data_Training_Continious, aes(x=num_imgs, y=shares)) + geom_point()
sc6<-ggplot(Data_Training_Continious, aes(x=num_videos, y=shares)) + geom_point()
sc7<-ggplot(Data_Training_Continious, aes(x=average_token_length, y=shares)) + geom_point()
sc8<-ggplot(Data_Training_Continious, aes(x=num_keywords, y=shares)) + geom_point()
sc9<-ggplot(Data_Training_Continious, aes(x=kw_min_min, y=shares)) + geom_point()
sc10<-ggplot(Data_Training_Continious, aes(x=kw_max_min, y=shares)) + geom_point()

ggarrange(sc1,sc2,sc3,sc4,sc5,sc6,sc7,sc8,sc9,sc10)


















plot(Data_Training_Continious$kw_avg_min, Data_Training_Continious$shares)
plot(Data_Training_Continious$kw_min_max, Data_Training_Continious$shares)
plot(Data_Training_Continious$kw_max_max, Data_Training_Continious$shares)
plot(Data_Training_Continious$kw_avg_max, Data_Training_Continious$shares)
plot(Data_Training_Continious$kw_min_avg, Data_Training_Continious$shares)
plot(Data_Training_Continious$kw_max_avg, Data_Training_Continious$shares)
plot(Data_Training_Continious$kw_avg_avg, Data_Training_Continious$shares)
plot(Data_Training_Continious$self_reference_min_shares, Data_Training_Continious$shares)
plot(Data_Training_Continious$self_reference_max_shares, Data_Training_Continious$shares)
plot(Data_Training_Continious$self_reference_avg_sharess, Data_Training_Continious$shares)


sc11<-ggplot(Data_Training_Continious, aes(x=kw_avg_min, y=shares)) + geom_point()
sc12<-ggplot(Data_Training_Continious, aes(x=kw_min_max, y=shares)) + geom_point()
sc13<-ggplot(Data_Training_Continious, aes(x=kw_max_max, y=shares)) + geom_point()
sc14<-ggplot(Data_Training_Continious, aes(x=kw_avg_max, y=shares)) + geom_point()
sc15<-ggplot(Data_Training_Continious, aes(x=kw_min_avg, y=shares)) + geom_point()
sc16<-ggplot(Data_Training_Continious, aes(x=kw_max_avg, y=shares)) + geom_point()
sc17<-ggplot(Data_Training_Continious, aes(x=kw_avg_avg, y=shares)) + geom_point()
sc18<-ggplot(Data_Training_Continious, aes(x=self_reference_min_shares, y=shares)) + geom_point()
sc19<-ggplot(Data_Training_Continious, aes(x=self_reference_max_shares, y=shares)) + geom_point()
sc20<-ggplot(Data_Training_Continious, aes(x=self_reference_avg_sharess, y=shares)) + geom_point()




ggarrange(sc1,sc2,sc3,sc4,sc5,sc6,lol7,sc7,sc8,sc9,sc10)
ggarrange(sc11,sc12,sc13,sc14,sc15,sc16,sc17,sc18,sc18,sc19,sc20)




pairs(Data_Training_Continious)




















