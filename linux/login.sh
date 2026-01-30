#!/bin/bash

# AUTHOR : ash_a9236 / ash-a9236
# This script is my own creation and is made to simplify SSH connections in places where the port 22 might be blocked or just as a more convinient way to login with a key on a public computer to remove the hassle of creating a new ket


echo "Please consider the following : "
echo "- You will be prompted to add a lifetime to your agent, it will be in minutes (minimum is therefore 1min)"
echo "- Please read the instructions carefully as there is no fallback. If you make a mistake, simply Ctrl + C then restart"

echo ""
echo ""
echo ""

# Only start if not already running
if [[ -z "$SSH_AGENT_PID" ]]; then
    echo "Adding key to agent..."
    eval "$(ssh-agent -s)"
else
    echo "SSH agent already running..."
fi

echo "Reading ssh agent : Checking if ssh loaded..."

for i in {1..3}; do
    echo "."
    sleep 1
done

echo "
Host github.com
    HostName ssh.github.com
    Port 443
    User git
" > ~/.ssh/config

read -p "Please enter your ssh key id (i.e. id_00123) -> " SSH_KEY
read -p "Are you in a portable USB ? (Y/n) -> " LOCATION_ANS

if [[ "$LOCATION_ANS" == "Y" || "$LOCATION_ANS" == "y" ]]; then
    read -p "Please enter the drive letter (i.e. E) -> " DRIVE

    if ! ssh-add -l >/dev/null 2>&1; then
    echo "ssh agent empty : manually adding key to agent..."
    ssh-add /$DRIVE/.ssh/$SSH_KEY

    echo "Reading ssh agent : Checking if ssh loaded..."
    sleep 1

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

else
    read -p  "Plesase enter the path to your .ssh folder (often under home/[username]/) : ommit the first '/' -> " DRIVE

    
    if ! ssh-add -l >/dev/null 2>&1; then
    echo "ssh agent empty : manually adding key to agent..."
    ssh-add /$DRIVE/.ssh/$SSH_KEY

    echo "Reading ssh agent : Checking if ssh loaded..."
    sleep 1

    for i in {1..3}; do
        echo "."
        sleep 1
    done

        if ! ssh-add -l | >/dev/null 2>&1; then
            echo "ssh agent empty : script failed, try to run the command yourself"
            echo "ssh-add $DRIVE/.ssh/$SSH_KEY"
            sleep 2
        else
            echo "SSH AUTH SUCCESS"
        fi
    else
        echo "SSH AUTH SUCCESS"
    fi
fi

#if the key is not already added


read -p "Do you wish to add a maximum lifetime to the agent (recommended if you are on a public computer) ? (Y/n) -> " USER_ANS_0

if [[ "$USER_ANS_0" == "Y" || "$USER_ANS_0" == "y" ]]; then
    read -p "Enter the maximum lifetime of your agent (in minutes) -> " LIFETIME
    ssh-add -t "$LIFETIME"m

    for i in {1..3}; do
        echo "."
        sleep 1
    done
  
    KILL_TIME=$(date -d "+$LIFETIME minutes" "+%Y-%m-%d %H:%M:%S")
    echo "The agent will be cleared at $KILL_TIME"
    echo "If you wish to clear the agent before so run ssh-add -D"
    
else 
    echo "No lifetime added to ssh agent"
    echo "To add a lifetime manually run ssh-add -t [lifetime]m"
fi


echo ""
echo ""

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
        echo "USERNAME : $(git config user.name 2>&1)"
        echo "EMAIL : $(git config user.email 2>&1)"
        echo "\GIT CONFIGURATION SUCCESS, WELCOME $(git config user.name 2>&1)"
    fi

    echo "Testing connection to github:443 ..."
    ssh -T git@github.com

fi

# echo "Current ssh identities on this computer : "
# ssh-add -l
