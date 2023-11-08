#!/bin/bash

# Define necessary variables.
REPO_NAME="toolbuilder"
REPO_URL="https://github.com/m-c-frank/$REPO_NAME.git"
INSTALL_PATH="$HOME/.local/bin"
CLONE_PATH="./$REPO_NAME"


# Update package database and install Git and Go if they are not already installed
if ! command -v git &>/dev/null; then
    echo "Git is not installed. Installing Git..."
    sudo pacman -Sy --noconfirm git
fi

if ! command -v go &>/dev/null; then
    echo "Go is not installed. Installing Go..."
    sudo pacman -Sy --noconfirm go
fi

# Clone the ToolBuilder repository.
git clone "$REPO_URL" "./"

# Change to the repository directory.
cd "$HOME/toolbuilder-repo" || exit

# Compile the Go source code.
go build -o "$REPO_NAME" toolbuilder.go

# Make the directory if it doesn't exist.
mkdir -p "$INSTALL_PATH"

# Install the binary.
mv "$REPO_NAME" "$INSTALL_PATH"

# Clean up the repository directory.
if [[ -d "$HOME/toolbuilder-repo" ]]; then
    rm -rf "$HOME/toolbuilder-repo"
fi

# Add the install path to the PATH if it's not already there.
if [[ ":$PATH:" != *":$INSTALL_PATH:"* ]]; then
    echo "export PATH=\$PATH:$INSTALL_PATH" >> "$HOME/.profile"
    source "$HOME/.profile"
fi

echo "ToolBuilder installed successfully."

