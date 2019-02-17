##### Code (core.R) for illustrating the predicting stock returns
##### based on the performance of beauty and cosmetic stocks
##### written by Jude Ken-Kwofie

#### core.R is the common library of packages, libraries, functions used for lipstick effect project.
#### To run the lip effect analysis, go to the lipstickeffect.R file 

############################################################
# Install Packages                                         #                                                     
############################################################
if (!require(ggplot2)) install.packages("ggplot2") #Declaratively create graphics
if (!require(quantmod)) install.packages("quantmod") #Quantitative Financial Modelling Framework
if (!require(magrittr)) install.packages("magrittr") #Forward pipe operator
if (!require(BatchGetSymbols)) install.packages('BatchGetSymbols') #Stock ticker aggregator
if (!require(data.table)) install.packages("data.table")
if (!require(lubridate)) install.packages(("lubridate"))
if (!require(randtests)) install.packages(("randtests"))

library(ggplot2)
library(quantmod)
library(magrittr)
library(BatchGetSymbols) 
library(data.table)
library(randtests)

############################################################
# Core Functions                                           #                                                     
############################################################
DownloadStockFinancialData <- function(tickers, start.date, end.date, freq.data) {
  # Downlaods the stock symbols from Yahoo Finance.
  #
  # Args:
  #   tickers: Vector of stock tickers to download
  #   start.date: The first date to download data (date or char as YYYY-MM-DD)
  #   end.date: The last date to download data (date or char as YYYY-MM-DD)
  #   freq.data: Frequency of financial data (’daily’, ’weekly’, ’monthly’, ’yearly’)
  #
  # Returns:
  #   A data frame with the master copy of the data stock financial data.
  
  # Error Handling
  if ( (is.not.null(tickers) && length(tickers) > 0) && is.Date(start.date) &&
       (is.not.null(freq.data) && length(freq.data)) && is.Date(end.date)) {
    
    # Download a batch of stock financial data
    df.out <- BatchGetSymbols(tickers = tickers, 
                              first.date = start.date,
                              last.date = end.date, 
                              freq.data = "daily",
                              cache.folder = file.path(tempdir(), 'BGS_Cache') ) # cache in tempdir()
    
    # Set a master data table
    data.master <- data.table(df.out$df.tickers)
  }
  
  return(data.master)
}

CalculateStockLogReturns <- function(df.master, symbol) {
  # Calculates the log returns of a stock.
  #
  # Args:
  #   df.stock: Data frame containing stock data
  #   symbol: Symbol of stock to calculate the log returns
  #   
  #
  # Returns:
  #   A data frame containing daily log returns for stock symbol.
  
  # Error Handling
  if (is.null(df.master) || length(df.master) < 0) {
    stop("The stock dataframe is null or empty", call = TRUE)
  }
  
  if(is.null(symbol)) {
    stop("The stock symbol is null or empty", call = TRUE)
  }
  
  df.selected.symbol <- data.master[ticker ==  symbol]
  
  df.selected.symbol[,log.return := round(log(price.close / price.open),4)]

  return(df.selected.symbol)
}

CalculateConfidenceIntervalsMean <- function(df.stock, conf.level) {
  # Given a confidence level calculates the confidence intervals for the mean
  # Args:
  #   df.logreturns: Data frame containing stock log-return data
  #   conf.level: The confidence interval to use
  #
  # Returns:
  #   Vector with confidence interval for the mean
  
  # Error Handling
  if (is.null(df.stock) || length(df.stock) < 0) {
    stop("The stock dataframe is null or empty", call = TRUE)
  }
  
  if (is.null(conf.level) || length(conf.level) < 0) {
    stop("The confidence interval is null or empty", call = TRUE)
  }
  
  # Set the vector of log.returns
  df.log.return <- df.stock$log.return
  
  # Calculate the confidence interval for the mean
  conf.int <- t.test(df.log.return, conf.level = conf.level)$conf.int
  
  # Set a vector with the lower and upper confidence interval points
  ci <- c(lower.ci = conf.int[1], upper.ci = conf.int[2])
  
  return (ci)
}

CalculateConfidenceIntervalsVariance <- function(df.stock, conf.level) {
  # Given a confidence level calculates the confidence intervals for the variance
  # Args:
  #   df.stock: Data frame containing stock log-return data
  #   conf.level: The confidence interval to use
  #
  # Returns:
  #   Vector with confidence interval for the mean
  
  # Error Handling
  if (is.null(df.stock) || length(df.stock) < 0) {
    stop("The stock dataframe is null or empty", call = TRUE)
  }
  
  if (is.null(conf.level) || length(conf.level) < 0) {
    stop("The confidence interval is null or empty", call = TRUE)
  }
  
  # Set the vector of log.returns
  df.log.return <- df.stock$log.return
  
  # Set degrees of freedom
  df <- length(df.log.return) - 1
  
  # Calculate the variance
  var.log.return <- var(df.log.return)
  
  #Use the fact that (n−1) * S^2 / σ2 ∼ χn−1 to calculate the confidence interval
 
  # Calculate the alpha
  alpha = 1 - conf.level
  
  # Calculate the lower and upper confidence interval points
  lower.ci <- (var.log.return * df) / qchisq(alpha / 2, df, lower.tail = FALSE)
  upper.ci <- (var.log.return * df) / qchisq( (1 - (alpha / 2)), df, lower.tail = FALSE)
  
  # Set a vector with the lower and upper confidence interval points and
  # also the variance of the log returns
  ci.var <- c(lower.ci = lower.ci, variance = var.log.return, upper.ci = upper.ci)
  
  return (ci.var)
}

CalculatePopulationMeansEquality <- function(df.stock1, df.stock2, symbol1, symbol2, conf.level) {
  
  # Performs single stock analysis 
  #
  # Args:
  #   df.stock1: The 1st Data frame containing stock log-return data
  #   df.stock2: The 1st Data frame containing stock log-return data
  #   symbol1: 1st Symbol of stock to calculate the log returns
  #   symbol2: 1st Symbol of stock to calculate the log returns
  #
  # Returns:
  #   None
  
  # Default isPopulationMeanEqual to FALSE. 
  # Assume Ho rejected and ux not equal to uy or Ha true
  isPopulationMeanEqual = FALSE
  
  # Calculate the number of obs, sample mean, and sample variance of stock1
  stock1.log.return.obs <- length(df.stock1$log.return)
  stock1.log.return.mean <- round(mean(df.stock1$log.return),4)
  stock1.log.return.var <- round(var(df.stock1$log.return),4)
  
  # Calculate the number of obs,sample mean, and sample variance of stock2  
  stock2.log.return.obs <- length(df.stock2$log.return) 
  stock2.log.return.mean <- round(mean(df.stock2$log.return),4)
  stock2.log.return.var <- round(var(df.stock2$log.return),4)
  
  # Sample Mean difference (xbar - ybar)
  mean.diff = stock1.log.return.mean - stock2.log.return.mean
  print(paste("Mean difference (Xbar - Ybar) = ", mean.diff, sep = " "))
  
  # Set degrees of freedom
  df <- (stock1.log.return.obs + stock2.log.return.obs) - 2
  print(paste("Degrees of freedom (df) = ", df, sep = " "))
  
  # Calculate the pooled estimator
  pooled.estimator = ((stock1.log.return.obs - 1) * stock1.log.return.var)
                      + ((stock2.log.return.obs - 1) * stock2.log.return.var) / df
  
  print(paste("Pooled estimator (Sp^2) = ", pooled.estimator, sep = " "))

  # Calculate the MSE ..
  mse = round(sqrt(pooled.estimator) * sqrt( 1 / stock1.log.return.obs 
                                             + 1 / stock2.log.return.obs ),4)
  
  print(paste("Mean squared error (MSE) = ", mse, sep = " "))
  
  # Calculate T-statistic
  t.statistic = round(abs(mean.diff / mse),4)
  print(paste("T statistic (t) = ", t.statistic, sep = " "))
  
  # Calculate p-value
  p.value <- round(pt(t.statistic,df), 4)
  print(paste("P value = ", p.value, sep = ""))
  
  # Calculate the alpha
  alpha = 1 - conf.level
  print(paste("Alpha = ", alpha, sep = ""))
  
  # Test null hypothesis (ux == uy)
  if(alpha < p.value) {
    #Accept Ho
    isPopulationMeanEqual = TRUE
  }

  return (isPopulationMeanEqual)
}

DoSingleStockAnalysis <- function(df.stock, symbol, conf.level) {
  # Performs single stock analysis 
  #
  # Args:
  #   df.stock: Data frame containing stock log-return data
  #   symbol: Symbol of stock to calculate the log returns
  #   conf.level: The confidence interval to use
  #
  # Returns:
  #   None
  
  # Error Handling
  if (is.null(df.stock) || length(df.stock) < 0) {
    stop("The stock dataframe is null or empty", call = TRUE)
  }
  
  if(is.null(symbol)) {
    stop("The stock symbol is null or empty", call = TRUE)
  }

  #Calculate the confidence interval for mean
  ci.mean <- CalculateConfidenceIntervalsMean(df.stock,conf.level)
  
  # Log Calculate the confidence interval for mean
  print(paste("*******Summary of Stock Confidence interval for mean *******", sep = " "))
  print(ci.mean)
  
  #Calculate the confidence interval for variance
  ci.var <- CalculateConfidenceIntervalsVariance(df.stock,conf.level)
  
  # Log Calculate the confidence interval for mean
  print(paste("*******Summary of Stock Confidence interval for variance *******", sep = " "))
  print(ci.var)
 
  # Clear plotting area
  par(mar=c(5,5,5,5))
  
  #Create plotting areas
  par(mfrow=c(2,3))
  
  #Utiliz a runs test for determining non-randomness
  print(runs.test(df.stock$log.return))
  
  #Plot histogram of stock log returns
  PlotHistogram(df.stock,symbol)
  
  #Plot normal distr
  PlotNorm(df.stock,symbol,ci.mean,ci.var)
  
  #Plot regression
  PlotSimpleRegression(df.stock,symbol)
}

DoMultipleStockAnalysis <- function(df.stock1, df.stock2, symbol1, symbol2, conf.level) {
  # Performs single stock analysis 
  #
  # Args:
  #   df.stock1: The 1st Data frame containing stock log-return data
  #   df.stock2: The 1st Data frame containing stock log-return data
  #   symbol1: 1st Symbol of stock to calculate the log returns
  #   symbol2: 1st Symbol of stock to calculate the log returns
  #   conf.level: The confidence interval to use
  #
  # Returns:
  #   None
  
  # Error Handling
  if (is.null(df.stock1) || length(df.stock1) < 0) {
    stop("The 1st stock dataframe is null or empty", call = TRUE)
  }
  
  if (is.null(df.stock2) || length(df.stock2) < 0) {
    stop("The 2nd stock dataframe is null or empty", call = TRUE)
  }
  
  if(is.null(symbol1)) {
    stop("The 1st stock symbol is null or empty", call = TRUE)
  }
  
  if(is.null(symbol2)) {
    stop("The 2nd stock symbol is null or empty", call = TRUE)
  }
  
  # Clear plotting area
  par(mar=c(5,5,5,5))
  
  #Create plotting areas
  par(mfrow=c(2,2))
  
  #Test the equality of the two population means (use a test for paired data if appropriate)
  isPopulationMeanEqual <- CalculatePopulationMeansEquality(df.stock1, df.stock2, symbol1, symbol2,conf.level)
  
  #Plot the regression of one log-return on the other
  PlotMultipleRegression(df.stock1, df.stock2, symbol1, symbol2)
  
  # Log Multiple Stock Analysis Population Mean Equality Test
  print(paste("*******Summaries of Stock1 and Stock2 -", symbol1, symbol2, " *******", sep = " "))
  print(symbol1)
  print(summary(df.stock1$log.return))
  print(symbol2)
  print(summary(df.stock2$log.return))

  print(paste("*******Population Mean Equality Check Summary -", symbol1, symbol2, " *******", sep = " "))
  print(paste("Population means of ", symbol1, " and ", symbol2, " are equal ? ", isPopulationMeanEqual,  sep = " "))
  
}

############################################################
# Plotting Functions                                       #                                                     
############################################################
PlotHistogram <- function(df.stock, symbol) {
  # Plots the Histrogram of a Single Stock
  #
  # Args:
  #   df.stock: Data frame containing stock log-return data
  #   symbol: Symbol of stock to calculate the log returns
  #
  # Returns:
  #   None
  
  # Error Handling
  if (is.null(df.stock) || length(df.stock) < 0) {
    stop("The stock dataframe is null or empty", call = TRUE)
  }
  
  if(is.null(symbol)) {
    stop("The stock symbol is null or empty", call = TRUE)
  }
  
  # Set the vector of log.returns
  df.log.return <- df.stock$log.return
  
  # Plot the histogram
  hist(df.log.return, main=paste("Histogram - ",symbol, sep=" " )
       , freq = FALSE
       , xlab = paste(symbol, "Log Return", sep = " ")
       , col = "lightblue"
       )
  
  # Calculate the mean and standard deviation
  log.return.mean <- mean(df.log.return) 
  log.return.sd <- sd(df.log.return)
  
  ##Add a normal curve to the plot
  curve(dnorm(x, mean = log.return.mean, sd = log.return.sd),
          add=TRUE,
          col="darkblue",
          lwd=2) 
}

PlotSimpleRegression <- function(df.stock, symbol) {
  # Calculates and Plots a Simple Regression of a Single Stock
  #
  # Args:
  #   df.stock: Data frame containing stock log-return data
  #   symbol: Symbol of stock to calculate the log returns
  #
  # Returns:
  #   None
  
  # Error Handling
  if (is.null(df.stock) || length(df.stock) < 0) {
    stop("The stock dataframe is null or empty", call = TRUE)
  }
  
  if(is.null(symbol)) {
    stop("The stock symbol is null or empty", call = TRUE)
  }
  
  # Set the vector of stock reference dates
  df.ref.date <- df.stock$ref.date
  
  # Set the vector of log.returns
  df.log.return <- df.stock$log.return
  
  # Get the regression and coefficients
  stock.regression <- lm(df.log.return ~ df.ref.date)
  stock.regression.coeff <- summary(stock.regression)$coef
  
  # Get the analysis of the regression table
  anova.stock.regression <- anova(stock.regression)
  
  # Get the sum of squares
  anova.stock.sum.squares <- anova.stock.regression$`Sum Sq`
  
  # Plot the Q-Q
  qqnorm(resid(stock.regression))
  qqline(resid(stock.regression))
  
  # Plot 
  plot(df.log.return ~ df.ref.date,bty="l",
       main=paste("Stock Log Return vs Reference Date -", symbol, sep = " "), 
       ylab=paste(symbol, "Log Return", sep = " "), 
       xlab="Reference Date",
       pch=19)
  
  # Add a line to show regression
  abline(stock.regression, lty=1, lwd=2,col="red")
  
  #Plot the fitted regression residuals and standards
  plot(fitted(stock.regression),resid(stock.regression),
       main=paste("Residuals vs Fitted Log Return -", symbol, sep = " "), 
       ylab="Residuals", 
       xlab="Fitted Log Return")
  
  plot(fitted(stock.regression),rstandard(stock.regression),
       main=paste("RStandard vs Fitted Log Return -", symbol, sep = " "), 
       ylab="RStandard", 
       xlab="Fitted Log Return")
  
  # Log Coefficients Summary to Standard Out
  print(paste("*******Linear Regression Summary -", symbol, " *******", sep = " "))
  print("Summary ")
  print(summary(stock.regression))
  print("Coefficients ")
  print(stock.regression.coeff)
  
}

PlotMultipleRegression <- function(df.stock1, df.stock2, symbol1, symbol2) {
  # Calculates and Plots a Simple Regression of a Single Stock
  #
  # Args:
  #   df.stock1: The 1st Data frame containing stock log-return data
  #   df.stock2: The 1st Data frame containing stock log-return data
  #   symbol1: 1st Symbol of stock to calculate the log returns
  #   symbol2: 1st Symbol of stock to calculate the log returns
  #
  # Returns:
  #   None
  
  # Error Handling
  if (is.null(df.stock1) || length(df.stock1) < 0) {
    stop("The 1st stock dataframe is null or empty", call = TRUE)
  }
  
  if (is.null(df.stock2) || length(df.stock2) < 0) {
    stop("The 2nd stock dataframe is null or empty", call = TRUE)
  }
  
  if(is.null(symbol1)) {
    stop("The 1st stock symbol is null or empty", call = TRUE)
  }
  
  if(is.null(symbol2)) {
    stop("The 2nd stock symbol is null or empty", call = TRUE)
  }
  
  # Set the x and y variables
  stock1.log.return <- df.stock1$log.return
  stock2.log.return <- df.stock2$log.return
  
  # Get the regression and coefficients
  stock.multiple.regression <- lm(stock1.log.return  ~ stock2.log.return)
  stock.multiple.regression.coeff <- summary(stock.multiple.regression)$coef
  
  # Get the analysis of the regression table
  anova.stock.multiple.regression <- anova(stock.multiple.regression)
  
  # Get the sum of squares
  anova.stock.sum.squares <- anova.stock.multiple.regression$`Sum Sq`
  
  # Plot the Q-Q
  qqnorm(resid(stock.multiple.regression))
  qqline(resid(stock.multiple.regression))
  
  # Plot 
  plot(stock1.log.return  ~ stock2.log.return,bty="l",
       main=paste("Stock 1 Log Return vs Stock 2 Log Return -", symbol1,  " - " , symbol2, sep = " "), 
       xlab=paste(symbol1, "Log Returns", sep = " "),
       ylab=paste(symbol2, "Log Returns", sep = " "), 
       pch=19)
  
  # Add a line to show regression
  abline(stock.multiple.regression, lty=1, lwd=2,col="red")
  
  #Plot the fitted regression residuals and standards
  plot(fitted(stock.multiple.regression),resid(stock.multiple.regression),
       main=paste("Residuals vs Fitted Log Return -", symbol1, " - " ,symbol2, sep = " "),
       xlab="Fitted Log Return",
       ylab="Residuals")
  
  plot(fitted(stock.multiple.regression),rstandard(stock.multiple.regression),
       main=paste("RStandard vs Fitted Log Return -", symbol1,  " - " , symbol2, sep = " "), 
       xlab="Fitted Log Return",
       ylab="RStandard")
  
  # Log Coefficients Summary to Standard Out
  print(paste("*******Linear Multiple Regression Summary -", symbol1, " - " , symbol2, " *******", sep = " "))
  print("Summary ")
  print(summary(stock.multiple.regression))
  print("Coefficients ")
  print(stock.multiple.regression.coeff)
  
  
  
}

PlotNorm <- function(df.stock, symbol,ci.mean,ci.var) {
  # Plots the Normal Probability of a Single Stock to see if the data is approximately normal
  # Args:
  #   df.stock: Data frame containing stock log-return data
  #   symbol: Symbol of stock to calculate the log returns
  #
  # Returns:
  #   None
  
  # Error Handling
  if (is.null(df.stock) || length(df.stock) < 0) {
    stop("The stock dataframe is null or empty", call = TRUE)
  }
  
  if (is.null(ci.mean) || length(ci.mean) < 0) {
    stop("The confidence interval for the mean is null or empty", call = TRUE)
  }
  
  if (is.null(ci.var) || length(ci.var) < 0) {
    stop("The confidence interval for the variance is null or empty", call = TRUE)
  }
  
  # Set the vector of log.returns
  df.log.return <- df.stock$log.return
  
  # Calculate the mean and standard deviation
  log.return.mean <- mean(df.log.return) 
  log.return.sd <- sd(df.log.return)
  
  #Plot the Standard Normal Distribution of the Log return
  plot(df.log.return, dnorm(df.log.return, mean = log.return.mean, sd = log.return.sd), 
       main=paste("Normal Distribution", symbol, sep = " "), 
       ylab="Density", 
       xlab="Log Return",
       type='p')
  
  # Log Normal Distribution Summary to Standard Out
  print(paste("*******Normal Distribution Plot Summary -", symbol, " *******", sep = " "))
  print(paste("mean = ", round(log.return.mean,4)))
  print(paste("std.dev = ", round(log.return.sd,4)))
}

############################################################
# Utility Functions                                        #                                                     
############################################################
is.not.null = function(x) {
  # Determine if object is not null
  #
  # Args:
  #   x: Object to check if null
  #
  # Returns:
  #   True if the object is not null false otherwise
  
  return (!is.null(x))
}