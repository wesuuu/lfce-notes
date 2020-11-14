#!/bin/bash

dnf update -y

# dynamic IP routing
dnf install frr -y

# generate ssh key
sudo ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y 2>&1 >/dev/null