#!/bin/bash
remote_host=$1
rsync -avr /home/cwarren/Documents -e ssh ${remote_host}:backup/
rsync -avr /home/cwarren/personal  -e ssh ${remote_host}:backup/
rsync -avr /home/cwarren/Pictures  -e ssh ${remote_host}:backup/

