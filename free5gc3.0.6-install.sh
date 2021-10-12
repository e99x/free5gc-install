#!/bin/bash

go version

gocheck=$?

if [ $gocheck = 127 ]; then #not_install
    wget https://golang.org/dl/go1.15.8.linux-amd64.tar.gz &&
    sleep 2
    sudo tar -C /usr/local -xzf go1.15.8.linux-amd64.tar.gz &&
    sleep 2
    mkdir -p ~/go/{bin,pkg,src} &&
    sleep 1
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc &&
    echo 'export GOROOT=/usr/local/go' >> ~/.bashrc &&
    echo 'export PATH=$PATH:$GOPATH/bin:$GOROOT/bin' >> ~/.bashrc &&
    echo 'export GO111MODULE=auto' >> ~/.bashrc &&
    source ~/.bashrc
    sleep 1
elif [ $gocheck = 0 ]; then #installed
    echo "Go already installed"
    sudo rm -rf /usr/local/go
    wget https://golang.org/dl/go1.15.8.linux-amd64.tar.gz &&
    sleep 2
    sudo tar -C /usr/local -xzf go1.15.8.linux-amd64.tar.gz &&
    sleep 2
    mkdir -p ~/go/{bin,pkg,src} &&
    sleep 1
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc &&
    echo 'export GOROOT=/usr/local/go' >> ~/.bashrc &&
    echo 'export PATH=$PATH:$GOPATH/bin:$GOROOT/bin' >> ~/.bashrc &&
    echo 'export GO111MODULE=auto' >> ~/.bashrc &&
    source ~/.bashrc
    sleep 1
else
    Please install manually go.
    exit 1
fi


sudo apt -y update &&
sudo apt -y install mongodb &&
sudo systemctl start mongodb &&

apt list --installed | grep mongo &&
mongocheck=$?

if [ $mongocheck = 0 ]; then #not_install
    sudo apt -y install git gcc g++ cmake autoconf libtool pkg-config libmnl-dev libyaml-dev &&
    go get -u github.com/sirupsen/logrus
elif [ $mongocheck = 1 ]; then #installed
    echo "mongo already installed"
else
    Please install manually mongo.
    exit 1
fi


echo -n "N2 Network Interface name?(ex enp0s2)"
read N2NAME
sudo sysctl -w net.ipv4.ip_forward=1 &&
sudo iptables -t nat -A POSTROUTING -o $N2NAME -j MASQUERADE &&
sudo systemctl stop ufw &&


git clone --recursive https://github.com/free5gc/free5gc.git ${HOME}/free5gc &&


make -C ${HOME}/free5gc &&

git clone https://github.com/free5gc/gtp5g.git ${HOME}/gtp5g &&

make -C ${HOME}/gtp5g &&
sudo make -C ${HOME}/gtp5g install &&

lsmod | grep gtp
