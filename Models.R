library(tidyverse)
data = read_csv

#Adjusted model for mortality
logit <- glm(discharge ~ anchor_year_group + gender + Age + Charlson + SOFA + Renal_replacement + Pressor + InvasiveV, data = data, family = "binomial"(link=logit))
summary(logit)

#Adjusted model for RRT
logit <- glm(Renal_replacement ~ anchor_year_group + gender + Age + Charlson + SOFA, data = data, family = "binomial"(link=logit))
summary(logit)

#Adjusted model for Pressor
logit <- glm(Pressor ~ anchor_year_group + gender + Age + Charlson + SOFA, data = data, family = "binomial"(link=logit))
summary(logit)

#Adjusted model for Ventilation
logit <- glm(InvasiveV ~ anchor_year_group + gender + Age + Charlson + SOFA, data = data, family = "binomial"(link=logit))
summary(logit)