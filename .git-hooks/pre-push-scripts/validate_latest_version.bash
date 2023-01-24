#!/bin/bash
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "➡️ On the $GIT_BRANCH branch."
if [[ "$GIT_BRANCH" != main ]]; then
	echo "➡️ Skip tagging .. We only create new tag on push to the main branch."
	exit 0
else
	# The latest version saved in git tag
	LATEST_GIT_TAG_VERSION = $(git describe --tags --abbrev=0)
	echo "➡️ Latest Git Tag version: $LATEST_GIT_TAG_VERSION"
	# npm version from Package.json file
	LOCAL_NPM_VERSION=$(cat "${PWD%/*/*}/package.json" | grep -o '"version": "[^"]*' | grep -o '[^"]*$')
	echo "➡️ package.json version: $LOCAL_NPM_VERSION"
	#
	if [[ "$LATEST_GIT_TAG_VERSION" > "$LOCAL_NPM_VERSION" ]] ; then
		echo "⚠️ package.json npm version is lower than the latest git tag version!"
		echo "📢 please make sure that you have the latest changes on your local."
		echo "⚠️ Terminating GIT push.."
		exit 1
	elif [[ "$LATEST_GIT_TAG_VERSION" == "$LOCAL_NPM_VERSION" ]] ; then
		echo "⚠️ package.json npm version is the same as the latest git tag version!"
		echo "📢 Skip creating a new git tag and npm version."
		echo "➡️ Pushing changes to master..."
		exit 0
	else
		git tag -a $LOCAL_NPM_VERSION -m "${LOCAL_NPM_VERSION}"
		if [ $? -eq 0 ]; then 	# Status 0 means that command exited with code 0 - success
			echo "🎉🎉 Git tag ${LOCAL_NPM_VERSION} created 🥳"
			echo "✅ Pushing code and tag to master branch..."
			# A GitHub action will trigger to release and then publish to npm once a new GitHub release is created.
			exit 0
		else 					# Any other status means fail
			echo -e "\033[0;31m🚫 Error, Could not create a new tag for version ${LOCAL_NPM_VERSION}!"
			echo -e "\033[0;31m🚫 Error code: $?"
			exit 1
		fi
	fi
fi