sudo apt-get update && sudo apt-get upgrade -y

# Basic packages
sudo apt-get install -y ca-certificates curl wget gnupg build-essential nano libssl-dev

# Git
sudo apt install git-all
git --version

ssh-keygen -t rsa -b 4096 -C "<youremail>@gmail.com" -f ~/.ssh/id_rsa -N ""
echo "Copw the follwing pulic key to your Github profile: https://github.com/settings/keys"
cat ~/.ssh/id_rsa.pub

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

echo "Cloning NasSetup script from Github"
mkdir -p ~/Projects
cd ~/Projects && git clone git@github.com:ManuelLang/SetupNas.git

# Cockpit
. /etc/os-release
sudo apt install -t ${VERSION_CODENAME}-backports cockpit
	
systemctl status cockpit
wget http://localhost:9090


# VSCode
sudo snap install code --classic

# OhMyZsh
sudo apt-get install -y zsh
curl -L http://install.ohmyz.sh | sh

# Python
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get install -y libncursesw5-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev

sudo apt-get install -y python3 python3-pip
python3 --version
pip --version

sudo pip3 install virtualenv virtualenvwrapper

# Docker
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo docker run hello-world

## Portainer
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
sudo docker ps
wget https://localhost:9443 # You need to define a new password, at leat 12 chars long

# VLC
sudo snap install vlc