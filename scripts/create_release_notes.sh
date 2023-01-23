#!/bin/bash
FILE_NAME=release_notes.properties

cd ..
if [ -f "$PWD/$FILE_NAME" ] 
then
	echo "➡️ $FILE_NAME file exists."
	# Check if DESCRIPTION exists in release notes file
	DESCRIPTION=$(grep -iR "^DESCRIPTION" "$FILE_NAME")
	#
	if [ -z "$DESCRIPTION" ] 
	then
		echo "➡️ Invalid or empty DESCRIPTION key ⚠️"
		echo "➡️ Clearing the $FILE_NAME content..."
		echo -n "" > $FILE_NAME
		echo "➡️ Writing DESCRIPTION key to $FILE_NAME file..."
		if echo -e "DESCRIPTION=$DESCRIPTION" >> $FILE_NAME; then 
			echo "✅ DESCRIPTION key written successfully, please remember to update the DESCRIPTION value."
			echo "Thank you."
		else
			echo -e "\033[0;31m🚫 Failed to write DESCRIPTION key to $FILE_NAME!"
		fi 
	else
		# DESCRIPTION key exists >> Close script.
		exit 0
	fi
else
	echo "➡️ $FILE_NAME file does not exist ⚠️"
	echo "➡️ Creating $FILE_NAME file..."
	if touch $FILE_NAME; 
	then
		echo "✅ $FILE_NAME created successfully."
			
		echo "➡️ Writing DESCRIPTION key to $FILE_NAME file..."
		if echo -e "DESCRIPTION=$DESCRIPTION" >> $FILE_NAME; then 
			echo "✅ DESCRIPTION key written successfully, please remember to update the DESCRIPTION value."
			echo "Thank you."
		else
			echo -e "\033[0;31m🚫 Failed to write DESCRIPTION key to $FILE_NAME!"
		fi 
	else
		echo "🚫 Failed to create $FILE_NAME!"
	fi
fi