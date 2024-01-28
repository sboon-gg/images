#!/bin/bash
# 
# Project Reality Server Update Script
#
# This script updates the PR server to the latest version
# It is intended to be run in a docker container
# but it can also be run on a normal linux machine
#
# If xmlstarlet is present (apt-get install xmlstarlet)
# it will store the new server version in a .prbf2-version file
#
# Usage:
# ./update.sh <PR_DIR> [LICENSE_FILE]
#
# Environment variables that will cause PR files to be overwritten:
# SERVER_IP: IP of the server
# SERVER_PORT: Port of the server

# Exit on error
set -e

if [ $# -eq 0 ]; then
  echo "Usage: $0 <PR_DIR> [LICENSE_FILE]"
  exit 1
fi

# Get PR_DIR from first argument (required)
PR_DIR=$1

# Check if PR_DIR exists
if [ ! -d "$PR_DIR" ]; then
  echo "PR directory does not exist: $PR_DIR"
  exit 1
fi

# Check if PR_DIR contains mods/pr
if [ ! -d "$PR_DIR/mods/pr" ]; then
  echo "PR directory does not contain mods/pr: $PR_DIR"
  exit 1
fi

echo "Directory: $PR_DIR is valid"

# Get LICENSE from environment variable
# or read from file if LICENSE_FILE is set
LICENSE=$LICENSE
if [ -n "$2" ]; then
  LICENSE=$(cat $2)
fi

# If SERVER_IP and SERVER_PORT are set, backup serversettings.con
# and restore it after update
SERVER_SETTINGS="$PR_DIR/mods/pr/settings/serversettings.con"
if [ -n "$SERVER_IP" ] && [ -n "$SERVER_PORT" ]; then
  echo "Updating serversettings.con"

  mv $SERVER_SETTINGS $SERVER_SETTINGS.bak
  echo "sv.serverIP \"${SERVER_IP}\"" > $SERVER_SETTINGS
  echo "sv.serverPort ${SERVER_PORT}" >> $SERVER_SETTINGS
fi

# If LICENSE is not empty, write it to license.key
LICENSE_KEY="$PR_DIR/mods/pr/license.key"
if [ -n "$LICENSE" ]; then
  echo "Updating license.key"
  # Backup license.key if it exists
  (test -e $LICENSE_KEY && mv $LICENSE_KEY $LICENSE_KEY.bak) || true
  echo -n $LICENSE > $LICENSE_KEY
fi

###
### Update PR ###
###
cd $PR_DIR/mods/pr/bin

# Set updater as executable
chmod +x prserverupdater-linux64

echo "Updating PR"

# Run updater
./prserverupdater-linux64

# Restore serversettings.con if it was backed up
test -e $SERVER_SETTINGS.bak && mv $SERVER_SETTINGS.bak $SERVER_SETTINGS || true

# Restore license.key if it was backed up
# or delete it if it was empty
if [ -e $LICENSE_KEY.bak ]; then
  mv $LICENSE_KEY.bak $LICENSE_KEY
elif [ -z "$LICENSE" ]; then
  rm $LICENSE_KEY
fi


# Store version in .prbf2-version file
if [ -x "$(command -v xmlstarlet)" ]; then
  VERSION=$(xmlstarlet sel -t -v '//mod/version' /pr/mods/pr/mod.desc | xargs) 
  echo "New version: $VERSION"
  echo $VERSION > $PR_DIR/.prbf2-version
fi
