import re
import os

# Initialize variables
capture_lines_1 = False
capture_lines_2 = False
capture_lines_3 = False
# to keep our values
captured_lines_Task_1 = []
captured_lines_Task_2 = []
captured_lines_Task_3 = []
# counter to stop after pattern is met 
counter_1 = 0
counter_2 = 0


# Go from answers(where the script is) to the location of the text file (one step up)
rel_path = os.path.join("..", "beeline_consent_query_stderr.txt")

with open(rel_path) as file:
    for line in file:
        line = line.strip() # remove leading/trailing white spaces
#--------------------------------- Searching Pattern for Task 1 --------------------------------#
        if line.startswith('INFO  : Query Execution Summary'):
            capture_lines_1 = True
            captured_lines_Task_1.append(line)
        if capture_lines_1:
            if line.startswith('INFO  : -----------------'):
                counter_1 += 1
            if counter_1 == 3:
                capture_lines_1 = False
            else:
                captured_lines_Task_1.append(line)
        
#--------------------------------- Searching Pattern for Task 2 --------------------------------#        
        if line.startswith('INFO  : Task Execution Summary'):
            capture_lines_2 = True
        if capture_lines_2:
            if line.startswith('INFO  : -----------------------------------'):
                counter_2 += 1
            if counter_2 == 3:
                capture_lines_2 = False
            else:
                captured_lines_Task_2.append(line)
                
#--------------------------------- Searching Pattern for Task 3 --------------------------------#              
        if line.startswith('INFO  : org.apache.tez.common.counters.DAGCounter:'):
            capture_lines_3 = True
        if capture_lines_3:
            if line.startswith('INFO  : Completed executing command(queryId=hive_20200'):
                break
            else:
                captured_lines_Task_3.append(line)
                
        
#-----------------------------------------------------------------------------------------#
################################### TASK 1 ################################################
#-----------------------------------------------------------------------------------------#
        
# keep the phrases that we need 
phrases = ["Compile Query", "Prepare Plan", "Get Query Coordinator (AM)", "Submit Plan", "Start DAG", "Run DAG"]
results = []
for line in captured_lines_Task_1:
    for phrase in phrases:
        if phrase in line:
            parts = line.split(":")
            # remove leading/trailing white spaces 
            value = parts[-1].strip()
            results.append(value)

# Create the dictionary 
informations = {}
for info in results:
    key, value = info.rsplit(maxsplit=1)  # split it the last value
    informations[key] = value

print(informations)


#-----------------------------------------------------------------------------------------#
################################### TASK 2 ################################################
#-----------------------------------------------------------------------------------------#

# remove info
captured_lines_Task_2 = [item.replace("INFO  :", "").strip() for item in captured_lines_Task_2]

vertex = captured_lines_Task_2[2] # these are the keys for the inside dictionary 
vertex = vertex.replace('VERTICES', '')
vertex = vertex.split() # split and make it to list 

# we keep the rest of the values map 1, map 3 and their values 
lines_list = list()
for i in range(4,8):
    lines = captured_lines_Task_2[i]
    lines_list.append(lines)

dictionary = {}
for i in range(len(lines_list)):
    split_line = re.split(r'\s{2,}', lines_list[i]) # split the list
    Maps = split_line[0] # take the keys of the dictionary (map 1, map 3 etc)
    
 
    small_dictionary = {}
    for j in range(len(split_line)):
        values = split_line[j]
        vertex[j-1]
        
        
        small_dictionary[vertex[j-1]] = values # add key and value to the small dictionary
        
    dictionary[Maps] = small_dictionary # add small dictionary to the large one
        
    

#-----------------------------------------------------------------------------------------#
################################### TASK 3 ################################################
#-----------------------------------------------------------------------------------------#

# remove info
captured_lines_Task_3 = [item.replace("INFO", "").strip() for item in captured_lines_Task_3]
# remove the first : that we find
captured_lines_Task_3 = [item.replace(':', '', 1) for item in captured_lines_Task_3]


big_dictionary = {}
for lines in captured_lines_Task_3:
    num_spaces = len(lines) - len(lines.lstrip()) # count begging white spaces 
    
    if num_spaces <= 1: # this means it is a big dictionary 
        my_word = lines # keep the word 
        small_dictionary = {} # create the nested dictionary
    
    if num_spaces > 1: # this means it is a sub dictionary 
        small_dictionary[lines.split(':')[-2].lstrip()] = lines.split(':')[-1].lstrip() # add to sub dictionary and remove leading white spaces
        
    big_dictionary[my_word] = small_dictionary 
        
        
# delete unecesary variables: 
del capture_lines_1, capture_lines_2, capture_lines_3, captured_lines_Task_1, captured_lines_Task_2,\
    captured_lines_Task_3, counter_1, counter_2, file, i, info, j, key, line, lines, lines_list,\
    Maps, my_word, num_spaces, parts, phrase, phrases, results, small_dictionary, split_line, \
    value, values, vertex 


   
    
import pprint
# we use this only for better visualization in the output
# Using pprint to pretty-print dictionaries
pprint.pprint(informations)
pprint.pprint(dictionary)
pprint.pprint(big_dictionary)


import json
# Convert the Python dictionary object into JSON
json_data_Task_1 = json.dumps(informations, indent=1)
json_data_Task_2 = json.dumps(dictionary, indent=1)
json_data_Task_3 = json.dumps(big_dictionary, indent=1)



# Define the directory where you want to create the new folder
directory = os.getcwd()  # this gets the current working directory

# Create a new directory path
new_dir_path = os.path.join(directory, 'Data_output')

# Create a new directory
os.makedirs(new_dir_path, exist_ok=True)

# Now write files into this new directory
with open(os.path.join(new_dir_path, "Task_1.json"), "w") as file:
    file.write(json_data_Task_1)

# Similarly for other files
with open(os.path.join(new_dir_path, "Task_2.json"), "w") as file:
    file.write(json_data_Task_2)

with open(os.path.join(new_dir_path, "Task_3.json"), "w") as file:
    file.write(json_data_Task_3)






