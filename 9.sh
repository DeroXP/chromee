#!/bin/bash

# Move to parent directory
cd ..

# Check if the ./hjdkshj directory exists
if [ -d ./hjdkshj ]
then
  # Move all files from ./hjdkshj to the parent directory
  mv ./hjdkshj/* .

  # Remove the ./hjdkshj directory
  rm -r ./hjdkshj

  echo "Files moved successfully!"
else
  echo "./hjdkshj directory not found!"
fi
