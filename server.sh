#!/bin/bash

# File to store connected clients
clients_file="clients.txt"
messages_file="messages.txt"

# Create or clear the files
> "$clients_file"
> "$messages_file"

echo "Server started. Listening for messages..."

# Function to handle broadcasting messages
broadcast_message() {
    local sender=$1
    local message=$2

    # Log the incoming message on the server
    echo "Message received from $sender: $message"

    # Broadcast the message to all clients
    while IFS= read -r client; do
        echo "$client: $message (sent by $sender)" >> "$messages_file"
    done < "$clients_file"

    # Display broadcast log on the server
    echo "Broadcasted: \"$message\" (from $sender) to all connected clients."
}

# Start the server loop
while true; do
    # Listen for incoming messages via a named pipe (FIFO)
    if [ ! -p server_fifo ]; then
        mkfifo server_fifo
    fi

    # Read incoming messages in the format: "SENDER:MESSAGE"
    if read -r data < server_fifo; then
        sender=$(echo "$data" | cut -d':' -f1)
        message=$(echo "$data" | cut -d':' -f2-)

        # Check if sender is a connected client
        if grep -q "^$sender$" "$clients_file"; then
            broadcast_message "$sender" "$message"
        else
            echo "Unauthorized sender: $sender"
        fi
    fi
done



