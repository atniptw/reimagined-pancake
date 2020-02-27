#!/bin/sh

echo "Waiting for postgres..."
echo ${twitter-db}
while ! nc -z twitter-db 5432; do
  sleep 0.1
done

echo "PostgreSQL started"

flask run -h 0.0.0.0