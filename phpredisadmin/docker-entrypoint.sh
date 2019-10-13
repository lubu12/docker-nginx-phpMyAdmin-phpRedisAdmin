#!/bin/bash
git clone https://github.com/ErikDubbelboer/phpRedisAdmin.git
cd phpRedisAdmin
git clone https://github.com/nrk/predis.git vendor
cp /tmp/config.inc.php includes/
rm /tmp/config.inc.php
chown -R app:app /var/www/html/phpRedisAdmin/ 

exec "$@"
