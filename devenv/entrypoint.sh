#!/usr/bin/env bash

set -eo pipefail

echo "Devenv entrypoint"

# Install default .zshrc if none exist
ZSHRC="/home/developer/.zshrc"
if [[ ! -f "$ZSHRC" ]]; then
    install -m 644 -o developer -g developer /root/.zshrc "$ZSHRC"
    cat << EOF >> "$ZSHRC"
eval "\$(direnv hook zsh)"
eval "\$(atuin init zsh)"
EOF
fi

# Create go src folder
install -d -m 755 -o developer -g developer /home/developer/go
install -d -m 755 -o developer -g developer /home/developer/go/src

# Start nginx
echo "Start nginx"
sudo service nginx start

# Run sshd daemon
echo "Run sshd daemon"
mkdir -p /run/sshd
exec /usr/sbin/sshd -D
