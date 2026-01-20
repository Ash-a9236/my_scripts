#!/bin/bash
#The code is ugly XD
#export GIT_SSH_COMMAND="ssh -i /d/.ssh/id_ed25519"

DRIVE_ROOT="$(cd "$(dirname "$BASH_SOURCE")/../../.." && pwd -W)"
export HOME="$DRIVE_ROOT"
echo "HOME forced to $HOME"

read -p "Please enter the drive letter (i.e. E) -> " DRIVE
read -p "Please enter your ssh key id (i.e. id_00123) -> " SSH_KEY

# Only start if not already running
if [[ -z "$SSH_AGENT_PID" ]]; then
    echo "Adding key to agent..."
    eval "$(ssh-agent -s)"
else
    echo "SSH agent already running..."
fi

echo "Reading ssh agent : Checking if ssh loaded..."
sleep 1

# Little loading dots for effect
for i in {1..3}; do
    echo "."
    sleep 1
done

#if the key is not already added
if ! ssh-add -l >/dev/null 2>&1; then
    echo "ssh agent empty : manually adding key to agent..."
    ssh-add /$DRIVE/.ssh/$SSH_KEY

    echo "Reading ssh agent : Checking if ssh loaded..."
    sleep 1

    # Little loading dots for effect
    for i in {1..3}; do
        echo "."
        sleep 1
    done

    if ! ssh-add -l | >/dev/null 2>&1; then
        echo "ssh agent empty : script failed, try to run the command yourself"
        echo "ssh-add /$DRIVE/.ssh/$SSH_KEY"
        sleep 2
    else
        echo "SSH AUTH SUCCESS"
    fi
else
    echo "SSH AUTH SUCCESS"
fi

read -p "Do you want to configure your name and email automatically ? (Y/n) -> " USER_ANS

if [[ "$USER_ANS" == "Y" || "$USER_ANS" == "y" ]]; then
    read -p "Enter your username -> " USERNAME
    read -p "Is $USERNAME correct ? (Y/n) -> " USER_ANS_02

    if [[ "$USER_ANS_02" == "N" || "$USER_ANS_02" == "n" ]]; then
        read -p "Enter your username -> " USERNAME
    fi

    read -p "Enter your email (you@example.com) -> " EMAIL
    read -p "Is $EMAIL correct ? (Y/n) -> " USER_ANS_03

    if [[ "$USER_ANS_03" == "N" || "$USER_ANS_03" == "n" ]]; then
        read -p "Enter your email -> " EMAIL
    fi

    echo "Adding username and email to git global settings ..."
    git config --global user.name "$USERNAME"
    git config --global user.email "$EMAIL"

    # Little loading dots for effect
    for i in {1..3}; do
        echo "."
        sleep 1
    done

    echo "Getting git user information ..."
    if ! git config user.name 2>&1 | git config user.email 2>&1; then
        echo "Git authentification empty : try to run the commands yourself"
        echo "git config --global user.name"
        echo "git config --global user.email"

    else
        USERNAME_GIT=$(git config user.name 2>&1)

        echo "USERNAME : $USERNAME_GIT"
        echo "EMAIL : $(git config user.email 2>&1)"
        echo "GIT CONFIGURATION SUCCESS, WELCOME $USERNAME_GIT"
    fi

fi
