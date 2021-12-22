#! /bin/bash

if [[ $_ != $0 ]]
then
  echo "Script is being sourced"
else
  echo "Script is a subshell - please run the script by invoking . install.sh";
  exit 1;
fi

echo "export PATH=\$PATH:~/mytools/bin:~/tools/bin" >> ~/.profile
source ~/.profile

echo "installing go lang"
sudo rm -rf /usr/local/go
go_version=$(curl https://go.dev/VERSION?m=text)
echo "go version: $go_version"
sudo wget "https://go.dev/dl/$go_version.linux-amd64.tar.gz" -P /usr/local
sudo tar -C /usr/local -xzf /usr/local/$go_version.linux-amd64.tar.gz
sudo rm /usr/local/$go_version.linux-amd64.tar.gz

echo "export PATH=\$PATH:/usr/local/go/bin:~/go/bin" >> ~/.profile
source ~/.profile
echo

echo "Installing/configuring tools..."

sudo apt update
sudo apt install assetfinder -y
sudo apt install sublist3r -y
sudo apt install amass -y
sudo apt install httprobe -y
sudo apt install eyewitness -y
go install github.com/tomnomnom/waybackurls@latest
go install github.com/haccer/subjack@latest

echo "Configuring git / github..."
git config --global user.name "Julio Henrique Moro Balarini"
git config --global user.email juliohmb@gmail.com

if [ ! -f ~/.ssh/id_ed25519.pub ];then
  echo "Please config your ssh key on your github account before proced: https://github.com/settings/keys"
  echo "do you want me to generate it for you? ( y / n )"
  read generate_ssh
  if [ $generate_ssh == "y" ];then
    echo "Generating ssh key..."
    ssh-keygen -t ed25519 -C "juliohmb@gmail.com"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
  else
    exit 1
  fi
fi
echo

echo "Creating directories"

if [ ! -d ~/tools ];then
  echo "Creating ~/tools directory"
  mkdir ~/tools/bin
  mkdir ~/tools/src
fi

if [ ! -d ~/tools ];then
  echo "Creating ~/mytools directory"
  git clone git@github.com:juliohmb/mytools.git
fi
echo
