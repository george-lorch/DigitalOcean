#!/bin/bash
if [ -z "$1" ]; then
  echo "No user specified"
  exit 1
fi

function own() {
    chown -R ${my_user} $1
    chgrp -R ${my_user} $1
}

my_user=$1
my_user_dir=/home/${my_user}

adduser ${my_user}
gpasswd -a ${my_user} sudo
vim /etc/ssh/sshd_config
service ssh restart

mkdir ${my_user_dir}/.ssh
chmod 700 ${my_user_dir}/.ssh
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7xF6dyaAwTGBE4+8EDx5C3ZXi7CpVZY/zDofuAoQm6VQOn6+xU9+W+EugNJ6tD3E5csjaEVK06lN9xC4yWg27dDIWgsvNxcNVtCbRx7QSFyJoEOAhMVesC7gttg/O7xfmtoglxUwaNun6e8UwYPZyGzXIgFG+puPwp8Za+3AoJhh1PoxdVublCIUB8UalJ9dWD9qj4EduO074GE41hbrDPyma3XEQtuRkMaW/oNdE0rVcqQrw3WmQXSeMT1i0StCwo4weexBOILIvA34tKH6o89kCaD9c9+6PoJIKq/ErP1uZwyUha7Rjl8hfnYWwL7+yHkfXkNPJpmmNIMheloex george@george-inspiron >> ${my_user_dir}/.ssh/authorized_keys
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpaFuiTFCcquzkkqB7Bla7jvgkDJ3T1BNKFWYafzjl86kiYqJ/038lyxs/19gjUbwD0AvzXNCPI9SxnPpNSI6mW7DCw+yImoxnd+pVrRB92C+kgSlPhIdHZtU1Y6mJOWvX1q6pligswkR5Sj3iWql5R8KGkCs7+COC1MBFgbhV7cnohDHZ/d/hG/Wk9EhVie/PsIa4dKhBV3Vfq9BEttw33/gTYDffKqT+tBipxsaWDQpge/NP2xYk+arqnhJKZ81l3igK56NcVeQTN2B2BkRl98AGA52qYsevHnPK1C8UCYE4J+SF9WbqKuVrFc6DjIdSCoTdZUkZqKhow4q45LJN glorch@desktop >> ${my_user_dir}/.ssh/authorized_keys
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDq6P5C7OEQnSARB1EKcIQTMPTqDp/i1wyObKHQhKEzZkO7bg4AMTOgVb+Ls3yMazNXnAHEPpYOhgj80kd6xOKITBUdhWhHqvueaX8usnM6Uw+2DpKTSpBfYc6kWN3Ti7zLButhJh32AxdF/Or7n03srcuFgICmmH2oomM/7Tnyy5Mv0zC6wEe5fw7J1gzTN5kAQ/9fck4WTvju+UbU5o+xcdTJZBMf3Vm/yBOZc1EfrWndbnVccPhZQr9boVyqvQNMcTwzHfj3LmgheBHajajQll7CKpZeFJGz/u9ZqKStGhkYkftay2A1JI2dcA3bkrYglmQGva0gP6/1zoQO6RzcjJX7eOrltsXHbSOh/8Hsih20icQRUoYDuU88jCMdmWNHagioDBW0b0m0ZvKUwgMB74Z8Ho2yRxj+rxWPI5l7TvWol9AbHNixmzVBVll7YupXJ6QX7K1ZiEPMaN83mKdBStFBFg8SQV2KxIOxy6AEvPBVUlowmAqGVt4a/AJgyS9TrU0ZuPmivQui8dLdi63vaO8QW+F5f93diI3yeU02o9xXBjDaATloMrrcYYU7e15z8zUWGPiowHlJot2GFT88ImIVYINh9i5Ilon006PXr8RBDwJK1ya0kl82465kb9CL83Bsunj5IJsP9/dXKkE7BmwL4pXz5rAYESeTuCgu4Q== glorch@george-inspiron >> ${my_user_dir}/.ssh/authorized_keys
chmod 600 ${my_user_dir}/.ssh/authorized_keys
own ${my_user_dir}/.ssh
own ${my_user_dir}/.ssh/*

apt-get install git
cd ${my_user_dir}
git clone https://git@github.com/georgelorchpercona/DigitalOcean do
own ${my_user_dir}/do
own ${my_user_dir}/do/*

mkdir ${my_user_dir}/bin
for cmd in `find ${my_user_dir}/do -name "*.sh"`; do
    ln -s $cmd ${my_user_dir}/bin
done

own ${my_user_dir}/bin
own ${my_user_dir}/bin/*
