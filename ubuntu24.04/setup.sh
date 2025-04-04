#!/bin/bash

# Configuración básica tras instalación limpia de Ubuntu

# Comprobar si se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root (usa sudo)." 
    exit 1
fi

USER_ORIGINAL=${SUDO_USER:-$USER}
HOME_ORIGINAL=$(eval echo ~$USER_ORIGINAL)
REPO_URL="https://raw.githubusercontent.com/davidnaviaweb/php-dev-env/refs/heads/main/"

echo "🛠️  Actualizando el sistema..."
apt update && apt upgrade -y

echo "📦 Instalando paquetes esenciales..."
apt install -y wget build-essential htop vim tmux unzip

echo "✅ Configuración básica completada."

echo "📦 Instalando Apache..."
sudo apt install -y apache2 apache2-utils
sudo a2enmod rewrite headers ssl expires proxy proxy_http
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
sudo apt install -y php libapache2-mod-php php-{mysqli,cli,gd,mbstring,common,xml,json,curl,zip,apcu}
sudo a2enmod php
sudo service apache2 restart

echo "✅ PHP instalado con éxito."

echo "📦 Instalando ZSH..."
sudo apt install -y zsh

echo "🛠️ Configurando OhMyZSH"
sudo sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
sudo chsh -s $(which zsh) $USER_ORIGINAL

echo "🛠️ Configurando Powerlevel10K"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME_ORIGINAL/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' $HOME_ORIGINAL/.zshrc
wget -O $HOME_ORIGINAL/.p10k.zsh "$REPO_URL/config/.p10k.zsh"

echo "📦 Instalando plugins de Oh My Zsh"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME_ORIGINAL/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME_ORIGINAL/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i '/^plugins=/c\plugins=(zsh-autosuggestions zsh-syntax-highlighting)' $HOME_ORIGINAL/.zshrc

echo "✅ Powerlevel10K y plugins configurados en Zsh."

echo "🛠️ Descargando archivos de alias desde GitHub"
echo ""
wget -O $HOME_ORIGINAL/.zsh_aliases "$REPO_URL/aliases/.zsh_aliases"
echo ""
echo "🛠️ Configurando .zshrc para cargar ~/.zsh_aliases"
if ! grep -q "source ~/.zsh_aliases" $HOME_ORIGINAL/.zshrc; then
    echo "source ~/.zsh_aliases" >> $HOME_ORIGINAL/.zshrc
fi

echo ""
wget -O $HOME_ORIGINAL/.git_aliases "$REPO_URL/aliases/.git_aliases"
echo ""
echo "🛠️ Configurando .zshrc para cargar ~/.git_aliases"
if ! grep -q "source ~/.git_aliases" $HOME_ORIGINAL/.zshrc; then
    echo "source ~/.git_aliases" >> $HOME_ORIGINAL/.zshrc
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
wget -O $HOME_ORIGINAL/.wp-completion.bash "$REPO_URL/utils/wp-completion.bash"
echo "source ~/.wp-completion.bash" >> $HOME_ORIGINAL/.zshrc

echo "✅ WP CLI instalado con éxito."

echo "📦 Instalando Utilidades..."
wget -O $HOME_ORIGINAL/DoComposer.sh "$REPO_URL/utils/DoComposer.sh"
chmod +x DoComposer.sh
sudo mv DoComposer.sh /usr/local/bin/DoComposer

wget -O $HOME_ORIGINAL/NewRelease.sh "$REPO_URL/utils/NewRelease.sh"
chmod +x NewRelease.sh
sudo mv NewRelease.sh /usr/local/bin/NewRelease

echo "✅ Utilidades instaladas con éxito."

echo "➡️ Cambiando a zsh para continuar la configuración..."
sudo -u $USER_ORIGINAL zsh <<'EOF'
source ~/.zshrc

echo "✅ Configuración adicional en zsh completada. Ejecuta 'exit' para salir de la terminal y aplicar los cambios."
EOF
