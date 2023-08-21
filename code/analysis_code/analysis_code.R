###############################
# analysis script
#
#this script loads the processed, cleaned data, does a simple analysis
#and saves the results to the results folder

#load needed packages. make sure they are installed.
library(here) #for data loading/saving
library(dplyr)
library(skimr)
library(ggplot2)
library(tidyverse)
library(tidyr)
library(ggrepel)
library(ggtext)
library(ggpubr)
library(recipes)
library(parsnip)
library(performance)
library(dotwhisker)
library(caret)
library(arsenal)

#path to data
data_location1 <- here::here("data","processed_data","carbon_index_data.rds")
data_location2 <- here::here("data","processed_data","carbon_stock_data.rds")
data_location3 <- here::here("data","processed_data","forest_area_data.rds")
data_location4 <- here::here("data","processed_data","forest_index_data.rds")
data_location5 <- here::here("data","processed_data","forest_share_data.rds")
data_location6 <- here::here("data","processed_data","land_area_data.rds")
data_location7 <- here::here("data","processed_data","temp_data_clean.rds")
#load data
carbon_index <- readRDS(data_location1)
carbon_stock <- readRDS(data_location2)
forest_area <- readRDS(data_location3)
forest_index <- readRDS(data_location4)
forest_share <- readRDS(data_location5)
land_area <- readRDS(data_location6)
temperature <- readRDS(data_location7)

######################################
#Data fitting/statistical analysis
######################################

############################
#### First model fit
# Let's re-create the graphs made during the exploratory step, but add a bit of analysis to them.

temp_organized = subset(temperature, select = -c(ObjectId))
temp_organized <- gather(temp_organized, key = "Year", value = "Temperature Change", 2:63)

# Basic line plot with points
temp_base_plot <- ggplot(data=temp_organized, aes(x=Year, y=`Temperature Change`, group = Country)) +
  geom_line()+
  geom_point() + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  geom_smooth(method=lm, se=FALSE, col='purple', linetype = 'dashed')

plot(temp_base_plot)

#Create a summary table of all plot points
summary_temp_figure <- summary(lm(`Temperature Change` ~ Year, temp_organized))$coefficients
summarytable_file_temp = here("results", "summary_temp_figure.rds")
saveRDS(summary_temp_figure, file = summarytable_file_temp)


#Now, let's perform a one-sample t-test on the temperature data to see if it statistically deviates from a temperature change of 0. (this would indicate global warming)
ttest <- t.test(temp_organized$`Temperature Change`, mu = 0)
ttest
ttest_temp = here("results","ttest_temp.rds")
saveRDS(ttest_temp, file = ttest_temp)

#Let's see if we can compare the temperature changes between two years: 1979 and 2010
linear <- linear_reg() %>%  
  set_engine("lm")
logistic <- logistic_reg() %>%
  set_engine("glm")

lm_fit_7910 <- linear %>%
                        fit(F1979~F2010, data = temperature)
lm_fit_7910

#We can also try comparing the most recent year's data to all other years
lm_fit_2020 <- linear %>%
                fit(F2020~., data = temperature)
lm_fit_2020


# Cross-validation of temperature data set
# R program to implement
# validation set approach

# setting seed to generate a
# reproducible random sampling
set.seed(123)

# creating training data as 80% of the dataset
random_sample <- createDataPartition(temp_organized $ `Temperature Change`,
                                     p = 0.8, list = FALSE)

# generating training dataset
# from the random_sample
training_dataset  <- temp_organized[random_sample, ]

# generating testing dataset
# from rows which are not
# included in random_sample
testing_dataset <- temp_organized[-random_sample, ]

# Building the model

# training the model by assigning sales column
# as target variable and rest other columns
# as independent variables
model <- lm(`Temperature Change` ~., data = training_dataset)

# predicting the target variable
predictions <- predict(model, testing_dataset)

# computing model performance metrics
data.frame( R2 = R2(predictions, testing_dataset $ `Temperature Change`),
            RMSE = RMSE(predictions, testing_dataset $ `Temperature Change`),
            MAE = MAE(predictions, testing_dataset $ `Temperature Change`))


#We can also try to compare the temperature change data with the forest data. 
summary_temp_forest <- summary(comparedf(temperature, forest_area))
summarytable_file_temp_forest = here("results", "summary_temp_forest.rds")
saveRDS(summary_temp_forest, file = summarytable_file_temp_forest)

#Let's graph the Forest Area and assign a line of best fit to each country to see if there are trends.
forest_area_organized = subset(forest_area, select = -c(ObjectId, ISO2, ISO3, Indicator, Unit, Source))
forest_area_organized <- gather(forest_area_organized, key = "Year", value = "Area", 2:30)

# Basic line plot with points
forest_area_base_plot <- ggplot(data=forest_area_organized, aes(x=Year, y= Area, group = Country)) +
  geom_line()+
  geom_point() + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  geom_smooth(method=lm, se=FALSE, col='purple', linetype = 'dashed')

forest_area_base_plot

summary_forest_area_figure <- summary(lm(Area ~ Year, forest_area_organized))$coefficients
summary_forest_area_figure

#Let's try a comparison between the forest area and temperature with just one country. We will use the United States for this example.
#We will do this by performing an ANCOVA (analysis of covariance) to compare the slopes and intercepts of the two data sets
US_temp <- temperature[temperature$Country == "United States",]
US_forest_area <- forest_area[forest_area$Country == "United States",]

US_temp = subset(US_temp, select = -c(ObjectId))
US_temp <- gather(US_temp, key = "Year", value = "Temperature Change", 2:63)

US_forest_area = subset(US_forest_area, select = -c(ObjectId, ISO2, ISO3, Indicator, Unit, Source))
US_forest_area <- gather(US_forest_area, key = "Year", value = "Area", 2:30)

ACOVAmodel <- aov()