#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(stringr)
library(tm)

bigrams <- readRDS(file = "bigrams.RData")
trigrams <- readRDS(file = "trigrams.RData")
quadragrams <- readRDS(file = "quadragrams.RData")
pentagrams <- readRDS(file = "pentagrams.RData")


predictNextWord <- function(words) {
    words <- stripWhitespace(removeNumbers(removePunctuation(tolower(words), preserve_intra_word_dashes = TRUE)))
    words <- strsplit(words, split = " ")[[1]]
    n <- length(words)
    if(n == 0) {message("Please insert a word or phrase.")}
    if(n == 1) {words <- tail(words, 1); nextWord <- bigramPredictor(words)}
    if(n == 2) {words <- tail(words, 2); nextWord <- trigramPredictor(words)}
    if(n == 3) {words <- tail(words, 3); nextWord <- quadragramPredictor(words)}
    if(n >= 4) {words <- tail(words, 4); nextWord <- pentagramPredictor(words)}
    nextWord
}

bigramPredictor <- function(words) {
    if(identical(character(0), as.character(head(bigrams[bigrams$word1 == words[1],2], 1)))) {
        as.character("it")
    }
    else {
        as.character(head(bigrams[bigrams$word1 == words[1], 2], 1))
    }
}

trigramPredictor <- function(words) {
    if(identical(character(0), as.character(head(trigrams[trigrams$word1 == words[1] &
                    trigrams$word2 == words[2],3], 1)))) {
        as.character(predictNextWord(words[2]))
    }
    else {
        as.character(head(trigrams[trigrams$word1 == words[1] &
                    trigrams$word2 == words[2], 3], 1))
    }
}

quadragramPredictor <- function(words) {
    if(identical(character(0), as.character(head(quadragrams[quadragrams$word1 == words[1] &
                    quadragrams$word2 == words[2] & quadragrams$word3 == words[3],4], 1)))) {
        as.character(predictNextWord(paste(words[2], words[3], sep=" ")))
    }
    else {
        as.character(head(quadragrams[quadragrams$word1 == words[1] &
                    quadragrams$word2 == words[2] & quadragrams$word3 == words[3], 4], 1))
    }
}

pentagramPredictor <- function(words) {
    if(identical(character(0), as.character(head(pentagrams[pentagrams$word1 == words[1] &
                    pentagrams$word2 == words[2] & pentagrams$word3 == words[3] &
                    pentagrams$word4 == words[4],5], 1)))) {
        as.character(predictNextWord(paste(words[2], words[3], words[4], sep=" ")))
    }
    else {
        as.character(head(pentagrams[pentagrams$word1 == words[1] &
                    pentagrams$word2 == words[2] & pentagrams$word3 == words[3] &
                    pentagrams$word4 == words[4], 5], 1))
    }
}

#Define server logic required to call predictNextWord
shinyServer(function(input, output) {
    output$words <- renderText({input$inputText});
    output$nextWord <- renderPrint({
        result <- predictNextWord(input$inputText)
        result
    })
  
})
