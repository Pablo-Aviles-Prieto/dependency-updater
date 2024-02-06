#!/bin/bash

# Setup script to prepare the environment for running other scripts

echo "Preparing environment..."

# Function to check if a file is executable
check_and_make_executable() {
    local script_path="$1"
    if [ ! -x "$script_path" ]; then
        echo "$script_path is not executable, setting executable permissions..."
        chmod +x "$script_path"
    else
        echo "$script_path is already executable."
    fi
}

# Assuming the scripts are in the current directory
check_and_make_executable update_dependencies.sh
check_and_make_executable check_jq_installation.sh

# Prompt user for package.json path and package manager
read -p "Enter the path to your package.json file: " package_json_path
read -p "Enter your package manager (npm or yarn): " package_manager

# Validate input for package manager
if [[ "$package_manager" != "npm" && "$package_manager" != "yarn" ]]; then
    echo "Invalid package manager. Please enter 'npm' or 'yarn'. Exiting script."
    exit 1
fi

echo "Proceeding with update_dependencies.sh..."
echo "Using package.json path: $package_json_path"
echo "Using package manager: $package_manager"

# Run update_dependencies.sh with provided arguments
./update_dependencies.sh "$package_json_path" "$package_manager"

