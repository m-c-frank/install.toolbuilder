#!/bin/bash

# Define necessary variables.
REPO_NAME="toolbuilder"
REPO_URL="https://github.com/m-c-frank/$REPO_NAME.git"
INSTALL_PATH="$HOME/.local/bin"
CLONE_PATH="$HOME/$REPO_NAME"

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
if [[ -d "$CLONE_PATH" ]]; then
    echo "Cleaning up old repository directory..."
    rm -rf "$CLONE_PATH"
fi

echo "Cloning the ToolBuilder repository..."
git clone "$REPO_URL" "$CLONE_PATH"

# Change to the repository directory.
cd "$CLONE_PATH" || { echo "Cloning failed, directory not found."; exit 1; }

# Initialize Go module and tidy up dependencies.
echo "Initializing Go module..."
go mod init "$REPO_NAME"
go mod tidy

# Compile the Go source code.
echo "Building the ToolBuilder..."
go build -o "$REPO_NAME" .

# Make the directory if it doesn't exist.
mkdir -p "$INSTALL_PATH"

# Install the binary.
echo "Installing the ToolBuilder binary..."
mv "$REPO_NAME" "$INSTALL_PATH"

# Clean up the repository directory.
echo "Cleaning up..."
rm -rf "$CLONE_PATH"

echo "ToolBuilder installed successfully."

