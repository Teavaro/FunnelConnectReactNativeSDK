#!/bin/bash

LOCAL_REF_TAGS_FOUND=0
# For every ref sent for push, check if the ref is of type /refs/tags/ (/refs/heads/ do not include tags)
while read local_ref local_oid remote_ref remote_oid
do
	COMMITTED_LOCAL_REF_TAGS_AMOUNT=$(grep -c 'refs/tags/' <<< "$local_ref")
	# If any tag refs found
	if [ $COMMITTED_LOCAL_REF_TAGS_AMOUNT -gt 0 ]; then
		# Change flag
		LOCAL_REF_TAGS_FOUND=1
		# List the name
		COMMITTED_LOCAL_REF_TAG=$(grep 'refs/tags/' <<< "$local_ref")
		echo "⚠️ Local tag detected for push: $COMMITTED_LOCAL_REF_TAG"
	fi
done

# If any of the tag refs are found in the push data, show the message and stop the push
if [ $LOCAL_REF_TAGS_FOUND -eq 1 ]; then
	echo "📢 As a safety measure, no tags created manually can be pushed to remote -> this process is fully automated."
	echo "📢 Please remove tags listed above or the --tags option while doing the push."
	exit 1
else
	echo "✅ No tags detected in the push refs. Proceeding..."
fi

GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "➡️ $GIT_BRANCH branch detected."
if [[ "$GIT_BRANCH" != main ]]; then
	# Just a push to a different branch, proceed with the push with no tag nor publish
	echo "➡️ Skipping automatic tagging step. New tag is created only on push to the main branch."
	exit 0
else
	LATEST_REMOTE_GIT_TAG_VERSION = $(git -c 'versionsort.suffix=-' \
		ls-remote --exit-code --refs --sort='version:refname' \
		--tags https://github.com/Teavaro/FunnelConnectReactNativeSDK '*.*.*' \
		| tail --lines=1 \
		| cut --delimiter='/' --fields=3)
	echo "➡️ Latest Git Tag version: $LATEST_REMOTE_GIT_TAG_VERSION"

	LOCAL_NPM_VERSION=$(cat "${PWD%/*/*}/package.json" | grep -o '"version": "[^"]*' | grep -o '[^"]*$')
	echo "➡️ Local package.json version: $LOCAL_NPM_VERSION"

	if [[ "$LATEST_REMOTE_GIT_TAG_VERSION" > "$LOCAL_NPM_VERSION" ]] ; then
		echo "⚠️ package.json npm version ($LOCAL_NPM_VERSION) is lower than the latest git tag version ($LATEST_REMOTE_GIT_TAG_VERSION)!"
		echo "📢 please make sure that you have the latest changes on your local."
		echo "⚠️ Terminating GIT push.."
		exit 1
	elif [[ "$LATEST_REMOTE_GIT_TAG_VERSION" == "$LOCAL_NPM_VERSION" ]] ; then
		echo "⚠️ package.json npm version ($LOCAL_NPM_VERSION) is the same as the latest git tag version!"
		echo "📢 Skip creating a new git tag and npm version."
		echo "➡️ Pushing changes without new tag to master..."
		exit 0
	else
		# Show message and wait for user confirmation on tagging
		echo "➡️ Local version detected: ${LOCAL_NPM_VERSION}. \
			Confirmation will add a tag with the same number and publish the new version to npm. \
			Denying terminates the push. Do you confirm the new version? (Y/N)"
		read -n1 ANSWER
		if [[ "${ANSWER}" == "Y" ]] ; then
			# Create new tag based on the package.json version
			git tag -a $LOCAL_NPM_VERSION -m "${LOCAL_NPM_VERSION}"
			if [ $? -eq 0 ]; then 	# Status 0 means that command exited with code 0 - success
				echo "🎉🎉 Git tag ${LOCAL_NPM_VERSION} created 🥳"
				echo "✅ Pushing code and tag to master branch..."
				# A GitHub action will trigger to publish to npm once a new tag is pushed to the main branch
				exit 0
			else	# Any other status means fail
				echo -e "\033[0;31m🚫 Error, Could not create a new tag for version ${LOCAL_NPM_VERSION}!"
				echo -e "\033[0;31m🚫 Error code: $?"
				exit 1
			fi
		else
			echo -e "🚫 Confirmation not granted. Terminating the push..."
		fi
	fi
fi