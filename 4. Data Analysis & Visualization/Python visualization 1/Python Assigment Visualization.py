#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import plotly.express as px
import matplotlib 
from scipy.stats import t
import plotly.graph_objects as go
import seaborn as sb
from matplotlib.ticker import MultipleLocator
import os


# * Firstly we insert the data in a dataframe called df

# In[2]:


# Getting the current working directory
current_dir = os.getcwd()
# Constructing the relative file path 
file_path = os.path.join(current_dir, "Data", "social_capital_county.csv")
# We use the relative path to read the dataSet
df = pd.read_csv(file_path)
df


# * Now we will create a small data frame only for the needed values. question_1_DF
# * We also have to add zeros infront of every value of the column county that does not have a length of 5

# In[3]:


question_1_DF = df[['ec_county','county_name','county']]

question_1_DF['county'] = question_1_DF['county'].astype(str)
question_1_DF['county'] = question_1_DF['county'].str.zfill(5)


# In[4]:


# Now we are left with this dataset that contains only the relevant information for question 1
question_1_DF


# * Firstly i rename the column ec_county
# * Secondly i create the conditions and values according to the exercise 
# * Finally i make the plot 

# In[5]:


question_1_DF=question_1_DF.rename(columns={'ec_county':'economic connectedness'})


# In[6]:


conditions = [
    (question_1_DF['economic connectedness'] <= 0.58),
    (question_1_DF['economic connectedness'] > 0.58 ) & (question_1_DF['economic connectedness'] < 0.67),
    (question_1_DF['economic connectedness'] >= 0.67) & (question_1_DF['economic connectedness'] < 0.72),
    (question_1_DF['economic connectedness'] >= 0.72 ) & (question_1_DF['economic connectedness'] < 0.76),
    (question_1_DF['economic connectedness'] >= 0.76) & (question_1_DF['economic connectedness'] < 0.81),
    (question_1_DF['economic connectedness'] >= 0.81 ) & (question_1_DF['economic connectedness'] < 0.85),
    (question_1_DF['economic connectedness'] >= 0.85) & (question_1_DF['economic connectedness'] < 0.90),
    (question_1_DF['economic connectedness'] >= 0.90 ) & (question_1_DF['economic connectedness'] < 0.97),
    (question_1_DF['economic connectedness'] >= 0.97) & (question_1_DF['economic connectedness'] < 1.06),
    (question_1_DF['economic connectedness'] >= 1.06), (question_1_DF['economic connectedness'].isnull())
    ]

values = ['<0.58','0.58-0.67','0.67-0.72','0.72-0.76','0.76-0.81','0.81-0.85','0.85-0.90','0.90-0.97','0.97-1.06','>1.06','NA']


# In[7]:


question_1_DF['tier'] = np.select(conditions, values)


# In[8]:



from urllib.request import urlopen
import json

with urlopen('https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json') as response:
    counties = json.load(response)

question_1_Figure = px.choropleth(question_1_DF, 
                                  geojson=counties, 
                                  locations='county', 
                                  color = 'tier', 
                                  scope="usa",
                                  category_orders={'tier':['>1.06','0.97-1.06','0.90-0.97','0.85-0.90','0.81-0.85','0.76-0.81','0.72-0.76','0.67-0.72','0.58-0.67','<0.58','NA']},
                    color_discrete_sequence=['rgb(5,48,97)','rgb(33,102,172)','rgb(67,147,195)','rgb(146,197,222)','rgb(209,229,240)','rgb(247,247,247)','rgb(253,219,199)','rgb(244,165,130)','rgb(214,96,77)','rgb(178,24,43)','yellow'],
                                  hover_data={'tier':False, 'county_name':False, 'economic connectedness':True},
                                  hover_name='county_name')
question_1_Figure.update_layout(legend_title="Economic Connectedness")


question_1_Figure.show()


# It is worth mentioning that that some county codes have changed. For example Alaska in our dataset (the dataset from the research paper) has a county code of 02158 but in the jeason file has 02270. Another example is Kenedy, Texas. This can be found in other counties because they have changed their county code. Also, the usa has more counties than those that we can  found in our dataset. With that being said its logical to have some missing values.
# 
#     Note: missing values are not NAs. Missing values are those counties that have changed their county code and now we can  not merge the relevant information

# In[9]:


# Checking the wrong fip code of Wade Hampton, Alaska
question_1_DF[question_1_DF['county_name'].str.contains('Wade Ha')]


# ## Question 2

# General steps to be taken:
# * Firstly i find the correct column that represents the y axis. This column is the 'kfr_pooled_pooled_p25' from the 'county_outcomes_simple' csv.
# * Secondly i merge the two dataframes and take only the information that i need
# * The merge will be made in the FIP codes after i manupulate them to bring them in the form that is needed

# In[10]:


# From the first data frame i need the county, county name, ec_county for the x axis and pop2018 
# since we want 200 most populous US counties
Question_2_df= df[['county','county_name','pop2018','ec_county']]
Question_2_df


# Now we will bring the second dataframe and we will keep only the necessary columns

# In[11]:


# Getting the current working directory
current_dir = os.getcwd()
# Constructing the relative file path 
file_path = os.path.join(current_dir, "Data", "county_outcomes_simple.csv")
# We use the relative path to read the dataSet
df_2 = pd.read_csv(file_path)
# keeping only the information that we need
Question_2_df_2 = df_2[['state','county','czname','kfr_pooled_pooled_p25']]
Question_2_df_2


# Now that we have loaded all the necessary tables we have to make the merge between the two data frames
# But first we need to: 
# * For the 'Question_2_df' add zero in front of the fip column if the length is not five
# * For the 'Question_2_df_2' add one zero if the length of state is not two and add two zeros if the length of county is not 3
# * Finally we have to merge the 2 columns in order to get the full FIP code

# In[12]:


# making the relevant changes to the first data frame 
Question_2_df['county'] = Question_2_df['county'].astype(str)
Question_2_df['county'] = Question_2_df['county'].str.zfill(5)


# In[13]:


# making the relevant changes to the second data frame 
Question_2_df_2['state'] = Question_2_df_2['state'].astype(str)
Question_2_df_2['state'] = Question_2_df_2['state'].str.zfill(2)

Question_2_df_2['county'] = Question_2_df_2['county'].astype(str)
Question_2_df_2['county'] = Question_2_df_2['county'].str.zfill(3)

# merging the columns to create the fip code 
Question_2_df_2['fip_code'] = Question_2_df_2['state']+ Question_2_df_2['county']


# In[14]:


# merging the data frames 
Merged_df= pd.merge(Question_2_df_2, Question_2_df, left_on='fip_code', right_on='county')

# Keeping the necessary information
Merged_df = Merged_df[['czname','kfr_pooled_pooled_p25','fip_code','county_name','pop2018','ec_county']]
Merged_df


# In[15]:


# keeping the 200 most populated counties
Merged_df = Merged_df.nlargest(200, 'pop2018')
Merged_df


# Now we have our data frame as we want to create our linear-scatter plot

# In[16]:


plt.figure(figsize=(11, 5))

sb.set_style("darkgrid")

Q_4 = sb.regplot(x = Merged_df['ec_county'],
           y = Merged_df['kfr_pooled_pooled_p25'], fit_reg=True)
plt.annotate("San Francisco", xy=(1.31244, 0.503888), xytext=(1.1, 0.425), arrowprops={"arrowstyle":"->", "color":"black"})
plt.annotate("Minneapolis", xy=(0.97632, 0.428964), xytext=(1.1, 0.375), arrowprops={"arrowstyle":"->", "color":"black"})
plt.annotate("Salt Lake City", xy=(0.96395, 0.454131), xytext=(0.9, 0.5), arrowprops={"arrowstyle":"->", "color":"black"})
plt.annotate("New York City", xy=(0.82734, 0.418693), xytext=(0.65, 0.5), arrowprops={"arrowstyle":"->", "color":"black"})
plt.annotate("Indianapolis", xy=(0.64282, 0.34408), xytext=(0.85, 0.325), arrowprops={"arrowstyle":"->", "color":"black"})
plt.xlabel('Economic Connectedness')
plt.ylabel('Predicted Household Income Rank \nFor Children with Parents at 25th Income Perentile');


# ## Question 3 

# We are going to need the following datasets and columns:
# * Dataset name: social_capital_zip, columns: zip, ec_zip
# * Dataset name: zip_covariates, columns: zip, kfr_pooled_pooled_p25, med_inc_2018

# In[17]:


# Getting the current working directory
current_dir = os.getcwd()
# Constructing the relative file path 
file_path = os.path.join(current_dir, "Data", "social_capital_zip.csv")
# we import the dataset 
econ_Con = pd.read_csv(file_path)

# keeping the data that we need:
econ_Con = econ_Con[['zip','ec_zip']] 

# for the zip columns we make the lenght equal to 5 
econ_Con['zip'] = econ_Con['zip'].astype(str)
econ_Con['zip'] = econ_Con['zip'].str.zfill(5)
econ_Con


# In[18]:


# Getting the current working directory
current_dir = os.getcwd()
# Constructing the relative file path 
file_path = os.path.join(current_dir, "Data", "zip_covariates.dta")
# we import the dataset 
zip_cov = pd.read_stata(file_path)

# keeping the data that we need:
zip_cov = zip_cov[['zip', 'kfr_pooled_pooled_p25', 'med_inc_2018']]

# for the zip columns we make the lenght equal to 5 
zip_cov['zip'] = zip_cov['zip'].astype(str)
zip_cov['zip'] = zip_cov['zip'].str.zfill(5)
zip_cov


# In[19]:


# Merging the dataframes 
Main_df= pd.merge(econ_Con, zip_cov, left_on='zip', right_on='zip')
Main_df


# In[20]:


# we will keep only the rows that we want according to the plot. we want median household between 30000 and 100000
Main_df = Main_df[Main_df['med_inc_2018'] > 30000]  
Main_df = Main_df[Main_df['med_inc_2018'] < 100000]  

# we create the tiers for the colors of the plot
conditions2 = [
    (Main_df['kfr_pooled_pooled_p25'] < 0.38),
    (Main_df['kfr_pooled_pooled_p25'] >= 0.38 ) & (Main_df['kfr_pooled_pooled_p25'] < 0.41),
    (Main_df['kfr_pooled_pooled_p25'] >= 0.41) & (Main_df['kfr_pooled_pooled_p25'] < 0.44),
    (Main_df['kfr_pooled_pooled_p25'] >= 0.44 ) & (Main_df['kfr_pooled_pooled_p25'] <= 0.48),
    (Main_df['kfr_pooled_pooled_p25'] > 0.48)]
values = ['< 38','38-41','41-44','44-48','> 48']

Main_df['Upward Mobility'] = np.select(conditions2, values)
Main_df


# In[21]:


# seting figure size and background color
plt.figure(figsize = (10,6))
sb.set(rc={'axes.facecolor':'#EBEBEB'})

# ploting 
p = sb.scatterplot(data=Main_df, 
               x=Main_df['med_inc_2018'], 
               y=Main_df['ec_zip'], 
               hue=Main_df['Upward Mobility'],
               palette=['darkblue','dodgerblue','beige','orange','brown'], legend='full',
               alpha  = 0.7,
               hue_order = ['> 48','44-48','41-44','38-41','< 38'])
# seting the labels
p.set_ylabel("Economic Connectedness", fontsize = 12)
p.set_xlabel("Median household Income in ZIP Code(US$)", fontsize = 12)



plt.show()


# ## Question 4

# In[22]:


# Getting the current working directory
current_dir = os.getcwd()
# Constructing the relative file path 
file_path = os.path.join(current_dir, "Data", "social_capital_high_school.csv")
# we import the dataset 
df_4 = pd.read_csv(file_path)

# we will keep only the variables that we need for our plot:
df_4 = df_4[['high_school','high_school_name','ec_parent_ses_hs','bias_parent_ses_hs']]
df_4


# In[23]:


# creating the x axis:
df_4['ec_parent_ses_hs'] = df_4['ec_parent_ses_hs']/2
df_4


# In[24]:


# we will use df_5 for our plot since the y and x axis are now calculated in %.
df_5 = df_4[['high_school_name','high_school','ec_parent_ses_hs','bias_parent_ses_hs']]
df_5['bias_parent_ses_hs'] = df_5['bias_parent_ses_hs']*100
df_5['ec_parent_ses_hs'] = df_5['ec_parent_ses_hs']*100


# In[25]:


df_5


# In[26]:


# finally we filter our dataframe to keep only the rows that have bias_parent_ses_hs greater than -15 as the assigment plot commands
df_5 = df_5[df_5['bias_parent_ses_hs'] >= -15]
df_5


# In[27]:


# setting background color
sb.set(rc={'axes.facecolor':'#EBEBEB'})
# setting the bbox arguments
bbox = dict(boxstyle="round", facecolor='white', edgecolor='grey')
#setting the arrowprops arguents
arrowprops=dict( lw=2.5, arrowstyle="->", color='lightblue')

fig, ax = plt.subplots(figsize=(10, 6))
# ploting 
ax.scatter(x= df_5['ec_parent_ses_hs'],
            y=df_5['bias_parent_ses_hs'],
            s=20,
            alpha=0.2,
           c = 'black')
plt.gca().invert_yaxis()

# setting the minor grid lines for x axis
ml2 = MultipleLocator(10)
ax.xaxis.set_minor_locator(ml2)
ax.xaxis.grid(which="minor", color='white', linestyle='-', linewidth=1)
# setting the minor grid lines for y axis
ml1 = MultipleLocator(5)
ax.yaxis.set_minor_locator(ml1)
ax.yaxis.grid(which="minor", color='white', linestyle='-', linewidth=1)

# setting the labels
plt.xlabel("Share of high-parental-SES student (%)")
plt.ylabel("Friending bias among low-parental-SES students (%)")

# making the annotations
plt.annotate("North Hollywood HS", xy=(28.193501, 16.764), xytext=(20, 20), arrowprops=arrowprops, bbox=bbox)
plt.annotate("Lake Highlands HS", xy=(41.870498, 19.902), xytext=(40, 25), arrowprops=arrowprops, bbox=bbox)
plt.annotate("Berkeley HS", xy=(51.010000, 11.372), xytext=(40, 10), arrowprops=arrowprops, bbox=bbox)
plt.annotate("Evanston Township HS", xy=(57.774, 11.782), xytext=(60, 10), arrowprops=arrowprops, bbox=bbox)
plt.annotate("Lincoln Park HS", xy=(45.452500, 3.471), xytext=(50, 5), arrowprops=arrowprops, bbox=bbox)
plt.annotate("Bishop Gorman HS", xy=(78.055, 0.564), xytext=(80, 3), arrowprops=arrowprops, bbox=bbox)
plt.annotate("Phillips Exeter Academy", xy=(79.206995, -1.38), xytext=(80, -3), arrowprops=arrowprops, bbox=bbox)
plt.annotate("Dalton School", xy=(71.367500, -0.778), xytext=(70, -5), arrowprops=arrowprops, bbox=bbox)
plt.annotate("Lane Technical HS", xy=(48.6745, -1.742), xytext=(50, -5), arrowprops=arrowprops, bbox=bbox)
plt.annotate("New Bedford HS", xy=(24.261, -0.764), xytext=(7, 0), arrowprops=arrowprops, bbox=bbox)
plt.annotate("Brooklyn Technical HS", xy=(45.3805, -1.614), xytext=(30, -10), arrowprops=arrowprops, bbox=bbox)
plt.annotate("West Charlotte HS", xy=(18.662, -5.284), xytext=(10, -7), arrowprops=arrowprops, bbox=bbox)
plt.annotate("LeFlore Magnet HS", xy=(23.0065, -5.177), xytext=(25, 5), arrowprops=arrowprops, bbox=bbox)
plt.annotate("Cambridge Rindge & Latin School", xy=(54.316, 5.497), xytext=(65, 7), arrowprops=arrowprops, bbox=bbox)

# putting the dots in place
plt.scatter(79.206995, -1.38, c='lightblue', alpha=0.6)
plt.scatter(78.055, 0.564, c='lightblue', alpha=0.6)
plt.scatter(54.316, 5.497, c='lightblue', alpha=0.6)
plt.scatter(57.774, 11.782, c='lightblue', alpha=0.6)
plt.scatter(41.870498, 19.902, c='lightblue', alpha=0.6)
plt.scatter(51.010000, 11.372, c='lightblue', alpha=0.6)
plt.scatter(45.452500, 3.471, c='lightblue', alpha=0.6)
plt.scatter(71.3675, -0.778, c='lightblue', alpha=0.5)
plt.scatter(48.6745, -1.742, c='lightblue', alpha=0.6)
plt.scatter(24.261, -0.764, c='lightblue', alpha=0.6)
plt.scatter(18.662, -5.284, c='lightblue', alpha=0.6)
plt.scatter(23.0065, -5.177, c='lightblue', alpha=0.6)
plt.scatter(45.3805, -1.614, c='lightblue', alpha=0.6)
plt.scatter(28.193501, 16.764, c='lightblue', alpha=0.6)

_ = 6


# ## Question 5 

# For the neighborhood we are going to need the following tables:
# * social_capital_zip.csv, for the column num_below_p50 which is the weight.
# * zip_covariates.dta,  for the columns of shares for the HHI index
# 
# For the college we are going to need the following tables:
# * social_capital_college.csv, for the columns: 
# * college_characteristics.dta, for the columns: 

# In[28]:


# Getting the current working directory
current_dir = os.getcwd()
# Constructing the relative file path 
file_path = os.path.join(current_dir, "Data", "social_capital_zip.csv")
# we import the dataset 
Num_bel = pd.read_csv(file_path)
# keeping the data that we need:
Num_bel = Num_bel[['zip','num_below_p50','nbhd_bias_zip']] 

# for the zip columns we make the lenght equal to 5 
Num_bel['zip'] = Num_bel['zip'].astype(str)
Num_bel['zip'] = Num_bel['zip'].str.zfill(5)
Num_bel


# In[29]:


# Getting the current working directory
current_dir = os.getcwd()
# Constructing the relative file path 
file_path = os.path.join(current_dir, "Data", "zip_covariates.dta")
# we import the dataset 
zip_cov = pd.read_stata(file_path)

#keeping the data that we need:
zip_cov = zip_cov[['zip', 'share_white_2018', 'share_black_2018','share_natam_2018','share_asian_2018','share_hawaii_2018','share_hispanic_2018']]


# for the zip columns we make the lenght equal to 5 
zip_cov['zip'] = zip_cov['zip'].astype(str)
zip_cov['zip'] = zip_cov['zip'].str.zfill(5)
zip_cov


# In[30]:


# now we merge the 2 dataframes
Merged_df= pd.merge(Num_bel, zip_cov, left_on='zip', right_on='zip')

# we rename the columns to have a better understanding of the variables
Merged_df=Merged_df.rename(columns={'num_below_p50':'Weights_ZIP','nbhd_bias_zip':'Friending_bias_ZIP'})

# We create the HHI index
Merged_df['HHI'] = 1 - (Merged_df['share_white_2018'] * Merged_df['share_white_2018'] + Merged_df['share_black_2018'] * Merged_df['share_black_2018'] + Merged_df['share_natam_2018'] * Merged_df['share_natam_2018'] + Merged_df['share_asian_2018'] * Merged_df['share_asian_2018'] + Merged_df['share_hawaii_2018'] * Merged_df['share_hawaii_2018'] + Merged_df['share_hispanic_2018'] * Merged_df['share_hispanic_2018'])

# We create the bins according to the HHI
Merged_df['Bins'] = pd.qcut(Merged_df.HHI, q=20, labels = False)

Merged_df


# In[31]:


# we group by Bins and find the means for the HHI index and the Friending_bias_ZIP
# this is for the neighborhood plot
Merged_df_new=Merged_df.groupby(['Bins'])['HHI','Friending_bias_ZIP'].mean()
Merged_df_new


# ### Now we move to the college plot

# In[32]:


# Getting the current working directory
current_dir = os.getcwd()
# Constructing the relative file path 
file_path = os.path.join(current_dir, "Data", "social_capital_college.csv")
# we import the dataset 
SCC = pd.read_csv(file_path)

# we keep only the data that we nee 
SCC = SCC[['zip','college','mean_students_per_cohort','bias_own_ses_college']] 

# for the zip columns we make the lenght equal to 5 
SCC['zip'] = SCC['zip'].astype(str)
SCC['zip'] = SCC['zip'].str.zfill(5)

# we rename the column with the bias to have a better view of the variable
SCC=SCC.rename(columns={'bias_own_ses_college':'bias_College'})

SCC


# In[33]:


# Getting the current working directory
current_dir = os.getcwd()
# Constructing the relative file path 
file_path = os.path.join(current_dir, "Data", "college_characteristics.dta")
# we import the dataset 
College_cov = pd.read_stata(file_path)

# we keep the data that we need 
College_cov = College_cov[['zip','college', 'black_share_fall_2000', 'hisp_share_fall_2000','asian_or_pacific_share_fall_2000']]

# for the zip columns we make the lenght equal to 5 
College_cov['zip'] = College_cov['zip'].astype(str)
College_cov['zip'] = College_cov['zip'].str.zfill(5)

# we create the share for the white population:
College_cov['white_share_fall_2000'] = 1 - College_cov['black_share_fall_2000'] - College_cov['hisp_share_fall_2000'] - College_cov['asian_or_pacific_share_fall_2000'] 

College_cov


# In[34]:


# now we will merge the 2 dataframes
Merged_df_college= pd.merge(SCC, College_cov, left_on='college', right_on='college')

# we create the HHI index: 
Merged_df_college['HHI'] = 1 - (Merged_df_college['black_share_fall_2000'] * Merged_df_college['black_share_fall_2000'] + Merged_df_college['hisp_share_fall_2000'] * Merged_df_college['hisp_share_fall_2000'] + Merged_df_college['asian_or_pacific_share_fall_2000'] * Merged_df_college['asian_or_pacific_share_fall_2000'] + Merged_df_college['white_share_fall_2000'] * Merged_df_college['white_share_fall_2000'])

# we create the bins according to the HHI
Merged_df_college['Bins'] = pd.qcut(Merged_df_college.HHI, q=20, labels = False)
Merged_df_college


# In[35]:


# we group by Bins and find the means for the HHI index and the bias_College
# this is for the college plot
Merged_df_new_college=Merged_df_college.groupby(['Bins'])['HHI','bias_College'].mean()
Merged_df_new_college


# In[36]:


# We will crete 2 new columns for each data frame. This column will be used for the color of the scatter plot
# lets create a new column
Merged_df_new_college['College'] = 'College'

# lets create a new column
Merged_df_new['Neighborhood'] = 'Neighborhood'


# In[37]:


# We Union the two dataframes 
Final_DF=pd.concat([Merged_df_new_college, Merged_df_new])

# And we merge the columns and create two new column one for the bias and one for the groups
Final_DF['Bias']=Final_DF['bias_College'].combine_first(Final_DF['Friending_bias_ZIP'])    
Final_DF['Groups']=Final_DF['College'].combine_first(Final_DF['Neighborhood'])

# We remove the columns that we do not need
Final_DF = Final_DF.drop('bias_College', axis=1)
Final_DF = Final_DF.drop('College', axis=1)
Final_DF = Final_DF.drop('Friending_bias_ZIP', axis=1)
Final_DF = Final_DF.drop('Neighborhood', axis=1)


# Finally we change the HHI index from decial to percentage
Final_DF['Bias'] = Final_DF['Bias']*100

Final_DF


# In[38]:


# We change the figure background color
sb.set(rc={'axes.facecolor':'#EBEBEB'})

# ploting 
sb.lmplot(x="HHI", y="Bias", data=Final_DF, hue="Groups", markers=['D', "o"], legend=False)

# changing the size of the figure
plt.gcf().set_size_inches(6.5, 4.5)

# seting the labels
plt.xlabel('Racial Diversity (Herfindalhl-Hirschman Index) in Group')
plt.ylabel('Friending Bias aming Low-SES Individuals (%)')

# changing the position of the legend 
plt.legend(loc='upper left')

plt.show()

