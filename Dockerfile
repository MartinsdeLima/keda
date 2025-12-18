FROM php:8.3-cli
COPY index.php /var/www/html/index.php
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]