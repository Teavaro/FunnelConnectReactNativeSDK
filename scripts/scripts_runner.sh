#!/bin/bash
echo "➡️ Starting creation scripts..."
for SCRIPT_PATH in "$PWD"/*.sh
do
	SCRIPT_NAME=$(basename "$SCRIPT_PATH")
	if [ $SCRIPT_NAME != scripts_runner.sh ]; then
		echo "-------------- $SCRIPT_NAME --------------"
		# Ref: https://stackoverflow.com/questions/62915668/how-to-run-multiple-shell-scripts-one-by-one-in-single-go-using-another-shell-sc
		bash "$SCRIPT_PATH" -H
	fi
done
echo "------------------------------------------------------"
echo "✅ Creation scripts finished successfully."

echo "➡️ Starting git scripts..."
GIT_SCRIPT_NAME=install-git-hooks.bash
cd ..
cd .git-hooks/
if [ -f "$PWD/$GIT_SCRIPT_NAME" ]; then
	echo "-------------- $GIT_SCRIPT_NAME --------------"
	bash "$GIT_SCRIPT_NAME"
fi
echo "------------------------------------------------------"
echo "✅ Git scripts finished successfully."