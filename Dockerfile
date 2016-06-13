FROM ubuntu:xenial
MAINTAINER Marcel Remmy <marcel.remmy@alumni.fh-aachen.de>

RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    apache2 \
    php7.0 \
    php7.0-mysql \
    libapache2-mod-php7.0 \
    curl \
    htop \
    supervisor

RUN a2enmod php7.0 && \
  a2enmod rewrite

# https://medium.com/dev-tricks/apache-and-php-on-docker-44faef716150#.sxou0h5pc
# PHP.ini file: enable <? ?> tags and quieten logging
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini && sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Expose apache.
EXPOSE 80

# Copy this repo into place.
ADD www /var/www/html
ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD run.sh /run.sh
RUN chmod u+x /run.sh

#VOLUME ["/var/www/html/", "/var/log/"]

#CMD ["exec supervisord -n"]
CMD ["/run.sh"]
