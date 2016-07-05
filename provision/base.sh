#!/bin/sh

#import original root CA(s)
update-ca-trust enable
cp /vagrant/cert/* /usr/share/pki/ca-trust-source/anchors/
update-ca-trust extract

#update system
yum -y update

