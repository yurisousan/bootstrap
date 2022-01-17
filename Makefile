all : update cli-tools gui-tools terminal-tools

wsl: update cli-tools terminal-tools

ubuntu: update cli-tools gui-tools terminal-tools

update:
	@sudo apt update -y

upgrade:
	@sudo apt upgrade -y

## ONLY CLI
cli-tools: 
    # Install Unzip
	@sudo apt install unzip
    # Install Docker
	@sudo apt install docker.io -y
	@sudo groupadd docker
	@sudo usermod -aG docker $USER
	@sudo systemctl enable docker.service
	@sudo systemctl enable containerd.service
    # Install TFEnv
    	@git clone https://github.com/tfutils/tfenv.git ~/.tfenv
	@echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.profile 
	@tfenv install latest
	@tfenv use latest
    # Install Virtual Box
	@wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
	@sudo add-apt-repository "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
	@sudo apt update && sudo apt install virtualbox-6.1 -y
    # Install Vagrant
	@sudo apt install vagrant -y
    # Install AWS CLI V2
	@curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	@unzip awscliv2.zip
	@sudo ./aws/install
    # Install Docker-Compose
	@sudo apt install docker-compose -y
	@mkdir -p ~/.zsh/completion
	@curl \
	    -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose \
	    -o ~/.zsh/completion/_docker-compose
	@fpath=(~/.zsh/completion $fpath)
    # Install Ansible
	@sudo apt install -y software-properties-common
	@sudo apt update -y
	@sudo apt install -y ansible

## GUI
gui-tools:
    # Install VS Code
	@apt install software-properties-common apt-transport-https wget
	@wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
	@add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
	@apt install code
    # Install Notion
	@echo "deb [trusted=yes] https://apt.fury.io/notion-repackaged/ /" | sudo tee /etc/apt/sources.list.d/notion-repackaged.list
	@apt install notion-app

## GIT-ZSH
terminal-tools:
    # Git: Removing the page for git commands
	@git config --global core.pager cat
    # Git: Add some pretty view to git log command
	@git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    # Install ZSH
	@apt install zsh -y
    # Install Oh My zsh
	@sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # Oh My zsh: Plugins
	@sudo apt install zsh-syntax-highlighting
	@echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
	@git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
	@source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
