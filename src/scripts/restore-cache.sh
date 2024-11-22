#!/bin/bash

echo "Cache Key is $CACHE_KEY"
echo "Cache Path is $CACHE_PATH"

# Check if CACHE_KEY and CACHE_PATH are set
if [ -z "$CACHE_KEY" ] || [ -z "$CACHE_PATH" ]; then
  echo "CACHE_KEY or CACHE_PATH is not set. Exiting..."
  exit 1
fi

# Check if the cache path already exists locally
if [ -d "$CACHE_PATH/$CACHE_KEY" ]; then
    echo "Cache already exists locally at $CACHE_PATH. Skipping download."
    exit 0
fi

# Configure S3 settings
aws configure set default.s3.max_concurrent_requests "$MAX_CONCURRENT_REQUESTS"
aws configure set default.s3.max_queue_size "$MAX_QUEUE_SIZE"
aws configure set default.s3.multipart_threshold "$S3_MULTIPART_THRESHOLD"

# Check if the archive exists in the S3 bucket
echo "Checking if s3://$BUCKET_NAME/$CACHE_KEY/$CACHE_KEY.tar.gz exists..."
if aws s3 ls "s3://$BUCKET_NAME/$CACHE_KEY/$CACHE_KEY.tar.gz" > /dev/null 2>&1; then
    echo "Cache archive found. Downloading..."
    
    # Download the archive from the S3 bucket
    if aws s3 cp "s3://$BUCKET_NAME/$CACHE_KEY/$CACHE_KEY.tar.gz" "$CACHE_KEY.tar.gz"; then
        echo "Cache archive downloaded: $CACHE_KEY.tar.gz"

        if tar -xzf "$CACHE_KEY.tar.gz" .; then
            echo "Cache restored...."
        else
            echo "Failed to extract cache archive."
            exit 1
        fi
    else
        echo "Failed to download cache archive."
        exit 1
    fi
else
    echo "Cache archive not found in S3. Exiting..."
    exit 1
fi
