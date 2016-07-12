FROM centos:6.8

#install nginx
RUN set -x && \
    yum install perl -y && \
    curl -sSL git.io/nodebrew | perl - setup && \
    echo "export PATH=$HOME/.nodebrew/current/bin:$PATH" >> $HOME/.bash_profile && \
    source ~/.bash_profile && \
    nodebrew install-binary v5.x && \
    nodebrew use v5.x && \
    npm install -g bower && \
    npm install -g grunt-cli && \
    npm install -g gulp && \
    npm install -g yo && \
    npm install -g generator-angular-fullstack && \
    npm install -g less

