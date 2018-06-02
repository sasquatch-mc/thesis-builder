FROM php:7.2-cli

WORKDIR /app

RUN apt-get update -y \
    && apt-get install -y \
        $PHPIZE_DEPS \
        zlib1g-dev \
        texlive \
    && docker-php-ext-install zip \
    && docker-php-source delete \
    && rm -rf /tmp/pear ~/.pearrc \
    && apt-get purge -y $PHPIZE_DEPS \
    && apt-get autoremove -y \
    && rm -r /var/lib/apt/lists/* \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer \
    && composer global require "hirak/prestissimo:^0.3"

ADD . /app

RUN composer install \
    --no-interaction \
    --no-progress \
    --no-scripts \
    --no-suggest \
    --no-dev \
    --prefer-dist

ENV CACHE_DRIVER array
