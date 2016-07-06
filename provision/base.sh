#!/bin/sh

#import original root CA(s)
sudo update-ca-trust enable
sudo cp ~/provision/cert/* /usr/share/pki/ca-trust-source/anchors/
sudo update-ca-trust extract
sudo update-ca-trust check

#update system
sudo yum -y update

