#!/usr/bin/env bash

cd "$(dirname "$0")/.."

TAILWIND_PATH="themes/swlacycom/tailwind"
TAILWIND_INPUT="tailwind.css"
TAILWIND_OUTPUT="../assets/main.css"

SESSION_NAME="swlacycom-build-serve"

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session '$SESSION_NAME' already exists: Attaching..."
    tmux attach -t "$SESSION_NAME"
    exit 0
fi

tmux new-session -d -s "$SESSION_NAME"
tmux split-window -h -t "$SESSION_NAME"

tmux send-keys -t "$SESSION_NAME:0.0" \
    "hugo serve --bind=0.0.0.0 --noHTTPCache --gc --buildDrafts --printPathWarnings --printUnusedTemplates" C-m

tmux send-keys -t "$SESSION_NAME:0.1" \
    "cd $TAILWIND_PATH && tailwindcss --input $TAILWIND_INPUT --output $TAILWIND_OUTPUT --watch" C-m

sleep 1
firefox "http://localhost:1313"

tmux attach -t "$SESSION_NAME"
