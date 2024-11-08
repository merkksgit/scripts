# Tmux-sessionizer

Tmux-sessionizer is a tmux script that improves workflow. Written by [ThePrimeagen](https://github.com/ThePrimeagen/)

## Installation

### Script

Save the script on ~/.local/scripts/tmux-sessionizer where tmux-sessionizer is the name of the script

```bash
#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/projects ~/tests -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

if [[ -z $TMUX ]]; then
    tmux attach -t $selected_name
else
    tmux switch-client -t $selected_name
fi
```

Here change the find paths on line no. 6 to your corresponding paths to projects folder on which you want to work on

### Add the script folder to .bashrc

```bash
PATH="$PATH":"$HOME/.local/scripts/"
```

### Add the macro `Ctrl + f` to your .bash_profile

```bash
bind -x '"\C-f":"tmux-sessionizer"'
```

### Add the following script on .tmux.conf

```
bind-key -r f run-shell "tmux neww ~/.local/scripts/tmux-sessionizer"
```

This will open fuzzy finder then you can search for the project you want and start new tmux session on that project directory on pressing \<prefix\> + f

### Give permission for tmux-sessionizer script to run and restart shell

```bash
chmod +x ~/.local/scripts/tmux-sessionizer
```

### How to use

- Press `Ctrl + f` to open the fzf finder
- Type the name of project you want to work on and press enter
- Now you will be on the project directory on a new tmux session
