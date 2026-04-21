#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
SECRET_NUMBER=$((1 + RANDOM % 1000))

# get the user's username
echo Enter your username:
read USER

# get the user's username from the database
USERNAME=$($PSQL "SELECT username FROM user_information WHERE username='$USER'")

# if the user does not exist
if [[ -z $USERNAME ]]
then
  # set the username variable to the new value
  USERNAME=$USER

  # insert the user's username into the database
  echo "$($PSQL "INSERT INTO user_information(username) VALUES('$USERNAME')")"

  # print the welcome message
  echo Welcome, $USERNAME! It looks like this is your first time here.
else
  # if the user exists
  # find the number of games the user has played
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM user_information WHERE username='$USERNAME'")

  # find the user's best game
  BEST_GAME=$($PSQL "SELECT best_game FROM user_information WHERE username='$USERNAME'")

  # print the welcome message
  echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
fi



