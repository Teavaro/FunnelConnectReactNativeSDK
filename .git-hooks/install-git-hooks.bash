#!/bin/bash
echo "➡️ Installing git hooks..."
GIT_DIR=$(git rev-parse --git-dir)
cd "$GIT_DIR"
cd ../
TO_PATH=$GIT_DIR/hooks/pre-push
cd "$PWD"/.git-hooks/
for SCRIPT_PATH in "$PWD"/*.bash
do
	SCRIPT_NAME=$(basename "$SCRIPT_PATH")
	if [ $SCRIPT_NAME != install-git-hooks.bash ]; then
		SCRIPT_NAME_WITHOUT_EXTENSION=${SCRIPT_NAME%.*}
		TO_PATH=$GIT_DIR/hooks/$SCRIPT_NAME_WITHOUT_EXTENSION
		echo "➡️ Copy From => $SCRIPT_PATH"
		echo "➡️ Copy To => $TO_PATH"
		ln -sf "$SCRIPT_PATH" "$TO_PATH"
	fi
done
echo "➡️ Hooks installed successfully ✅"