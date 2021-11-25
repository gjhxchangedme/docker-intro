FROM amazonlinux:2.0.20210421.0

RUN yum update -y
RUN amazon-linux-extras install -y php7.2 epel
RUN yum install -y httpd \
                mod_ssl \
                make \
                php-cli \
                php-xml \
                php-json \
                php-mbstring \
                php-process \
                php-common \
                php-fpm \
                php-zip \
                php-pdo \
                php-pear \
                php-dev \
                php-redis \
                php-imagick \
                php-mysqlnd \
                php-devel \
                php-zip \
                php-pgsql \
                php-soap \
                php-pdo_pgsql \
                libjpeg-devel \
                freetype-devel \
                php-gd \
                zip \
                unzip \
                supervisor \
                openssl-devel \
                gcc \
                git

# Update PECL to install the right package
RUN pecl channel-update pecl.php.net

# MongoDB
RUN pecl install mongodb

# Delete default welcome
RUN rm -rf /etc/httpd/conf.d/welcome.conf

# Httpd
RUN mkdir /var/www/httpd
COPY ./etc/httpd/conf.d/www.conf /etc/httpd/conf.d/www.conf
COPY ./etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf

COPY ./certs/local-cert.pem /etc/pki/tls/certs/localhost.crt
COPY ./certs/local-key.pem /etc/pki/tls/certs/localhost.key
COPY ./etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf

# Apache
RUN /usr/sbin/httpd
RUN systemctl enable httpd

# PHP FPM
RUN /usr/sbin/php-fpm
RUN systemctl enable php-fpm

# Composer                                   
RUN curl -O https://getcomposer.org/download/1.10.0/composer.phar
RUN mv composer.phar /usr/bin/composer
RUN chmod +x /usr/bin/composer

# Supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY ./php/php.ini /etc/php.ini
COPY ./index.php /var/www/html/

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]