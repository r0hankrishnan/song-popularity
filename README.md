## Song Popularity Prediction Project (In Progress)
**If you are visiting from my CV, please go to the `class-submissions` folder to see my code and writing submissions**

*Apologies for the incomplete README, I am currently in the process of expanding upon this project!*

This is an expansion of the final project for STAT 1361. In this project we are given a data set containing a list of songs across three genres (pop, rock, and jazz), their characteristics, and their popularities. I will explore the data and then create several models to predict a song's popularity based on the given information. 

## Table of Contents
1. [**Introduction**](#introduction)
2. [**EDA**](#eda)
3. [**Modelling**](#modelling)
4. [**Shiny Dashboard**](#shiny-dashboard)

## Introduction (The Hypothetical Scenario)
SonicWave Productions is a growing company seeking to gain headway in the music industry. The music industry is valued at 14.34 billion as of 2024 and is projected to consistently grow in the following years (Statista, 2024). To gain a competitive advantage and grow SonicWave’s market share, it is imperative to understand what factors are most important in creating a popular song.

As a Data Science Consultant , I was hired to predict the popularity of songs from rock, jazz, and pop genres. I was provided a data set with 1200 observations across 19 variables that encompassed various song metrics. Such a model would empower their team of music professionals to swiftly identify songs that are either undervalued or overvalued in the market, facilitating strategic decisions in song selection, promotion, and distribution. In this README, I will highlight the analyses I conducted to understand the relationships within the data, how I cleaned the data, the models I developed and how they performed, and my final takeaways regarding how the models should or should not be utilized.

## EDA
To view my exploratory data analysis, please open the `exploratory-analysis.Rmd` file.

### EDA Highlights

I first looked at how popularity differed when compared with the categorical variables in the data set, specifically track genre and time signature. As is shown in the boxplot figure to the right, pop (green) has most of the popular songs while jazz (red) has mostly lower and middle rated songs and rock (blue) has almost entirely lower rated songs, with its higher rated songs falling outside of 1.5*IQR of its bounds. I then looked at how popularity differed by time signature. It appears that there is no real difference between time signatures of 3, 4, and 5; though time signatures of 1 seemed to have a larger density of lower popularity longs. Another interesting finding was that songs that were not explicit tended to have a higher density of lower ranked songs and very few extremely high ranked songs while explicit songs tended to have either lower ranked or extremely high ranked songs. Overall, very few of the variables appeared to follow a normal distribution. There also appeared to be some level of collinearity between energy and loudness. However, since there are only a small number of variables to work with, I elected to keep both in the model and address the issue via model selection techniques.

![Popularity by Genre](~/Desktop/000008.png)

## Modelling

## Shiny Dashboard



