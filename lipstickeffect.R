##### Code for illustrating the predicting stock returns
##### based on the performance of beauty and cosmetic stocks
##### written by Jude Ken-Kwofie

#### To run the lip effect analysis, simple click on "Source" in the upper right hand corner.

#Source Project Files
source("core.R") 

############################################################
# Set Values                                              #                                                     
############################################################
start.date <- as.Date("2007-12-01")

end.date <- as.Date("2009-06-30")
freq.data <- 'daily'

tickers <- c('SPY','LRLCY','EL','SSDOY','COTY','NUS','IPAR'
             ,'REV','AVP','ELF')

df.master <- DownloadStockFinancialData(tickers, start.date, end.date, freq.data)

conf.level <- 0.95

############################################################
# Calculate log-returns                                    #           
# Defined as log(t) = Sclose(t) / Sopen(t)                 #                                      
############################################################
df.spy <- CalculateStockLogReturns(df.master, "SPY")
df.lrlcy <- CalculateStockLogReturns(df.master, "LRLCY")
df.el <- CalculateStockLogReturns(df.master, "EL")
df.ssdoy <- CalculateStockLogReturns(df.master, "SSDOY")
df.coty <- CalculateStockLogReturns(df.master, "COTY")
df.nus <- CalculateStockLogReturns(df.master, "NUS")
df.ipar <- CalculateStockLogReturns(df.master, "IPAR")
df.rev <- CalculateStockLogReturns(df.master, "REV")
df.avp <- CalculateStockLogReturns(df.master, "AVP")
df.elf <- CalculateStockLogReturns(df.master, "ELF")
df.amzn <- CalculateStockLogReturns(df.master, "AMZN")
df.wmt <- CalculateStockLogReturns(df.master, "WMT")
df.ul <- CalculateStockLogReturns(df.master, "UL")
df.cvs <- CalculateStockLogReturns(df.master, "CVS")
df.wba <- CalculateStockLogReturns(df.master, "WBA")
df.tgt <- CalculateStockLogReturns(df.master, "TGT")
df.ulta <- CalculateStockLogReturns(df.master, "ULTA")
df.m <- CalculateStockLogReturns(df.master, "M")

############################################################
# Do Single Stock Analysis                                 #                                      
############################################################
DoSingleStockAnalysis(df.spy, "SPY", conf.level)
DoSingleStockAnalysis(df.lrlcy, "LRLCY", conf.level)
DoSingleStockAnalysis(df.el, "EL", conf.level)
DoSingleStockAnalysis(df.ssdoy, "SSDOY", conf.level)
#DoSingleStockAnalysis(df.coty, "COTY", conf.level) 
DoSingleStockAnalysis(df.nus, "NUS", conf.level)
DoSingleStockAnalysis(df.ipar, "IPAR", conf.level)
DoSingleStockAnalysis(df.rev, "REV", conf.level)
DoSingleStockAnalysis(df.avp, "AVP", conf.level)
#DoSingleStockAnalysis(df.elf, "ELF", conf.level)

############################################################
# Do Multiple Stock Analysis                               #                                      
############################################################
DoMultipleStockAnalysis(df.lrlcy,df.spy,"LRLCY","SPY", conf.level)
DoMultipleStockAnalysis(df.el,df.spy,"EL","SPY", conf.level)
DoMultipleStockAnalysis(df.ssdoy,df.spy,"SSDOY","SPY", conf.level)
#DoMultipleStockAnalysis(df.coty,df.spy,"COTY","SPY", conf.level)
DoMultipleStockAnalysis(df.nus,df.spy,"NUS","SPY", conf.level)
DoMultipleStockAnalysis(df.ipar,df.spy,"IPAR","SPY", conf.level)
DoMultipleStockAnalysis(df.rev,df.spy,"REV","SPY", conf.level)
DoMultipleStockAnalysis(df.avp,df.spy,"AVP","SPY", conf.level)
#DoMultipleStockAnalysis(df.elf,df.spy,"ELF","SPY", conf.level)
