# THE “LIPSTICK EFFECT” AND PREDICTING STOCK MARKET RETURNS

There are several sophisticated investment strategies and economic indicators that are used to predict stock returns and the general health of the US economy. Strategies like <> consist of several areas of complexity and analysis by leading financial and investment strategist and are studied rigorously in the academia and in professional settings. There are also a set of economic indicators that are considered superstitious or not based in traditional belief or imprecise measures of market trends. 

My wife is in the beauty industry and has always asked me to do some analysis to help her out. So, I decided one weekend to investigate one such economic indicator - “The Lipstick Effect”. The goal is to to find evidence if beauty indulgences can predict stock returns, overall US economic health, and consumer confidence. The Lipstick Effect or Indicator suggests that consumers purchase less expensive business products when they feel unsure of the future of the economy. The Lipstick Effect is a theory that when economic times are tough, consumers stop spending on big-ticket items, but actually increase their spending on smaller indulgences.

The following analysis was performed to investigate statistically the investment and economic predictive power of beauty industry stocks: 

* Observed and analyzed the log-returns of major beauty stocks.
* Compared pairs of stocks to determine whether they had similar log-returns and observed their correlation.
* Determined if the stock performance of the beauty businesses like, Estee Lauder can indicate an oncoming recession or period of diminished consumer confidence. 

## Getting Started

### RStudio

Files
* lipstick_effect.Rproj – This file serves as a shortcut for opening the project directly from the filesystem.
* core.R – This file contains the packages, libraries, and functions for running the lipstick effect analysis.
* lipstickeffect.R – This file contains the lipstick effect analysis and imports core.R. Performing the Analysis
*  To run the lip stick effect program, please do the following:

### Prerequisites

* RStudio (latest)

### Installing

1. Click on the filename – ‘lipstick_effect.Rproj’
	* RStudio will open.
	*  The files core.R and lipstickeffect.R should be visible within Rstudio.
2. Select the file lipstickeffect.R.
3. Click on the ‘Source’ button on the right-hand side of the dialog. This first
imports core.R, installs all the required packages, and runs the analysis.
4. View the series of plots to see normal distributions, quantile-quantile plots, and
more.

## Plots

![SPY ETF - Normality](https://github.com/j2k850/lipstick_effect/blob/master/SPY.png)
![EL ETF - Normality](https://github.com/j2k850/lipstick_effect/blob/master/EL.png)
![EL ETF - Normality 2](https://github.com/j2k850/lipstick_effect/blob/master/EL_normality.png)

## Dataset 

The data set consists of the daily stock prices of beauty businesses and conglomerates that primarily generate sales or obtain a portion of their sales from retailing beauty-related products. 

The period of investigation is November 8th 2016 to November 6th,2018. A total of 396 data points were collected for each stock. The daily stock prices were taken from Yahoo Finance. 

The stock ticker symbol SPY is used as a proxy for the overall performance of the U.S. Stock Market.

The stocks and the companies represented in the data set are as follows:

| No.           | Company Name  | Stock Ticker          | Exchange      | Industry      | Market Capitalization|
| ------------- |:-------------:| -----:| -------------:| -------------:| -------------:| 
| 1.            | L'Oréal S.A.  |  LRLCY| Other OTC| Household & Personal Products|114.868|
| 2.            | The Estée Lauder Companies Inc.  |  EL| New York Stock Exchange| Household & Personal Products|51.199B|
| 3.            | Shiseido Company, Limited  |  SSDOY| Other OTC| Household & Personal Products|24.493B|
| 4.            | Coty Inc.  | COTY` | New York Stock Exchange| Household & Personal Products|6.497B|
| 5.            | Nu Skin Enterprises, Inc.  |  NUS| New York Stock Exchange| Household & Personal Products|3.606B|
| 6.            | Inter Parfums, Inc. (IPAR)  |  IPAR| NASDAQ Global Market| Household & Personal Products|1.927B|
| 7.            | Revlon, Inc.  |  REV| New York Stock Exchange| Household & Personal Products|1.536B|
| 8.            | Avon Products, Inc.  |  AVP| New York Stock Exchange| Household & Personal Products|889.144M|
| 9.            | e.l.f. Beauty, Inc.  |  ELF| New York Stock Exchange| Household & Personal Products|615.733M|

## Goals

The horrible effects of the Great Recession of 2008, which lasted from December 2007 to June 2009,  in the United States and in Western Europe led to total financial market chaos, major cutbacks in consumer spending and massive job loss. It started with a 8 trillion dollar housing bubble, which led to a U.S. labor market lost 8.4 million jobs, or 6.1% of all payroll employment. Since, we have experienced the longest-running bull market on record (e.g., 9 years) since World War II, with a market rise of more than 300% 

Despite claims that the longest running bull rally will continue, several experts suspect that a major bear run is looming. Therefore, I believe working to find statistically evidence of the “Lipstick Effect” can aid in:
* Making an informed decision on the direction of the markets regarding 
* Deciding whether or not to invest in the market and with which stocks and at what time to invest in
* And, perhaps protect readers from the negative effects of bear market rallies like the Great Recession.

With this goal in mind, I investigated a set of questions involving the log-returns of beauty stocks. 
To carry-out the statistical analysis, the following questions were raised:
* If the beauty stocks log-returns were in line with a random sample,
* If the beauty stocks were distributed normally,
* Analyzing statistical parameters like the log-returns mean and variance, if the beauty stocks performed well during the investigation period,
* If there are any general indication or observations that suggest the theory of the Lipstick Effect,
* And, when comparing stocks, if they were correlated and if there were similar patterns in movements by looking at the log-returns means and determining if they were equal.

## Analysis

### Single Stock Analysis

I used the runs test of the randtest package to determine if the stock log-returns were from a random sample. The null hypothesis is the elements in the data set are mutually independent and therefore the data is consistent with a random sample. The alternative hypothesis is the elements in the data set are not mutually independent and therefore the data isn’t consistent with a random sample.

**Runs Test for Determining Non-Randomness**

|  Stock       |  P-Value       | 
| ------------- |:-------------:| 
| SPY      | 0.4812 		| 
| LRLCY    | 0.07253		| 
| EL       | 0.9198		| 
| SSDOY    | 0.4388 		| 
| COTY     | Error w/ download  | 
| NUS      | 0.2683  		| 
| IPAR     | 0.7627  		| 
| REV      | 0.0857  		| 
| AVP      | 0.5104  		| 
| ELF      | Error w/ download	| 


All the stocks had a P-value greater than 0.05. Thus the null hypothesis was failed to be rejected and it was concluded that these stocks were consistent with a random sample.
Histograms and normal Q-Q  of each stock log-returns were created to determine if the stock log-returns came from a normal distribution. 	In normal Q-Q plots, the number of quantiles is selected to match the size of the sample data. Analysis of the histograms and especially the Q-Q plots showed that there were not any significant inconsistencies with the frequency distributions nor the linearity of the Q-Q plots. Thus, it was concluded that the stock log-returns came from a normal distribution.

Statistical testing was performed following the analysis of the randomness and normality of the stock log-returns. To this end, confidence intervals of the beauty stock log-returns’ mean, 𝜇,  and the variance, 𝜎2 were calculated. The t-distribution was used in the determination of the confidence intervals since variances of the normal distribution from which stock log-returns came from were unknown. Thus, the sample standard deviations, n - 1 degrees of freedom, and the chi-squared distribution was used in the calculation of the confidence intervals tabulated here.

**95% Confidence Interval for 𝝁 and 𝝈𝟐**

| Stock        | Variance           | Confidence Interval for 𝝁  | Confidence Interval for 𝝈𝟐|
| ------------- |:-------------:| -----:| ---------------:|
| SPY      | 0.0003756545 | (-0.002686535 ,  0.001143101) | (0.0003283128 ,0.0004340864) |
| LRLCY    | 0.0002142263 | (-0.0006747922, 0.0022172164) | (0.0001872285, 0.0002475485) |
| EL       | 0.0006012978 | (-0.001992529, 0.002852630)   | (0.0005255195, 0.0006948278) |
| SSDOY    | 0.0002582469 | (0.000747213, 0.003922484)    | (0.0002257014, 0.0002984164) |
| COTY     | Error w/ download | | |
| NUS      | 0.0008722067 | (-0.002126049, 0.003709382)   | (0.0007622873, 0.0010078758) |
| IPAR     | 0.002889794  | (-0.007030327, 0.003591438)   | (0.002525609,0.003339292) |
| REV      | 0.003226334  | (-0.009662878 , 0.001560353)  | (0.002819737, 0.003728181) |
| AVP      | 0.0007555131  | (-0.002912245  0.002518811)  | (0.0006602999,0.0008730308) |
| ELF     | Error w/ download | | |

As shown in the above table, the 95% confidence intervals for the mean and the variance were quite small. This shows that the beauty stock log-returns centered around the mean and that there was little variability. 				 	 	 		

Following the confidence interval analyses, linear regressions were performed on each beauty stock log-return versus time. The table below shows the results of the linear regressions.

The R-squared (𝑹𝟐) statistic provides a measure of how well the linear regression model is fitting the actual data. The R-squared results clearly show that there is not a strong linear relationship stock log-returns and time. The R-squared values for the stock log-returns are all close to zero. Analysis of the scatter-plots, stock log-returns vs. reference date, also indicates that there is no correlation between the two parameters. The linear regression models can not be used to predict the future.

**Linear Regression of Log-returns Against Time**

|  Stock        | Bo (Intercept)  | B1 (Slope)  | 𝑹𝟐 |
| ------------- |:-------------:| -----:|-----------:|
| SPY      | -4.596e-02 | 3.197e-06 |0.0007493|
| LRLCY    | -7.611e-02 | 5.438e-06 |0.003802|
| EL       | -9.462e-02 | 6.723e-06 |0.00207|
| SSDOY    | -2.480e-01 | 1.771e-05 |0.03345|
| COTY     | Error w/ download | ||
| NUS      | -1.000e-01 | 7.133e-06 |0.001607|
| IPAR     | 1.818e-02  | -1.408e-06 |1.888e-05|
| REV      | 2.911e-02  | -2.345e-06 |4.696e-05|
| AVP      | -1.319e-01 | 9.315e-06  |0.003163|
| COTY     | Error w/ download | ||

### Two Stock Analysis

The T statistic with unknown variance and the confidence level of 95% was utilized to test the equality of the population means of the stock log-returns. A linear regression was then used to see if there were any similarities. The stock “SPY” was used in all two stock analysis comparisons.

**Two Sample T-test and Linear Regression**

| Stock        | P-Value        | Slope  | R^2 |
| ------------- |:-------------:| -----:|------------:|
| LRLCY        | 0.5319 | 0.4072830 |0.2909|
| EL           | 0.5138 | 0.8374262|0.4381|
| SSDOY        | 0.5503 | 0.3444580|0.1726|
| COTY         | Error w/ download | ||
| NUS          | 0.515 | 0.905031|0.3528|
| IPAR         | 0.5047 | 1.6716246|0.3632|
| REV          | 0.5165 | 0.756221|0.06659|
| AVP          | 0.506  | 0.920979|0.4217|
| ELF         | Error w/ download | ||

The two stock analyses showed that in all cases we failed to reject the null hypothesis of the equality of the population means of the beauty stock log-returns with the SPY stock. The SPY stock is an ETF which follows the S&P 500.  This result does make sense since during the Great Recession of 2008 all stocks were performed badly due to the total financial collapse that lasted from December 2007 to June 2009.

To help distinguish which of the beauty stock log-returns was the best predictor for the economic downturn, linear regressions were performed between the beauty stock log-returns and the log-returns of the SPY ETF. Slopes and R2 values were analyzed to determine the performance of the beauty stock log-returns with the SPY ETF stock. Slopes near 1, are expected to provide log-returns that are approximately similar over the same time period. Also, higher R2  values shows that the returns were more correlated that others.		 	 	 		
				
Analyzing the results, we see that the EL stock has the best slope and the R2 pairing with the AVP stock being second. In addition, the residual plots against time and the residual plots against log-returns demonstrate no obvious patterns, which suggest that a linear regression is the appropriate type of regression for the data.

### Conclusion

The lipstick effect is the theory that when facing an economic crisis consumers will be more willing to buy less costly luxury goods. Instead of buying expensive fur coats, for example, people will buy expensive lipsticks or in general beauty products. For example, there are accounts that lipstick sales doubled after the attacks of 9/11. 	 	 	 		
			
The aim of this work was to find evidence of the “The Lipstick Effect” during the unfortunate period of the Great Recession and see if beauty indulgences can be used to predict bear markets, overall US economic health, and consumer confidence. 

Run tests and analysis of stock log-return normality clearly showed that the selected stocks log returns were normally distributed and consistent with a random sample.

It can also be concluded that future predictions of the beauty stock returns during this period is unreliable and should not be used for investment purposes. Linear regression models of stock log-returns versus time showed clearly show very weak signals of linearity. 

Comparing the beauty stock log returns with the SPY ETF stock show that there was no significant differences in the log returns. Analysis of the slopes and R2 pairings does not show any major trends with the highest slope and R2  pairing being only 0.8374 and 0.4381, respectively. Thus, we can conclude that there is in the cases analyzed we can easily conclude that there is not a strong linear relationship with the beauty stocks and the S&P 500. 

The analyses conducted does not clearly show that the Lipstick Effect can predict that consumers would purchase more beauty or personal care products and thus can be used to foretell market recessions. The sheer enormity of the financial collapse of the Great Recession perhaps caused consumers to forego all “feel good” purchases, thus making it difficult to determine if the “Lipstick Effect” is an old wives tale or something that can be used as a real indication of economic performance. Also, only the stock log-returns were analyzed. The addition of analyzing the company beauty sales could aid in the overall analysis.

The great news is that my wife was elated that I spent my off time to do this analysis and not watch sports for at least one weekend. I have a feeling I will be conducting more of these beauty focused statistical analsyses for my wife.

### References

* My wife
* Beth McKenna, “The Stock Market’s “Lipstick Effect” Has Been Red-Hot By Beth McKenna August 30, 2011 Stocks 101” Go Banking Rates, August 30, 2011		<https://www.gobankingrates.com/investing/stocks/stock-market-lipstick-effect-red-hot/>	
* Business Section, “Lip Reading”,, The Economist,  Jan 22nd 2009 <https://www.economist.com/business/2009/01/22/lip-reading>

