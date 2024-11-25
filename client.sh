#!/bin/bash

# Server address (adjust if needed)
server_fifo="server_fifo"
clients_file="clients.txt"

# Function to add a user
add_user() {
    echo "Enter your username to register:"
    read username

    # Check if the server FIFO exists
    if [ ! -p $server_fifo ]; then
        echo "Server is not running. Exiting..."
        exit 1
    fi

    # Add the user to the server's client list
    if grep -q "^$username$" "$clients_file"; then
        echo "User already registered."
    else
        echo "$username" >> "$clients_file"
        echo "User $username registered successfully!"
    fi
}

# Function to send a message to the server
send_message() {
    echo "Enter your message:"
    read message
    echo "$username:$message" > "$server_fifo"
}

# Function to view messages
view_messages() {
    echo "All messages:"
    cat messages.txt | grep "$username" | sort | uniq
}

# Main menu
while true; do
    echo "Client Menu:"
    echo "1. Add/Register a User"
    echo "2. Send a Message"
    echo "3. View Messages"
    echo "4. Exit"
    echo "Choose an option:"
    read option

    case $option in
        1) add_user ;;
        2) 
            if [ -z "$username" ]; then
                echo "You must register first. Select option 1 to register."
            else
                send_message
            fi
            ;;
        3) view_messages ;;
        4) echo "Exiting client... Goodbye!"; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
