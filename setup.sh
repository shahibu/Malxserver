#!/bin/sh
#
# This script is intended to set up your debian-based Linux distributions with web development solution.
# The script takes further steps by install Apache + PHP + MySQL/MariaDB.
#
# Copyright (C) 2021 Malxserver Version: 1.0
#
# GNU GENERAL PUBLIC LICENSE
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

## ===================================================================
# Show program banner
# ===================================================================

banner() {

cat << "EOF"
  __  __           _
 |  \/  |         | |
 | \  / |   __ _  | | __  __  ___    ___   _ __  __   __   ___   _ __
 | |\/| |  / _` | | | \ \/ / / __|  / _ \ | '__| \ \ / /  / _ \ | '__|
 | |  | | | (_| | | |  >  <  \__ \ |  __/ | |     \ V /  |  __/ | |
 |_|  |_|  \__,_| |_| /_/\_\ |___/  \___| |_|      \_/    \___| |_|

    Malxserver Version: 1.0
  -------------------------------------------------------
EOF

}

# ===================================================================
# Colors for terminal
# ===================================================================

   BLUE='\033[1;94m'
   GREEN='\033[1;92m'
   RED='\033[1;91m'
   PURPLE='\033[1;35m'
   ENDC='\033[1;00m'

   # ===================================================================
# Check if the program run as a root
# ===================================================================

check_root(){

# Make sure only root can run this script
        if [ $(id -u) -ne 0 ]; then
          echo "\n$RED[!] This script must be run as root$ENDC\n" >&2
          exit 1
        fi

}


# Install the repository/package signing keys, if they aren't already.

# ===================================================================
# Check operating system stability
# ===================================================================
#
setup_dev(){
    apt-get update
    apt-get upgrade
}

install_apache()
{
  #Install Apache
        echo "\n$PURPLE☐  Start Installing ............ $ENDC\n"
        apt install -y apache2 apache2-utils
        systemctl enable apache2
        systemctl start apache2
        msg_apache=$(apache2 -v)
        echo "$GREEN☑$ENDC : $msg_apache"
        mkdir /malxserver
        cp servername.conf /etc/apache2/conf-available/servername.conf
        a2enconf servername.conf
        systemctl reload apache2
}

# Install MariaDB
install_database(){
        echo "\n$PURPLE☐  Install MariaDB Database Servers ... $ENDC\n"
        apt install mariadb-server mariadb-client
        systemctl enable mariadb
        systemctl start mariadb
        msg_mariandb=$(mariadb --version)
       echo "$GREEN☑$ENDC : $msg_mariandb"
}

# Install PHP 7.4 stable
install_php(){
  echo "\n$PURPLE☐  Install PHP stable ... $ENDC\n"
  apt install php7.4 libapache2-mod-php7.4 php7.4-mysql php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline
  a2enmod php7.4
  systemctl restart apache2
  a2dismod php7.4
  cp htdocs /malxserver
  chmod -R 755 /malxserver/htdocs
  systemctl restart apache2
  msg_php=$(php --version)
       echo "$GREEN☑$ENDC : $msg_php"

}
# Install phpMyAdmin stable
install_phpmyadmin(){
  echo "\n$PURPLE☐  Install phpMyAdmin stable ... $ENDC\n"
  apt install phpmyadmin
  ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
  systemctl reload apache2
  msg_php=$(php --version)
       echo "$GREEN☑$ENDC : $msg_php"

}

# ===================================================================
# Initialization setup
# ===================================================================

case $(uname -m) in
x86_64)
    banner
    check_root
    setup_dev
    install_apache
    install_database
    install_php
    install_phpmyadmin
    ;;

*)
    banner
          echo "\n$RED[!] This program runs on Intel/AMD 32-bit x86 and 64-bit x64 processors only. $ENDC\n" >&2

          exit 1
    exit 1
    ;;
esac
