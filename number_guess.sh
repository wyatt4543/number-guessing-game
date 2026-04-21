#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -q -c"
SECRET_NUMBER=$((1 + RANDOM % 1000))

# get the user's username
echo "Enter your username:"
read USER

# get the user's username from the database
USERNAME=$($PSQL "SELECT username FROM user_information WHERE username='$USER'")

# if the user does not exist
if [[ -z $USERNAME ]]
then
   # set the username variable to the new value
  USERNAME=$USER

  # insert the user's username into the database
  $PSQL "INSERT INTO user_information(username) VALUES('$USERNAME')"

  # print the welcome message
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  # if the user exists
  # find the number of games the user has played
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM user_information WHERE username='$USERNAME'")

  # find the user's best game
  BEST_GAME=$($PSQL "SELECT best_game FROM user_information WHERE username='$USERNAME'")

  # print the welcome message
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# ask for the user to guess the number
echo "Guess the secret number between 1 and 1000:"

# create a variable to store the number of guesses
NUMBER_OF_GUESSES=0

# while the guess is not equal to the answer
while (( USER_GUESS != SECRET_NUMBER ));
do
  # get the user's guess
  read USER_GUESS

  # while the guess is not an integer
  while ! [[ $USER_GUESS =~ ^[0-9]+$ ]];
  do
    # print wrong input error
    echo "That is not an integer, guess again:"
    read USER_GUESS
  done

  # increment the number of guesses by one
  (( NUMBER_OF_GUESSES++ ))

  # if the guess is less than the answer
  if (( USER_GUESS < SECRET_NUMBER ));
  then
    # prompt the user to guess higher
    echo "It's higher than that, guess again:"
  fi

  # if the guess is greater than the answer
  if (( USER_GUESS > SECRET_NUMBER ));
  then
    # prompt the user to guess lower
    echo "It's lower than that, guess again:"
  fi
done

# print the win message
echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

# increase the number of games played for the user by 1
(( GAMES_PLAYED++ ))
$PSQL "UPDATE user_information SET games_played = $GAMES_PLAYED WHERE username = '$USERNAME';"

# change the player's best game if the number of guesses is lower than the best game's guesses
if (( BEST_GAME == 0 || NUMBER_OF_GUESSES < BEST_GAME ));
then
  # update the player's best game in the database
  $PSQL "UPDATE user_information SET best_game = $NUMBER_OF_GUESSES WHERE username = '$USERNAME';"
fi