# Installing libraries
library(tidyverse)
library(dplyr)

# Importing datasets
vehicles_df <- read_csv("G:\\Mi unidad\\Data Analytics\\04. Projects\\02. Personal\\01. Raw data\\vehicles.csv")

# Exploring the data
colnames(vehicles_df)
head(vehicles_df)
str(vehicles_df)

# Number of ID
n_distinct(vehicles_df$id)

# Looking for duplicates
sum(vehicles_df %>% duplicated())  # There is no duplicates

# Deleting records with price 0
vehicles_clean <- filter(vehicles_df, price > 0)

# Formatting date times to dates
vehicles_clean$posting_date <- as.Date(vehicles_clean$posting_date)

# Adding regions from URL
vehicles_clean <- vehicles_clean %>% 
  mutate(region = 
           str_replace_all(vehicles_clean$url, ".*//|\\.craigslist.*", "") %>% 
           as.data.frame())

# Adding the year of the post and the age of the car
vehicles_clean <- vehicles_clean %>% 
  mutate(post_year = format(vehicles_clean$posting_date, format="%Y"))

vehicles_clean <- vehicles_clean %>% 
  mutate(age_of_car = as.numeric(post_year) - as.numeric(year))

# Due the model year of a vehicle may be the same as the calendar year or the
# following year, there are some negatives ages.
# Let's replace them for 0 ages.
age_list <- vehicles_clean$age_of_car
count = 1

for (i in age_list){
  if(is.na(i)){
    age_list[count] = i
  } else if (age_list[count] < 0){
    age_list[count] = 0
  } else
    age_list[count] = i
  count = count + 1
}

# Updating the age_of_car column
vehicles_clean <- vehicles_clean %>% mutate(age_of_car = age_list)

# Selecting relevant data for analysis
vehicles <- vehicles_clean %>% select(id, region, manufacturer, price, type, 
                                      paint_color, cylinders, fuel, odometer, 
                                      transmission, age_of_car, lat, long)

# Saving the data frame into a csv file
write.csv(as.matrix(vehicles), 
          "G:\\Mi unidad\\Data Analytics\\04. Projects\\02. Personal\\03. Cleaned data\\vehicles.csv",
          row.names = FALSE)
