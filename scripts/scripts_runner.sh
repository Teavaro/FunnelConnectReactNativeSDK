#!/bin/bash
echo "➡️ Installing git scripts..."
GIT_SCRIPT_NAME=install-git-hooks.bash
cd ..
cd .git-hooks/
if [ -f "$PWD/$GIT_SCRIPT_NAME" ]; then
	echo "-------------- $GIT_SCRIPT_NAME --------------"
	bash "$GIT_SCRIPT_NAME"
fi
echo "------------------------------------------------------"
echo "✅ Git scripts finished successfully."
