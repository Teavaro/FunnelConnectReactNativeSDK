#!/bin/bash
echo "➡️ Installing scripts..."
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
echo "✅ Scripts installed successfully."