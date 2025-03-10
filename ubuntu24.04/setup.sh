#!/bin/bash

# Configuración básica tras instalación limpia de Ubuntu

# Comprobar si se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root (usa sudo)." 
    exit 1
fi

echo "🛠️  Actualizando el sistema..."
apt update && apt upgrade -y

echo "📦 Instalando paquetes esenciales..."
apt install -y wget build-essential htop vim tmux unzip

echo "✅ Configuración básica completada."

echo "📦 Instalando Apache..."
sudo apt install -y apache2 apache2-utils
sudo service apache2 start

echo "🛠️ Estado de Apache"
sudo service apache2 status

echo "📦 Instalando MariaDB..."
sudo apt install -y mariadb-server mariadb-client
sudo service mysql start

echo "🛠️ Estado de MariaDB"
sudo service mysql status

echo "🛠️ Configurando MariaDB"

mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'toor' WITH GRANT OPTION;"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DROP DATABASE IF EXISTS test;"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -e "FLUSH PRIVILEGES;"

echo "✅ MariaDB configurado con éxito."

echo echo "📦 Instalando PHP..."
sudo apt install -y php libapache2-mod-php php-{mysql,cli,gd,mbstring,common,xml,xmlrpc,dom,json,ftp,iconv,curl,simplexml,zip}
sudo a2enmod php
sudo service apache2 restart

echo "✅ PHP instalado con éxito."

echo "📦 Instalando ZSH..."
sudo apt install -y zsh

echo "🛠️ Configurando ZSH"
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh) $USER

echo "🛠️ Configurando Powerlevel10K"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k/powerlevel10k"/g' ~/.zshrc

echo "📦 Instalando plugins de Oh My Zsh"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i '/^plugins=/c\plugins=(zsh-autosuggestions zsh-syntax-highlighting)' ~/.zshrc

echo "✅ Powerlevel10K y plugins configurados en Zsh."

echo "🛠️ Descargando archivos de alias desde GitHub"
REPO_URL="https://raw.githubusercontent.com/davidnaviaweb/php-dev-env/aliases/"

wget -O ~/.zsh_aliases "$REPO_URL.zsh_aliases"
echo "🛠️ Configurando .zshrc para cargar ~/.zsh_aliases"
if ! grep -q "source ~/.zsh_aliases" ~/.zshrc; then
    echo "source ~/.zsh_aliases" >> ~/.zshrc
fi

wget -O ~/.git_aliases "$REPO_URL.git_aliases"
echo "🛠️ Configurando .zshrc para cargar ~/.git_aliases"
if ! grep -q "source ~/.git_aliases" ~/.zshrc; then
    echo "source ~/.git_aliases" >> ~/.zshrc
fi

echo "✅ Archivos de alias configurados con éxito."

echo "📦 Instalando Composer..."
sudo apt install -y composer

echo "✅ Composer instalado con éxito."

echo "📦 Instalando Node.js..."
sudo apt install -y nodejs npm

echo "✅ Node.js instalado con éxito."

echo "📦 Instalando WP CLI"
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

echo "🛠️ Configurando WP CLI completion"
curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/main/utils/wp-completion.bash
mv wp-completion.bash ~/.wp-completion.bash
echo "source ~/.wp-completion.bash" >> ~/.zshrc

echo "✅ WP CLI instalado con éxito."

echo "📦 Instalando Utilidades..."
curl -O https://raw.githubusercontent.com/davidnaviaweb/php-dev-env/utils/do_composer.sh
chmod +x do_composer.sh
sudo mv do_composer.sh /usr/local/bin/do_composer

curl -O https://raw.githubusercontent.com/davidnaviaweb/php-dev-env/utils/newrelease.sh
chmod +x newrelease.sh
sudo mv newrelease.sh /usr/local/bin/newrelease

echo "✅ Utilidades instaladas con éxito."

source ~/.zshrc