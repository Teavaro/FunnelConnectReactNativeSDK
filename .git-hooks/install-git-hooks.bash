#!/bin/bash

echo "➡️ Installing git hooks..."
GIT_DIR=$(git rev-parse --git-dir)
PRE_PUSH_PATH=$GIT_DIR/hooks/pre-push
PRE_COMMIT_PATH=$GIT_DIR/hooks/pre-commit

cd "$GIT_DIR"
cd ../
cd "$PWD"/.git-hooks/

for SCRIPT_PATH in "$PWD"/*.bash
do
	SCRIPT_NAME=$(basename "$SCRIPT_PATH")
	if [ $SCRIPT_NAME == pre-push.bash ]; then
		echo "➡️ Installing pre-push git hook..."
		SCRIPT_NAME_WITHOUT_EXTENSION=${SCRIPT_NAME%.*}
		PRE_PUSH_PATH=$GIT_DIR/hooks/$SCRIPT_NAME_WITHOUT_EXTENSION
		echo "➡️ Copy From => $SCRIPT_PATH"
		echo "➡️ Copy To => $PRE_PUSH_PATH"
		ln -sf "$SCRIPT_PATH" "$PRE_PUSH_PATH"
	elif [ $SCRIPT_NAME == pre-commit.bash ]; then
		echo "➡️ Installing pre-commit git hook..."
		SCRIPT_NAME_WITHOUT_EXTENSION=${SCRIPT_NAME%.*}
		PRE_COMMIT_PATH=$GIT_DIR/hooks/$SCRIPT_NAME_WITHOUT_EXTENSION
		echo "➡️ Copy From => $SCRIPT_PATH"
		echo "➡️ Copy To => $PRE_COMMIT_PATH"
		ln -sf "$SCRIPT_PATH" "$PRE_COMMIT_PATH"
	fi
done
echo "➡️ Hooks installed successfully ✅"