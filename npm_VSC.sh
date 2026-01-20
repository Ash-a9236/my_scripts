#!/bin/bash

read -p "Enter the name of your drive (i.e. E) -> " DRIVE
read -p "Enter the version of your node folder (i.e. v22.19.0) -> " NODE_V

# Add Node + npm global bin to PATH
export PATH="$DRIVE/node-$NODE_V-win-x64:/$DRIVE/node-$NODE_V-win-x64/npm-global/bin:$PATH"

sleep 2

# Launch VS Code
"/$DRIVE/VSC/Code.exe" &

echo "Checking if VSC launches properly"
# Little loading dots for effect
for i in {1..3}; do
    echo "."
    sleep 1
done

# Test if portable Node is in PATH
if command -v node >/dev/null 2>&1; then
    echo "Check : Node.js is available: $(node -v)"
else
    echo "[ERROR : Node.js not found in PATH]"
fi

# Test if portable npm is in PATH
if command -v npm >/dev/null 2>&1; then
    echo "Check : npm is available: $(npm -v)"
else
    echo "[ERROR : npm not found in PATH]"
fi

# Test if potable npx is in PATH
if command -v npx >/dev/null 2>&1; then
    echo "Check : npx works (you can run React/TS projects)"
    npx --version
else 
    echo "[ERROR : npx not available, React environment not set up]"
fi

# Little loading dots for effect
for i in {1..3}; do
    echo "."
    sleep 1
done

echo "VS Code started with portable Node.js from drive $DRIVE:"
