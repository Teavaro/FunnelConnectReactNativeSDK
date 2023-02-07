#!/bin/bash

# 1. Check tags set up to be pushed to the remote
echo "➡️ Checking branch..."
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "➡️ $GIT_BRANCH branch detected."
# TODO: Make the npm version check against the diff, not a local file
LOCAL_NPM_VERSION=$(cat "${PWD}/package.json" | grep -o '"version": "[^"]*' | grep -o '[^"]*$')
IS_LOCAL_VERSION_PUSHED_AS_REF_TAG_TO_MAIN=0
# For every ref sent for push, check if the ref is of type /refs/tags/ (/refs/heads/ do not include tags)
while read local_ref local_oid remote_ref remote_oid
do
	PUSHED_REF_TAG=$(grep 'refs/tags/' <<< "$local_ref" | cut --delimiter='/' --fields=3)
	[ -z "$PUSHED_REF_TAG" ] && continue # The ref is not a tag (most probably head)
	if [[ "$GIT_BRANCH" == main ]]; then
		if [ "$PUSHED_REF_TAG" == "$LOCAL_NPM_VERSION" ]; then
			# Change flag
			IS_LOCAL_VERSION_PUSHED_AS_REF_TAG_TO_MAIN=1
			echo "✅ Current package.json $LOCAL_NPM_VERSION version will be pushed as a $PUSHED_REF_TAG tag. Proceeding..."
		else
			echo -e "🚫 Detected unexpected ref tag: $PUSHED_REF_TAG"
			echo -e "🚫 It is not aligned with the local npm version: $LOCAL_NPM_VERSION"
			echo "📢 Make sure the version is aligned with the tag that is being pushed. Terminating the push..."
			exit 1
		fi
	else # Not a main branch
		PUSHED_REF_TAG_NUMBER=$(grep -c 'refs/tags/' <<< "$local_ref")
		# If any tag refs found
		if [ $PUSHED_REF_TAG_NUMBER -gt 0 ]; then
			echo "📢 Local tag detected for push: $PUSHED_REF_TAG"
			echo -e "🚫 As a safety measure, no tags be pushed to remote other than main. Current branch: $GIT_BRANCH"
			echo "📢 Please remove tags listed above or the --tags option while doing the push."
			exit 1
		fi
	fi
done

# 2. For the main branch, if the tag is not detected, terminate the push
if [ "$GIT_BRANCH" == main ] && [ $IS_LOCAL_VERSION_PUSHED_AS_REF_TAG_TO_MAIN -eq 0 ]; then
	echo "📢 Missing tag for $LOCAL_NPM_VERSION version found in package.json."
	echo "📢 Please commit the changes with new version or align the tags. Make sure to use --tags option while doing the push including new version."
	echo -e "🚫 Terminating the push..."
	exit 1
fi
