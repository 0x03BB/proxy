#!/bin/ash

# Get the container name. Exit if it isn't running.
CONTAINER=$(docker-compose ps -q)
if [[ -z "${CONTAINER}" ]]; then
    echo "No container running"
    exit 1
fi

# Delete the container’s configuration files.
docker exec "${CONTAINER}" ash -c 'rm -rf /etc/nginx/conf.d/*'

# Copy the configuration files from the host.
docker cp ./conf.d/ "${CONTAINER}":/etc/nginx/

# Send the 'reload' signal to nginx. This reloads the configuration without restarting the process.
docker exec "${CONTAINER}" nginx -s reload
