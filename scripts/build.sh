#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <serve | deploy>"
    exit 1
fi

cd "$(dirname "$0")/.."

TAILWIND_PATH="themes/swlacy.com/tailwind"
TAILWIND_INPUT="tailwind.css"
TAILWIND_OUTPUT="../assets/main.css"

case "$1" in
    serve)
        SESSION_NAME="blog-build-serve"

        if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
            echo "Session '$SESSION_NAME' already exists: Attaching..."
            tmux attach -t "$SESSION_NAME"
            exit 0
        fi

        tmux new-session -d -s "$SESSION_NAME"
        tmux split-window -h -t "$SESSION_NAME"

        tmux send-keys -t "$SESSION_NAME:0.0" \
            "hugo serve --bind=0.0.0.0 --noHTTPCache --gc --enableGitInfo --buildDrafts --printPathWarnings --printUnusedTemplates" C-m

        tmux send-keys -t "$SESSION_NAME:0.1" \
            "cd $TAILWIND_PATH && tailwindcss --input $TAILWIND_INPUT --output $TAILWIND_OUTPUT --watch" C-m

        tmux attach -t "$SESSION_NAME"
        ;;

    deploy)
        echo "Hugo build..."
        hugo --cleanDestinationDir --minify --gc --ignoreCache --printPathWarnings

        if [ $? -ne 0 ]; then
            echo "Hugo build failed; exiting"
            exit 1
        fi

        read -p "Proceed? [Y/y]: " CONFIRMATION_CHOICE

        if [[ "$CONFIRMATION_CHOICE" == "Y" || "$CONFIRMATION_CHOICE" == "y" ]]; then
            echo "Proceeding..."
        else
            echo "Canceled"
            exit 1
        fi

        read -p "Commit message: " COMMIT_MESSAGE

        echo "Pushing to GitHub..."
        git add -A
        git commit -m "$COMMIT_MESSAGE"
        git push

        echo "Deploying to Firebase..."
        firebase deploy

        if [ $? -ne 0 ]; then
            echo "Firebase deployment failed; exiting"
            exit 1
        fi

        echo "Success!"
        ;;

    *)
        echo "Invalid arg: Specify either 'serve' or 'deploy'"
        exit 1
        ;;
esac
