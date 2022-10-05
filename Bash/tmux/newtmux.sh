#tmux new -s ANDRES -d
#tmux split-window -t ANDRES:0 -h
#tmux new-window -t ANDRES:1
#tmux split-window -t ANDRES:0.0 -v
#tmux send-keys -t ANDRES:0.0 "nano newtmux.sh" Enter
#tmux send-keys -t ANDRES:0.2 htop Enter
#tmux split-window -t ANDRES:0.2 -h
#tmux send-key -t ANDRES:0.3 "ping 8.8.8.8" Enter

tmux new -s ANDRES -d
tmux split-window -t ANDRES:0 -v
tmux select-pane -t ANDRES:0.0
tmux split-pane -t ANDRES:0.0 -h
tmux select-pane -t ANDRE:0.1
tmux split-window -t ANDRES:0.1 -h
tmux select-pane -t ANDRES:0.0
tmux split-window -t ANDRES:0.0 -h
