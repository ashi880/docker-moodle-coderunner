# Dockerfile for moodle instance. more dockerish version of https://github.com/sergiogomez/docker-moodle
FROM ubuntu:14.04
MAINTAINER Jon Auer <jda@coldshore.com>

VOLUME ["/var/moodledata"]
EXPOSE 80
COPY moodle-config.php /var/www/html/moodle/config.php

# Keep upstart from complaining
# RUN dpkg-divert --local --rename --add /sbin/initctl
# RUN ln -sf /bin/true /sbin/initctl

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Database info
#ENV MYSQL_HOST 127.0.0.1
#ENV MYSQL_USER moodle
#ENV MYSQL_PASSWORD moodle
#ENV MYSQL_DB moodle
ENV MOODLE_URL http://192.168.59.103

# ADD http://downloads.sourceforge.net/project/moodle/Moodle/stable27/moodle-latest-27.tgz /tmp/moodle-latest-27.tgz
ADD ./foreground.sh /etc/apache2/foreground.sh

RUN apt-get update && \
	apt-get -y upgrade

RUN apt-get -y install mysql-client pwgen python-setuptools curl git unzip apache2 php5 \
		php5-gd libapache2-mod-php5 postfix wget supervisor php5-pgsql curl libcurl3 \
		libcurl3-dev php5-curl php5-xmlrpc php5-intl php5-mysql git-core make

RUN cd /tmp && \
	git clone -b MOODLE_27_STABLE git://git.moodle.org/moodle.git && \
	mv /tmp/moodle/* /var/www/html/moodle/ && \
	rm /var/www/html/index.html && \
	chown -R www-data:www-data /var/www/html && \
	chmod +x /etc/apache2/foreground.sh

# SSH
# RUN apt-get -y install openssh-server
# RUN mkdir -p /var/run/sshd
# EXPOSE 22
# CMD ["/usr/sbin/sshd", "-D"]

RUN cd /tmp && \
	git clone https://github.com/trampgeek/CodeRunner.git && \
	mv /tmp/CodeRunner /var/www/html/moodle/local/

RUN cd /var/www/html/moodle/local/CodeRunner && \
	python install

RUN cd /var/www/html/moodle/question/type && \
	chown -R www-data:www-data coderunner
RUN cd /var/www/html/moodle/question/behaviour && \
	chown -R www-data:www-data adaptive_adapted_for_coderunner

CMD ["/etc/apache2/foreground.sh"]

