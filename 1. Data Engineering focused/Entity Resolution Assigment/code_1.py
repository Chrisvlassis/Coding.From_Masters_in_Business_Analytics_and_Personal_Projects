import pandas as pd

data = pd.read_csv(r"C:\Users\vlass\OneDrive\Υπολογιστής\Metaptyxiako\3rd_Trimester\Advanced Data Engineering\Entity Resolution Assigment\ER-Data.csv", delimiter=';')

#----------------------------------- Task A ---------------------------------------------#
# make values to lower case:
data['authors'] = data['authors'].str.lower()
data['venue'] = data['venue'].str.lower()
data['title'] = data['title'].str.lower()



    


# lets put in a set the unique values:
unique_values = set()

for column in data:
    if column != 'id':
        unique_values.update(data[column].dropna().unique())



# now we create all the posible combinations: such as 'New' 'York'. 
# For each element in the original set
new_set = list()

for element in unique_values:
    # Check if the element is a string before attempting to split
    if isinstance(element, str):
        # Split the element by spaces
        split_element = element.split(' ')
        # Add each split part to the new set
        for part in split_element:
            new_set.append(part)

del unique_values


from collections import Counter

# Count the occurrences of each element in the list
counter = Counter(new_set)

# Select only the elements that occur more than once
more_than_once_keys = [item for item, count in counter.items() if count > 1]

del counter,  new_set


blocks = {}
# take the number of rows
num_rows = data.shape[0]
# take the number of columns
num_column = data.shape[1]
# loop throught the data frame:
for rows in range(0,num_rows):
    for columns in range(0,num_column):
        # we begin the scan:
        if columns != 0: # we do not want to scan the IDs
            value = data.iloc[rows, columns]
            if pd.notna(value):  # check that the value is not NaN
                sentence = str(value)
                for word in more_than_once_keys:
                    # check the split values
                    if word in sentence.split(): # check if word is found in the value 
                        # Check if the word is already a key in the dictionary
                        if word in blocks:
                            # If the key exists, append to the list of values
                            blocks[word].append(data.iloc[rows, 0])
                        else:
                            # If the key doesn't exist, create a new list with the value
                            blocks[word] = [data.iloc[rows, 0]]                                          

# remove duplicate values in each block. No reason, it is wrong,  to keep 2 times the same ID in each block
for key in blocks:
    blocks[key] = list(set(blocks[key]))

# remove any blocks that contain one row, since we want at least two entities in each block.
blocks = {key: value for key, value in blocks.items() if len(value) > 1}


del more_than_once_keys


# Printing the rows that contained in each block
for key, values in blocks.items():
    for ids in values:
        selected_authors = data.loc[data['id'] == ids, 'authors'].values[0]
        selected_venue = data.loc[data['id'] == ids, 'venue'].values[0]
        selected_years = data.loc[data['id'] == ids, 'year'].values[0]
        selected_title = data.loc[data['id'] == ids, 'title'].values[0]
        print(f'{key} -> '
              f'"authors": {selected_authors}, '
              f'"venue": {selected_venue}, '
              f'"year": {selected_years}, '
              f'"title": {selected_title},')
        

# take the keys of the dictionary:
keys_list = list(blocks.keys())
# use this function with a blocking key to get all the rows for this specific blocking key.
def search_in_blocks():
    while True:
        user_input = input("Please enter blocking key: ")
        if user_input in keys_list:
            blocking_key = user_input
            for value in blocks[blocking_key]:
                selected_authors = data.loc[data['id'] == value, 'authors'].values[0]
                selected_venue = data.loc[data['id'] == value, 'venue'].values[0]
                selected_years = data.loc[data['id'] == value, 'year'].values[0]
                selected_title = data.loc[data['id'] == value, 'title'].values[0]
                print(f'{blocking_key} -> '
                      f'"authors": {selected_authors}, '
                      f'"venue": {selected_venue}, '
                      f'"year": {selected_years}, '
                      f'"title": {selected_title},')
            break  # The 'break' statement ends the loop once the condition is met.
        else:
            print("The value is not in the list. Please try again.")

# call function
search_in_blocks()
        
        
        
        

#----------------------------------- Task B ---------------------------------------------#
total_comparisons = 0

for key, values in blocks.items():
    comparisons_for_each_block = len(values)*(len(values)-1)//2
    total_comparisons += comparisons_for_each_block
print("Total comparisons:", total_comparisons)

#----------------------------------- Task C ---------------------------------------------#
import itertools

# Create a new dictionary with the first 100 key-value pairs of the original dictionary
sample_dict = dict(itertools.islice(blocks.items(), 10))


# for each of the lists i store all the possible 2 combination sets of values
from itertools import combinations

# Create a new dictionary to hold the sets
my_dict = {}

for key, values in sample_dict.items():
    # Create all 2-combinations of the values
    comb = combinations(values, 2)
    # Convert each combination to a set and store it in a list
    my_dict[key] = [set(c) for c in comb]


from collections import Counter
from itertools import chain

# Convert lists of sets to lists of frozensets
frozensets_dict = {k: [frozenset(s) for s in v] for k, v in my_dict.items()}

# Flatten the list of frozensets
flat_list = list(chain(*frozensets_dict.values()))

# Count the occurrences of each frozenset
counter = Counter(flat_list)

# Find and create dictionary of common sets (as frozensets) and their counts
common_sets = {s: count for s, count in counter.items() if count > 1}

print(common_sets)






#------------------------------------ Create the Graph --------------------------------------#
import networkx as nx
import matplotlib.pyplot as plt

# initialize a graph
G = nx.Graph()

# add edges to the graph
for s, weight in common_sets.items():
    # Unpack the set to individual elements
    node1, node2 = s
    # Add an edge between the nodes with the count as the weight
    G.add_edge(node1, node2, weight=weight)

# Prune edges with weight < 2
edges_to_remove = [(node1, node2) for node1, node2, weight in G.edges(data='weight') if weight < 2]
for edge in edges_to_remove:
    G.remove_edge(*edge)
    
    
# find the number of comparison for the sample before any prunning
total_comparisons = 0

for key, values in sample_dict.items():
    comparisons_for_each_block = len(values)*(len(values)-1)//2
    total_comparisons += comparisons_for_each_block
print("Total comparisons before making any Graph and Pruning:", total_comparisons)


# Count edges after pruning
print("Number of edges after pruning: ", G.number_of_edges())


# Create a list to store the sets of connected nodes
connected_nodes = []

# Iterate through the edges and add sets to the list
for edge in G.edges():
    connected_nodes.append(set(edge))

#----------------------------------- Task D ---------------------------------------------#

# we create a simple function that takes as inputs the IDs of 2 rows 
def jaccard_similarity(id_1, id_2):
    title_1 = data.loc[data['id'] == id_1, 'title'].values[0]
    title_2 = data.loc[data['id'] == id_2, 'title'].values[0]
    set1 = set(title_1.split())
    set2 = set(title_2.split())
    intersection = set1.intersection(set2)
    union = set1.union(set2)
    
    
    return len(intersection) / len(union)

# call the function 
jaccard_similarity(1,5)



























