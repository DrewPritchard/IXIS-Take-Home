# install and load packages
install.packages('tidyverse')
install.packages('openxlsx')

library(tidyverse)
library(openxlsx)

addsToCart = read.csv("./DataAnalyst_Ecom_data_addsToCart.csv")

sessionCounts = read.csv('./DataAnalyst_Ecom_data_sessionCounts.csv')



##### Create Monthly * Device table #####

# set dim_date col to date variable
sessionCounts$dim_date = sessionCounts$dim_date %>% as.Date(format = '%m/%d/%y')

# create month for monthly level group by
sessionCounts$month_start = lubridate::floor_date(sessionCounts$dim_date, 'month')

# summarize data on Month * Device level
MonthlyDeviceSummary = sessionCounts %>% group_by(dim_deviceCategory, month_start) %>% summarise(across(c(sessions, transactions, QTY), sum))

# create ECR(transactions/sessions) column
MonthlyDeviceSummary$ECR = round(MonthlyDeviceSummary$transactions/ MonthlyDeviceSummary$sessions,4)




##### Create MoM comparison #####

# create a start_month var to use as a key
addsToCart$month_start = make_date(year = addsToCart$dim_year, month = addsToCart$dim_month)

# create a MoM df and then append addToCart monthly values
GASummaryMoM = sessionCounts %>% group_by(month_start) %>% summarise(across(c(sessions, transactions, QTY), sum))
GASummaryMoM = merge(addsToCart, GASummaryMoM)
GASummaryMoM = GASummaryMoM %>% mutate(ECR = transactions/sessions)


# use lag to get prior month value
GASummaryMoM = GASummaryMoM %>% mutate(prior_month = lag(month_start),
                                       prior_sessions = lag(sessions),
                                       prior_transactions = lag(transactions),
                                       prior_QTY = lag(QTY),
                                       prior_ECR = lag(ECR),
                                       prior_addsToCart = lag(addsToCart))


# Absolute diff and % shift MoM
GASummaryMoM = GASummaryMoM %>% mutate(MoM_diff_sessions = sessions - prior_sessions,
                                                       MoM_shift_sessions = (MoM_diff_sessions/prior_sessions) %>% round(4),
                                                       MoM_diff_transactions = transactions - prior_transactions,
                                                       MoM_shift_transactions = (MoM_diff_transactions/prior_transactions) %>% round(4),
                                                       MoM_diff_QTY = QTY - prior_QTY,
                                                       MoM_shift_QTY = (MoM_diff_QTY/prior_QTY) %>% round(4),
                                                       MoM_diff_ECR = ECR - prior_ECR,
                                                       MoM_shift_ECR = (MoM_diff_ECR/prior_ECR) %>% round(4),
                                       MoM_diff_addsToCart = addsToCart - prior_addsToCart,
                                       MoM_shift_addsToCart = (MoM_diff_addsToCart/prior_addsToCart) %>% round(4))


# Only get most recent 2 months values
GASummaryMoM_2mo = GASummaryMoM %>% filter(month_start == max(GASummaryMoM$month_start) | month_start == max(GASummaryMoM$month_start) - months(1))



# write to xlsx file as two sheets
names <- list('MonthlyDeviceSummary' = MonthlyDeviceSummary, 'GASummaryMoM_2mo' = GASummaryMoM_2mo)
openxlsx::write.xlsx(names, file = 'GA_Ecommerce_Analysis.xlsx')
