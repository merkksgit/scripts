#!/bin/bash
echo "Current version of 'Oh My Posh':"
oh-my-posh --version
sudo wget https://www.github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
echo "Oh My Posh updated to following version:"
oh-my-posh --version
