FROM ubuntu-upstart:14.04
MAINTAINER Ruslan Telyak <rvelvetby@gmail.com>

RUN apt-get update
RUN apt-get -y install \
    git \
    libqt4-dev \
    libqt4-dev-bin \
    libqt4-opengl-dev \
    libqtwebkit-dev \
    qt4-linguist-tools \
    qt4-qmake \
    apache2 \
    php5-dev \
    php5-mysql \
    php5-curl \
    php5-gd \
    libapache2-mod-php5 \
    php5-mcrypt \
    xvfb \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-scalable \
    xfonts-cyrillic

# Setup PHP.
RUN sed -i 's/display_errors = Off/display_errors = On/' /etc/php5/apache2/php.ini
RUN sed -i 's/display_errors = Off/display_errors = On/' /etc/php5/cli/php.ini

# Setup Apache2.
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
RUN sed -i 's/VirtualHost \*:80/VirtualHost \*:\*/' /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

RUN \
    echo "Xvfb :0 > /dev/null 2>&1 &" >> /etc/init.d/rc.local && \
    echo "export DISPLAY=:0.0" >> /etc/apache2/envvars && \
    git clone https://github.com/scraperlab/browserext.git /opt/browserext && \
    cd /opt/browserext && \
    chmod -R 777 /opt/browserext && \
    ./build.sh && \
    ./install.sh && \
    echo "extension=browserext.so" >> /etc/php5/apache2/php.ini && \
    service apache2 restart

WORKDIR /var/www/html

EXPOSE 80
