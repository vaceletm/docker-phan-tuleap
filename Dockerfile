FROM php:7

RUN apt-get update -q && apt-get -qqy install unzip

# For Phan
RUN cd /tmp && \
    curl -fsSL -o php-ast.zip https://github.com/nikic/php-ast/archive/master.zip && \
    unzip php-ast.zip && \
    cd php-ast-master && \
    phpize && \
    ./configure && \
    make && \
    make install

RUN docker-php-ext-enable ast && rm -rf /tmp/php-ast.zip php-ast-master

RUN curl -fsSL -o /usr/local/bin/composer https://getcomposer.org/download/1.1.0/composer.phar && chmod +x /usr/local/bin/composer

RUN curl -fsSL -o /tmp/phan-0.4.zip https://github.com/etsy/phan/archive/0.4.zip && \
    cd / && \
    unzip /tmp/phan-0.4.zip && \
    cd phan-0.4 && \
    composer install

RUN ln -s /phan-0.4/phan /usr/local/bin/phan

# For Tuleap
#Possible values for ext-name:
#bcmath bz2 calendar ctype curl dba dom enchant exif fileinfo filter ftp gd gettext gmp hash iconv imap interbase intl json ldap mbstring mcrypt mysqli oci8 odbc opcache pcntl pdo pdo_dblib pdo_firebird pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell readline recode reflection session shmop simplexml snmp soap sockets spl standard sysvmsg sysvsem sysvshm tidy tokenizer wddx xml xmlreader xmlrpc xmlwriter xsl zip

RUN apt-get -qqy install libxml2-dev libz-dev
RUN docker-php-ext-install -j$(nproc) soap zip dom pdo pdo_mysql xml

RUN apt-get -qqy install libxslt-dev
RUN docker-php-ext-install -j$(nproc) xmlrpc xsl

