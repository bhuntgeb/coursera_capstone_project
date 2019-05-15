#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(data.table)

# loading the lookup tables
load("final_unigrams_dt.RData")
load("final_bigrams_dt.RData")
load("final_trigrams_dt.RData")
load("final_fourgrams_dt_01.RData")
load("final_fourgrams_dt_02.RData")

# Define server logic 
shinyServer(function(session, input, output) {

# Create a reactive function which returns the prediction result
  result <-reactive({
          # initiate a data frame for return
          result<-data.frame(r=" ", f=" ", prop=" ")
          
          # read the input text
          if(input$text!=""){
                  text<-input$text
                  # remove punctuation 
                  text<-gsub(pattern = "[[:punct:]]", replacement = "", text)  
                  # transform the input text to lower case
                  text<-tolower(text)
                  
                  # split the text into seperate words
                  pred<-strsplit(text, split = " ")
                  pred<-unlist(pred)
                  l<-length(pred)

                  # use only the last word for prediction
                  if(length(pred)>=1)
                  {
                          result1<-final_bigrams_dt[p==pred[l]]
                          r<-result1$r
                          f<-result1$f
                          prop<-result1$prop
                          # print(result1)
                  }
                  # use only the last two words for prediction
                  if(l>=2)
                  {
                          result2<-final_trigrams_dt[p==paste0(pred[(l-1):l], collapse = " ")]
                          r<-append(r, result2$r)
                          f<-append(f, result2$f)
                          prop<-append(prop, result2$prop)
                          #print(result2)
                  }
                  # use only the last three words for prediction
                  if(l>=3)
                  {
                          result3<-final_fourgrams_dt_01[p==paste0(pred[(l-2):l], collapse = " ")]
                          r<-append(r, result3$r)
                          f<-append(f, result3$f)
                          prop<-append(prop, result3$prop)
                          #print(result3)
                          
                          result4<-final_fourgrams_dt_02[p==paste0(pred[(l-2):l], collapse = " ")]
                          r<-append(r, result4$r)
                          f<-append(f, result4$f)
                          prop<-append(prop, result4$prop)
                          #print(result4)
                  }

                  # 
                  if(length(r)!=0){
                          result<-data.table(r=unlist(r),f=unlist(f),prop=unlist(prop))
                          result<-data.frame(result)
                          # Group by predicted word and sum up the propabilities
                          result<-aggregate(prop ~ r, result, sum)
                          # Order the predicted words by each prpability
                          result<-result[order(-result$prop),]
                  }
                  else{
                          result<-data.frame(head(final_unigrams_dt,n=9))
                  }
        }
        result$r
          
})
  
# Create the buttons for the predicted next words
  
  output$pred1<-renderUI({
          # print(class(result()[1]))
          if(result()[1]!=" "){
                
                actionButton("action", label=result()[1],width = '33%', style = "font-size: 20px")    
                
          }
  }) 
  output$pred2<-renderUI({
          if(length(result())!=0){
                  if(!is.na(result()[2])){
                  actionButton("action2", label=result()[2],width = '33%', style = "font-size: 20px")    
                  }
          }
  }) 
  output$pred3<-renderUI({
          if(length(result())!=0){
                  if(!is.na(result()[3])){
                  actionButton("action3", label=result()[3],width = '33%', style = "font-size: 20px")    
                  }
          }
  }) 
  output$pred4<-renderUI({
          if(length(result())!=0){
                  if(!is.na(result()[4])){
                  actionButton("action4", label=result()[4],width = '33%', style = "font-size: 20px")    
                  }
          }
  }) 
  output$pred5<-renderUI({
          if(length(result())!=0){
                  if(!is.na(result()[5])){
                  actionButton("action5", label=result()[5],width = '33%', style = "font-size: 20px")    
                  }
          }
  }) 
  output$pred6<-renderUI({
          if(length(result())!=0){
                  if(!is.na(result()[6])){
                  actionButton("action6", label=result()[6],width = '33%', style = "font-size: 20px") 
                  }
          }
  })   
  output$pred7<-renderUI({
          if(length(result())!=0){
                  if(!is.na(result()[7])){
                  actionButton("action7", label=result()[7],width = '33%', style = "font-size: 20px")    
                  }
          }
  }) 
  output$pred8<-renderUI({
          if(length(result())!=0){
                  if(!is.na(result()[8])){
                  actionButton("action8", label=result()[8],width = '33%', style = "font-size: 20px")    
                  }
          }       
  }) 
  
  
  output$pred9<-renderUI({
          if(length(result())!=0){
                  if(!is.na(result()[9])){
                  actionButton("action9", label=result()[9],width = '33%', style = "font-size: 20px") 
                  }
          }
  }) 
  

  # Event Handler for the clickable buttons
  # With a click the predicted word is appended to the text in the input textarea
  
  observeEvent(input$action, {
          name <- paste0(input$text, result()[1], sep = " ")
          updateTextInput(session = session, "text", value = name)
  })
  
  observeEvent(input$action2, {
          name <- paste0(input$text, result()[2], sep = " ")
          updateTextInput(session = session, "text", value = name)
  })
  
  observeEvent(input$action3, {
          name <- paste0(input$text, result()[3], sep = " ")
          updateTextInput(session = session, "text", value = name)
  })
  observeEvent(input$action4, {
          name <- paste0(input$text, result()[4], sep = " ")
          updateTextInput(session = session, "text", value = name)
  })
  
  observeEvent(input$action5, {
          name <- paste0(input$text, result()[5], sep = " ")
          updateTextInput(session = session, "text", value = name)
  })
  
  observeEvent(input$action6, {
          name <- paste0(input$text, result()[6], sep = " ")
          updateTextInput(session = session, "text", value = name)
  })
  observeEvent(input$action7, {
          name <- paste0(input$text, result()[7], sep = " ")
          updateTextInput(session = session, "text", value = name)
  })
  
  observeEvent(input$action8, {
          name <- paste0(input$text, result()[8], sep = " ")
          updateTextInput(session = session, "text", value = name)
  })
  
  observeEvent(input$action9, {
          name <- paste0(input$text, result()[9], sep = " ")
          updateTextInput(session = session, "text", value = name)
  })
  
})
