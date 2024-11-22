#!/bin/bash

# Check if the cache path exists
if [ -d "<<parameters.cache-path>>" ]; then
  echo "Cache path exists. Archiving..."

  # Create the archive
  tar -czf "<<parameters.cache-path>>.tar.gz" -C "<<parameters.cache-path>>" .
  echo "Archive created: <<parameters.cache-path>>.tar.gz"

  # Configure S3 settings
  aws configure set default.s3.max_concurrent_requests "<<parameters.s3-max-concurrent-requests>>"
  aws configure set default.s3.max_queue_size "<<parameters.s3-max-queue-size>>"
  aws configure set default.s3.multipart_threshold "<<parameters.s3-multipart-threshold>>"

  # Upload the archive to the S3 bucket
  aws s3 cp "<<parameters.cache-path>>.tar.gz" "s3://<<parameters.bucket-name>>/<<parameters.cache-key>>/<<parameters.cache-path>>.tar.gz"
  echo "Cache archive uploaded to S3."
else
  echo "Cache path does not exist. Skipping upload."
fi
