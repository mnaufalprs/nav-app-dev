FROM node:18.15-alpine as nodebuilder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

FROM php:8.3.1-fpm

RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader

COPY . .

COPY --from=nodebuilder /app/public /var/www/html/public

RUN chown -R www-data:www-data /var/www/html

EXPOSE 8080
CMD ["php-fpm"], [ "npm", "run", "dev"], [ "npm", "run", "start"]
