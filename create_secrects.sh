#!/bin/bash
SECRETS_DIR_NAME=.secrets
SECRETS_DIR="$PWD/$SECRETS_DIR_NAME"
SECRETS_FILE_NAME=secrets.properties
#
if [ -d "$SECRETS_DIR" ];
then
    echo "➡️ $SECRETS_DIR_NAME directory exists."
	cd "$SECRETS_DIR"
	if [ -f "$PWD/$SECRETS_FILE_NAME" ]
	then
		echo "➡️ $SECRETS_FILE_NAME file exists."
		# Check if GitHub token exists in secrets file
		GITHUB_TOKEN=$(grep -iR "^GITHUB_TOKEN" "$SECRETS_FILE_NAME" | awk -F "=" '{print $2}')
		#
		if [ -z "$GITHUB_TOKEN" ]
		then
			echo "➡️ Invalid or empty GITHUB_TOKEN ⚠️"
			# Open user input
			read -p "Enter GitHub Token: " GITHUB_TOKEN
			echo "➡️ Writing GitHub Token to $SECRETS_FILE_NAME file..."
			if echo -e "GITHUB_TOKEN=$GITHUB_TOKEN" >> $SECRETS_FILE_NAME; then
				echo "✅ GitHub token saved successfully."
				read -n1 -s -r -p $'➡️ Press any key to exit \n' key
				echo "Thank you."
				exit 0
			else
				echo -e "\033[0;31m🚫 Failed to save GitHub token!"
			fi
		else
			echo "➡️ GitHub token exists."
			exit 0
		fi
	else
		echo "➡️ $SECRETS_FILE_NAME file does not exist ⚠️"
		echo "➡️ Creating $SECRETS_FILE_NAME file..."
		if touch $SECRETS_FILE_NAME; then
			echo "✅ $SECRETS_FILE_NAME created successfully."
			# Open user input
			read -p "Enter GitHub Token: " GITHUB_TOKEN
			echo "➡️ Writing GitHub Token to $SECRETS_FILE_NAME file..."
			if echo -e "GITHUB_TOKEN=$GITHUB_TOKEN" >> $SECRETS_FILE_NAME; then
				echo "✅ GitHub token saved successfully."
				read -n1 -s -r -p $'➡️ Press any key to exit \n' key
				echo "Thank you."
				exit 0
			else
				echo -e "\033[0;31m🚫 Failed to save GitHub token!"
			fi
		else
			echo "🚫 Failed ot create $SECRETS_FILE_NAME!"
		fi
	fi
else
	echo "➡️ $SECRETS_DIR directory does not exist ⚠️"
	echo "➡️ Creating $SECRETS_DIR directory..."
	if mkdir $SECRETS_DIR_NAME; then
		echo "✅ $SECRETS_DIR_NAME directory created successfully."
		echo "➡️ Creating $SECRETS_FILE_NAME file..."
		if touch $SECRETS_FILE_NAME; then
			echo "✅ $SECRETS_FILE_NAME created successfully."
			# Open user input
			read -p "Enter GitHub Token: " GITHUB_TOKEN
			echo "➡️ Writing GitHub Token to $SECRETS_FILE_NAME file..."
			if echo -e "GITHUB_TOKEN=$GITHUB_TOKEN" >> $SECRETS_FILE_NAME; then
				echo "✅ GitHub token saved successfully."
				read -n1 -s -r -p $'➡️ Press any key to exit \n' key
				echo "Thank you."
				exit 0
			else
				echo -e "\033[0;31m🚫 Failed to save GitHub token!"
			fi
		else
			echo "🚫 Failed ot create $SECRETS_FILE_NAME!"
		fi
	else
		echo "🚫 Failed ot create $SECRETS_DIR_NAME directory!"
	fi
fi