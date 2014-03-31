library(shiny)
library(plotrix)
library(ggplot2)
library(reshape2)
shinyServer(function(input, output){
  
  data <- reactive({
    xx <- seq(from=0,to=100,length.out = 30*input$n)
    set.seed(100)
    slope <- input$slope
    if(slope == "Flat") slp = 0
    if(slope == "Slight") slp = 0.5   
    if(slope == "Steeper") slp = 1
    if(slope == "Steepest") slp = 2.5
    noise <- input$noise
    if(noise == "Low") sdx = 25
    if(noise == "Medium") sdx = 75
    if(noise == "High") sdx = 200
    yy <- slp*xx + rnorm(30*input$n, 0, sd=sdx) + 100
    data.frame(X=xx, Y=yy)
  })
  
#  output$plot <- renderPlot({
#    plot(data(), xlab="X", ylab="Y", ylim=c(-300,800))
#    if(input$line) {
#      abline(lm(Y ~ X, data=data()), col="dark blue")
#    }
#    if(input$means) {
#      abline(v = mean(data()[,1]), lty="dotted")
#      abline(h = mean(data()[,2]), lty="dotted")
#    } 
#    if(input$ant) {
#      model = lm(Y ~ X, data=data())
#      txt = paste("The equation of the line is:\nY = ",
#                  round(coefficients(model)[1],0)," + ",
#                  round(coefficients(model)[2],3),"X + error")
      
#      boxed.labels(50,600,labels=txt,bg="white", cex=1.25)
#    }    
    
#  })
 #
  
  
  output$plot <- reactivePlot(function(){
    
    dd <- melt(data())
    
    p <- ggplot(dd, aes(x=X, y=Y))+ geom_boxplot()
    
    
  }
)
  
  output$summary <- renderPrint({
    model = lm(Y ~ X, data=data())
    summary(model)
  })
  
}
)