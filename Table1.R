library(tidyverse)
library(table1)
library(dplyr)

df = read_csv('study_cohort.csv')
final_df = df
final_df$ethnicity_new = final_df$ethnicity
final_df$ethnicity_new[final_df$ethnicity == 'OTHER' 
                       | final_df$ethnicity == 'UNABLE TO OBTAIN'
                       | final_df$ethnicity == 'UNKNOWN'
                       | final_df$ethnicity == 'AMERICAN INDIAN/ALASKA NATIVE'] <- "OTHER"

final_df$dis_loc_new = final_df$discharge_location
final_df$dis_loc_new[final_df$discharge_location == "DIED"
                     | final_df$discharge_location == "HOSPICE"] <- "DIED"

final_df$pressor_lab = final_df$pressor
final_df$pressor_lab[final_df$pressor == 'TRUE'] <- "Yes"
final_df$pressor_lab[is.na(final_df$pressor)] <- "No"

final_df$rrt_new = final_df$rrt
final_df$rrt_new[final_df$rrt == 1] <- "Yes"
final_df$rrt_new[is.na(final_df$rrt)] <- "No"

final_df$vent_req[is.na(final_df$InvasiveVent_hr)] <- "No"
final_df$vent_req[!is.na(final_df$InvasiveVent_hr)] <- "Yes"


# 18-34;; 35-44;; 45-54;; 55-64;; 65-74; 75-84; 85 and higher
final_df$age_new = final_df$admission_age
final_df$age_new[final_df$admission_age >= 18 
                       & final_df$admission_age <= 34] <- "18 - 34"

final_df$age_new[final_df$admission_age >= 35 
                 & final_df$admission_age <= 44] <- "35 - 44"

final_df$age_new[final_df$admission_age >= 45 
                 & final_df$admission_age <= 54] <- "45 - 54"

final_df$age_new[final_df$admission_age >= 55 
                 & final_df$admission_age <= 64] <- "55 - 64"

final_df$age_new[final_df$admission_age >= 65 
                 & final_df$admission_age <= 74] <- "65 - 74"

final_df$age_new[final_df$admission_age >= 75 
                 & final_df$admission_age <= 84] <- "75 - 84"

final_df$age_new[final_df$admission_age >= 85] <- "85 and higher"

##########SOFA############
final_df$SOFA_new = final_df$SOFA
final_df$SOFA_new[final_df$SOFA >= 0 
                 & final_df$SOFA <= 5] <- "0 - 5"

final_df$SOFA_new[final_df$SOFA >= 6 
                 & final_df$SOFA <= 10] <- "6 - 10"

final_df$SOFA_new[final_df$SOFA >= 11 
                 & final_df$SOFA <= 15] <- "11 - 15"

final_df$SOFA_new[final_df$SOFA >= 16] <- "16 and above"

##########Charlson Index###################
final_df$charlson_new = final_df$charlson_comorbidity_index
final_df$charlson_new[final_df$charlson_comorbidity_index >= 0 
                 & final_df$charlson_comorbidity_index <= 5] <- "0 - 5"

final_df$charlson_new[final_df$charlson_comorbidity_index >= 6 
                 & final_df$charlson_comorbidity_index <= 10] <- "6 - 10"

final_df$charlson_new[final_df$charlson_comorbidity_index >= 11 
                 & final_df$charlson_comorbidity_index <= 15] <- "11 - 15"

final_df$charlson_new[final_df$charlson_comorbidity_index >= 16] <- "16 and above"

final_df$los_hosp = as.numeric(difftime(final_df$dischtime, final_df$admittime, units = 'days'))
final_df$los_hosp[final_df$los_hosp < 0] <- 0 # clean data to have minimum of 0 days
final_df$gender <- factor(df$gender, levels = c('F', 'M'), 
                    labels = c('Famale', 'Male'))

final_df$pressor_lab <- factor(final_df$pressor_lab)
final_df$rrt_new <- factor(final_df$rrt_new)


final_df$hospital_expire_flag <- factor(df$discharge_location, 
                                        levels = c(0, 1), 
                                        labels = c('Survial', 'Death'))

final_df$dis_loc_new <- factor(final_df$dis_loc_new)

final_df$SOFA_new <- factor(final_df$SOFA_new, levels = c('0 - 5', '6 - 10','11 - 15', '16 and above' ))
final_df$charlson_new <- factor(final_df$charlson_new, levels = c('0 - 5', '6 - 10','11 - 15', '16 and above' ))



label(final_df$age_new)    <- "Age by group"
units(final_df$age_new)       <- "years"

label(final_df$admission_age)       <- "Age overall"
units(final_df$admission_age)       <- "years"

label(final_df$gender)       <- "Gender"

label(final_df$SOFA)          <- "SOFA overall"
label(final_df$SOFA_new)          <- "SOFA"

 
label(final_df$los_hosp)       <- "Length of stay - hospital"
units(final_df$los_hosp)       <- "days"

label(final_df$ethnicity_new)       <- "Ethnicity"

label(final_df$charlson_comorbidity_index)       <- "Charlson Index overall"

label(final_df$charlson_new) <- "Charlson Index"

label(final_df$pressor_lab) <- "Ever on pressor during ICU"

label(final_df$vent_req)       <- "Invasive Ventilation required"

label(final_df$InvasiveVent_hr)       <- "Invasive Ventilation"
units(final_df$InvasiveVent_hr)       <- "hours"

label(final_df$hospital_expire_flag)       <- "Hospital Mortality"

label(final_df$rrt_new)      <- "Renal Replacement Therapy"



table1(~ hospital_expire_flag + pressor_lab +  vent_req + rrt_new +
        age_new + admission_age + gender + SOFA_new + SOFA  + los_hosp + ethnicity_new
        + charlson_new + charlson_comorbidity_index  + InvasiveVent_hr
       
       | anchor_year_group, data=final_df, render.missing=NULL,topclass="Rtable1-grid Rtable1-shade Rtable1-times")



