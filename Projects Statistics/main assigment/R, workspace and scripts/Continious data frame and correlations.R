Data_Training_Continious<- Main_Training[,
c('shares','n_tokens_title', 
'n_tokens_content', 
'num_hrefs' ,
'num_self_hrefs' ,
'num_imgs' ,
'num_videos',
'average_token_length' ,
'num_keywords',
'kw_min_min' ,
'kw_max_min' ,
'kw_avg_min' ,
'kw_min_max' ,
'kw_max_max' ,
'kw_avg_max' ,
'kw_min_avg' ,
'kw_max_avg' ,
'kw_avg_avg' ,
'self_reference_min_shares', 
'self_reference_max_shares' ,
'self_reference_avg_sharess')]


install.packages('corrplot')
library(corrplot)

lol<-cor(Data_Training_Continious)
lol<-as.data.frame(lol)

corrplot(corr = cor(Data_Training_Continious))












