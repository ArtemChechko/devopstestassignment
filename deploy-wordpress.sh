#!/bin/bash
set -e

# Update system and install dependencies
apt-get update -y
apt-get install -y apache2 php php-mysql php-redis unzip curl git

# Variables
DB_NAME="your-db-name"
DB_USER="your-db-user"
DB_PASSWORD="your-db-password"
DB_HOST="your-db-host"
REDIS_HOST="your-redis-host"
REDIS_KEY_SALT="your-redis-key-salt"
AUTH_KEY="your-auth-key"
SECURE_AUTH_KEY="your-secure-auth-key"
LOGGED_IN_KEY="your-logged-in-key"
NONCE_KEY="your-nonce-key"
AUTH_SALT="your-auth-salt"
SECURE_AUTH_SALT="your-secure-auth-salt"
LOGGED_IN_SALT="your-logged-in-salt"
NONCE_SALT="your-nonce-salt"

# Export environment variables
echo "Exporting environment variables..."
cat <<EOV | tee /etc/environment
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_HOST=$DB_HOST
REDIS_HOST=$REDIS_HOST
REDIS_KEY_SALT=$REDIS_KEY_SALT
AUTH_KEY=$AUTH_KEY
SECURE_AUTH_KEY=$SECURE_AUTH_KEY
LOGGED_IN_KEY=$LOGGED_IN_KEY
NONCE_KEY=$NONCE_KEY
AUTH_SALT=$AUTH_SALT
SECURE_AUTH_SALT=$SECURE_AUTH_SALT
LOGGED_IN_SALT=$LOGGED_IN_SALT
NONCE_SALT=$NONCE_SALT
EOV

source /etc/environment

# Download and set up WordPress
cd /var/www/html
rm -rf *
curl -O https://wordpress.org/latest.zip
unzip latest.zip
mv wordpress/* .
rm -rf wordpress latest.zip

# Clone wp-config.php from Git
git clone https://github.com/your-repo/wordpress-config.git /tmp/wp-config
mv /tmp/wp-config/wp-config.php /var/www/html/

# Set permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Enable Redis cache
apt-get install -y php-redis
systemctl restart apache2

echo "WordPress successfully deployed!"
