library(shiny)
library(plotrix)

shinyUI(pageWithSidebar(
  
  headerPanel("Regression Example"),
  
  sidebarPanel(
    selectInput("slope","Slope:",
                list("Flat","Slight","Steeper","Steepest"),"Slight"),
    selectInput("noise","Noisiness of the data:",
                list("Low","Medium","High")),
    sliderInput("n","Multiply the number of observations by:",
                min = 1,
                max = 10,
                value = 1),
    br(),
    h4("To do"),
    helpText("Try changing the slope of the line,
             the noisiness of the data or the number of observations.
             You will be able to see the change on the plot. Can you also
             determine its effect on the Summary Statistics?"),
    br(),
    checkboxInput("line","Show regression line?", T),
    checkboxInput("means","Show mean of X and Y?"),
    checkboxInput("ant","Show regression equation?", F)
    ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Plot",plotOutput("plot")),
      tabPanel("Scatter Plot",plotOutput("scatterplot")),
      tabPanel("Summary Statistics",
               h4("Screen output in R"),
               verbatimTextOutput("summary")),
      tabPanel("Example  R code",
               helpText("#Generate some data and place in a dataframe"),
               helpText("X <- 1:100"),
               helpText("Y <- 100 + 2*X + rnorm(100, sd=10)"),
               helpText("mydata <- data.frame(X, Y)"),
               br(),
               helpText("#Fit regression model"),
               helpText("model <- lm(Y ~ X, data=mydata)"),
               br(),
               helpText("#Summary statistics for the model"),
               helpText("summary(model)"),
               br(),
               helpText("#Plot the data and add the regression line"),
               helpText("plot(Y ~ X, data=mydata)"),
               helpText("abline(model)")
      )
    )
  )
  
  ))