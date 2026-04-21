#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"
SECRET_NUMBER=$((1 + RANDOM % 1000))