#!/bin/bash

# 1. Check the remote and local (package.json) version discrepancies.
# TODO: Make the npm version check against the diff, not a local file
echo "➡️ Checking package version..."
LOCAL_NPM_VERSION=$(cat "${PWD}/package.json" | grep -o '"version": "[^"]*' | grep -o '[^"]*$')
if [[ ! $LOCAL_NPM_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	echo "⚠️ package.json npm version ($LOCAL_NPM_VERSION) being committed is invalid!"
	echo "📢 please make sure to use a valid versioning pattern -> x.x.x"
	echo "⚠️ Terminating GIT commit..."
    exit 1
fi
echo "✅ Package version OK."

LATEST_REMOTE_GIT_TAG_VERSION=$(git -c 'versionsort.suffix=-' \
	ls-remote --exit-code --refs --sort='version:refname' \
	--tags https://github.com/Teavaro/FunnelConnectReactNativeSDK '*.*.*' \
	| tail --lines=1 \
	| cut --delimiter='/' --fields=3)

# 2. Compare local and remote version
echo "➡️ Comparing remote and local versions..."
SPLIT_LOCAL_NPM_VERSION=(${LOCAL_NPM_VERSION//./ })
SPLIT_LATEST_REMOTE_GIT_TAG_VERSION=(${LATEST_REMOTE_GIT_TAG_VERSION//./ })
IS_VERSION_BUMPED=0
for i in 0 1 2 # Indexes represent the position of the version number: 0 - Major, 1 - Minor, 2 - Patch
do
	if [ ${SPLIT_LATEST_REMOTE_GIT_TAG_VERSION[$i]} -gt ${SPLIT_LOCAL_NPM_VERSION[$i]} ] ; then
		echo "⚠️ package.json npm version ($LOCAL_NPM_VERSION) is lower than the latest git tag version ($LATEST_REMOTE_GIT_TAG_VERSION) !"
		echo "📢 please make sure that you have the latest changes on your local."
		echo "⚠️ Terminating GIT commit..."
		exit 1
	elif [ ${SPLIT_LATEST_REMOTE_GIT_TAG_VERSION[$i]} -lt ${SPLIT_LOCAL_NPM_VERSION[$i]} ] ; then
		echo "📢 Local version ($LOCAL_NPM_VERSION) is higher than the remote version ($LATEST_REMOTE_GIT_TAG_VERSION) !"
		IS_VERSION_BUMPED=1
		break
	else
		continue
	fi
done

if [ $IS_VERSION_BUMPED -eq 0 ] ; then
	echo "✅ Remote and local versions OK. Proceeding..."
	exit 0
fi

# 3. Prompt user to confirm tagging if the branch is main and version is bumped
echo "➡️ Versions difference detected. Checking branch..."
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$GIT_BRANCH" == main ]]; then
	# Show message and wait for user confirmation on tagging
	echo "Please confirm the new version."
	echo "Y - Confirmation adds a tag with the same version to publish to npm on push."
	echo "N - Denying terminates the commit."
	read -p "Do you confirm the new version? (Y/N): " ANSWER </dev/tty
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
	else
		echo -e "🚫 Confirmation not granted. You cannot bump the local version without new tag."
		echo "⚠️ Terminating GIT commit..."
		exit 1
	fi
else	# Not a main branch (feature/fix branch etc.)
	echo "⚠️ package.json npm version ($LOCAL_NPM_VERSION) is higher than the latest git tag version ($LATEST_REMOTE_GIT_TAG_VERSION) !"
	echo "📢 branches other than main cannot apply version updates. Please make sure that you have the same version as remote."
	echo "⚠️ Terminating GIT commit..."
	exit 1
fi

echo -e "🚫 Unsupported case. Terminating GIT commit..."
exit 1