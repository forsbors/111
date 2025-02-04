#!/bin/bash

# Define variables
URL="https://github.com/trexminer/T-Rex/releases/download/0.26.8/t-rex-0.26.8-linux.tar.gz"
FILENAME="t-rex-0.26.8-linux.tar.gz"
DEST_DIR="/root"
CHECK_FILE="$DEST_DIR/t-rex"
RETRY_INTERVAL=120

# Check if WORKER_NAME environment variable exists
if [ -z "$WORKER_NAME" ]; then
    echo "Environment variable WORKER_NAME is not set. Exiting."
    exit 1
fi

# Function to handle errors
error_exit() {
    echo "$1" >&2
    exit 1
}

# Function to download with indefinite retries
download_with_retries() {
    while true; do
        wget -O "$FILENAME" "$URL"
        if [ $? -eq 0 ]; then
            if [ -s "$FILENAME" ]; then
                return 0
            else
                echo "Downloaded file is empty. Retrying in $RETRY_INTERVAL seconds..."
                rm -f "$FILENAME"
            fi
        else
            echo "Download failed. Retrying in $RETRY_INTERVAL seconds..."
        fi
        sleep $RETRY_INTERVAL
    done
}

# Check if the CHECK_FILE already exists
if [ -f "$CHECK_FILE" ]; then
    echo "$CHECK_FILE already exists. Skipping download and extraction."
else
    # Check if the file already exists and is valid
    if [ -f "$FILENAME" ]; then
        if [ -s "$FILENAME" ]; then
            echo "$FILENAME already exists and is valid. Skipping download."
        else
            echo "$FILENAME exists but is empty. Redownloading..."
            rm -f "$FILENAME"
            download_with_retries
        fi
    else
        download_with_retries
    fi

    # Extract the file to the destination directory
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

    echo "Download and extraction completed successfully."
fi

# Run program in a loop, in case of crash, so it can restart
while true; do
    echo "Running post-download and extraction task..."
    # Run t-rex pointed to vipor.net pool for CLORE Blockchain, use ENV variable WORKER_NAME as worker name for the pool
    /root/t-rex -a kawpow -o stratum+tcp://eu.clore.k1pool.com:5030 -u Krf63bWe2Eme2R3PPnPepH8YQQoyQmvjNuY.$WORKER_NAME -p x
    sleep 10 # Wait 10 seconds between restarts
done
