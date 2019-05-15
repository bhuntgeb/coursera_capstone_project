# Loading libraries for NLP and Data.Table
library(quanteda)
library(data.table)

# create the file connection
blogs_con <- file("D:/Coursera/Course/C10_Capstone/Project/Data/Coursera-SwiftKey/final/en_US/en_US.blogs.txt", "r") 
news_con <- file("D:/Coursera/Course/C10_Capstone/Project/Data/Coursera-SwiftKey/final/en_US/en_US.news.txt", "r") 
twitter_con <- file("D:/Coursera/Course/C10_Capstone/Project/Data/Coursera-SwiftKey/final/en_US/en_US.twitter.txt", "r") 

# read in the lines of each document 
blogs_lines<-readLines(blogs_con, encoding = "UTF-8")
news_lines<-readLines(news_con, encoding = "UTF-8")
twitter_lines<-readLines(twitter_con, encoding = "UTF-8")

# close the file connection
close(blogs_con)
close(news_con)
close(twitter_con)

# devide in trainig- and test- dataset
# setting seed for reproducable a trainingset
set.seed(12344)

# create a random binomial vector to select the lines for the training dataset
sample_blogs<-rbinom(n=length(blogs_lines), size= 1, prob=0.7)
sample_news<-rbinom(n=length(news_lines), size= 1, prob=0.7)
sample_twitter<-rbinom(n=length(twitter_lines), size= 1, prob=0.7)

# iterate over each line and select training and test lines
blogs_training=c()
blogs_testing=c()
for (i in c(1:length(blogs_lines))){
        if(sample_blogs[i]==1)
        { blogs_training[length(blogs_training)+1]<-blogs_lines[i] }
        else
        {blogs_testing[length(blogs_testing)+1]<-blogs_lines[i]}
}

# iterate over each line and select training and test lines
news_training=c()
news_testing=c()
for (i in c(1:length(news_lines))){
        if(sample_news[i]==1)
        { news_training[length(news_training)+1]<-news_lines[i] }
        else
        {news_testing[length(news_testing)+1]<-news_lines[i]}
}

# iterate over each line and select training and test lines
twitter_training=c()
twitter_testing=c()
for (i in c(1:length(twitter_lines))){
        if(sample_twitter[i]==1)
        { twitter_training[length(twitter_training)+1]<-twitter_lines[i] }
        else
        {twitter_testing[length(twitter_testing)+1]<-twitter_lines[i]}
}

# create a document out of the readed lines for each dataset 
blogs_training_text<-paste(blogs_training, collapse = " ")
news_training_text<-paste(news_training, collapse = " ")
twitter_training_text<-paste(twitter_training, collapse = " ")

# create one corpus out of all documents
all_corpus<-corpus(c(blogs_training_text, news_training_text, twitter_training_text ))


# create the unigrams by tokenizating the corpus by word
all_unigrams<-tokens(all_corpus, what = "word", 
                     remove_numbers = TRUE, remove_punct = TRUE,
                     remove_symbols = TRUE, remove_separators = TRUE, remove_hyphens = TRUE)
all_unigrams_dfm<-dfm(all_unigrams)
all_unigrams_stats<-textstat_frequency(all_unigrams_dfm)
# save(all_unigrams_dt, file="all_unigrams_dt.RData")
# load(file="all_unigrams_dt.RData")

# which words represents 90% of the corpus
all_unigrams_word_count<-sum(ntoken(all_unigrams))
all_unigrams_stats$cumsum<-cumsum(all_unigrams_stats$frequency)
all_unigrams_v_50<-all_unigrams_stats$rank[all_unigrams_stats$cumsum>all_unigrams_word_count*0.5][[1]]
all_unigrams_v_90<-all_unigrams_stats$rank[all_unigrams_stats$cumsum>all_unigrams_word_count*0.90][[1]]
all_unigrams_h_50<-all_unigrams_word_count*0.5
all_unigrams_h_90<-all_unigrams_word_count*0.90

#plot(all_unigrams_stats$cumsum)
#abline(h=all_unigrams_h_50, col="blue" )
#abline(h=all_unigrams_h_90, col="red" )
#abline(v=all_unigrams_v_50, col="blue" )
#abline(v=all_unigrams_v_90, col="red" )

# extrakt the word that represents the rare 10%
remove_word<-all_unigrams_stats$feature[all_unigrams_v_90:length(all_unigrams_stats$feature)]

# remove the words that represents the rare 10% 
unigrams <- tokens_remove(all_unigrams, remove_word, padding = TRUE)

# calculate the document frequency matrix from the unigrams
unigrams_dfm<-dfm(unigrams)
# calculate the statistics 
unigrams_stats<-textstat_frequency(unigrams_dfm)
# save the feature and the frequency in a resulting data table
unigrams_dt<-data.table(unigrams_stats$feature,unigrams_stats$frequency)
save(unigrams_dt, file="unigrams_dt.RData")


# create the bigrams
bigrams<-tokens_ngrams(unigrams, n = 2, concatenator = " ")
# calculate the statistics 
bigrams_dfm<-dfm(bigrams)
# save the feature and the frequency in a resulting data table
bigrams_stats<-textstat_frequency(bigrams_dfm)
# count the bigrams
bigrams_l<-length(bigrams_stats$frequency)

# creating a data table withe first word as the predictor and the second word as result
bigrams_func<-function(x, data){
        p<-list() # predictor
        r<-list() # result
        f<-list() # frequncy
        for (i in c(1:x)){
                word<-unlist(strsplit(data$feature[i], split=" "))
                p[i]<-word[1]
                r[i]<-word[2] 
                f[i]<-data$frequency[i]
        }
        list(p,r,f)
}

bigrams_dt<-bigrams_func(bigrams_l, bigrams_stats)
bigrams_dt<-data.table(bigrams_dt[[1]],bigrams_dt[[2]],bigrams_dt[[3]])

save(bigrams_dt, file="bigrams_dt.RData")
#bigrams_dt[V1=="of"]

# create the trigrams
trigrams<-tokens_ngrams(unigrams, n = 3, concatenator = " ")
# calculate the statistics 
trigrams_dfm<-dfm(trigrams)
# save the feature and the frequency in a resulting data table
trigrams_stats<-textstat_frequency(trigrams_dfm)
# count the trigrams
trigrams_l<-length(trigrams_stats$frequency)

# creating a data table withe first and second word as the predictor and the third word as result
trigrams_func<-function(x, data){
        p<-list() # predictor
        r<-list() # result
        f<-list() # frequncy
        for (i in c(1:x)){
                word<-unlist(strsplit(data$feature[i], split=" "))
                p[i]<-paste0(c(word[1],word[2]), collapse = " ")
                r[i]<-word[3] 
                f[i]<-data$frequency[i]
        }
        list(p,r,f)
}

trigrams_dt<-trigrams_func(trigrams_l, trigrams_stats)
trigrams_dt<-data.table(trigrams_dt[[1]],trigrams_dt[[2]],trigrams_dt[[3]])
save(trigrams_dt,file="trigrams_dt.RData")
#trigrams_dt[V1=="of the"]

# create the  fourgrams
fourgrams<-tokens_ngrams(unigrams, n = 4, concatenator = " ")
# calculate the statistics 
fourgrams_dfm<-dfm(fourgrams)
# save the feature and the frequency in a resulting data table
fourgrams_stats<-textstat_frequency(fourgrams_dfm)
# count the fourgrams
fourgrams_l<-length(fourgrams_stats$frequency)
#save(fourgrams_stats,file="fourgrams_stats.RData")

# creating a data table withe first, second and thrid word as the predictor and the fourth word as result
fourgrams_func<-function(x, data){
        p<-list() # predictor
        r<-list() # result
        f<-list() # frequncy
        for (i in c(1:x)){
                word<-unlist(strsplit(data$feature[i], split=" "))
                p[i]<-paste0(c(word[1],word[2],word[3]), collapse = " ")
                r[i]<-word[4] 
                f[i]<-data$frequency[i]
        }
        list(p,r,f)
}

fourgrams_dt<-fourgrams_func(fourgrams_l, fourgrams_stats)
fourgrams_dt<-data.table(fourgrams_dt[[1]],fourgrams_dt[[2]],fourgrams_dt[[3]])
save(fourgrams_dt,file="fourgrams_dt.RData")

####### Reducing the volume of the model ##########

# load the saved lookup data tables
load(file="unigrams_dt.RData")
load(file="bigrams_dt.RData")
load(file="trigrams_dt.RData")
load(file="fourgrams_dt.RData")


# Function that holds only the first three results for a predictor (unigram, bigram, trigram, fourgram)
reduce_func<-function(x, data, unique_data){
        p<-list() # predictor
        r<-list() # result
        f<-list() # frequncy
        for(i in c(0:(x-1))){
                temp_dt<-data[V1==unique_data[i+1]]
                l<-length(temp_dt[[1]])
                if(l>3)
                {
                        # If there are more than 3 results, just read the first three one
                        l<-3
                }
                
                for(j in c(1:l)){
                        p<-append(p,temp_dt[j,]$V1)
                        r<-append(r,temp_dt[j,]$V2)
                        f<-append(f,temp_dt[j,]$V3)
                }
                
                # since this function runs for a long time, this couter shows the processed predictors
                print(c(i,"_"))
        }
        #print(length(p))
        #print(length(r))
        #print(length(f))
        
        #form the resulting data table
        result_dt<-data.table(p,r,f)
        result_dt
}

#create the final unigrams lookup data table
setnames(unigrams_dt,c("V1","V2"),c("r","f"))
# remove all empty predictors
final_unigrams_dt<-unigrams_dt[r!=""]

# Add the relative probability of each result
prop<-list(unlist(final_unigrams_dt$f)/sum(unlist(final_unigrams_dt$f)))
final_unigrams_dt[, prop := prop]
# tail(final_unigrams_dt)
save(final_unigrams_dt, file="final_unigrams_dt.RData")

#create the final bigrams lookup data table
# just use grams that frequency is more than 2
bigrams_f3_dt<-bigrams_dt[V3>2,]
# create a vector of unique grams
unique_bigrams<-unique(unlist(bigrams_f3_dt[,V1]))
unique_bigrams_l<-length(unique_bigrams)

# use the function to reduce the volume of the lookup data table
system.time(final_bigrams_dt<-reduce_func(unique_bigrams_l, bigrams_f3_dt, unique_bigrams))

# Add the relative probability of each result
prop<-list(unlist(final_bigrams_dt$f)/sum(unlist(final_bigrams_dt$f)))
final_bigrams_dt[, prop := prop]
save(final_bigrams_dt, file="final_bigrams_dt.RData")

#create the final trigrams lookup data table
# just use grams that frequency is more than 2
trigrams_f3_dt<-trigrams_dt[V3>2,]
# create a vector of unique grams
unique_trigrams<-unique(unlist(trigrams_f3_dt[,V1]))
unique_trigrams_l<-length(unique_trigrams)

# use the function to reduce the volume of the lookup data table
system.time(final_trigrams_dt<-reduce_func(unique_trigrams_l, trigrams_f3_dt, unique_trigrams))

# Add the relative probability of each result
prop<-list(unlist(final_trigrams_dt$f)/sum(unlist(final_trigrams_dt$f)))
final_trigrams_dt[, prop := prop]

save(final_trigrams_dt, file="final_trigrams_dt.RData")

#create the final fourgrams lookup data table
# just use grams that frequency is more than 2
fourgrams_f3_dt<-fourgrams_dt[V3>2,]
# create a vector of unique grams
unique_fourgrams<-unique(unlist(fourgrams_f3_dt[,V1]))
unique_fourgrams_l<-length(unique_fourgrams)

# since the vector of all unique fourgrams is very long, it has to be split to reduce the processing time
unique_fourgrams_01<-unique_fourgrams[1:200000]
unique_fourgrams_01_l<-length(unique_fourgrams_01)
unique_fourgrams_02<-unique_fourgrams[200001:unique_fourgrams_l]
unique_fourgrams_02_l<-length(unique_fourgrams_02)

# use the function to reduce the volume of the lookup data table
system.time(final_fourgrams_dt_01<-reduce_func(unique_fourgrams_01_l, fourgrams_f3_dt, unique_fourgrams_01))
system.time(final_fourgrams_dt_02<-reduce_func(unique_fourgrams_02_l, fourgrams_f3_dt, unique_fourgrams_02))

# Add the relative probability of each result
prop<-list(unlist(final_fourgrams_dt_01$f)/sum(unlist(final_fourgrams_dt_01$f)))
final_fourgrams_dt_01[, prop := prop]

prop<-list(unlist(final_fourgrams_dt_02$f)/sum(unlist(final_fourgrams_dt_02$f)))
final_fourgrams_dt_02[, prop := prop]

save(final_fourgrams_dt_01, file="final_fourgrams_dt_01.RData")
save(final_fourgrams_dt_02, file="final_fourgrams_dt_02.RData")

#### Load every lokkup data table again to check the object size   ####
#### There sould be a good balance between knowledge of the data   ####
#### and is's size and the needed lookup time per data table       ####
#### To find the best balance needs several days of data wrangling ####

load("final_bigrams_dt.RData")
load("final_trigrams_dt.RData")
load("final_fourgrams_dt_01.RData")
load("final_fourgrams_dt_02.RData")
object.size(final_bigrams_dt)
object.size(final_trigrams_dt)
object.size(final_fourgrams_dt_01)
object.size(final_fourgrams_dt_02)


