shinyUI(fluidPage(
  
  titlePanel("Bayesian A/B Testing"),
  
  h4("Inspiration from DataOragami Lessons by Cameron Davidson-Pilon"),
  
  sidebarLayout(
    
    sidebarPanel(
      numericInput("a_obs", "Number of observations from Group A:",  
                  value=100, min=0),
      numericInput("a_conv", "Number of conversions (successes) from Group A:",  
                   value=50, min=0),
      numericInput("b_obs", "Number of observations from Group B:",  
                   value=100, min=0),
      numericInput("b_conv", "Number of conversions (successes) from Group B:",  
                   value=60, min=0),
      sliderInput("posterior_ab_range", "Select A/B Posterior Plot Range:",
                  min=0, max=1, value=c(0,1)),
      numericInput("increase", "Check probabilty increase larger than specific value: ",  
                   value=0, min=0),
      h4("Directions:"),
      p("1. Input number of observations from each group"),
      p("2. Input number converted (success) from each group"),
      p("3. Zoom in/out of A/B Posterior Distribution plot window (optional)"),
      p("4. Query posterior distribution of the relative increase (optional)"),
      h4("Reference:"),
      p("DataOragami Screencasts on Bayesian Analysis by Cameron Davidson-Pilon"),
      HTML("<a href='http://dataorigami.net/'>DataOragami Website</a>")
      
    ),
    
    mainPanel(
      plotOutput("posteriorAB"),
      textOutput("probAB"),
      plotOutput("posteriorDiff"),
      textOutput("probDiff")
    )
  )
))