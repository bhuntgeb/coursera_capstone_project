Capstone project - Next word prediction
========================================================
author: Bastian Huntgeburth
date: 2019-05-11
autosize: true

This presentation gives a short overview about my results of the capstone project of the Data Science specialization course provided by the Johns Hopkins University. The goal of the project was to develop a data product that predicts the next word in a human written text like the well-known SwiftKey product. The resulting application can accessed with this [link.](https://bhuntge.shinyapps.io/NextWordPred/)


Project steps
========================================================
The following main steps were done during the data science project.

- Loading data: The textual data consist of blog- , twitter- and news-text and was loaded in a single document corpus
- Explorative data analysis: We searched for the top n-grams and the words which represents 90% of the corpus
- Cleaning the data: Removing numbers, punctuation, symbols and hyphens. Just holding the words that represent 90% of the corpus.
- Building the model: We choosed the Marcov chain to build our prediction model. The results were several big lookup tables that give a prediction with the knowledge of the last 1-2-3-words.
- Developing the data product: Developed a simple shiny app.

The Model
========================================================
After the data was loaded into a corpus and cleaned, it was ready for building a model.

With a first approach we choose the Marcov Chain as a appropriate model to predict a next word. The Marcov Chain says that a next state is based on a limited number of previous states. 
$$P(w_i|w_1 w_2 ... w_{i-1})\approx P(w_i|w_{i-1}... _{i-n})$$

The states of the textual data were represented by tokens (words) of the corpus. We build every possible Marcov chain with up to 4 consecutive words (bi-, tri- and fourgrams). The last word of each n-gram was the prediction based on the other words bevor. After that the count of each chain was calculated and the resulting frequency was transformed in the relative probability. All chains were saved in big lookup tables, for later prediction.


The data product
========================================================
You can find the application behind this link.

To use the data product, you just need to type in your text in the textarea. Don't forget the space behind your words. The prediction of the next word is done automatically. The predicted word will be shown as clickable buttons ordered by their probability. If you click on a button, the word will be appended to your text. The application was tested with the firefox browser. 

Additional material
========================================================

For reproducibility I'am sharing all my material.

- The Explorative Analysis [(here)] (http://rpubs.com/bhuntgeb/483451)
- The whole code for data processing [(new tab)] (https://github.com/bhuntgeb/coursera_capstone_project)
- The Shiny app as the resulting data product [(here)](https://bhuntge.shinyapps.io/NextWordPred/)

Further steps
- The correction of misspelled words should be taken into account. 
- A better backoff-method should be developed to handle unknown words in the predictor. 
- It would be a good feature, to implement a continuous learning process to optimize the model.

