#!/bin/bash

# 1. Check the remote and local (package.json) version discrepancies.
# TODO: Make the npm version check against the diff, not a local file
# TODO: 0.4.10 is lower than 0.4.9
echo "➡️ Checking package version..."
LOCAL_NPM_VERSION=$(cat "${PWD}/package.json" | grep -o '"version": "[^"]*' | grep -o '[^"]*$')
if [[ ! $LOCAL_NPM_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	echo "⚠️ package.json npm version ($LOCAL_NPM_VERSION) being committed is invalid!"
	echo "📢 please make sure to use a valid versioning pattern -> x.x.x"
	echo "⚠️ Terminating GIT commit..."
    exit 1
fi
LATEST_REMOTE_GIT_TAG_VERSION=$(git -c 'versionsort.suffix=-' \
	ls-remote --exit-code --refs --sort='version:refname' \
	--tags https://github.com/Teavaro/FunnelConnectReactNativeSDK '*.*.*' \
	| tail --lines=1 \
	| cut --delimiter='/' --fields=3)
if [[ "$LATEST_REMOTE_GIT_TAG_VERSION" > "$LOCAL_NPM_VERSION" ]] ; then
	echo "⚠️ package.json npm version ($LOCAL_NPM_VERSION) is lower than the latest git tag version ($LATEST_REMOTE_GIT_TAG_VERSION)!"
	echo "📢 please make sure that you have the latest changes on your local."
	echo "⚠️ Terminating GIT commit.."
	exit 1
elif [[ "$LATEST_REMOTE_GIT_TAG_VERSION" == "$LOCAL_NPM_VERSION" ]] ; then
	exit 0
fi

# 2. With LOCAL_NPM_VERSION bigger than the remote one, check the current branch.
# With this condition, create tag for main, reject commit for other branch.
echo "➡️ Checking branch..."
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$GIT_BRANCH" == main ]]; then
	# Show message and wait for user confirmation on tagging
	echo "➡️ Local version detected: ${LOCAL_NPM_VERSION}."
	echo "Please confirm the new version."
	echo "Y - Confirmation adds a tag with the same version to publish to npm on push."
	echo "T - Tag already present. Confirm, but do not try to create new tag."
	echo "N - Denying terminates the commit."
	# TODO: Remove an option to tag because the ref/tag will be at the wrong commit - the previous one before the version change in package.json, failing the publish
	read -p "Do you confirm the new version? (Y/T/N): " ANSWER </dev/tty
	if [[ "${ANSWER}" == "Y" ]] || [[ "${ANSWER}" == "y" ]]; then
		# Create new tag based on the package.json version
		git tag -a $LOCAL_NPM_VERSION -m "${LOCAL_NPM_VERSION}"
		if [ $? -eq 0 ]; then 	# Status 0 means that command exited with code 0 - success
			echo "🎉🎉 Git tag ${LOCAL_NPM_VERSION} created 🥳"
			echo "✅ Please make sure to use --tags during the push to main branch. Proceeding..."
			exit 0
		else	# Any other status means fail
			echo -e "\033[0;31m🚫 Error, Could not create a new tag for version ${LOCAL_NPM_VERSION}!"
			echo -e "\033[0;31m🚫 Error code: $?"
			exit 1
		fi
	# TODO: Make the tag existence validation automatic
	elif [[ "${ANSWER}" == "T" ]] || [[ "${ANSWER}" == "t" ]]; then
		echo "Confirmed with tag skip. Assuming the tag existence."
		echo "✅ Please make sure to use --tags during the push to main branch. Proceeding..."
		exit 0
	else
		echo -e "🚫 Confirmation not granted. You cannot bump the local version without new tag. Terminating the commit..."
		exit 1
	fi
else	# Not a main branch (feature/fix branch etc.)
	echo "⚠️ package.json npm version ($LOCAL_NPM_VERSION) is higher than the latest git tag version ($LATEST_REMOTE_GIT_TAG_VERSION)!"
	echo "📢 branches other than main cannot apply version updates. Please make sure that you have the same version as remote."
	echo "⚠️ Terminating GIT commit..."
	exit 1
fi