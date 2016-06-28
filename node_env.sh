#!/bin/sh

# -k: ignore SSL error
if !(which nodebrew >/dev/null); then
    # install
    curl -L git.io/nodebrew | perl - setup
    if !(grep -q "export PATH=$HOME/\.nodebrew/current/bin:" $HOME/.bash_profile); then
        echo "export PATH=$HOME/.nodebrew/current/bin:$PATH" >> $HOME/.bash_profile
        source $HOME/.bash_profile
    fi
    # -k: ignore SSL error
    #patch -uf $HOME/.nodebrew/current/bin/nodebrew < /vagrant/nodebrew.patch
else
    #patch -uf $HOME/.nodebrew/current/bin/nodebrew < /vagrant/nodebrew.patch
    #cat $HOME/.nodebrew/current/bin/nodebrew
    echo 'nodebrew installed'
fi


# use stable version
nodebrew install-binary stable
nodebrew use stable

if !(which bower >/dev/null); then
    npm install -g bower
fi

if !(which grunt >/dev/null); then
    npm install -g grunt-cli
fi

if !(which gulp >/dev/null); then
    npm install -g gulp
fi

if !(which yo >/dev/null); then
    npm install -g yo
    #npm install -g less
fi

if !(npm ls -g generator-angular-fullstack > /dev/null); then
    npm install -g generator-angular-fullstack
fi

if !(npm ls -g less > /dev/null); then
    npm install -g less
fi
