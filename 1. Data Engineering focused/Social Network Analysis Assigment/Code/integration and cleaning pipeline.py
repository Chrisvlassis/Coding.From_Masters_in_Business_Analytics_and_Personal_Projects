from itertools import islice
import re
import csv
import os
import pandas as pd
import ast

############################################################################################################
#################################### Part 1: Data Manipulation: ################################################
############################################################################################################



#############


#########


# this function will clean the data to the following form: From, To 
def process_lines(lines):
    name = lines[2].split('/')[3]
    text = re.findall(pattern, lines[3]) 
    if not text: # set column to null if there is no mention of other people in the text
        text = ''
    return [name, text]

# this function is used to append the data to the 5 files for the 'From, To' file.
def write_to_csv(csvfile, lines):
    writer = csv.writer(csvfile)
    # Check if file is empty, if so, write header
    if os.stat(csvfile.name).st_size == 0: # if there is not a header
        writer.writerow(['From', 'To'])  # write header
    writer.writerow(process_lines(lines))
    
###
# this function finds the pattern for the # and creates a new file with the user and topic_of_interest
def write_user_interest(csvfile, lines):
    writer = csv.writer(csvfile)
    # Check if the file is empty
    if csvfile.tell() == 0:
        # Write header only if the file is empty
        writer.writerow(['user', 'topic_of_interest'])
    user = lines[2].split('/')[3]
    topic_of_interest = re.findall(r"#(\w+)", lines[3])
    if not topic_of_interest: # set column to null if there is no mention of other people in the text
        topic_of_interest = ''
    writer.writerow([user, topic_of_interest])
###


pattern = r"@(\w+)" # this pattern is used to grab the @ usernames
with open(r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\tweets2009-07.txt", 'r', encoding = 'UTF-8') as file:
        while True:  # while there are lines to read:
            lines = list(islice(file, 4))  # if no lines left, then break
            if not lines:
                break
            # if for example there is 1 line left and we do not use this is 'if' we will get an error:
            if len(lines) >= 3: # this makes sure that we have enought lines to store.
            # for each day that we want we create a csv file:
                if re.search(r'2009-07-01', lines[1]):
                    with open(r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-01", 'a', newline='',  encoding='utf-8') as csvfile:
                        write_to_csv(csvfile, lines)
                    with open(r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-01_USER-TOPIC_OF_INTEREST", 'a', newline='',  encoding='utf-8') as csvfile:
                        write_user_interest(csvfile, lines)       
                elif re.search(r'2009-07-02', lines[1]):
                    with open(r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-02", 'a', newline='',  encoding='utf-8') as csvfile:
                        write_to_csv(csvfile, lines)  
                    with open(r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-02_USER-TOPIC_OF_INTEREST", 'a', newline='',  encoding='utf-8') as csvfile:
                        write_user_interest(csvfile, lines)
                elif re.search(r'2009-07-03', lines[1]):
                    with open(r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-03", 'a', newline='',  encoding='utf-8') as csvfile:
                        write_to_csv(csvfile, lines)
                    with open(r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-03_USER-TOPIC_OF_INTEREST", 'a', newline='',  encoding='utf-8') as csvfile:
                        write_user_interest(csvfile, lines)
                elif re.search(r'2009-07-04', lines[1]):
                    with open(r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-04", 'a', newline='',  encoding='utf-8') as csvfile:
                        write_to_csv(csvfile, lines)
                    with open(r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-04_USER-TOPIC_OF_INTEREST", 'a', newline='',  encoding='utf-8') as csvfile:
                        write_user_interest(csvfile, lines)
                elif re.search(r'2009-07-05', lines[1]):
                    with open(r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-05", 'a', newline='',  encoding='utf-8') as csvfile:
                        write_to_csv(csvfile, lines)
                    with open(r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-05_USER-TOPIC_OF_INTEREST", 'a', newline='',  encoding='utf-8') as csvfile:
                        write_user_interest(csvfile, lines)

################################################################################################################
############################ For the 'From, To, Weight' file: ########################################################
################################################################################################################

def convert_string_to_list(s):
    try:
        return ast.literal_eval(s)
    except (ValueError, SyntaxError):
        return []

# read the csv data. This is for the csv type: From,To, Weight
data_2009_07_01 = r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-01"
data_2009_07_02 = r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-02"
data_2009_07_03 = r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-03"
data_2009_07_04 = r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-04"
data_2009_07_05 = r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-05"

# For the: From,To, Weight
data_list = [data_2009_07_01, data_2009_07_02, data_2009_07_03, data_2009_07_04, data_2009_07_05]

# this block of code makes the data of the data frame more granular
# so, before the 'To' column had a list with the @ users. Now we have each user in one cell
# example:
# Old structure
#	From	To
# bert0364, ['therealchillar', 'mizrada']
# New structure:
# bert0364, therealchillar
# bert0364, mizrada 
for csv_file in data_list:
    df = pd.read_csv(csv_file, names=['From', 'To'])
    
    df['To'] = df['To'].apply(convert_string_to_list)
    df = df.explode('To')
    df = df.groupby(['From', 'To']).size().reset_index(name='weight')
    
    # Save grouped DataFrame to a new CSV file
    output_file = csv_file + '_grouped_data'
    df.to_csv(output_file, index=False) # create the new files
    
    os.remove(csv_file)


################################################################################################################
############################ For the 'user, topic_of_interest file: ########################################################
################################################################################################################

# read the csv data. This is for the csv type: user, topic_of_interest:
data_2009_07_01_topic_of_iterest = r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-01_USER-TOPIC_OF_INTEREST"
data_2009_07_02_topic_of_iterest = r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-02_USER-TOPIC_OF_INTEREST"
data_2009_07_03_topic_of_iterest = r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-03_USER-TOPIC_OF_INTEREST"
data_2009_07_04_topic_of_iterest = r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-04_USER-TOPIC_OF_INTEREST"
data_2009_07_05_topic_of_iterest = r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Social_Netwrork_Analysis\Project_2\data\output_data_2009-07-05_USER-TOPIC_OF_INTEREST"



# For the: From,To, Weight
data_list_topic_of_iterest = [data_2009_07_01_topic_of_iterest, data_2009_07_02_topic_of_iterest, \
                               data_2009_07_03_topic_of_iterest, data_2009_07_04_topic_of_iterest, \
                               data_2009_07_05_topic_of_iterest]




for csv_file in data_list_topic_of_iterest:
    df = pd.read_csv(csv_file)
    # we make the data granualar. Same thing that we did before.
    df['topic_of_interest'] = df['topic_of_interest'].str.strip('[]').str.split(', ')
    df = df.explode('topic_of_interest')
    # we remove '' from values of column
    df['topic_of_interest'] = df['topic_of_interest'].str.strip("'") 
    # we count how many times the topic of interest has be seen for each user:
    df = df.groupby(['user', 'topic_of_interest']).size().reset_index(name='occurrences')
    # we find the max occurances for each user:
    df = df.loc[df.groupby('user')['occurrences'].idxmax()]
    # we remove the column with the occurances:
    df.drop('occurrences', axis=1, inplace=True)
    # Save grouped DataFrame to a new CSV file
    output_file = csv_file + '_grouped_data'
    df.to_csv(output_file, index=False) # create the new files
    os.remove(csv_file)














