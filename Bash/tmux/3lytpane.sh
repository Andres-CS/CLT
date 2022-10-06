#Start Tmux server and session
tmux new -s CS644 -d

#Layout
tmux split-window -t CS644:0 -v
#tmux select-pane -t CS644:0.0
tmux split-pane -t CS644:0.0 -h

#Turn mouse feature on
tmux set-option mouse on

#Pane style
tmux set-option  pane-border-status bottom
