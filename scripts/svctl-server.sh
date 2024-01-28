#!/bin/bash

./svctl render . --watch &

# run the pr server
./start_pr.sh +noStatusMonitor 1 +multi 1 +dedicated 1
