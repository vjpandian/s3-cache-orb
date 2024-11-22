#!/bin/bash

echo "Cache Key is $CACHE_KEY"
echo "Cache Path is $CACHE_PATH"

# Check if CACHE_KEY and CACHE_PATH are set
if [ -z "$CACHE_KEY" ] || [ -z "$CACHE_PATH" ]; then
  echo "Error: CACHE_KEY or CACHE_PATH is not set. Exiting..."
  exit 1
fi

# Check if the cache path already exists locally
if [ -d "$CACHE_PATH/$CACHE_KEY" ]; then
    echo "Cache already exists locally at $CACHE_PATH/$CACHE_KEY. Skipping download."
    exit 0
fi

# Check if the archive exists in the S3 bucket
echo "Checking if s3://$BUCKET_NAME/$CACHE_KEY/$CACHE_KEY.tar.gz exists..."
if aws s3 ls "s3://$BUCKET_NAME/$CACHE_KEY/$CACHE_KEY.tar.gz" > /dev/null 2>&1; then
    echo "Cache archive found. Downloading..."
    
    # Download the archive from the S3 bucket
    if aws s3 cp "s3://$BUCKET_NAME/$CACHE_KEY/$CACHE_KEY.tar.gz" "$CACHE_PATH/$CACHE_KEY.tar.gz"; then
        echo "Cache archive successfully downloaded to $CACHE_PATH/$CACHE_KEY.tar.gz"
    else
        echo "Error: Failed to download cache archive from S3."
        exit 1
    fi
else
    echo "Error: Cache archive not found in S3."
    exit 1
fi
