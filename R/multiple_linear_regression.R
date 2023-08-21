library(plyr)
library(dplyr)
library(ggplot2)
library(car)
library(mltools)
library(data.table)
library(olsrr)
getwd()
setwd('/Users/stevenschindler/Documents/R/D208')
df <- read.csv('clean_churn_file.csv', header = TRUE)
head(df)

summary(df$Outage_sec_perweek)
summary(df$Area)
summary(df$Yearly_equip_failure)
summary(df$InternetService)
summary(df$Population)
summary(df$Bandwidth_GB_Year)
summary(df$Tenure)


hist(df$Outage_sec_perweek)
hist(df$Yearly_equip_failure)
hist(df$Population)
hist(df$Bandwidth_GB_Year)
hist(df$Tenure)



#factor InternetService and area
df$InternetService <- as.factor(df$InternetService)
df$Area <- as.factor(df$Area)

Area <- table(df$Area)
InternetService <- table(df$InternetService)

barplot(Area)
barplot(InternetService)

# bivariate graphs
dsl_vs_out <- table(df$Outage_sec_perweek, df$InternetService)
barplot(dsl_vs_out, main="Outage_sec_perweek VS InternetService",
        xlab="Internet Service")
yearly_vs_out <- table(df$Outage_sec_perweek, df$Yearly_equip_failure)
barplot(yearly_vs_out, main="Outage_sec_perweek VS Yearly_equip_failure",
        xlab="Yearly_equip_failure")
area_vs_out <- table(df$Outage_sec_perweek, df$Area)
barplot(area_vs_out, main="Outage_sec_perweek VS Area",
        xlab="Area")

plot(df$Bandwidth_GB_Year, df$Outage_sec_perweek, main="Outage_sec_perweek VS Bandwidth_GB_Year",
     xlab="Bandwidth ", ylab="Outage_sec_perweek", pch=19) 

plot(df$Population, df$Outage_sec_perweek, main="Outage_sec_perweek VS Population",
     xlab="Population ", ylab="Outage_sec_perweek", pch=19) 

plot(df$Tenure, df$Outage_sec_perweek, main="Outage_sec_perweek VS Tenure",
     xlab="Tenure ", ylab="Outage_sec_perweek", pch=19) 

# One-Hot-Encoding

new_df <- one_hot(as.data.table(df))
head(new_df)

write.csv(new_df, "new_churn_clean.csv", row.names=FALSE)

new_df <- new_df %>% rename("InternetService_Fiber_Optic" = "InternetService_Fiber Optic")

model <- lm(formula = Outage_sec_perweek ~ Yearly_equip_failure + Population + 
              Bandwidth_GB_Year + InternetService_DSL + InternetService_Fiber_Optic + 
              Area_Rural + Area_Urban  + Tenure, data = new_df )
model
summary(model)
vif(model)
ols_step_backward_p(model)




qqnorm(resid(model))
qqline(resid(model),col ="yellow")

new_model <- lm(formula = Outage_sec_perweek ~ Bandwidth_GB_Year + InternetService_DSL, data = new_df)
summary(new_model)
vif(new_model)



AIC(model)
AIC(new_model)
BIC(model)
BIC(new_model)

plot(fitted(new_model),resid(new_model))
abline(0,0,col = "yellow")

qqnorm(resid(new_model))
qqline(resid(new_model),col ="yellow")

R.Version()
