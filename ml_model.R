#--> Libraries 
library(tidyverse)

#--> Load data
load("NSDUH_2016_v2.RData")

#--> Define a standardization function (probably exists in some library)
standardize <- function(vector){
  mu <- mean(vector)
  std <- sd(vector)
  output <- (vector - mu) / std
  return(output)
}

#--> Standardize the numeric variables
DATA5 <- DATA4 %>%
  mutate(alcohol_days = standardize(alcohol_days),
         marijuana_days = standardize(marijuana_days),
         cocaine_days = standardize(cocaine_days),
         hallucinogen_days = standardize(hallucinogen_days),
         income_level = factor(income_level),
         geography = factor(geography),
         suicidal = factor(suicidal))

head(DATA5)

# Random Forest -----------------------------------------------------------
library(randomForest)
set.seed(1729) # Ramanujan

#--> Split into train (50%) and (validation (25%) + test (25%))
train_index <- sample(nrow(DATA5), 0.5*nrow(DATA5), replace = FALSE)
TRAIN <- DATA5[train_index, ]
NOT_TRAIN <- DATA5[-train_index, ]

validate_index <- sample(nrow(NOT_TRAIN), 0.5*nrow(NOT_TRAIN), replace = FALSE)
VALIDATE <- NOT_TRAIN[validate_index, ]
TEST <- NOT_TRAIN[-validate_index, ]

#--> First try
model1 <- randomForest(suicidal ~ ., data = TRAIN, importance = TRUE)
pred1 <- predict(model1, TRAIN, type = "class")
mean(pred1 == TRAIN$suicidal)

model2 <- randomForest(suicidal ~ ., data = TRAIN, ntree = 500, mtry = 5, importance = TRUE)
pred2 <- predict(model1, TRAIN, type = "class")
mean(pred2 == TRAIN$suicidal)

#--> Itereate to try different models
acc <- c()

for (i in 2:7) {
  model3 <- randomForest(suicidal ~ ., data = DATA5, ntree = 500, mtry = i, importance = TRUE)
  predicted_values <- predict(model3, VALIDATE, type = "class")
  acc[i - 1] = mean(predicted_values == VALIDATE$suicidal)
}

print(acc)

plot(2:7, acc)

#--> Use mtry = 6 (7 was out of bounds for some reason)
model_final <- randomForest(suicidal ~ ., data = DATA5, ntree = 500, mtry = 6, importance = TRUE)
predict_final <- predict(model_final, TEST, type = "class")
mean(predict_final == TEST$suicidal)

importance(model_final)

library(gridExtra)

#--> Graph of random froest results
png("suicide_forest_graph.png", 1000, 600)
varImpPlot(model_final, "main" = "Variable Importance for Suicide Risk")
dev.off()

#--> Graph of table
df <- as.table(importance(model_final))

png("suicide_importance_table.png", height = 50*nrow(df), width = 200*ncol(df))
grid.table(df)
dev.off()

#--> SUicide rate by income level
DATA4 %>%
  group_by(income_level) %>%
  summarize(count = n(), percent = sum(suicidal)/n()) -> INCSUI

INTINC <- data.frame(
  "Integer" = 1:7,
  "Income" = c("< 10,000", "10,000-19,999",
               "20,000-29,999", "30,000-39,999",
               "40,000-49,999", "50,000-74,999",
               "75,000 +")
)


IS <- left_join(INCSUI, INTINC, by=c("income_level"="Integer")) %>% 
  select(-income_level) %>%
  transmute(Income=Income, percent=percent)

names(IS)[2] <- "Percent_Suicidal"

p1 <- ggplot(IS) +
    geom_col(aes(x = Income,  y=Percent_Suicidal, fill = Percent_Suicidal), position = "stack") +
    coord_flip() +
    theme_minimal() +
    ggtitle("Relationship between Income and Suicidal Thoughts")

png("suicide_income.png")
print(p1)
dev.off()
