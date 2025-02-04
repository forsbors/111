#!/bin/bash

# Telegram bot settings
TELEGRAM_TOKEN="6358738990:AAEBRPzqmIy2O6iFV1-5W9W72wVmToHzpWo"
TELEGRAM_CHAT_ID="507394248"
WORKER_NAME=${WORKER_NAME:-"miner001"}  # Использует значение из переменной окружения или "miner001" по умолчанию

# Function to send Telegram message
send_telegram_message() {
    MESSAGE="$1"
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
        -d chat_id="$TELEGRAM_CHAT_ID" \
        -d text="$MESSAGE" \
        -d parse_mode="HTML" >/dev/null
}

# Define variables
URL="https://github.com/trexminer/T-Rex/releases/download/0.26.8/t-rex-0.26.8-linux.tar.gz"
FILENAME="t-rex-0.26.8-linux.tar.gz"
DEST_DIR="/root"
CHECK_FILE="$DEST_DIR/t-rex"
RETRY_INTERVAL=120

# Check if WORKER_NAME environment variable exists
if [ -z "$WORKER_NAME" ]; then
    send_telegram_message "❌ Environment variable WORKER_NAME is not set. Exiting."
    exit 1
fi

# Function to handle errors
error_exit() {
    send_telegram_message "❌ Error: $1"
    exit 1
}

# Function to download with indefinite retries
download_with_retries() {
    while true; do
        wget -O "$FILENAME" "$URL"
        if [ $? -eq 0 ]; then
            if [ -s "$FILENAME" ]; then
                send_telegram_message "✅ Download completed successfully"
                return 0
            else
                send_telegram_message "⚠️ Downloaded file is empty. Retrying in $RETRY_INTERVAL seconds..."
                rm -f "$FILENAME"
            fi
        else
            send_telegram_message "⚠️ Download failed. Retrying in $RETRY_INTERVAL seconds..."
        fi
        sleep $RETRY_INTERVAL
    done
}

# Check if the CHECK_FILE already exists
if [ -f "$CHECK_FILE" ]; then
    send_telegram_message "ℹ️ $CHECK_FILE already exists. Skipping download and extraction."
else
    # Check if the file already exists and is valid
    if [ -f "$FILENAME" ]; then
        if [ -s "$FILENAME" ]; then
            send_telegram_message "ℹ️ $FILENAME already exists and is valid. Skipping download."
        else
            send_telegram_message "⚠️ $FILENAME exists but is empty. Redownloading..."
            rm -f "$FILENAME"
            download_with_retries
        fi
    else
        send_telegram_message "🔄 Starting download..."
        download_with_retries
    fi
    
    # Extract the file to the destination directory
    send_telegram_message "📦 Extracting files..."
    tar -xzf "$FILENAME" -C "$DEST_DIR"
    if [ $? -ne 0 ]; then
        error_exit "Extraction failed. Exiting."
    fi
    
    # Check if the extracted file exists
    if [ ! -f "$CHECK_FILE" ]; then
        error_exit "Extraction verification failed: $CHECK_FILE not found. Exiting."
    fi
    
    # Clean up the downloaded tar.gz file
    rm -f "$FILENAME"
    send_telegram_message "✅ Download and extraction completed successfully."
fi

# Run program in a loop, in case of crash, so it can restart
while true; do
    send_telegram_message "🚀 Starting mining process..."
    /root/t-rex -a kawpow -o stratum+tcp://eu.clore.k1pool.com:5030 -u Krf63bWe2Eme2R3PPnPepH8YQQoyQmvjNuY.$WORKER_NAME -p x
    EXIT_CODE=$?
    send_telegram_message "⚠️ Mining process stopped with exit code $EXIT_CODE. Restarting in 10 seconds..."
    sleep 10 # Wait 10 seconds between restarts
done
