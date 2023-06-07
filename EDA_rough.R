##################################
########### SOME EDA #############
##################################

# 1. any metrics trending together?
  
# 2. metrics trending inversely

# 3. general trends of sessions, transactions, quantity


##### TRENDS BY DEVICE #####
# insight into 

# Transactions
ggplot(data = MonthlyDeviceSummary,
       aes(x = month_start,
           y = transactions,
           color = dim_deviceCategory)) +
  geom_point() +
  geom_smooth(method = "lm")

# Quantity
ggplot(data = MonthlyDeviceSummary,
       aes(x = month_start,
           y = QTY,
           color = dim_deviceCategory)) +
  geom_point() +
  geom_smooth(method = "lm")

# Sessions
ggplot(data = MonthlyDeviceSummary,
       aes(x = month_start,
           y = sessions,
           color = dim_deviceCategory)) +
  geom_point() +
  geom_smooth(method = "lm")


# ECR
ggplot(data = MonthlyDeviceSummary,
       aes(x = month_start,
           y = ECR,
           color = dim_deviceCategory)) +
  geom_point() +
  geom_smooth(method = "lm") +
  ggtitle("ECR Trend by Device")


##### MoM Analysis #####

# average monthly growth for each metric
# insight into which metrics we might want to prioritize for next year

# sessions
ggplot(data = GASummaryMoM,
       aes(x = month_start,
           y = MoM_shift_sessions)) +
  geom_point() +
  geom_smooth(method = "lm")

ggplot(data = GASummaryMoM,
       aes(x = month_start,
           y = MoM_shift_transactions)) +
  geom_point() +
  geom_smooth(method = "lm")


ggplot(data = GASummaryMoM,
       aes(x = month_start,
           y = MoM_shift_QTY)) +
  geom_point() +
  geom_smooth(method = "lm")

ggplot(data = GASummaryMoM,
       aes(x = month_start,
           y = MoM_shift_ECR)) +
  geom_point() +
  geom_smooth(method = "lm")


ggplot(data = GASummaryMoM,
       aes(x = month_start,
           y = MoM_shift_addsToCart)) +
  geom_point() +
  geom_smooth(method = "lm")