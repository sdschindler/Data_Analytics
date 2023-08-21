getwd()
library(dplyr)

#set.seed(123)
df <- read.csv('churn_clean.csv', header = TRUE)

churn<-df$Churn
contract<-df$Contract
chisq.test(contract, churn)





