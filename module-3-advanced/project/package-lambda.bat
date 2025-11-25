@echo off
REM Script to package Lambda function for deployment (Windows)

echo Packaging Lambda function...

cd /d "%~dp0lambda"

REM Remove old zip if exists
if exist function.zip del function.zip

REM Create zip file using PowerShell
powershell -Command "Compress-Archive -Path index.py -DestinationPath function.zip -Force"

echo.
echo Lambda function packaged successfully!
echo Created: lambda\function.zip
