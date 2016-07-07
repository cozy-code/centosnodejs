#
# http://qiita.com/pottava/items/452bf80e334bc1fee69a
# docker pull centos:6.8
# docker run -it centos:6.8 /bin/bash
# <install>
#  install component on container( write commands on this file)
#  $eixt
# docker commit  [CONTAINERNAME] vagrant/nginx
# docker run -it vagrant/nginx /bin/bash
#  goto <install>
# docker rm $(docker ps -aq)
# docker rm $(docker ps -f status=exited -q)
#
# <build>
# docker build -t test-image .

FROM centos:6.8

#install nginx
RUN set -x && \
    rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm && \
    yum -y install nginx && \
    mkdir -p /var/www/html && \
    chown nginx.nginx /var/www/html

# forward request and error logs to docker log collector
RUN ln --symbolic --force /dev/stdout /var/log/nginx/access.log  && \
    ln --symbolic --force /dev/stderr /var/log/nginx/error.log

# Change Nginx config here...
RUN rm /etc/nginx/conf.d/default.conf
ADD ./default.conf /etc/nginx/conf.d/

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]


