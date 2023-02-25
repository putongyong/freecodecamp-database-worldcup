#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != "winner" ]]
  then
    # get team_name_winner
    TEAM_NAME_WINNER=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'") 

    # if not found
    if [[ -z $TEAM_NAME_WINNER ]]
    then
    INSERT_TEAM_NAME_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    if [[ $INSERT_TEAM_NAME_WINNER == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $WINNER
    fi
  fi

if [[ $OPPONENT != "opponent" ]]
  then
    # get team_name_opponent
    TEAM_NAME_OPPONENT=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'") 

    # if not found
    if [[ -z $TEAM_NAME_OPPONENT ]]
    then
    INSERT_TEAM_NAME_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
    if [[ $INSERT_TEAM_NAME_OPPONENT == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $OPPONENT
    fi
  fi

if [[ $YEAR != "year" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'") 
    INSERT_GAME=$($PSQL "INSERT INTO games(winner_id, opponent_id,year,round,winner_goals,opponent_goals) VALUES($WINNER_ID,$OPPONENT_ID,$YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS)")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR
    fi
fi

done

