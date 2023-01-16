#!/bin/bash

# Mount EFS
MOUNT_PATH="/var/www"
EFS_DNS_NAME=${vars.efs_dns_name}

[ $(grep -c $${EFS_DNS_NAME} /etc/fstab) -eq 0 ] && \
        (echo "$${EFS_DNS_NAME}:/ $${MOUNT_PATH} nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0" >> /etc/fstab; \
                mkdir -p $${MOUNT_PATH}; mount $${MOUNT_PATH})

# Install packages
yum -y update
amazon-linux-extras enable php7.4
yum -y install httpd mod_ssl php php-cli php-gd php-mysqlnd

echo -e '<IfModule mod_setenvif.c>\n\tSetEnvIf X-Forwarded-Proto "^https$" HTTPS\n</IfModule>' > /etc/httpd/conf.d/xforwarded.conf
sed -i 's/post_max_size = 8M/post_max_size = 128M/g'  /etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 128M/g'  /etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 600/g'  /etc/php.ini
sed -i 's/; max_input_vars = 1000/max_input_vars = 2000/g'  /etc/php.ini
sed -i 's/max_input_time = 60/max_input_time = 300/g'  /etc/php.ini

systemctl enable --now httpd

firewall-cmd --add-service=http
firewall-cmd --add-service=https
firewall-cmd --runtime-to-permanent

# Download Wordpress
WP_ROOT_DIR=$${MOUNT_PATH}/html
LOCK_FILE=$${MOUNT_PATH}/.wordpress.lock
EC2_LIST=$${MOUNT_PATH}/.ec2_list
WP_CONFIG_FILE=$${WP_ROOT_DIR}/wp-config.php


SHORT_NAME=$(hostname -s)
echo "$${SHORT_NAME}" >> $${EC2_LIST}
FIRST_SERVER=$(head -1 $${EC2_LIST})

if [ ! -f $${LOCK_FILE} -a "$${SHORT_NAME}" == "$${FIRST_SERVER}" ]; then

# Create lock to avoid multiple attempts
	touch $${LOCK_FILE}

# ALB monitoring healthy during initialization
	echo "OK" > $${WP_ROOT_DIR}/index.html

  cd $${MOUNT_PATH}
  wget http://wordpress.org/latest.tar.gz
  tar xzvf latest.tar.gz
	rm -rf $${WP_ROOT_DIR}
	mv wordpress html
  mkdir $${WP_ROOT_DIR}/wp-content/uploads
  chown -R apache /var/www
  chgrp -R apache /var/www
  chmod 2775 /var/www
  find /var/www -type d -exec sudo chmod 2775 {} \;
  find /var/www -type f -exec sudo chmod 0664 {} \;
	rm -rf latest.tar.gz

else
	echo "$(date) :: Lock is acquired by another server"  >> /var/log/user-data-status.txt
fi

# Reboot
reboot
