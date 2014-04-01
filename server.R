library(shiny)
library(ggplot2)
library(reshape2)
library(gridExtra)
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
    
    df <- data()
    
    dd <- melt(data())
    
    p2 <- ggplot(dd, aes(x=variable, y=value,fill=variable))+ geom_boxplot() 
  
    if(input$means) p2 <- p2 + geom_hline(yintercept = c(mean(df[,1]),mean(df[,2])),lty=2)    
    
    p2 <- p2 + coord_flip() + opts(title="Boxplot")
    p1 <- qplot(df[,1], df[,2]) + xlim(0,max(df[,1])) + ylim(0,max(df[,2])) + opts(title="Scatter Plot")
    
    m <- lm(df[,2]~df[,1])
    coefs <- data.frame(a =coef(m)[1], b= coef(m)[2])
    
    if(input$line) p1 <- p1+ geom_abline(data=coefs, aes(intercept=a,slope=b))
    
    p3 <- ggplot(dd, aes(x = value,col=variable)) + geom_density()
    
    if(input$means) p3 <- p3 + geom_vline(xintercept = c(mean(df[,1]),mean(df[,2])),lty=2)    
    
    grid.arrange(p1,p2,p3)
    
  }
)
  
  output$scatterplot <- reactivePlot(function(){
    
    df <- data()
    
    dd <- melt(data())
    
    p1 <- qplot(df[,1], df[,2]) + xlim(0,max(df[,1])) + ylim(0,max(df[,2])) + opts(title="Scatter Plot")
    
    m <- lm(df[,2]~df[,1])
    coefs <- data.frame(a =coef(m)[1], b= coef(m)[2])
    
    if(input$line) p1 <- p1+ geom_abline(data=coefs, aes(intercept=a,slope=b))
    print(p1)    
  }
  )
  
  
  output$summary <- renderPrint({
    model = lm(Y ~ X, data=data())
    summary(model)
  })
  
}
)