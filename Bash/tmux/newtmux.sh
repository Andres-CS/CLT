#tmux new -s CS644 -d
#tmux split-window -t CS644:0 -h
#tmux new-window -t CS644:1
#tmux split-window -t CS644:0.0 -v
#tmux send-keys -t CS644:0.0 "nano newtmux.sh" Enter
#tmux send-keys -t CS644:0.2 htop Enter
#tmux split-window -t CS644:0.2 -h
#tmux send-key -t CS644:0.3 "ping 8.8.8.8" Enter

#tmux new -s CS644 -d
#tmux split-window -t CS644:0 -v
#tmux select-pane -t CS644:0.0
#tmux split-pane -t CS644:0.0 -h
#tmux select-pane -t CS644:0.1
#tmux split-window -t CS644:0.1 -h
#tmux select-pane -t CS644:0.0
#tmux split-window -t CS644:0.0 -h
#tmux select-pane -t CS644:0.4
#tmux resize-pane -U 30
#tmux set-option pane-border-status bottom
#tmux set-option mouse on

#Start Tmux server and session
tmux new -s CS644 -d

#Layout
tmux split-window -t CS644:0 -v
tmux select-pane -t CS644:0.0
tmux split-pane -t CS644:0.0 -h
tmux select-pane -t CS644:0.2
tmux split-pane -t CS644:0.2 -h

#Turn mouse feature on
tmux set-option mouse on

#Pane style
tmux set-option  pane-border-status bottom
