# tmux

## ペイン分割

```
上下分割: Ctrl+b -> "
```

## スクロール

```
Ctrl+b -> [
```

## ペインのsync

```
Ctrl+b -> :set-window-option synchronize-panes on
```

## .tmux.conf
```
bind | split-window -h
bind - split-window -v
bind ^h select-layout even-horizontal
bind ^v select-layout even-vertical
bind -n S-left select-pane -L
bind -n S-down select-pane -D
bind -n S-up select-pane -U
bind -n S-right select-pane -R

bind a setw synchronize-panes

set-window-option -g mode-keys vi
set -g window-style 'bg=colour239'
set -g window-active-style 'bg=colour234'
set -g mouse on

set -s escape-time 0

unbind -T copy-mode MouseDragEnd1Pane
unbind -T copy-mode-vi MouseDragEnd1Pane

# linux の場合
bind-key -T copy-mode-vi c send -X copy-pipe-and-cancel "xsel -ip && xsel -op | xsel -ib"
bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "xsel -ip && xsel -op | xsel -ib"
bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel "xsel -ip && xsel -op | xsel -ib"
```