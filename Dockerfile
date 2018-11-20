FROM becopay/alpine-nginx-php

LABEL maintainer="io@becopay.com"
LABEL version="2.2.6"
LABEL description="Magento 2.2.6"

ENV MAGENTO_VERSION 2.2.6
ENV INSTALL_DIR /var/www/html
ENV COMPOSER_HOME /var/www/.composer/

ADD ./php.ini /etc/php7/php.ini

ADD ./auth.json $COMPOSER_HOME

ADD ./nginx.conf /etc/nginx/conf.d/default.conf

RUN chsh -s /bin/bash www-data

RUN cd /tmp && \ 
  curl https://codeload.github.com/magento/magento2/tar.gz/$MAGENTO_VERSION -o $MAGENTO_VERSION.tar.gz && \
  tar xvf $MAGENTO_VERSION.tar.gz && \
  mv magento2-$MAGENTO_VERSION/* magento2-$MAGENTO_VERSION/.htaccess $INSTALL_DIR

RUN cd $INSTALL_DIR && composer install
RUN cd $INSTALL_DIR && composer require becopay/magento2-becopay-gateway
RUN cd $INSTALL_DIR && composer config repositories.magento composer https://repo.magento.com/
RUN chown -R www-data:www-data /var/www

RUN cd $INSTALL_DIR \
    && find . -type d -exec chmod 770 {} \; \
    && find . -type f -exec chmod 660 {} \; \
    && chmod u+x bin/magento

COPY ./install-magento /usr/local/bin/install-magento
RUN chmod +x /usr/local/bin/install-magento

COPY ./install-sampledata /usr/local/bin/install-sampledata
RUN chmod +x /usr/local/bin/install-sampledata

WORKDIR $INSTALL_DIR

# Add cron job
ADD crontab /etc/cron.d/magento2-cron
RUN chmod 0644 /etc/cron.d/magento2-cron \
    && crontab -u www-data /etc/cron.d/magento2-cron
