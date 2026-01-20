#!/bin/bash

#script to make a git see a repository as 'safe' while entering a relative path

read -p "Enter the name of your drive (i.e. E) -> " DRIVE

read -p "Does the repo need the PHP Wampoon server? (Y/n) -> " USER_ANS_01

if [[ "$USER_ANS_01" == "Y" || "$USER_ANS_01" == "y" ]]; then
    echo "Putting repo in $DRIVE:/Wampoon/htdocs/"
    read -p "Enter the relative path from htdocs (relative/path) -> " REPO_REL_PATH
    FULL_PATH="$DRIVE:/Wampoon/htdocs/$REPO_REL_PATH"
else
    echo "Putting repo in $DRIVE:/Documents"
    read -p "Enter the relative path from Documents (relative/path) -> " REPO_REL_PATH
    FULL_PATH="$DRIVE:/Documents/$REPO_REL_PATH"
fi

git config --global --add safe.directory "$FULL_PATH"

# Little loading dots for effect
for i in {1..3}; do
    echo "."
    sleep 1
done

echo "Repo '$FULL_PATH' marked safe."
