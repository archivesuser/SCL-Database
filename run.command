#!/bin/bash

homebrew_check() {
	if which brew > /dev/null 2>&1; then
		echo 'Installing Homebrew...'
		echo 'You will be asked for your password'
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
	if ! which brew > /dev/null 2>&1; then
		echo
		echo 'ERROR: Unable to install Homebrew'
		echo 'Please contact Justin <justinnhli@oxy.edu> for support'
		# FIXME make it obvious that an error has occurred
	fi
}

python_check() {
	if ! which python3 >/dev/null 2>&1; then
		echo 'Python not detected; installing...'
		install_homebrew && brew install python3
	fi
	if ! which python3 > /dev/null 2>&1; then
		echo
		echo 'ERROR: Unable to install Python'
		echo 'Please contact Justin <justinnhli@oxy.edu> for support'
		# FIXME make it obvious that an error has occurred
		exit 1
	fi
}

tesseract_check() {
	if ! which tesseract >/dev/null 2>&1; then
		echo 'tesseract not detected; installing...'
		install_homebrew && brew install tesseract
	fi
	if ! which tesseract > /dev/null 2>&1; then
		echo
		echo 'ERROR: Unable to install tesseract'
		echo 'Please contact Justin Li <justinnhli@oxy.edu> for support'
		# FIXME make it obvious that an error has occurred
		exit 1
	fi
}

pip_check() {
	if ! which pip >/dev/null 2>&1; then
		echo 'pip not detected; installing...'
		# FIXME
	fi
	if ! which pip >/dev/null 2>&1; then
		echo
		echo 'ERROR: Unable to install pip'
		echo 'Please contact Justin Li <justinnhli@oxy.edu> for support'
		exit 1
	fi
	cat requirements.txt | sed 's/=.*//' | while read module; do
		if ! pip list 2>/dev/null | grep "$module" >/dev/null 2>&1; then
			pip install -r requirements.txt
			break
		fi
	done
}

# leave some space from the top
clear

# change to the current directory
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# check that everything is installed
if ! ( tesseract_check && pip_check ); then
	# FIXME make it more obvious that an error has occurred
	echo
	echo 'AN ERROR HAS OCCURRED'
	echo 'Please copy the text in this window in your email to <justinnhli@oxy.edu>'
	echo
	read -p "Press <Enter> to continue (and close this window)"
	exit
fi

# run the database updates
python3 database.py

# ask the user to close the window
read -p "Press <Enter> to close this window"
exit