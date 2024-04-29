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
  if [ $YEAR != "year" ]
  then
    #busca o id o winner e se não houver, insere na tabela teams.
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name= '$WINNER'")
    if [[ -z $WINNER_ID ]] 
    then
      INSERT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name= '$WINNER'")

    #busca o id o opponent e se não houver, insere na tabela teams.
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name= '$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
      then
      INSERT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name= '$OPPONENT'")

    #insere na tabela games os dados corretos do jogo contendo os ids winner e opponent
    INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals)
    VALUES($YEAR, '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  fi
done