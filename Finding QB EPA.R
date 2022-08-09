#Install all necessary packages
library(tidyverse)
library(nflfastR)
library(data.table)
install.packages("plyr")
install.packages("questionr")
library(questionr)
library(plyr)

#Get play by play for 2018-2021 and make it a data table
pbp <- load_pbp(2018:2021)
pbp <- data.table(pbp)

#Filter out all instances where a pass was not thrown
passer <- pbp %>%
  filter(passer_player_name != "NA")

#Get passer names and total epa from 2018-2022
pass_epa <- aggregate(epa ~ passer_player_name, data=passer, sum)

#Get table of pass attempts
pass_plays <- table(passer$passer_player_name)

#Make the table above a data frame
pass_plays_df <- as.data.frame(pass_plays)

#rename variables
pass_plays_df <- rename.variable(pass_plays_df, "Var1", "passer_player_name")
pass_plays_df <- rename.variable(pass_plays_df, "Freq", "pass_attempts")

#Merge the two data frames
pass_epa_attempt <- merge(pass_plays_df, pass_epa)

#Turn total epa into epa per game
pass_epa_attempt <- mutate(pass_epa_attempt, epa_per_game = (epa/4)/16)

#Filter out for players with less than 500 pass attempts
pass_epa_attempt <- filter(pass_epa_attempt, pass_attempts > 500)

#Remove total epa (serves no purpose)
pass_epa_attempt_fin <- pass_epa_attempt[,-3] 
