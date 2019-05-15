#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Next word prediction by Bastian Huntgeburth (2019-5-11)"),
  sidebarLayout(
          sidebarPanel(
                  tabsetPanel(type = "tabs",
                              tabPanel("How to use", br(),
                                      p("To use this dataproduct, you just need to type in your text in the textarea. Don't forget the space behind your words. "),  
                                      span("The prediction of the next word is done automatically. The predicted word will be shown as clickable buttons  "),
                                      span("ordered by their probability. If you click on a button, the word will be appended to your text. The application was tested with the firefox browser. ")
                              ),
                              tabPanel("Background", br(),
                                       p("This application is part of the coursera datascience specialization capstone of the Johns Hopkins University. "),
                                       span("The mission was to develop a dataproduct, which predicts the next word in human written text. "),
                                       span("For that, a huge amount of textual data was analyzed with NPL technics to build a prediction model. "),
                                       span("The main challenge was to find a well working algorithm and to reduce the size of the model. The goal was to realize  "),
                                       span("a real-time prediction with limited compute resources. "),
                                       h3("Modelling"),
                                       p("The model is based on three text files that contain blog, twitter and news texts. The next bullet points  represents the steps during building the model."),
                                       p("- Loading data: Loading all text files into one big corpus  "),
                                       p("-  Cleaning data: Removing numbers, punctuation, symbols and hyphens. Just holding the words that represents 90% of the corpus"),
                                       p("-  Model building: Tokenization of the corpus in uni-, bi-, tri- and fourgrams. Calculating the document frequency matrixes (DFM). The frequency was transformed to the relative probability. 
                                       Using the n-grams to build a markov chain The last word of an n-gram is the result and the other word bevor are the predictors. Save this in big lookup-tables. "),
                                       p("- Prediction: Cleaning the textual data from the textarea input field and search for the prediction in the lookup-tables."),
                                       h3("Additional information:"),
                                       p("Explorative analysis:", a("Link", href="http://rpubs.com/bhuntgeb/483451")),
                                       p("GitHub repository of this application:", a("Link", href="https://github.com/bhuntgeb/coursera_capstone_project")),
                                       p("A small presentation about the capstone project:", a("Link", href="http://rpubs.com/bhuntgeb/496704")),
                                       h3("Further stepps"),
                                       p("The correction of mispelled words shoulsd be taken into account. Altought a better backoff-method"),
                                       span("should be developed to handel unknowen words in the predictor n-gram. It would altought be a good"),
                                       span("feature, to implement a continous learning to optimize the model.")
                                       )
                                      )
          ),
          mainPanel(
                  # Textarea to write the words used for predicting the next word
                  textAreaInput("text", "Write your text here:", rows=6),
                  uiOutput("pred1", inline = TRUE),
                  uiOutput("pred2", inline = TRUE),
                  uiOutput("pred3", inline = TRUE),
                  uiOutput("pred4", inline = TRUE),
                  uiOutput("pred5", inline = TRUE),
                  uiOutput("pred6", inline = TRUE),
                  uiOutput("pred7", inline = TRUE),
                  uiOutput("pred8", inline = TRUE),
                  uiOutput("pred9", inline = TRUE)
   
                )
          )
      )
)
