##################################################################################################################################################################
############################################### 2 Average degree over time #######################################################################################
##################################################################################################################################################################
library(igraph)
library(glue)
library(ggplot2)
library(ggrepel)
library(writexl)
library(dplyr)


# contains the vertices for each graph
vertices <- list()
# contains the edges for each graph
edges <- list()
# contains the diameters for each graph
diameter_list <- list()
# contains the average in degree for each graph
avg_in_degree_list <- list()
# contains the average out degree for each graph
avg_out_degree_list <- list()
# contains the average page ranks for each graph
avg_pagerank_list <- list()

# contains the top 10 nodes by in degree
top_10_in_list <- list()
# contains the top 10 nodes by out degree
top_10_out_list <- list()
# contains the top 10 nodes by page rank 
top_10_pagerank_list <- list()


for (i in 1:5) {
  output <- read.csv(glue("C:/Users/vlass/OneDrive/Υπολογιστής/Metaptyxiako/3rd_Trimester/Social_Netwrork_Analysis/Project_2/data/output_2009-07-0{i}"))
  output_user_topic_of_interest <- read.csv(glue("C:/Users/vlass/OneDrive/Υπολογιστής/Metaptyxiako/3rd_Trimester/Social_Netwrork_Analysis/Project_2/data/output_2009-07-0{i}_USER-TOPIC_OF_INTEREST"))
  
  
  # We remove this '\n' pattern from the tables. For some reason we got it from python.
  output$From <- gsub("\\n$", "", output$From)
  output$To <- gsub("\\n$", "", output$To)
  output_user_topic_of_interest$user<- gsub("\\n$", "", output_user_topic_of_interest$user)
  
  # we create the graph:
  graph <- graph_from_data_frame(output, directed=TRUE)
  
  
  # Lets add the topic of interest attribute
  ##############################################
  # we get the node names(user names)
  vertex_names <- V(graph)$name
  
  # we get the topic of interest from the data frame
  topic_of_interest_values <- output_user_topic_of_interest[vertex_names, "topic_of_interest"]
  
  # we add the the topic of interest to the nodes
  graph <- set_vertex_attr(graph, "topic_of_interest", value = topic_of_interest_values)
  ##############################################

#-----------------------------------------------------------------------------------#
  # we find the vertices:
  n_vertices <- vcount(graph)
  # append to the list that contains the vertices for each Graph
  vertices <- append(vertices, n_vertices)

#-----------------------------------------------------------------------------------#  
  # we find the number of edges:
  n_edges <- ecount(graph)
  # append to the list that contains the number of edges for each Graph
  edges <- append(edges, n_edges)

#-----------------------------------------------------------------------------------#  
  # we find the diameter of the graph:
  diameter <- diameter(graph)
  # append to the list that contains the diameters for each Graph
  diameter_list <- append(diameter_list, diameter)

#-----------------------------------------------------------------------------------#  
  # we calculate the IN degree for each vertex
  in_degrees <- degree(graph, mode = "in")
  # we find the average IN degree
  avg_in_degree <- round(mean(in_degrees), 5)
  # we append the avg in degree of each graph to the list with diameters
  avg_in_degree_list <- append(avg_in_degree_list, avg_in_degree)

#-----------------------------------------------------------------------------------#
  # we calculate the OUT degree for each vertex
  out_degrees <- degree(graph, mode = "out")
  # we find the average OUT degree
  avg_out_degree <- round(mean(out_degrees), 5)
  # we append the avg OUT degree of each graph to the lit with diameters:
  avg_out_degree_list <- append(avg_out_degree_list, avg_in_degree)

#-----------------------------------------------------------------------------------#
  # we calculate the pagerank for each vertex
  pagerank_result <- page_rank(graph, directed = TRUE)
  # we find the average OUT degree
  avg_out_pageRank <- round(mean(pagerank_result$vector), 7)
  # we append the avg OUT degree of each graph to the lit with diameters:
  avg_pagerank_list <- append(avg_pagerank_list, avg_out_pageRank)
  
  
  
  
  
  ##################################################################################################################################################################
  ################################################### 3 Important nodes #######################################################################################
  ##################################################################################################################################################################
  
#-----------------------------------------------------------------------------------#
  # We create a data frame with the node names and corresponding in degrees
  df_in <- data.frame(node = names(in_degrees), in_degree = in_degrees)
  
  # Sort by in-degree in decreasing order and select top 10
  top_10_in <- df_in[order(df_in$in_degree, decreasing = TRUE), ][1:10, ]
  
  # reset row names
  rownames(top_10_in) <- NULL
  
  # append the data frames to the list
  top_10_in_list <- append(top_10_in_list, list(top_10_in))
  
  
#-----------------------------------------------------------------------------------#
  # We create a data frame with the node names and corresponding out degrees
  df_out <- data.frame(node = names(out_degrees), out_degree = out_degrees)
  
  # Sort by out-degree in decreasing order and select top 10
  top_10_out <- df_out[order(df_out$out_degree, decreasing = TRUE), ][1:10, ]
  
  # reset row names
  rownames(top_10_out) <- NULL
  
  # append the data frames to the list
  top_10_out_list <- append(top_10_out_list, list(top_10_out))
  
  
#-----------------------------------------------------------------------------------#
  # We calculate the PageRank
  pr <- page_rank(graph, directed = TRUE)  
  
  # We create a data frame with node names and corresponding PageRank values
  df_pagerank <- data.frame(node = names(pr$vector), pagerank = pr$vector)
  
  # we sort by PageRank in decreasing order and select top 10
  top_10_pagerank <- df_pagerank[order(df_pagerank$pagerank, decreasing = TRUE), ][1:10, ]
  
  # reset row names
  rownames(top_10_pagerank) <- NULL
  
  # append the data frames to the list
  top_10_pagerank_list <- append(top_10_pagerank_list, list(top_10_pagerank))
  
}
# we delete some of the variables to have more space in memory:
remove(df_pagerank, df_out, df_in, pagerank_result, out_degrees, in_degrees, output, output_user_topic_of_interest)



##################################################################################################################################################################
################################################### 4 Communities #######################################################################################
##################################################################################################################################################################

# import data
df_1 <- read.csv(glue("C:/Users/vlass/OneDrive/Υπολογιστής/Metaptyxiako/3rd_Trimester/Social_Netwrork_Analysis/Project_2/data/output_2009-07-01"))
df_2 <- read.csv(glue("C:/Users/vlass/OneDrive/Υπολογιστής/Metaptyxiako/3rd_Trimester/Social_Netwrork_Analysis/Project_2/data/output_2009-07-02"))
df_3 <- read.csv(glue("C:/Users/vlass/OneDrive/Υπολογιστής/Metaptyxiako/3rd_Trimester/Social_Netwrork_Analysis/Project_2/data/output_2009-07-03"))
df_4 <- read.csv(glue("C:/Users/vlass/OneDrive/Υπολογιστής/Metaptyxiako/3rd_Trimester/Social_Netwrork_Analysis/Project_2/data/output_2009-07-04"))
df_5 <- read.csv(glue("C:/Users/vlass/OneDrive/Υπολογιστής/Metaptyxiako/3rd_Trimester/Social_Netwrork_Analysis/Project_2/data/output_2009-07-05"))

#------------ This part of the code is only used to find one user that appears in all of the dates that we have -----------------#
# keep only from the 'From' column
df_1 <- df_1[, 1, drop = FALSE]
df_2 <- df_2[, 1, drop = FALSE]
df_3 <- df_3[, 1, drop = FALSE]
df_4 <- df_4[, 1, drop = FALSE]
df_5 <- df_5[, 1, drop = FALSE]

# keep the unique users
df_1 <- unique(df_1)
df_2 <- unique(df_2)
df_3 <- unique(df_3)
df_4 <- unique(df_4)
df_5 <- unique(df_5)

# Merge the data frames
merged_df <- merge(df_1, df_2, by = "From", all = FALSE)
remove(df_1, df_2)
merged_df <- merge(merged_df, df_3, by = "From", all = FALSE)
remove(df_3)
merged_df <- merge(merged_df, df_4, by = "From", all = FALSE)
remove(df_4)
merged_df <- merge(merged_df, df_5, by = "From", all = FALSE)
remove(df_5)
remove(merged_df)
# Now then merged_df contains the users that appear in all 5 days of the week.
# we will take the user aaronkaiser to detect the evolution of the communities he is a part of.


#-------------------------------------------------------------------------------------------------------------#

#---------------- The following code tracks the user aaronkaiser ---------------------------------------------#
list_of_Graphs <- list()
list_of_Communities <- list()
for (i in 1:5){
  output <- read.csv(glue("C:/Users/vlass/OneDrive/Υπολογιστής/Metaptyxiako/3rd_Trimester/Social_Netwrork_Analysis/Project_2/data/output_2009-07-0{i}"))
  output_user_topic_of_interest <- read.csv(glue("C:/Users/vlass/OneDrive/Υπολογιστής/Metaptyxiako/3rd_Trimester/Social_Netwrork_Analysis/Project_2/data/output_2009-07-0{i}_USER-TOPIC_OF_INTEREST"))
  
  # We remove this '\n' pattern from the tables. For some reason we got it from python.
  output$From <- gsub("\\n$", "", output$From)
  output$To <- gsub("\\n$", "", output$To)
  output_user_topic_of_interest$user<- gsub("\\n$", "", output_user_topic_of_interest$user)
  
  # we create the graph:
  graph <- graph_from_data_frame(output, directed=TRUE)
  
  # Lets add the topic of interest attribute
 #--------------------------------------------------------------------#
  # we get the node names(user names)
  vertex_names <- V(graph)$name
  
  # we get the topic of interest from the data frame
  topic_of_interest_values <- output_user_topic_of_interest[vertex_names, "topic_of_interest"]
  
  # we add the the topic of interest to the nodes
  graph <- set_vertex_attr(graph, "topic_of_interest", value = topic_of_interest_values)
  #--------------------------------------------------------------------#
  
  # append graphs to the list
  list_of_Graphs[[i]] <- graph
  
  # make grapth undirected:
  graph <- as.undirected(graph)
  
  # we will use louvain community detection
  lv <- cluster_louvain(graph)
  
  # append the community detections to the list
  list_of_Communities[[i]] <- lv
}
remove(output, output_user_topic_of_interest)


# we find the vertex IDs for the user we want:
which(V(list_of_Graphs[[1]])$name == 'aaronkaiser') # ID = 3429
which(V(list_of_Graphs[[2]])$name == 'aaronkaiser') # ID = 2669
which(V(list_of_Graphs[[3]])$name == 'aaronkaiser') # ID = 1725
which(V(list_of_Graphs[[4]])$name == 'aaronkaiser') # ID = 1312
which(V(list_of_Graphs[[5]])$name == 'aaronkaiser') # ID = 1250

# We find the community IDs of this specific user
community1 <- membership(list_of_Communities[[1]])[3429]
community2 <- membership(list_of_Communities[[2]])[2669]
community3 <- membership(list_of_Communities[[3]])[1725]
community4 <- membership(list_of_Communities[[4]])[1312]
community5 <- membership(list_of_Communities[[5]])[1250]
#-------------------------------------------------------------------------------------------------------------#


#--------------------------- In this part we find simmilarities within the 5 communities -----------------------------------#

# lets get the community IDs that the user aaronkaiser appears for the 5 different graphs to be used in the for loop
IDs = list(34, 573, 20, 571, 83)

names_list = list()
topic_list = list()
average_weight_list = list()

for (i in 1:5){

  membershipS <- membership(list_of_Communities[[i]])
  
  # we take only the nodes that belong to community 34
  community_nodes <- which(membershipS == IDs[[i]])
  
  # we take part of the graph. We take the subgraph that has the community. 
  community_subgraph <- induced.subgraph(list_of_Graphs[[i]], community_nodes)
  
#---------------------------------------------------------------------#  
  # Lets get all the attributes for the nodes in communities 
  # we get the names:
  names <- V(community_subgraph)$name
  
  # we append the names to the list:
  names_list[[length(names_list) + 1]] <- names
#---------------------------------------------------------------------# 
  
  # we get the topics of interest:
  topics <- V(community_subgraph)$topic_of_interest 
  
  # we create a data frame that contains the topic of interst and the frequency for each topic.
  topics <- table(topics)
  
  # we sort
  topics <- topics[order(-topics)]
  # append data frame to list:
  topic_list[[i]] <- topics
  
#---------------------------------------------------------------------#   
  
  # we get the weights:
  weights <- E(community_subgraph)$weight
  # we get the average weight of the community
  average_weight <- mean(weights)
  # we append to a list
  average_weight_list[[i]] <- average_weight
#---------------------------------------------------------------------#  
}

#--------------------------------- lets plot the Graphs -----------------------------------------#


# Because the Graphs are too large to be ploted we will take part of them





# we create groups
V(list_of_Graphs[[1]])$color <- factor(membership(list_of_Communities[[1]]))

# we take the sizes of the communities
community_size1 <- sizes(list_of_Communities[[1]])

# we remove very big and small communities
filtered_community1 <- community_size1 > 50 & community_size1 < 100

# we take the communities that we want to plot
mid_community1 <- unlist(list_of_Communities[[1]][filtered_community1])

# we create the subgraphs
g1_subgraph <- induced.subgraph(list_of_Graphs[[1]], mid_community1)


# We plot 
plot(g1_subgraph, vertex.label = NA, edge.arrow.width = 0.8, edge.arrow.size = 0.2,
     layout = layout_with_fr(g1_subgraph), margin = 0, vertex.size = 3,
     vertex.color = V(g1_subgraph)$color, main = "Communities For July 1st")



subgraph_list <- list()

for (i in 1:5){
  
  # we create groups
  V(list_of_Graphs[[i]])$color <- factor(membership(list_of_Communities[[i]]))
  
  # we take the sizes of the communities
  community_size <- sizes(list_of_Communities[[i]])
  
  # we remove very big and small communities
  sub_community <- community_size > 50 & community_size < 100
  
  # we take the communities that we want to plot
  comm_to_be_plotted <- unlist(list_of_Communities[[i]][sub_community])
  
  # we create the subgraphs
  subgraphh <- induced.subgraph(list_of_Graphs[[i]], comm_to_be_plotted)
  
  # we append to the list
  subgraph_list[[i]] <- subgraphh
  
  
}
# we plot:
days <- c("Wednesday", "Thursday", "Friday", "Saturday", "Sunday")

for (i in 1:5){
  # We plot 
  plot(subgraph_list[[i]], vertex.label = NA, edge.arrow.width = 0.8, edge.arrow.size = 0.2,
       layout = layout_with_fr(subgraph_list[[i]]), margin = 0, vertex.size = 3,
       vertex.color = V(subgraph_list[[i]])$color, main = paste("Communities For", days[i]))
}







#---------------------------- In this part we plot the information to use it in the report --------------------------------------#


#-----------------------------------------------------------------------------------#
#### We want to create one plot for each of the 3 metrics.
# The following preperation is made:

# we define the days
days <- c("Wednesday", "Thursday", "Friday", "Saturday", "Sunday")

# We add the days to each of the dataframes contained in the lists.
for(i in seq_along(top_10_in_list)) {
  # Add a new column to each data frame
  top_10_in_list[[i]]$day <- days[i]
  top_10_out_list[[i]]$day <- days[i]
  top_10_pagerank_list[[i]]$day <- days[i]
}

# we combine the dataframes to one big dataframe
df_combined_in_degree_top_10 <- bind_rows(top_10_in_list)
df_combined_out_degree_top_10 <- bind_rows(top_10_out_list)
df_combined_PageRank_top_10 <- bind_rows(top_10_pagerank_list)
#-----------------------------------------------------------------------------------#





#-------------------------------------------- Now we start plotting: ----------------------------------------------------------------#
# We order the days: 
df_combined_in_degree_top_10$day <- factor(df_combined_in_degree_top_10$day, 
                                           levels = c("Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

#-----------------------------------------------------------------------------------------------------------------#


# Ploting top 10 for each day based on in-degree
plot_in <- ggplot(df_combined_in_degree_top_10, aes(x = day, y = in_degree, group = node, color = node)) +
  geom_line(size = 1, alpha = 0.3) +
  geom_point(size = 3) +
  geom_text_repel(aes(label = node), face = "bold", size = 6) +
  labs(x = "Day", y = "In-degree") +
  guides(color = FALSE) +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 14))  

print(plot_in)
#-----------------------------------------------------------------------------------------------------------------#


#-----------------------------------------------------------------------------------------------------------------#
# Ploting top 10 for each day based on out-degree
plot_out <- ggplot(df_combined_out_degree_top_10, aes(x = day, y = out_degree, group = node, color = node)) +
  geom_line(size = 1, alpha = 0.3) +
  geom_point(size = 3) +
  geom_text_repel(aes(label = node), face = "bold", size = 6) +
  labs(x = "Day", y = "Out-degree") +
  guides(color = FALSE) +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 14))  

print(plot_out)
#-----------------------------------------------------------------------------------------------------------------#


#-----------------------------------------------------------------------------------------------------------------#
# Ploting top 10 for each day based on PageRank
plot_pagerank <- ggplot(df_combined_PageRank_top_10, aes(x = day, y = pagerank, group = node, color = node)) +
  geom_line(size = 1, alpha = 0.3) +
  geom_point(size = 3) +
  geom_text_repel(aes(label = node), face = "bold", size = 6) +
  labs(x = "Day", y = "pagerank") +
  guides(color = FALSE) +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 14))  

print(plot_pagerank)
#-----------------------------------------------------------------------------------------------------------------#


























