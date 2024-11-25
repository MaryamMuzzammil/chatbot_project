#!/bin/bash

# Function to add a new user
add_user() {
    echo "Enter your username:"
    read username
    if grep -q "$username" users.txt; then
        echo "User already exists."
    else
        echo "$username" >> users.txt
        echo "User $username added."
    fi
}

# Function to broadcast a message to all users with sender information
broadcast_message() {
    echo "Enter your username:"
    read sender
    if ! grep -q "^$sender$" users.txt; then
        echo "User $sender does not exist. Please add the user first."
        return
    fi
    
    echo "Enter the message to broadcast:"
    read message
    echo "Broadcasting message..."
    while IFS= read -r user; do
        echo "$user: $message (sent by $sender)" >> messages.txt
    done < users.txt
    echo "Broadcast complete."
}

# Function to view all messages
view_messages() {
    echo "All Messages:"
    while IFS= read -r message; do
        username=$(echo "$message" | cut -d':' -f1)
        content=$(echo "$message" | cut -d':' -f2-)
        echo "$username on $(date +'%Y-%m-%d'): $content"
    done < messages.txt | sort | uniq
}


# Main menu
while true; do
    echo "Chatbot Menu:"
    echo "1. Add a User"
    echo "2. Broadcast a Message"
    echo "3. View Messages"
    echo "4. Exit"
    echo "Choose an option:"
    read option
    case $option in
        1) add_user ;;
        2) broadcast_message ;;
        3) view_messages ;;
        4) echo "Exiting chatbot..."; exit ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
