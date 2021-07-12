---
title: "Fictional Dataset EDA"
author: "Brandon Wallace"
date: "7/9/2021"
output: md_document
---

# This fictional dataset features 150000 rows and 6 columns for exploratory data analysis (EDA) [click here](https://www.kaggle.com/carlolepelaars/toy-dataset)

## Setting up my environment

```{r loading packages}
library(tidyverse)
library(janitor)
library(highcharter)
```

## Import data and clean

```{r}
toys <- read_csv("toy_dataset.csv") %>%
  clean_names() %>%
  mutate_all(list(~na_if(., " "))) %>%
  na.omit() %>%
  distinct()
```

```{r}
str(toys)
```


```{r}
summary(toys)
```

* There is an individual who reported income of less than 0 which we will investigate

```{r}
indices <- which(toys$income <0)
toys[246,]
```

* Since our data set is large and this is only one entry with an invalid entry of income < 0, we will simply delete this observation from our analysis. 

```{r}
toys_a <- toys[-c(246),]
summary(toys_a)
```

## Data Exploration

```{r}
table(toys_a$gender)
```

```{r}
hchart(as.character(toys_a$gender), type = "pie") %>%
  hc_title(text = "Gender Distribution")
```

```{r}
table(toys_a$illness)
```

```{r}
hchart(as.character(toys_a$illness), type = "pie") %>%
  hc_title(text = "Illness Pie Chart")
```

```{r}
table(toys_a$city)
```


```{r}
ggplot(toys_a, aes(x = city),) +
  geom_bar(color = 'pink', fill = 'lightblue') +
  labs(y = "Count", x = "City", title = "City Sample Breakdown")
```

```{r}
toys_i <- 
  toys_a %>%
  group_by(city) %>%
  summarize(avg_income = mean(income)) %>%
  arrange(city)
```

```{r}
head(toys_i)
```

```{r}
ggplot(toys_a, aes(x = city, y = income)) +
  geom_boxplot() + 
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
  labs(x = "City", y = "Income", title = "Average Income by City")
```

```{r}
toys_b <- 
  toys_a %>%
  group_by(age, gender) %>%
  summarize(avg_income = mean(income))
```

```{r}
ggplot(toys_b, aes(x = age, y = avg_income, color = gender)) +
  geom_line(size = 1) +
  labs(y = "Average Income", x = "Age", title = "Average Income throughout Lifetime") +
  scale_color_manual(values = c("#1b98e0", "#353436"))
```

* Here we can see that the average income stays relatively normal throughout an individuals lifetime, but there is a clear discrepancy between the average income between genders

```{r}
ggplot(toys_a, aes(x = income, color = "red")) +
  geom_density(alpha = .2) +
  geom_vline(aes(xintercept = mean(income, na.rm = T)),
color = "black", linetype = "dashed", size = 1) +
  geom_bar(pos = "dodge") +
  labs(y = "Value", x = "Income", title = "Distribution of Income")
```

