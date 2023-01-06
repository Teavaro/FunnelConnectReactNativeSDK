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
		URL="https://github.com/Teavaro/FunnelConnectReactNativeSDK/releases"
		#		
		RESPONSE=$(curl -s -w %{http_code} -H Accept: application/vnd.github+json -H Authorization: Bearer $GITHUB_TOKEN $URL/latest)
		HTTP_STATUS_CODE=$(tail -n1 <<< "$RESPONSE")  # get the last line.
		HTTP_BODY=$(sed '$ d' <<< "$RESPONSE" )   # get all but the last line which contains the status code.
		HTTP_BODY=$(echo $HTTP_BODY | sed -r 's/000000000//g')  # Remove leading zeros.
		#echo "➡️ Status Code: $HTTP_STATUS_CODE"
		#echo "➡️ Response: $HTTP_BODY"
		#
		if [[ "$HTTP_STATUS_CODE" -ne 200 ]] ; then 
			echo -e "\033[0;31m🚫 Error, Could not fetch the latest GitHub release!"
		else
			LATEST_GITHUB_RELEASE=$(echo $HTTP_BODY | jq -r '.tag_name')
			echo "➡️ Latest GitHub Release: $LATEST_GITHUB_RELEASE"
			#
			CURRENT_GIT_TAG=$(git describe --abbrev=0 --tags)
			echo "➡️ Current GIT Tag: $CURRENT_GIT_TAG"
			#
			LOCAL_NPM_VERSION=$(cat "${PWD%/*/*}/package.json" | jq -r ".version")
			echo "➡️ package.json version: $LOCAL_NPM_VERSION"
			if [[ "$LATEST_GITHUB_RELEASE" != "$LOCAL_NPM_VERSION" ]] ; then
				echo "⚠️ package.json npm version does not match the latest version on GitHub!"
				echo "📢 please make sure that the you have the latest changes on your local."
				echo "⚠️ Terminating GIT push.."
				exit 1
			else
				if [[ "$LATEST_GITHUB_RELEASE" == "$CURRENT_GIT_TAG" ]] ; then
					echo "⚠️ Release already exists."
					echo "📢 please create a new tag and push it to the master branch to create a new release."
					echo "⚠️ Terminating GIT push.."
					exit 1
				else
					RELEASE_NOTES_FILE_PATH="${PWD%/*/*}/release_notes.properties"
					RELEASE_NOTES_DESCRIPTION=$(grep -iR "^DESCRIPTION" "$RELEASE_NOTES_FILE_PATH" | awk -F "=" '{print $2}')
					#
					RESPONSE=$(curl -s -w %{http_code} -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_TOKEN" "$URL"  -d '{ "tag_name":"'$CURRENT_GIT_TAG'","body":"'$RELEASE_NOTES_DESCRIPTION'","draft":false,"prerelease": false,"generate_release_notes":false,"make_lateststring":true}')
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
						echo "🎉🎉 Release $CURRENT_GIT_TAG created successfully 🥳"
						echo "✅ Pushing to master branch..."
						# A GitHub action will trigger once the new Tag is npushed to master to deploy a new release to NPM.
						exit 0
					fi
				fi
			fi
		fi	
	fi
fi