#!/bin/sh
apt-get update
apt-get install make docker docker-compose -y

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Create devenv home directory
install -d -o ubuntu -g ubuntu -m 0755 /home/ubuntu/devenv

# Copy .ssh authorized keys into devenv home
install -d -o ubuntu -g ubuntu -m 0700 /home/ubuntu/devenv/.ssh
install -o ubuntu -g ubuntu -m 0600 /home/ubuntu/.ssh/authorized_keys /home/ubuntu/devenv/.ssh/authorized_keys

# Basic aliases
cat << EOF > /home/ubuntu/.bash_aliases
alias ll='ls -lAFh'
alias ..='cd ..'
alias ...='cd ../..'
alias cd..='cd ..'
alias p=pwd
alias d=docker
alias dc=docker-compose
EOF
chown ubuntu:ubuntu /home/ubuntu/.bash_aliases
