#!/bin/bash

game="---------"
playerChoice=""
computerChoice=""
rounds="9"

function checkRes() {
	if [[ "$2" =~ ^$1{3}.* ]]
	then
			return 1
	elif [[ "$2" =~ ^.{3}$1{3}.* ]]
	then
			return 1
	elif [[ "$2" =~ ^.{6}$1{3} ]]
	then
			return 1
	elif [[ "$2" =~ ^($1{1}.{2}){3} ]]
	then
			return 1
	elif [[ "$2" =~ ^(.{1}$1{1}.{1}){3} ]]
	then
			return 1
	elif [[ "$2" =~ ^(.{2}$1{1}){3} ]]
	then
			return 1
	elif [[ "$2" =~ ^($1{1}.{3}){2}$1{1} ]]
	then
			return 1
	elif [[ "$2" =~ ^.{2}($1{1}.{1}){2}.* ]]
	then
			return 1
	else
			return 0
	fi
}

function outputTable() {
	for i in {0..6..3}
	do
		echo "	${game:i:1} | ${game:i+1:1} | ${game:i+2:1}"
		echo "	---------"
	done
}

echo "TIC-TAC-TOE game. Choose your sign(X or O):"
read playerSign

echo "X always starts"
echo

if [[ $playerSign == "X" ]]
then
	computerSign="O"
else 
	computerSign="X"
	echo "It's the computer's turn"
	echo
	(( rounds-- ))
	computerChoice="$(expr $RANDOM % 9 + 1)"
	game=`echo $game | sed "s/./$computerSign/$computerChoice"`
fi 


outputTable
echo 

while [[ 1 ]]
do
	echo "It's your turn."
	echo

	(( rounds-- ))

	while [[ 1 ]]
	do
		read -p "Choose a position: " playerChoice
		if [[ "$playerChoice" =~ [1-9]{1} ]] && [[ ${game:$playerChoice - 1:1} == "-" ]]
		then
			break
		fi

		echo "Please enter an available position."
	done

	game=`echo $game | sed "s/./$playerSign/$playerChoice"`
	echo

	outputTable
	checkRes $playerSign $game
	if [[ $? -eq 1 ]]
	then
		echo "Congrats! You've won!"
		exit
	fi

	if [[ $rounds -eq 0 ]]
	then
		echo "It's a draw"
		exit
	fi

	echo "It's the computer's turn"
	echo

	(( rounds-- ))

	strOfChoices=""
	computerChoice=""
	for i in {1..9}
	do
		if [[ ${game:i-1:1} == "-" ]]
		then
			strOfChoices+="$i"
			posChoice="$i"
			posGame=`echo $game | sed "s/./$playerSign/$posChoice"`
			checkRes $playerSign $posGame
			if [[ $? -eq 1 ]]
			then
				computerChoice=$posChoice
				break
			fi
		fi
	done

	if [[ $computerChoice == "" ]]
	then
		computerChoice=${strOfChoices:$(expr $RANDOM % ${#strOfChoices}):1}
	fi
	
	game=`echo $game | sed "s/./$computerSign/$computerChoice"`
	
	outputTable
	checkRes $computerSign $game

	if [[ $? -eq 1 ]]
	then
		echo "The computer has won!"
		exit
	fi

	if [[ $rounds -eq 0 ]]
	then
		echo "It's a draw"
		exit
	fi

done
