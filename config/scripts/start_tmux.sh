
TERMINAL="ghostty"
START_DIR=~/projects/tribe/react-app/

# === Sesjon: startup (frontend/backend/runtime) ===
SESSION_NAME="tribe"
if ! tmux has-session -t $SESSION_NAME 2>/dev/null; then
    # Opprett sesjonen
    tmux new-session -d -s $SESSION_NAME -n init -c $START_DIR

    tmux new-window -t $SESSION_NAME -n 'main' -c $START_DIR

    # === runtime med alle nødvendige kommandoer ===
    tmux new-window -t $SESSION_NAME -n runtime -c $START_DIR
    tmux send-keys -t $SESSION_NAME:runtime "builtin cd $START_DIR" C-m

    # Pane 0: venstre øvre – trib → npm start
    tmux split-window -h -t $SESSION_NAME:runtime -c $START_DIR
    tmux select-pane -L -t $SESSION_NAME:runtime

    # Pane 1: høyre øvre – backend → supabase
    tmux select-pane -R -t $SESSION_NAME:runtime
    tmux send-keys -t $SESSION_NAME:runtime.1  "supabase functions serve --env-file <(sops decrypt $GIT_ROOT/secrets/supabase.yaml && cat $GIT_ROOT/secrets/.env.sh)" 

    # Pane 2: venstre nedre – trib → npm start
    tmux select-pane -L -t $SESSION_NAME:runtime
    tmux split-window -v -t $SESSION_NAME:runtime -c $START_DIR
    tmux send-keys -t $SESSION_NAME:runtime.2 "npm start" C-m

    # Pane 4: temporal → temporal/src
    tmux select-pane -t $SESSION_NAME:runtime.3
    tmux split-window -v -t $SESSION_NAME:runtime -c "$START_DIR/temporal/src"
    tmux send-keys -t $SESSION_NAME:runtime.4 "temporal server start-dev" C-m

    # Pane 5: watch
    tmux select-pane -t $SESSION_NAME:runtime.4
    tmux split-window -v -t $SESSION_NAME:runtime -c "$START_DIR/temporal/src"
    tmux send-keys -t $SESSION_NAME:runtime.5 "npm run start.watch" C-m

    # Pane 6: server.ts
    tmux select-pane -t $SESSION_NAME:runtime.5
    tmux split-window -v -t $SESSION_NAME:runtime -c "src/$START_DIR/temporal/src"
    tmux send-keys -t $SESSION_NAME:runtime.6 "npx tsx server.ts" C-m

    # Sett layout og fokuser på pane 0
    tmux select-layout -t $SESSION_NAME:runtime tiled
    tmux select-pane -t $SESSION_NAME:runtime.0

    # Fjern init-vindu
    tmux kill-window -t $SESSION_NAME:init 2>/dev/null
fi
        
