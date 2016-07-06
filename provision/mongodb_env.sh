#!/bin/sh

#install mongo db
MONGO_REPO=$(cat << 'EOS'
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc
EOS
)
if !(which mongo >/dev/null); then
    sudo echo "$MONGO_REPO" | sudo tee /etc/yum.repos.d/mongodb-org-3.2.repo
    sudo yum install -y mongodb-org
    #mkdir -p /data/db
    sudo chkconfig mongod on
    sudo /etc/init.d/mongod start
fi
