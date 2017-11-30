Next-Word Predictor
========================================================
author: Aaron Taylor
date: Due 1 December 2017
autosize: true

<br> <br>

![title](courseraLogo.png)
![title](swiftkeyLogo.png)


***

<br> <br> <br> <br>

This presentation will pitch an application for predicting the next word.  

This is the capstone project for the Coursera Data Science Specialization.


The Next-Word Predictor App
========================================================

The Next-Word Predictor is a Shiny application which, given a phrase, will attempt to predict the next word. This sort of application is very useful for text entry on mobile devices, where the user wants to spend as little effort as possible typing on the device's tiny keyboard. By predicting words before they are entered, substantial savings in the user's time and effort can be achieved  

- This app uses a backoff model with ngrams, including bigrams, trigrams, quadragrams, and pentagrams
- The corpus for this project was obtained from Swiftkey, and contains text from Twitter, news articles, and blogs
- Substantial preprocessing is performed in order to sort the data and shrink the corpus to a swift size


Preprocessing
========================================================

Preprocessing the corpus includes:
- Combining the corpus, and stripping out waste information like numbers, symbols, urls, punctuation, separators, and profanity
- Tokenization and ngramization of the corpus, in units of 2, 3, 4, and 5 words -- these ngrams form the basis of our model
- Counting up the number of times each selection of words appear, removing X-grams that appear 3 times or less, and ordering the X-grams in order of decreasing frequency  

This process makes extensive use of the "quanteda" and "data.table" R libraries, for speed


Prediction Model: Stupid Backoff
========================================================

This app uses a Stupid Backoff Model to predict the next word  

- The last four words of the submitted phrase are compared to the pentagram data, and the likeliest next word is displayed
- If the words do not appear in the pentagram data, then the model "backs off" to quadragrams, and performs the same procedure with the last three words; this continues to the trigrams and bigrams as well, if nothing can be found
- If no match is found, then "it" is returned, being a very common and neutral word
- More information can be found in Slava Katz's 1987 paper, which described the process (http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.129.7219)


Future Possibilities and Links
========================================================

This project only scrates the surface of Natural Language Processing and predictive analysis. Possiblilities for improvements include:

- Parts of speech tagging to better understand context
- A larger corpus, froma  variety of sources
- A feedback loop, so that the app learns from right/wrong answers
- Machine Learning, such as the Naive Bayes model

Link to the Shiny App: https://amontgom.shinyapps.io/NextWordPredictor/
