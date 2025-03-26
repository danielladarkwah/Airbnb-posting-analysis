#installing and loading the mongolite library to download the Airbnb data
#install.packages("mongolite") #need to run this line of code only once and then you can comment out
library(mongolite)
library(jsonlite)

# This is the connection_string. You can get the exact url from your MongoDB cluster screen
#replace the <<user>> with your Mongo user name and <<password>> with the mongo password
#lastly, replace the <<server_name>> with your MongoDB server name
connection_string <- 'mongodb+srv://ddarkwah:vpiEU4wGUw2GvvwL@cluster0.kjydska.mongodb.net/'
airbnb_collection <- mongo(collection="listingsAndReviews", db="sample_airbnb", url=connection_string)


#Here's how you can download all the Airbnb data from Mongo
## keep in mind that this is huge and you need a ton of RAM memory

airbnb_all <- airbnb_collection$find()

#######################################################
#if you know or want to learn MQL (MongoQueryLanguage), that is a JSON syntax, feel free to use the following:::
######################################################
#1 subsetting your data based on a condition:
mydf <- airbnb_collection$find('{"bedrooms":2, "price":{"$gt":50}}')

#2 writing an analytical query on the data::
mydf_analytical <- airbnb_collection$aggregate('[{"$group":{"_id":"$room_type", "avg_price": {"$avg":"price"}}}]')

#install.packages("textcat")


#Load libraries
library(readr)
library(tm)
library(dplyr)
library(textcat)
library(tidytext)
library(tidyr)
library(ggplot2)
library(stringr)


##############################################
###########Load dataset###################
##############################################
airbnb_data <- read_csv("airbnb_data.csv")
View(airbnb_data)

# View a summary of the dataset
summary(airbnb_data)


##############################################
###########Text Preprocessing###################
##############################################
# Use the 'textcat' package to detect language
# Detect languages
languages <- textcat(airbnb_data$description)

# Filter only English descriptions
airbnb_data_english <- airbnb_data[languages == "english", ]

# Optionally, check how many entries are in English
cat("Number of descriptions in English:", nrow(airbnb_data_english), "\n")

#Number of descriptions in English: 4347 hence can be used for analysis


# Create a corpus from the 'description' column
corpus <- VCorpus(VectorSource(airbnb_data_english$description))

# Define the text cleaning process
clean_corpus <- tm_map(corpus, content_transformer(tolower)) # Convert text to lowercase
clean_corpus <- tm_map(clean_corpus, removePunctuation) # Remove punctuation
clean_corpus <- tm_map(clean_corpus, removeNumbers) # Remove numbers
clean_corpus <- tm_map(clean_corpus, removeWords, stopwords("english")) # Remove English stop words

# Optionally convert back to a data frame and update the original dataset
airbnb_data_english$description_clean <- sapply(clean_corpus, as.character)

# View a snippet of the cleaned descriptions
head(airbnb_data_english$description_clean)

##############################################
###########Tokenization###################
##############################################

# Tokenizing the cleaned descriptions into individual words
tokenized_descriptions <- airbnb_data_english %>%
  unnest_tokens(word, description_clean)
print(tokenized_descriptions)


##############################################
############Bigrams###########################
##############################################
#checking the structure in order to use description_clean for bigrams
# Check the structure of airbnb_data_english
str(airbnb_data_english)

# Converting description_clean to character if not already
airbnb_data_english$description_clean <- as.character(airbnb_data_english$description_clean)

# Creating bigrams from the cleaned descriptions
bigrams <- airbnb_data_english %>%
  unnest_tokens(bigram, description_clean, token = "ngrams", n = 2)

# Separating the bigrams for easier analysis
bigrams_separated <- bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

# Filter out any remaining stop words in bigrams, if necessary
data("stop_words")
bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word, !word2 %in% stop_words$word)

# Counting the frequency of bigrams
bigram_counts <- bigrams_filtered %>%
  count(word1, word2, sort = TRUE)
print(bigram_counts)

# Load ggplot2 for visualization
library(ggplot2)

# Visualizing the most common bigrams

# Decide on how many top bigrams to display for a clear visualization
top_n <- 20  # for example, the top 20 bigrams

# Create a subset of the top N bigrams
top_bigram_counts <- head(bigram_counts, top_n)



# Visualize the top N bigrams for clarity
bigram_plot <- ggplot(top_bigram_counts, aes(x = reorder(paste(word1, word2), n), y = n)) +
  geom_col(fill = "dodgerblue") +
  labs(title = paste("Top", top_n, "Most Common Bigrams in Airbnb Descriptions"), x = NULL, y = "Frequency") +
  coord_flip() +  # Flipping coordinates for better readability
  theme_minimal()
print(bigram_plot)

bigram_plot <- bigram_plot +
  theme(axis.text.y = element_text(size = 8),
        axis.text.x = element_text(size = 8, angle = 45, hjust = 1),
        plot.title = element_text(size = 12, face = "bold"),
        plot.margin = margin(5, 5, 5, 5))

#Bigram common words(CSV for network visualisation)
write.csv(bigram_counts, "bigram_counts.csv", row.names = FALSE)

########################################################
##########################Trigrams######################
########################################################

# Remove URLs and NA entries before creating trigrams
airbnb_data_english <- airbnb_data_english %>%
  mutate(description_clean = stringr::str_replace_all(description_clean, "https?\\S+\\s?", "")) %>%
  filter(description_clean != "NA" & description_clean != "")

# Ensure that the text is still in the correct format (character)
airbnb_data_english$description_clean <- as.character(airbnb_data_english$description_clean)


# Create trigrams from the cleaned descriptions
trigrams <- airbnb_data_english %>%
  unnest_tokens(trigram, description_clean, token = "ngrams", n = 3)

# Separate the trigrams for easier analysis
trigrams_separated <- trigrams %>%
  separate(trigram, c("word1", "word2", "word3"), sep = " ", extra = "drop")

# Filter out stop words and non-alphabetic sequences (if present)
data("stop_words")
trigrams_filtered <- trigrams_separated %>%
  filter(!word1 %in% stop_words$word & !word2 %in% stop_words$word & !word3 %in% stop_words$word) %>%
  filter(str_detect(word1, "^[a-z]+$") & str_detect(word2, "^[a-z]+$") & str_detect(word3, "^[a-z]+$"))

# Count and sort the trigrams
trigram_counts <- trigrams_filtered %>%
  count(word1, word2, word3, sort = TRUE)

# Display the top trigrams
head(trigram_counts)


# Visualize the most common trigrams, taking just the top for clarity
top_n <- 20  # Choose top N for display
top_trigram_counts <- head(trigram_counts, top_n)

ggplot(top_trigram_counts, aes(x = reorder(paste(word1, word2, word3), n), y = n)) +
  geom_col(fill = "dodgerblue") +
  labs(title = "Top Trigrams in Airbnb Descriptions", x = NULL, y = "Frequency") +
  coord_flip() +  # Flipping coordinates for better readability
  theme_minimal()

##########################################################
#############################Sentiment####################
##########################################################
# Load AFINN lexicon
afinn <- get_sentiments("afinn")

# Load Bing lexicon
bing <- get_sentiments("bing")

# Load NRC lexicon
nrc <- get_sentiments("nrc")

# Combine all three lexicons into one data frame
sentiments <- bind_rows(
  mutate(afinn, lexicon = "afinn"),
  mutate(bing, lexicon = "bing"),
  mutate(nrc, lexicon = "nrc")
)

# Check the unique sentiments available (from the bing and nrc lexicons)
unique(sentiments$sentiment)

# Check the lexicon sources (should show "afinn", "bing", "nrc")
unique(sentiments$lexicon)

# View a summary of sentiment values (primarily from the AFINN lexicon)
summary(sentiments$value)

# Take a look at one lexicon at a time
bing_sentiment <- filter(sentiments, lexicon == "bing")
nrc_sentiment <- filter(sentiments, lexicon == "nrc")
afinn_sentiment <- filter(sentiments, lexicon == "afinn")

# Viewing unique sentiments within the NRC lexicon
unique(nrc_sentiment$sentiment)


# Assuming tokenized_descriptions is the dataframe with tokenized words from the Airbnb descriptions
# Inner join with each sentiment lexicon
bing_scores <- tokenized_descriptions %>%
  inner_join(bing, by = "word")

afinn_scores <- tokenized_descriptions %>%
  inner_join(afinn, by = "word")

nrc_scores <- tokenized_descriptions %>%
  inner_join(nrc, by = "word", relationship = "many-to-many")


# Calculate sentiment for each lexicon
# For Bing and NRC, we can simply count the number of positive and negative words
bing_sentiment <- bing_scores %>%
  count(sentiment) %>%
  spread(key = sentiment, value = n, fill = 0) %>%
  mutate(sentiment_bing = positive - negative)

# For AFINN, we sum up the sentiment values
afinn_sentiment <- afinn_scores %>%
  summarise(sentiment_afinn = sum(value))

# For NRC, we focus only on positive and negative sentiments
nrc_sentiment <- nrc_scores %>%
  filter(sentiment %in% c("positive", "negative")) %>%
  count(sentiment) %>%
  spread(key = sentiment, value = n, fill = 0) %>%
  mutate(sentiment_nrc = positive - negative)

# Bind rows to compare
sentiment_comparison <- bind_rows(
  bing_sentiment %>% mutate(lexicon = "Bing"),
  afinn_sentiment %>% mutate(lexicon = "AFINN"),
  nrc_sentiment %>% mutate(lexicon = "NRC")
)


# Visualize the comparison
ggplot(sentiment_comparison, aes(x = lexicon, y = sentiment_bing, fill = lexicon)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Sentiment Score Comparison Across Lexicons",
       x = "Lexicon",
       y = "Sentiment Score")

sentiment_comparison_long <- sentiment_comparison %>%
  pivot_longer(
    cols = c(sentiment_afinn, sentiment_bing, sentiment_nrc), 
    names_to = "lexicons", 
    values_to = "sentiment_scores",
    names_prefix = "sentimentss_"
  ) %>%
  # Since `pivot_longer` uses the column names as values, we need to clean them up
  mutate(lexicons = str_replace(lexicon, "_", "")) %>%
  # Remove rows with NA sentiment scores
  drop_na()


# Plot the sentiment scores for each lexicon
ggplot(sentiment_comparison_long, aes(x = lexicons, y = sentiment_scores, fill = lexicons)) +
  geom_col(show.legend = FALSE) +
  theme_minimal() +
  labs(title = "Sentiment Score Comparison Across Lexicons",
       x = "Lexicon",
       y = "Sentiment Scores")


##########################################
######################LDA#################
##########################################
tokenized_descriptions <- airbnb_data_english %>%
  unnest_tokens(word, description)

# Remove stop words from the tokenized descriptions
tokenized_descriptions <- tokenized_descriptions %>%
  anti_join(stop_words)

# Create a document-term matrix
dtm <- tokenized_descriptions %>%
  count(description_clean, word) %>%
  cast_dtm(description_clean, word, n)


library(topicmodels)
library(wordcloud)

# Fit the LDA model on the DTM
lda_model <- LDA(dtm, k = 5, control = list(seed = 1234))  # You can choose a different number of topics (k)

# Get the terms from the LDA model and inspect the highest probability words per topic
topics <- tidy(lda_model) %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

# Add the most likely topic to each description
doc_topics <- augment(lda_model, data = dtm)

# View the topics associated with the original data
airbnb_data <- airbnb_data %>%
  mutate(topic = doc_topics$.topic[match(description, doc_topics$document)])

# Filter for the top terms in each topic for visualization
topics <- topics %>%
  mutate(scaled_beta = beta * 1000)  # Scaling up the beta values for better visualization

top_terms <- topics %>%
  arrange(topic, desc(scaled_beta)) %>%
  group_by(topic) %>%
  top_n(10, scaled_beta) %>%
  ungroup() 

write.csv(top_terms, "top_terms_per_topic.csv", row.names = FALSE)

#####LDA-Top terms Visualization using Word Cloud)###############
top_terms$scaled_beta <- sqrt(top_terms$scaled_beta)

# Now generate the word cloud
wordcloud(words = top_terms$term, freq = top_terms$scaled_beta, min.freq = 1,
          max.words = 200, random.order = FALSE, rot.per = 0.35,
          scale = c(2, 0.5),  # Adjust scale if necessary
          colors = brewer.pal(8, "Dark2"))


########################################################
####Numerical Analysis Visualization####################
########################################################
#Average sentiments and ratings per property type
library(dplyr)
library(syuzhet)

# Calculate the average sentiment for each property type
# Make sure to replace 'description' with the actual column name from your 'airbnb_all' dataframe
average_sentiment <- airbnb_data %>%
  group_by(property_type) %>%
  summarise(average_sentiment = mean(sapply(description, function(desc) {
    sentiment <- tryCatch({
      get_sentiment(desc)
    }, error = function(e) NA)
    if (is.numeric(sentiment)) sentiment else NA
  }), na.rm = TRUE)) %>%
  ungroup()  # Ensure that the data is ungrouped after summarising

# View the average sentiment data frame
print(average_sentiment)

# Write the average sentiment data frame to a CSV file
write.csv(average_sentiment, "average_sentiment_per_property_type.csv", row.names = FALSE)



## Average sentiment scores per address.country
# Calculate the sentiment score for each description
airbnb_data <- airbnb_data %>%
  mutate(sentiment_score = sapply(description, function(desc) {
    sentiment <- tryCatch({
      get_sentiment(desc)
    }, error = function(e) NA)
    if (is.numeric(sentiment)) sentiment else NA
  }))

# Find the average sentiment score per country
average_sentiment_country <- airbnb_data %>%
  group_by(address.country) %>%
  summarise(average_sentiment = mean(sentiment_score, na.rm = TRUE)) %>%
  ungroup() # To remove the grouping

# Check the output
print(average_sentiment_country)

# Write to CSV 
write.csv(average_sentiment_country, "average_sentiment_per_country.csv", row.names = FALSE)


##Average review score Per property type
# Calculate the average review score for each property type
review_scores_by_property <- airbnb_data %>%
  group_by(property_type) %>%
  summarise(average_review_score = mean(`review_scores.review_scores_rating`, na.rm = TRUE)) %>%
  ungroup()

# Write the average review scores by property type to a CSV file
write.csv(review_scores_by_property, "review_scores_by_property.csv", row.names = FALSE)



library(dplyr)


# Calculate the correlation matrix for selected numerical variables including review scores
correlation_matrix <- airbnb_data %>%
  select(`review_scores.review_scores_rating`, price, number_of_reviews, bedrooms, bathrooms) %>% # Replace with actual numeric columns
  cor(use = "complete.obs") # This will only consider complete cases, excluding NA values

# View the correlation matrix
print(correlation_matrix)

# Write the correlation matrix to a CSV file
write.csv(correlation_matrix, "correlation_matrix.csv", row.names = TRUE)