#!/bin/bash
if [ -z "$1" ]; then
  echo "No user specified"
  exit 1
fi

function own() {
    chown -R ${my_user} /home/${my_user}/$1
    chgrp -R ${my_user} /home/${my_user}/$1
}

my_user=$1
adduser ${my_user}
gpasswd -a ${my_user} sudo
vim /etc/ssh/sshd_config
service ssh restart

mkdir /home/${my_user}/.ssh
chmod 700 /home/${my_user}/.ssh
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7xF6dyaAwTGBE4+8EDx5C3ZXi7CpVZY/zDofuAoQm6VQOn6+xU9+W+EugNJ6tD3E5csjaEVK06lN9xC4yWg27dDIWgsvNxcNVtCbRx7QSFyJoEOAhMVesC7gttg/O7xfmtoglxUwaNun6e8UwYPZyGzXIgFG+puPwp8Za+3AoJhh1PoxdVublCIUB8UalJ9dWD9qj4EduO074GE41hbrDPyma3XEQtuRkMaW/oNdE0rVcqQrw3WmQXSeMT1i0StCwo4weexBOILIvA34tKH6o89kCaD9c9+6PoJIKq/ErP1uZwyUha7Rjl8hfnYWwL7+yHkfXkNPJpmmNIMheloex george@george-inspiron >> /home/${my_user}/.ssh/authorized_keys
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpaFuiTFCcquzkkqB7Bla7jvgkDJ3T1BNKFWYafzjl86kiYqJ/038lyxs/19gjUbwD0AvzXNCPI9SxnPpNSI6mW7DCw+yImoxnd+pVrRB92C+kgSlPhIdHZtU1Y6mJOWvX1q6pligswkR5Sj3iWql5R8KGkCs7+COC1MBFgbhV7cnohDHZ/d/hG/Wk9EhVie/PsIa4dKhBV3Vfq9BEttw33/gTYDffKqT+tBipxsaWDQpge/NP2xYk+arqnhJKZ81l3igK56NcVeQTN2B2BkRl98AGA52qYsevHnPK1C8UCYE4J+SF9WbqKuVrFc6DjIdSCoTdZUkZqKhow4q45LJN glorch@desktop  >> /home/${my_user}/.ssh/authorized_keys
chmod 600 /home/${my_user}/.ssh/authorized_keys
own .ssh

apt-get install git
cd /home/${my_user}
git clone https://git@github.com/georgelorchpercona/DigitalOcean bin
own bin
