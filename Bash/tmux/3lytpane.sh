#Start Tmux server and session
tmux new -s $1 -d

#Layout
tmux split-window -t $1:0 -v
tmux split-pane -t $1:0.0 -h

#Turn mouse feature on
tmux set-option mouse on

#Pane style
tmux set-option  pane-border-status bottom

#Enter Tmux
tmux a
