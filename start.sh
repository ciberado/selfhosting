#!/bin/bash

for dir in */ ; do
    name="${dir%/}"
    # Skip directories ending with .off
    if [[ -d "$dir" && ! "$name" =~ \.off$ ]]; then
        # Check if docker-compose.yml or docker-compose.yaml exists
        if [[ -f "$dir/docker-compose.yml" || -f "$dir/docker-compose.yaml" ]]; then
            echo "Running 'docker compose up -d' in $dir"
            (cd "$dir" && docker compose down && docker compose up -d)
        else
            echo "Skipping $dir - no docker-compose file found"
        fi
    else
        echo "Skipping $dir"
    fi
done

