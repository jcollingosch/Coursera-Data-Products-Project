library(shiny)
library(ggplot2)
library(reshape2)

shinyServer(function(input, output) {
  
  samples <- reactive({
    data.frame(samples_a=rbeta(10000, 1+input$a_conv, 1+input$a_obs-input$a_conv),
               samples_b=rbeta(10000, 1+input$b_conv, 1+input$b_obs-input$b_conv))
  })
  
  output$posteriorAB <- renderPlot({
    
    range <- seq(input$posterior_ab_range[1], input$posterior_ab_range[2],
                 length.out = 200)

    a_pdf <- dbeta(range, 1 + input$a_conv, 1 + input$a_obs - input$a_conv)
    b_pdf <- dbeta(range, 1 + input$b_conv, 1 + input$b_obs - input$b_conv)

    posterior_df <- data.frame(range, A=a_pdf, B=b_pdf)
    posterior_long <- melt(posterior_df,
                           id.vars="range",
                           value.name = "pdf",
                           variable.name="Group")
    ggplot(posterior_long, aes(x=range, y=pdf, color=Group)) +
      geom_line(lwd=2) +
      labs(x="Conversion Rate", y="Probability", title="A/B Posterior Distribution")
  })
  
  output$probAB <- renderText({
    samples_df <- samples()
    p <- mean(samples_df$samples_b > samples_df$samples_a)
    print(paste("P(A > B | Data) = ",round(p,2)))
  })
  
  output$posteriorDiff <- renderPlot({
    samples_df <- samples()
    rel_diff <- (samples_df$samples_b - samples_df$samples_a)/samples_df$samples_a
    ggplot(data.frame(rel_diff), aes(rel_diff)) +
      geom_histogram(fill="steelblue") +
      labs(x="Relative Increase",
           y="",
           title="Relative Increase in A Conversion Rate (A-B)/A")
  })
  
  output$probDiff <- renderText({
    samples_df <- samples()
    rel_diff <- (samples_df$samples_b - samples_df$samples_a)/samples_df$samples_a
    q <- quantile(rel_diff, c(0.025,0.975))
    p <- mean(rel_diff > input$increase)
    print(paste("95% Credible Interval of the relative increase: (",round(q[1],2),",",round(q[2],2),")",
                "The probability increase >",input$increase," = ",round(p,2)))
  })
})