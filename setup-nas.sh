git_email="$1"
git_name="$2"
ssh_password="$3"

if [[ -z $git_email ]]; then
    echo "Please provide your email for Github setup"
    return
fi

if [[ -z $git_name ]]; then
    echo "Please provide your full name for Github setup"
    return
fi

if [[ -z $ssh_password ]]; then
    echo "Please provide a passphrase to generate RSA key pair"
    return
fi


sudo apt-get update && sudo apt-get upgrade -y

# Basic packages
sudo apt-get install -y ca-certificates curl wget gnupg build-essential nano libssl-dev

# Git
sudo apt install -y git-all
git --version

ssh-keygen -t rsa -b 4096 -C "${git_email}" -f ~/.ssh/id_rsa -N ${ssh_password}
echo "Copw the follwing pulic key to your Github profile: https://github.com/settings/keys"
cat ~/.ssh/id_rsa.pub

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

git config --global user.email "${git_email}"
git config --global user.name "${git_name}"

echo "Cloning NasSetup script from Github"
mkdir -p ~/Projects
cd ~/Projects && git clone git@github.com:ManuelLang/SetupNas.git

# Cockpit
. /etc/os-release
sudo apt install -y -t ${VERSION_CODENAME}-backports cockpit
	
systemctl status cockpit
wget http://localhost:9090


# VSCode
sudo snap install code --classic

# OhMyZsh
sudo apt-get install -y zsh
curl -L http://install.ohmyz.sh | sh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
chsh -s $(which zsh) # Set zsh shell as default
cp ~/Projects/SetupNas/.zshrc ~/.zshrc

# Python
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get install -y libncursesw5-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev

sudo apt-get install -y python3 python3-pip python3-dev gcc
python3 --version
pip --version

sudo pip3 install virtualenv virtualenvwrapper python3.10-venv

# Docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose docker-compose-plugin

docker -v
docker-compose -v
sudo docker run hello-world

## Portainer
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
sudo docker ps
wget https://localhost:9443 # You need to define a new password, at leat 12 chars long

# Jellyfin
mkdir -p ~/jellyfin/config/
mkdir -p ~/jellyfin/cache/
sudo docker pull jellyfin/jellyfin
cp ~/Projects/SetupNas/jellyfin/docker-compose.yaml ~/jellyfin && cd ~/jellyfin && sudo docker-compose up

# VLC
sudo snap install vlc

# Paperless
mkdir -p ~/paperless/media/
mkdir -p ~/paperless/data/
mkdir -p ~/paperless/consume/
mkdir -p ~/paperless/export/
bash -c "$(curl -L https://raw.githubusercontent.com/paperless-ngx/paperless-ngx/main/install-paperless-ngx.sh)"

# MQTT
sudo add-apt-repository ppa:mosquitto-dev/mosquitto-ppa
sudo apt install -y mosquitto mosquitto-clients
sudo snap install mqtt-explorer
mkdir -p ~/home-assistant/config/
cp ~/Projects/SetupNas/home-assistant/docker-compose.yaml ~/home-assistant && cd ~/home-assistant && sudo docker-compose up