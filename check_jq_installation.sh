# !/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Select an option to proceed:"
    echo "1) Install jq on macOS (using Homebrew)"
    echo "2) Install jq on Linux (using apt-get)"
    echo "3) Exit"
    read -p "Enter your choice (1/2/3): " choice

    case $choice in
        1)
            if ! command -v brew &> /dev/null; then
                echo "Homebrew is not installed. Please install Homebrew first."
                exit 1
            else
                echo "Installing jq with Homebrew..."
                brew install jq
            fi
            ;;
        2)
            echo "You may need to enter your password to install jq."
            sudo apt-get update && sudo apt-get install -y jq
            ;;
        3)
            echo "Exiting script."
            exit 0
            ;;
        *)
            echo "Invalid choice. Exiting script."
            exit 1
            ;;
    esac
fi
