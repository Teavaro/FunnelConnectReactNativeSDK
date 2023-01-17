#!/bin/bash
GIT_DIR=$(git rev-parse --git-dir)
echo "➡️ Installing pre-push hook scripts..."
cd "$GIT_DIR"
cd ../
cd "$PWD"/.git-hooks/pre-push-scripts/
#
for SCRIPT_PATH in "$PWD"/*.bash
do
	echo "➡️ Installing $SCRIPT_PATH"
	# Ref: https://stackoverflow.com/questions/62915668/how-to-run-multiple-shell-scripts-one-by-one-in-single-go-using-another-shell-sc
	bash "$SCRIPT_PATH" -H
done