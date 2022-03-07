#!/bin/bash
echo "------------- make de tpc --------------"
make

mkdir ./bin/fichier_asm
for rep in `ls ./test`
do
	echo "---------- execution des tests dans ../$rep --------- "
	for fichier in `ls ./test/$rep`;do
		
		v=$fichier
		v2=${v::-4}
		v2+=".asm"
		#echo $v2
		echo "---------- tests dans ../$rep/$fichier --------- "
		./bin/compil -o $v2 < ./test/$rep/$fichier
		let "res = $?"
		echo "\$? = " $res
		if [ $res = 0 ]
		then
		    echo "Programme correct !"
			mv $v2 bin/fichier_asm

		else
			echo "Le programme n'a pas pu compiler"
		fi
		
	done
done




