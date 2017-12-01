library(tm)
library(RWeka)
library(ggplot2)
library(stringi)
library(caret)
library(quanteda)
library(data.table)
library(stringr)
library(plyr)


tweets <- readLines("./data/Data_Science_Capstone/final/en_US/en_US.twitter.txt")
news <- readLines("./data/Data_Science_Capstone/final/en_US/en_US.news.txt")
blogs <- readLines("./data/Data_Science_Capstone/final/en_US/en_US.blogs.txt")

blogsCorpus <- corpus(tolower(blogs))
newsCorpus <- corpus(tolower(news))
tweetCorpus <- corpus(tolower(tweets))
#blogsCorpusDF <- data.frame(text = unlist(blogsCorpus), stringsAsFactors = FALSE)
#blogsCorpusDF$type <- "blogs"
#newsCorpusDF <- data.frame(text = unlist(newsCorpus), stringsAsFactors = FALSE)
#newsCorpusDF$type <- "news"
#tweetCorpusDF <- data.frame(text = unlist(tweetCorpus), stringsAsFactors = FALSE)
#tweetCorpusDF$type <- "tweets"
#corpusDF <- rbind(blogsCorpusDF,newsCorpusDF,tweetCorpusDF)

corpus <- blogsCorpus + newsCorpus + tweetCorpus

badwords <- readLines("http://www.cs.cmu.edu/~biglou/resources/bad-words.txt")
badwords <- badwords[-(which(badwords %in% c("refugee","reject","remains","screw",
                                             "welfare", "sweetness","shoot","sick","shooting","servant","sex",
                                             "radical","racial","racist","republican","public","molestation",
                                             "mexican","looser","lesbian","liberal","kill","killing","killer",
                                             "heroin","fraud","fire","fight","fairy","^die","death","desire",
                                             "deposit","crash","^crim","crack","^color","cigarette","church",
                                             "^christ","canadian", "cancer","^catholic","cemetery","buried",
                                             "burn","breast","^bomb","^beast","attack","australian","balls",
                                             "baptist","^addict","abuse","abortion","amateur","asian","aroused",
                                             "angry","arab","bible")==TRUE))]

corpus <- Corpus(VectorSource(fullData))
corpus <- tm_map(corpus, space,"\"|/|@|\\|")
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeWords, badwords)
corpus <- tm_map(corpus, removeWords, "http\\w+")

tokens <- tokens(x = corpus, what = "word", remove_numbers = TRUE, remove_symbols = TRUE,
                 remove_url = TRUE, remove_punct = TRUE, remove_separators = TRUE)
saveRDS(tokens, file = "~/R/workplace/git/Data_Science_Capstone/tokens.RData")

monograms <- tokens_ngrams(x = tokens, n = 1)
saveRDS(monograms, file = "~/R/workplace/git/Data_Science_Capstone/monograms.RData")
rm(monograms)
gc()
bigrams <- tokens_ngrams(x = tokens, n = 2)
saveRDS(bigrams, file = "~/R/workplace/git/Data_Science_Capstone/bigrams.RData")
rm(bigrams)
gc()
trigrams <- tokens_ngrams(x = tokens, n = 3)
saveRDS(trigrams, file = "~/R/workplace/git/Data_Science_Capstone/trigrams.RData")
rm(trigrams)
gc()
quadragrams <- tokens_ngrams(x = tokens, n = 4)
saveRDS(quadragrams, file = "~/R/workplace/git/Data_Science_Capstone/quadragrams.RData")
rm(quadragrams)
gc()
pentagrams <- tokens_ngrams(x = tokens, n = 5)
saveRDS(pentagrams, file = "~/R/workplace/git/Data_Science_Capstone/pentagrams.RData")
rm(pentagrams)
gc()
hexagrams <- tokens_ngrams(x = tokens, n = 6)
saveRDS(hexagrams, file = "~/R/workplace/git/Data_Science_Capstone/hexagrams.RData")
rm(hexagrams)
gc()


tokens <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/tokens.RData")
monograms <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/monograms.RData")
bigrams <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/bigrams.RData")
trigrams <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/trigrams.RData")
quadragrams <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/quadragrams.RData")
pentagrams <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/pentagrams.RData")
hexagrams <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/hexagrams.RData")
head(tokens); head(monograms); head(bigrams); head(trigrams); head(quadragrams); head(pentagrams); head(hexagrams)



monogramsDF <- data.frame(text = unlist(monograms), stringsAsFactors = FALSE)
monogramsDF$frequency <- 1
monogramsDT <- data.table(monogramsDF)
monogramsDT <- data.table(monograms)
monogramsDT$frequency <- 1
monogramsDT[,list(frequency=sum(frequency)), by='monograms']
monogramsDT[, y := which(monogramsDT$monograms %in% monograms), by = 1:nrow(monogramsDT)][1:100,]
monogramsDT[, .(monograms = unlist(monograms)), by=.(i,j)][,sum(j),by=k]


#monogramsDF <- data.frame(text = unlist(monograms), stringsAsFactors = FALSE)
monogramsDT <- data.table(text = unlist(monograms), stringsAsFactors = FALSE)
#monogramsDF$frequency <- 1
monogramsDT$frequency <- 1
#monogramsDT <- data.table(monogramsDF)
monogramsDT <- monogramsDT[,list(frequency=sum(frequency)), by='text']
#monogramsDF <- data.frame(table(monogramsDF))
#monogramsDT <- data.table(monogramsDF)
monogramsDF <- data.frame(monogramsDT)
monogramsDF <- monogramsDF[order(monogramsDF$frequency, decreasing = TRUE),]
colnames(monogramsDF) <- c("words","count")



library(quanteda)
library(data.table)
monograms <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/monograms.RData")
monogramsDT <- data.table(text = unlist(monograms), stringsAsFactors = FALSE)
monogramsDT$frequency <- 1
monogramsDT <- monogramsDT[,list(frequency=sum(frequency)), by='text']
monogramsDF <- data.frame(monogramsDT)
monogramsDF <- monogramsDF[order(monogramsDF$frequency, decreasing = TRUE),]
colnames(monogramsDF) <- c("words","count")
saveRDS(monogramsDF, file = "~/R/workplace/git/Data_Science_Capstone/monogramsDF.RData")
rm(monograms, monogramsDF, monogramsDT)
gc()


bigrams <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/bigrams.RData")
bigramsDT <- data.table(text = unlist(bigrams), stringsAsFactors = FALSE)
bigramsDT$frequency <- 1
bigramsDT <- bigramsDT[,list(frequency=sum(frequency)), by='text']
bigramsDF <- data.frame(bigramsDT)
bigramsDF <- bigramsDF[order(bigramsDF$frequency, decreasing = TRUE),]
colnames(bigramsDF) <- c("words","count")
saveRDS(bigramsDF, file = "~/R/workplace/git/Data_Science_Capstone/bigramsDF.RData")
rm(bigrams, bigramsDF, bigramsDT)
gc()


trigrams <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/trigrams.RData")
trigramsDT <- data.table(text = unlist(trigrams), stringsAsFactors = FALSE)
trigramsDT$frequency <- 1
trigramsDT <- trigramsDT[,list(frequency=sum(frequency)), by='text']
trigramsDF <- data.frame(trigramsDT)
trigramsDF <- trigramsDF[order(trigramsDF$frequency, decreasing = TRUE),]
colnames(trigramsDF) <- c("words","count")
saveRDS(trigramsDF, file = "~/R/workplace/git/Data_Science_Capstone/trigramsDF.RData")
rm(trigrams, trigramsDF, trigramsDT)
gc()


quadragrams <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/quadragrams.RData")
n <- length(quadragrams)
m <- n/2
quad1 <- quadragrams[1:m]
quad2 <- quadragrams[(m+1):n]
rm(quadragrams)
gc()
#quadragramsDT <- data.table(text = unlist(quadragrams), stringsAsFactors = FALSE)
#quadragramsDT$frequency <- 1
#quadragramsDT <- quadragramsDT[,list(frequency=sum(frequency)), by='text']
#quadragramsDF <- data.frame(quadragramsDT)
#quadragramsDF <- quadragramsDF[order(quadragramsDF$frequency, decreasing = TRUE),]
#colnames(quadragramsDF) <- c("words","count")
#saveRDS(quadragramsDF, file = "~/R/workplace/git/Data_Science_Capstone/quadragramsDF.RData")
#rm(quadragrams, quadragramsDF, quadragramsDT)

quad1DT <- data.table(text = unlist(quad1), stringsAsFactors = FALSE)
quad1DT$frequency <- 1
quad1DT <- quad1DT[,list(frequency=sum(frequency)), by='text']
quad1DF <- data.frame(quad1DT)
quad1DF <- quad1DF[order(quad1DF$frequency, decreasing = TRUE),]
colnames(quad1DF) <- c("words","count")
saveRDS(quad1DF, file = "~/R/workplace/git/Data_Science_Capstone/quad1DF.RData")
rm(quad1DF, quad1DT)
gc()

quad2DT <- data.table(text = unlist(quad2), stringsAsFactors = FALSE)
quad2DT$frequency <- 1
quad2DT <- quad2DT[,list(frequency=sum(frequency)), by='text']
quad2DF <- data.frame(quad2DT)
quad2DF <- quad2DF[order(quad2DF$frequency, decreasing = TRUE),]
colnames(quad2DF) <- c("words","count")
saveRDS(quad2DF, file = "~/R/workplace/git/Data_Science_Capstone/quad2DF.RData")
rm(quad2DF, quad2DT)
gc()

pentagrams <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/pentagrams.RData")
n <- length(pentagrams)
m <- n/2
pent1 <- pentagrams[1:m]
pent2 <- pentagrams[(m+1):n]
rm(pentagrams)
gc()
#pentagramsDT <- data.table(text = unlist(pentagrams), stringsAsFactors = FALSE)
#pentagramsDT$frequency <- 1
#pentagramsDT <- pentagramsDT[,list(frequency=sum(frequency)), by='text']
#pentagramsDF <- data.frame(pentagramsDT)
#pentagramsDF <- pentagramsDF[order(pentagramsDF$frequency, decreasing = TRUE),]
#colnames(pentagramsDF) <- c("words","count")
#saveRDS(pentagramsDF, file = "~/R/workplace/git/Data_Science_Capstone/pentagramsDF.RData")
#rm(pentagrams, pentagramsDF, pentagramsDT)

pent1DT <- data.table(text = unlist(pent1), stringsAsFactors = FALSE)
pent1DT$frequency <- 1
pent1DT <- pent1DT[,list(frequency=sum(frequency)), by='text']
pent1DF <- data.frame(pent1DT)
pent1DF <- pent1DF[order(pent1DF$frequency, decreasing = TRUE),]
colnames(pent1DF) <- c("words","count")
saveRDS(pent1DF, file = "~/R/workplace/git/Data_Science_Capstone/pent1DF.RData")
rm(pent1DF, pent1DT)
gc()

pent2DT <- data.table(text = unlist(pent2), stringsAsFactors = FALSE)
pent2DT$frequency <- 1
pent2DT <- pent2DT[,list(frequency=sum(frequency)), by='text']
pent2DF <- data.frame(pent2DT)
pent2DF <- pent2DF[order(pent2DF$frequency, decreasing = TRUE),]
colnames(pent2DF) <- c("words","count")
saveRDS(pent2DF, file = "~/R/workplace/git/Data_Science_Capstone/pent2DF.RData")
rm(pent2DF, pent2DT)
gc()


hexagrams <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/hexagrams.RData")
n <- length(hexagrams)
m <- n/2
hex1 <- hexagrams[1:m]
hex2 <- hexagrams[(m+1):n]
rm(hexagrams)
gc()
#hexagramsDT <- data.table(text = unlist(hexagrams), stringsAsFactors = FALSE)
#hexagramsDT$frequency <- 1
#hexagramsDT <- hexagramsDT[,list(frequency=sum(frequency)), by='text']
#hexagramsDF <- data.frame(hexagramsDT)
#hexagramsDF <- hexagramsDF[order(hexagramsDF$frequency, decreasing = TRUE),]
#colnames(hexagramsDF) <- c("words","count")
#saveRDS(hexagramsDF, file = "~/R/workplace/git/Data_Science_Capstone/hexagramsDF.RData")
#rm(hexagrams, hexagramsDF, hexagramsDT)

hex1DT <- data.table(text = unlist(hex1), stringsAsFactors = FALSE)
hex1DT$frequency <- 1
hex1DT <- hex1DT[,list(frequency=sum(frequency)), by='text']
hex1DF <- data.frame(hex1DT)
hex1DF <- hex1DF[order(hex1DF$frequency, decreasing = TRUE),]
colnames(hex1DF) <- c("words","count")
saveRDS(hex1DF, file = "~/R/workplace/git/Data_Science_Capstone/hex1DF.RData")
rm(hex1DF, hex1DT, hex1)
gc()

hex2DT <- data.table(text = unlist(hex2), stringsAsFactors = FALSE)
hex2DT$frequency <- 1
hex2DT <- hex2DT[,list(frequency=sum(frequency)), by='text']
hex2DF <- data.frame(hex2DT)
hex2DF <- hex2DF[order(hex2DF$frequency, decreasing = TRUE),]
colnames(hex2DF) <- c("words","count")
saveRDS(hex2DF, file = "~/R/workplace/git/Data_Science_Capstone/hex2DF.RData")
rm(hex2DF, hex2DT, hex2)
gc()



monogramsDF <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/monogramsDF.RData")
rownames(monogramsDF) <- 1:nrow(monogramsDF)
monogramsDF2 <- monogramsDF[!monogramsDF$count == 1 & !monogramsDF$count == 2 & !monogramsDF$count == 3,]
monogramsDF2 <- monogramsDF2[order(monogramsDF2$count, decreasing = TRUE),]
rownames(monogramsDF2) <- 1:nrow(monogramsDF2)
monograms <- as.data.frame(cbind(str_split_fixed(monogramsDF2$words, "_", 1),monogramsDF2$count))
colnames(monograms) <- c("word1", "count")
saveRDS(monograms, file = "~/R/workplace/git/Data_Science_Capstone/monograms.RData")
rm(monogramsDF, monogramsDF2, monograms)
gc()

bigramsDF <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/bigramsDF.RData")
rownames(bigramsDF) <- 1:nrow(bigramsDF)
bigramsDF2 <- bigramsDF[!bigramsDF$count == 1 & !bigramsDF$count == 2 & !bigramsDF$count == 3,]
bigramsDF2 <- bigramsDF2[order(bigramsDF2$count, decreasing = TRUE),]
rownames(bigramsDF2) <- 1:nrow(bigramsDF2)
bigrams <- as.data.frame(cbind(str_split_fixed(bigramsDF2$words, "_", 2),bigramsDF2$count))
colnames(bigrams) <- c("word1", "word2", "count")
saveRDS(bigrams, file = "~/R/workplace/git/Data_Science_Capstone/bigrams.RData")
rm(bigramsDF, bigramsDF2, bigrams)
gc()

trigramsDF <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/trigramsDF.RData")
rownames(trigramsDF) <- 1:nrow(trigramsDF)
trigramsDF2 <- trigramsDF[!trigramsDF$count == 1 & !trigramsDF$count == 2 & !trigramsDF$count == 3,]
trigramsDF2 <- trigramsDF2[order(trigramsDF2$count, decreasing = TRUE),]
rownames(trigramsDF2) <- 1:nrow(trigramsDF2)
trigrams <- as.data.frame(cbind(str_split_fixed(trigramsDF2$words, "_", 3),trigramsDF2$count))
colnames(trigrams) <- c("word1", "word2", "word3", "count")
saveRDS(trigrams, file = "~/R/workplace/git/Data_Science_Capstone/trigrams.RData")
rm(trigramsDF, trigramsDF2, trigrams)
gc()

quad1DF <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/quad1DF.RData")
quad2DF <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/quad2DF.RData")
rownames(quad1DF) <- 1:nrow(quad1DF)
rownames(quad2DF) <- 1:nrow(quad2DF)
quadDF <- merge(quad1DF, quad2DF, by = "words")
quadDF$count <- rowSums(quadDF[, c("count.x", "count.y")])
quadDF <- quadDF[, c("words", "count")]
quadDF2 <- quadDF[!quadDF$count == 1 & !quadDF$count == 2 & !quadDF$count == 3,]
quadDF2 <- quadDF2[order(quadDF2$count, decreasing = TRUE),]
rownames(quadDF2) <- 1:nrow(quadDF2)
quadragrams <- as.data.frame(cbind(str_split_fixed(quadDF2$words, "_", 4), quadDF2$count))
colnames(quadragrams) <- c("word1", "word2", "word3", "word4", "count")
saveRDS(quadragrams, file = "~/R/workplace/git/Data_Science_Capstone/quadragrams.RData")
rm(quad1DF, quad2DF, quadDF, quadDF2, quadragrams)
gc()

pent1DF <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/pent1DF.RData")
pent2DF <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/pent2DF.RData")
rownames(pent1DF) <- 1:nrow(pent1DF)
rownames(pent2DF) <- 1:nrow(pent2DF)
pentDF <- merge(pent1DF, pent2DF, by = "words")
pentDF$count <- rowSums(pentDF[, c("count.x", "count.y")])
pentDF <- pentDF[, c("words", "count")]
pentDF2 <- pentDF[!pentDF$count == 1 & !pentDF$count == 2 & !pentDF$count == 3,]
pentDF2 <- pentDF2[order(pentDF2$count, decreasing = TRUE),]
rownames(pentDF2) <- 1:nrow(pentDF2)
pentagrams <- as.data.frame(cbind(str_split_fixed(pentDF2$words, "_", 5), pentDF2$count))
colnames(pentagrams) <- c("word1", "word2", "word3", "word4", "word5", "count")
saveRDS(pentagrams, file = "~/R/workplace/git/Data_Science_Capstone/pentagrams.RData")
rm(pent1DF, pent2DF, pentDF, pentDF2, pentagrams)
gc()



monograms <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/monograms.RData")
bigrams <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/bigrams.RData")
trigrams <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/trigrams.RData")
quadragrams <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/quadragrams.RData")
pentagrams <- readRDS(file = "~/R/workplace/git/Data_Science_Capstone/pentagrams.RData")
bigrams <- bigrams[1:50000,]
trigrams <- trigrams[1:50000,]
quadragrams <- quadragrams[1:50000,]
pentagrams <- pentagrams[1:50000,]
saveRDS(bigrams, file = "~/R/workplace/git/Data_Science_Capstone/bigrams.RData")
saveRDS(trigrams, file = "~/R/workplace/git/Data_Science_Capstone/trigrams.RData")
saveRDS(quadragrams, file = "~/R/workplace/git/Data_Science_Capstone/quadragrams.RData")
saveRDS(pentagrams, file = "~/R/workplace/git/Data_Science_Capstone/pentagrams.RData")