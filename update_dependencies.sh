#!/bin/bash

# Usage: ./update_dependencies.sh path/to/package.json npm
# macOS with homebrew => (brew install jq)
# Ubuntu with apt-get => (sudo apt-get install jq)

FILE_PATH=$1
PACKAGE_MANAGER=$2

# Check if the provided path is a directory and append 'package.json' if it is.
if [[ -d "$FILE_PATH" ]]; then
    FILE_PATH="${FILE_PATH%/}/package.json" # Removes any trailing slash and appends '/package.json'
fi

if [[ ! -f "$FILE_PATH" ]]; then
    echo "package.json not found at specified path: $FILE_PATH"
    exit 1
fi

if [[ "$PACKAGE_MANAGER" != "npm" && "$PACKAGE_MANAGER" != "yarn" ]]; then
    echo "Invalid package manager specified. Use 'npm' or 'yarn'."
    exit 1
fi

#if ! command -v jq &> /dev/null; then
#    echo "jq could not be found. Please install jq to use this script."
#    exit 1
#fi

if ! command -v jq &> /dev/null; then
    echo "jq could not be found. Running the jq install wizard..."
    # Call the check_jq_installation.sh script
    ./check_jq_installation.sh

    # Check if jq is installed after running the installation script
    if ! command -v jq &> /dev/null; then
        echo "jq is still not installed. Exiting script."
        exit 1
    fi
fi

# Function to update dependencies
update_dependencies() {
    local deps=$1
    for dep in $(jq -r 'keys[]' <<< "$deps"); do
	if [[ "$PACKAGE_MANAGER" == "npm" ]]; then
            echo "npm install $dep@latest"
            npm install "$dep"@latest
        else
            echo "yarn add $dep@latest"
            yarn add "$dep"@latest
        fi
    done
}

echo_dependencies() {
    local deps=$1
    echo "Preview of commands to be executed:"
    for dep in $(jq -r 'keys[]' <<< "$deps"); do
        if [[ "$PACKAGE_MANAGER" == "npm" ]]; then
            echo "npm install $dep@latest"
        else
            echo "yarn add $dep@latest"
        fi
    done
}

# Check for nvm and prompt for Node.js version
if command -v nvm > /dev/null; then
    echo "nvm found. Please enter the Node.js version you'd like to use (e.g., 14, 16, 18), or press enter to use the current version:"
    read -p "Node.js version: " node_version
    if [ -n "$node_version" ]; then
        nvm use $node_version
        if [ $? -ne 0 ]; then
            echo "Error switching to Node.js version $node_version. Please ensure the version is installed with nvm."
            exit 1
        fi
    fi
else
    echo "nvm not found. Continuing with the current Node.js version."
fi

# Extract dependencies and devDependencies
dependencies=$(jq '.dependencies' $FILE_PATH)
devDependencies=$(jq '.devDependencies' $FILE_PATH)

# Update dependencies
echo "Updating dependencies..."
update_dependencies "$dependencies"
#echo_dependencies "$dependencies"

# Update devDependencies
echo "Updating devDependencies..."
update_dependencies "$devDependencies"
#echo_dependencies "$devDependencies"

echo "Update complete!"
