#!/bin/bash
# Script to package Lambda function for deployment

echo "Packaging Lambda function..."

cd "$(dirname "$0")/lambda"

# Remove old zip if exists
rm -f function.zip

# Create zip file
zip function.zip index.py

echo "✅ Lambda function packaged successfully!"
echo "📦 Created: lambda/function.zip"
