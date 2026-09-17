#!/bin/bash

ACTION=$1
NAME=$2
PORT=${3:-8080}

IMAGE_NAME="paperless-preview-base"

show_usage() {
	echo "Usage: ./preview.sh [create|destroy|list] <preview-name> [port]"
	echo "Examples:"
	echo "  ./preview.sh create preview1 8081"
	echo "  ./preview.sh destroy preview1"
	echo "  ./preview.sh list"
	exit 1
}

if [ -z "$ACTION" ]; then show_usage; fi

case $ACTION in
	create)
		if [ -z "$NAME" ]; then show_usage; fi

		echo "Ensuring base image is built..."
		docker build -t $IMAGE_NAME .

		echo "Preparing preview environment: $NAME..."
		mkdir -p "./previews/$NAME/data"

		# Optionally update seed DB if modified locally
		if [ -f "./src/db.sqlite3" ]; then
			cp "./src/db.sqlite3" "./previews/$NAME/data/db.sqlite3"
		fi

		echo "Launching container 'preview-$NAME' on port $PORT..."
		docker run -d \
			--name "preview-$NAME" \
			-p "$PORT:8000" \
			-v "$(pwd)/previews/$NAME/data:/app/data" \
			$IMAGE_NAME

		echo "Verification: Container status"
		docker ps --filter "name=preview-$NAME"
		echo "------------------------------------------------"
		echo "Preview live at: http://localhost:$PORT"
		;;

	destroy)
		if [ -z "$NAME" ]; then show_usage; fi

		echo "Removing preview-$NAME..."
		docker stop "preview-$NAME" 2>/dev/null || true
		docker rm "preview-$NAME" 2>/dev/null || true
		rm -rf "./previews/$NAME"
		echo "Preview $NAME completely removed."
		;;

	list)
		docker ps --filter "name=preview-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
		;;

	*)
		show_usage
		;;
esac
