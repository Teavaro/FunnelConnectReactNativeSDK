#!/bin/bash
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "➡️ On the $GIT_BRANCH branch."
if [[ "$GIT_BRANCH" != main ]]; then
	echo "➡️ Skip creating new release .. We only create release on puh to the main branch."
	exit 0
else
	#
	SECRETS_PATH="${PWD%/*/*}/.secrets"
	SECRETS_FILE="$SECRETS_PATH/secrets.properties"	
	GITHUB_TOKEN=$(grep -iR "^GITHUB_TOKEN" "$SECRETS_FILE" | awk -F "=" '{print $2}')
	#
	if [ -z "$GITHUB_TOKEN" ]
	then
		echo -e "\033[0;31m🚫 Invalid or empty GITHUB_TOKEN, please make sure GITHUB_TOKEN exists in secrets.properties file in this path 👉 $SECRETS_FILE"
	else
		URL="https://api.github.com/repos/Teavaro/FunnelConnectReactNativeSDK/releases"
		#		
		RESPONSE=$(curl -s -w %{http_code} -H Accept: application/vnd.github+json -H Authorization: Bearer $GITHUB_TOKEN $URL/latest)
		HTTP_STATUS_CODE=$(tail -n1 <<< "$RESPONSE")  # get the last line.
		HTTP_BODY=$(sed '$ d' <<< "$RESPONSE" )   # get all but the last line which contains the status code.
		HTTP_BODY=$(echo $HTTP_BODY | sed -r 's/000000000//g')  # Remove leading zeros.
		echo "➡️ Status Code: $HTTP_STATUS_CODE"
		echo "➡️ Response: $HTTP_BODY"
		#
		if [[ "$HTTP_STATUS_CODE" -ne 200 ]] ; then 
			echo -e "\033[0;31m🚫 Error, Could not fetch the latest GitHub release!"
		else
			LATEST_GITHUB_RELEASE=$(echo $HTTP_BODY | jq -r '.tag_name')
			echo "➡️ Latest GitHub Release: $LATEST_GITHUB_RELEASE"
			# npm version from Package.json file
			LOCAL_NPM_VERSION=$(cat "${PWD%/*/*}/package.json" | jq -r ".version")
			echo "➡️ package.json version: $LOCAL_NPM_VERSION"
			#
			if [[ "$LATEST_GITHUB_RELEASE" > "$LOCAL_NPM_VERSION" ]] ; then
				echo "⚠️ package.json npm version is lower than the latest version on GitHub!"
				echo "📢 please make sure that you have the latest changes on your local."
				echo "⚠️ Terminating GIT push.."
				exit 1
			elif [[ "$LATEST_GITHUB_RELEASE" == "$LOCAL_NPM_VERSION" ]] ; then
				echo "⚠️ package.json npm version is the same as the latest GitHub release!"
				echo "📢 Skip creating a new GitHub release and npm version."
				echo "➡️ Pushing changes to master..."
				exit 0
			else
				RELEASE_NOTES_FILE_PATH="${PWD%/*/*}/release_notes.properties"
				RELEASE_NOTES_DESCRIPTION=$(grep -iR "^DESCRIPTION" "$RELEASE_NOTES_FILE_PATH" | awk -F "=" '{print $2}')
				#
				RESPONSE=$(curl -s -w %{http_code} -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_TOKEN" "$URL"  -d '{ "tag_name":"'$LOCAL_NPM_VERSION'","body":"'$RELEASE_NOTES_DESCRIPTION'","draft":false,"prerelease": false,"generate_release_notes":false,"make_lateststring":true}')
				#
				HTTP_STATUS_CODE=$(tail -n1 <<< "$RESPONSE")  # get the last line.
				HTTP_BODY=$(sed '$ d' <<< "$RESPONSE" )   # get all but the last line which contains the status code.
				echo "➡️ Status Code: $HTTP_STATUS_CODE"
				echo "➡️ Response: $HTTP_BODY"
				#
				if [[ "$HTTP_STATUS_CODE" -ne 201 ]] ; then 
					echo -e "\033[0;31m🚫 Error, Could not create a new GitHub release!"
					exit 1
				else
					echo "🎉🎉 Release $LOCAL_NPM_VERSION created successfully 🥳"
					echo "✅ Pushing to master branch..."
					# A GitHub action will trigger to deploy a new release to npm once a new GitHub release is created.
					exit 0
				fi
			fi
		fi
	fi
fi