library(plyr)
library(dplyr)
library(ggplot2)
library(car)
library(mltools)
library(data.table)
library(DescTools)
library(glmtoolbox)
library(caret)
version
getwd()
setwd('/Users/stevenschindler/Documents/R/D208')
df <- read.csv('clean_churn_file_log.csv', header = TRUE)
head(df)
summary(df$Churn)
summary(df$Outage_sec_perweek)
summary(df$Yearly_equip_failure)
summary(df$Income)
summary(df$Email)
summary(df$Contacts)
summary(df$Techie)
summary(df$Contract)
summary(df$Multiple)
summary(df$Tenure)
summary(df$MonthlyCharge)
summary(df$Bandwidth_GB_Year)



#factor Contract
df$Contract <- as.factor(df$Contract)
Contract <- table(df$Contract)

#convert Yes,No to 1,0
df <- 
  df %>%
  mutate(Churn = revalue(Churn, c("Yes" = 1, "No" = 0)))
df$Churn <- as.numeric(df$Churn)
df <- 
  df %>%
  mutate(Techie = revalue(Techie, c("Yes" = 1, "No" = 0)))
df$Techie <- as.numeric(df$Techie)
df <- 
  df %>%
  mutate(Multiple = revalue(Multiple, c("Yes" = 1, "No" = 0)))
df$Multiple <- as.numeric(df$Multiple)

#onehot eencoding
new_df <- one_hot(as.data.table(df))


new_df <- new_df %>% rename("Contract_Month" = "Contract_Month-to-month")
new_df <- new_df %>% rename("Contract_One_year" = "Contract_One year")

write.csv(new_df, "new_churn_clean_log.csv", row.names=FALSE)
model <- glm(Churn ~ Outage_sec_perweek + Yearly_equip_failure + Income + Email 
             + Contacts + Techie + Contract_Month + Contract_One_year +
             Multiple + Tenure + MonthlyCharge + Bandwidth_GB_Year ,data = new_df,
             family = "binomial")


summary(model)
vif(model)

stepCriterion(model, direction="backward", criterion="p-value")



#null deviance - residual deviance for model
 11564.4 - 4806.6

new_model <- glm(Churn ~ Techie + Contract_Month + MonthlyCharge + Bandwidth_GB_Year,data = new_df,
                 family = "binomial")

summary(new_model)

#null deviance - residual deviance for new_model
 11564.4 - 5771.2

#confusion matrix
pred <- predict(new_model,type="response" )
pred1 <-ifelse(pred > 0.5,1,0)

Churn <- new_df$Churn

confusionMatrix(as.factor(Churn),as.factor(pred1))







#factor Churn,Techie,Multiple
df$Churn <- as.factor(df$Churn)
df$Techie <- as.factor(df$Techie)
df$Multiple <- as.factor(df$Multiple)

Churn <- table(df$Churn)
Churn
Techie <- table(df$Techie)
Multiple <- table(df$Multiple)



#histograms
hist(df$Outage_sec_perweek)
hist(df$Yearly_equip_failure)
hist(df$Income)
hist(df$Email)
hist(df$Bandwidth_GB_Year)
hist(df$Tenure)
hist(df$Contacts)
hist(df$MonthlyCharge)
#barplot
barplot(Churn,main ="Churn")
barplot(Techie,main="Techie")
barplot(Contract,main="Contract")
barplot(Multiple,main="Multiple")


ggplot(df, aes(x = Outage_sec_perweek, y = Churn)) + geom_jitter()
ggplot(df, aes(x = Yearly_equip_failure, y = Churn)) + geom_jitter()
ggplot(df, aes(x = Income , y = Churn)) + geom_jitter()
ggplot(df, aes(x = Email, y = Churn)) + geom_jitter()
ggplot(df, aes(x = Bandwidth_GB_Year, y = Churn)) + geom_jitter()
ggplot(df, aes(x = Tenure, y = Churn)) + geom_jitter()
ggplot(df, aes(x = Contacts, y = Churn)) + geom_jitter()
ggplot(df, aes(x = MonthlyCharge, y = Churn)) + geom_jitter()

ggplot(df, aes(y = Churn, fill = Techie)) + geom_bar(position = "dodge")
ggplot(df, aes(y = Churn, fill = Contract)) + geom_bar(position = "dodge")
ggplot(df, aes(y = Churn, fill = Multiple)) + geom_bar(position = "dodge")

