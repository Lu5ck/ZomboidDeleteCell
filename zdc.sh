#!/bin/bash

echo "**************************************"
echo "*  Zomboid Delete Cell (ZDC) Script  *"
echo "**************************************"
echo "* Place script in Zomboid Folder     *"
echo "* Delete one cell each run           *"
echo "* I take no responsibility           *"
echo "**************************************"
read -p "Which cell are you deleting? Example 30x40 : " zdcCells

if [[ ! $zdcCells =~ ^[0-9]+x[0-9]+$ ]]; then
	echo "Invalid cell format"
	exit
fi

# We split the string into usable variables
zdcCells=(${zdcCells//x/ })

echo "***************************************"
echo "*     Deleting the following cell     *"
echo "***************************************"
echo "Cell: ${zdcCells[0]}x${zdcCells[1]}"
let "zdcTemp1 = ${zdcCells[0]} * 30 + 0"
let "zdcTemp2 = ${zdcCells[1]} * 30 + 0"
echo "Coordinate: ${zdcTemp1}x${zdcTemp2} to $((${zdcTemp1}+29))x$((${zdcTemp2}+29))"

zdcBackupDir="backups/zdc"

if [ ! -d $zdcBackupDir ]; then
	mkdir "${zdcBackupDir}"
elif [ "$(ls -A $zdcBackupDir)" ]; then
	echo "Warning: Backup Directory Not Empty"
fi

read -p "Confirm [Y/N] : " zdcConfirm

if [[ ! $zdcConfirm =~ ^[yY]$ ]]; then
	echo "Exiting Script"
	exit
fi


# Remove chunkdata (not datachunk) which is single cell file
# Soft delete the file by moving them to backup dir
mv -f Saves/Multiplayer/servertest/chunkdata_${zdcCells[0]}_${zdcCells[1]}.bin ${zdcBackupDir} 2>/dev/null

# Remove zombie population data which is singel cell file
# Soft delete the file by moving them to backup dir
mv -f Saves/Multiplayer/servertest/zpop_${zdcCells[0]}_${zdcCells[1]}.bin ${zdcBackupDir} 2>/dev/null

# Each cell is a 30x30 block, a range of 0 to 29
for i in {0..29..1}
do
	for n in {0..29..1}
	do
		# This is just coordinate (x,y) stored in two variables
		let "zdcTemp1 = ${zdcCells[0]} * 30 + ${i}"
		let "zdcTemp2 = ${zdcCells[1]} * 30 + ${n}"
		
		# Remove map which is divided into blocks
		# Soft delete the files by moving them to backup dir
		mv -f Saves/Multiplayer/servertest/map_${zdcTemp1}_${zdcTemp2}.bin ${zdcBackupDir} 2>/dev/null
	done
done

#Clean
unset zdcCells
unset zdcConfirm
unset zdcBackupDir
unset zdcTemp1
unset zdcTemp2

echo "ZDC Script Completed"
