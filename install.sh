#!/bin/bash

dir="$HOME/.wsl"
user=$(whoami)

echo
echo "Welcome to easyWSLbash installer"
echo

mkdir -p "$dir"
cd "$dir"

git clone https://github.com/leongrdic/easyWSLbash.git
if [ -f "$dir/env.sh" ]; then
	rm -f easyWSLbash/env.sh
fi

echo
echo "Moving files and fixing permissions"

mv easyWSLbash/* .
rm -rf easyWSLbash

chmod +x wrapper.sh
chmod +x bin/linux/wsl-alias

mkdir -p bin/win

if [ $(grep -c '^wsl:' /etc/passwd) == 1 ]; then
	echo "The wsl user already exists - skipping creation"
else
	echo "I need root access to setup a new user that will be used for pre-mounting drives"

	sudo useradd -s /bin/bash -G sudo wsl
	sudo passwd -l wsl

	sudo su -c "echo 'wsl ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
	sudo su -c "echo '$user ALL=(wsl) NOPASSWD:ALL' >> /etc/sudoers"
fi

echo

if [ -z "$(ls -A bin/win)" ]; then
	echo "Choose a command you'd like to use to call bash from Windows"

	echo -n "Command [b]: "
	read cmd_win

	if [ -z "$cmd_win" ]; then
		cmd_win="b"
	fi

	cmd_path="bin/win/$cmd_win.bat"
	cp template.bat "$cmd_path"
	perl -pi -e 's/{alias}//g' "$cmd_path"
fi

dir_win=$(echo "$dir" | sed 's/\//\\/g')
dir_win="$dir_win\\bin\\win"

echo
echo "The installation has completed!"
echo
echo "Please add the following directory to your PATH enviroment variable in Windows:"
echo "%localappdata%\\Packages\\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\\LocalState\\rootfs$dir_win"
echo
