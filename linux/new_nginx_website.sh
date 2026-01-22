#!/bin/bash

# AUTHOR : ash_a9236 / ash-a9236
# This script is my own creation and is made to automate the creation of a php slim website from an already made repository in /var/www
# Passing this script as your own, using this script to brake the law or perfom malicious actions is completly forbidden (unless approved by the author)

echo "Note that you need to be a sudoer user to be able to run this script"
echo "This script assumes you are using a Linux-Nninx-MariaDB-PhpMyAdmin (LNMP) stack"
echo ""

read -p "Is the main folder or git repo already in /var/www ? (Y/n) -> " USER_ANS_00


if [[ "$USER_ANS_00" == "Y" || "$USER_ANS_00" == "y" ]]; then
    read -p "Please enter the name of the folder that is hosting the website (main folder in /var/www) -> " WEBSITE_NAME    

else 
    read -p "Please enter the name of the website (without spaces) -> " WEBSITE_NAME
    sudo mkdir /var/www/$WEBSITE_NAME
fi

echo "Your webiste will run on https://localhost:80XX. Note that 8083 is often reserved for phpmyadmin and that you cannot have two websites configured on the same port."
read -p "Please enter the port number of the website (i.e. 96 for port 8096) -> " PORT

read -p "Are you using slim php framework ? (Y/n) -> " USER_ANS_01\

if [[ "$USER_ANS_01" == "Y" || "$USER_ANS_01" == "y" ]]; then
    echo "
        server {
            listen 80$PORT;
            server_name localhost;
            
            # Serve directly from public directory
            root /var/www/$WEBSITE_NAME/public;
            index index.php;
            
            # Static files
            location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg|woff|woff2|ttf|eot)$ {
                try_files $uri =404;
                expires 30d;
                add_header Cache-Control "public, immutable";
            }
            
            # All other requests go to Slim
            location / {
                try_files $uri $uri/ /index.php$is_args$args;
            }
            
            # PHP handling
            location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php8.4-fpm.sock;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
            }
            
            # Deny access to hidden files
            location ~ /\. {
                deny all;
            }
        }

    " > /etc/nginx/sites-available/$WEBSITE_NAME

    echo "Adding the webiste to sites-enabled"

    sudo ln -s /etc/nginx/sites-available/$WEBSITE_NAME /etc/nginx/sites-enabled/
    sudo nginx -t
    sudo systemctl reload nginx
    sudo systemctl restart mariadb

    for i in {1..3}; do
        echo "."
        sleep 1
    done

    echo "Changing permissions to owner = $USER and group = www-data"
    sudo chown -R $USER:www-data /var/www/$WEBSITE_NAME

    echo "Changing directory permissions to 755"
    sudo find /var/www/$WEBSITE_NAME -type d -exec chmod 755 {} \;

    echo "Changing file permissions to 644"
    sudo find /var/www/$WEBSITE_NAME -type f -exec chmod 644 {} \;

    sudo chmod -R 775 /var/www/$WEBSITE_NAME/storage 2>/dev/null
    sudo chmod -R 775 /var/www/$WEBSITE_NAME/bootstrap/cache 2>/dev/null

else 
    echo "
        server {
            listen 80$PORT;
            server_name localhost;
            
            # Serve directly from public directory
            root /var/www/$WEBSITE_NAME/;
    
            
            # All other requests go to Slim
            location / {
                try_files $uri $uri/ =404;
            }   
            
            # Deny access to hidden files
            location ~ /\. {
                deny all;
            }
        }

    " > /etc/nginx/sites-available/$WEBSITE_NAME

    echo "Adding the webiste to sites-enabled"

    sudo ln -s /etc/nginx/sites-available/$WEBSITE_NAME /etc/nginx/sites-enabled/
    sudo nginx -t
    sudo systemctl reload nginx
    sudo systemctl restart mariadb

    for i in {1..3}; do
        echo "."
        sleep 1
    done

    echo "Changing permissions to owner = $USER and group = www-data"
    sudo chown -R $USER:www-data /var/www/$WEBSITE_NAME

    echo "Changing directory permissions to 755"
    sudo find /var/www/$WEBSITE_NAME -type d -exec chmod 755 {} \;

    echo "Changing file permissions to 644"
    sudo find /var/www/$WEBSITE_NAME -type f -exec chmod 644 {} \;
fi


echo "Restarting engines to upload changes"
sudo systemctl restart nginx
sudo systemctl restart mariadb

for i in {1..3}; do
    echo "."
    sleep 1
done
