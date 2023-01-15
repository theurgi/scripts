#!/usr/bin/env bash

# Select and open applications with fzf. Supports macOS and Linux.
#
# Dependencies:
# - fzf: https://github.com/junegunn/fzf
#
# Usage:
# - Add the file paths that contain your applications to the APPLICATION_PATHS array.
# - Run app.
# - Search for applications with fzf.
# - Press Enter to open the selected application or escape to exit.

APPLICATION_PATHS=(
	"/Applications"
	"/System/Applications"
)

get_applications() {
	if [[ "$OSTYPE" == "darwin"* ]]; then
		for path in "${APPLICATION_PATHS[@]}"; do
			find "$path" -name '*.app' -maxdepth 2 -type d -print0 | xargs -0 -I {} basename {} .app
		done
	elif
		[[ "$OSTYPE" == "linux-gnu" ]]
	then
		for path in "${APPLICATION_PATHS[@]}"; do
			find "$path" -name '*.desktop' -maxdepth 2 -type d -print0 | xargs -0 -I {} basename {} .desktop
		done
	else
		echo "Unsupported OS: $OSTYPE"
		exit 1
	fi
}

main() {
	app=$(get_applications | fzf --prompt="app " --reverse)

	[[ -z "$app" ]] && exit 0

	if [[ "$OSTYPE" == "darwin"* ]]; then
		open -a "$app"
	else
		xdg-open "$app"
	fi
}

main
