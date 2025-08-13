#!/bin/bash
# ref: https://gist.github.com/thinkycx/2e21c3572a8d1fde21aad07a58fcf940/
# ref: https://github.com/aiktb/dotzsh
# usage: curl -fsSL https://raw.githubusercontent.com/lautumn1990/zsh/main/zsh.sh -o zsh.sh && bash zsh.sh

install_autojump_by_git(){
    # sudo yum install autojump -y
    git clone git://github.com/joelthelion/autojump.git /tmp/.autojump && cd /tmp/.autojump
    ./install.py
    rm -rf /tmp/.autojump
    # add for you self into .zshrc
    # [[ -s /root/.autojump/etc/profile.d/autojump.sh ]] && source /root/.autojump/etc/profile.d/autojump.sh
}

install_ubuntu(){
    # get this script, you may need to run:
    # apt-get update && apt-get install curl -y  
    # curl raw URL > thinkycx-zsh.sh
    # bash thinkycx-zsh.sh

    # apt-get install sudo -y
    sudo apt-get update -y
    sudo apt-get install tmux -y
    sudo apt-get install git -y
    sudo apt-get install git -y # for not install strange bug 20180831
    sudo apt-get install curl -y 
    sudo apt-get install zsh -y

    #optional
    #sudo apt-get install terminator -y 
    sudo apt-get install vim -y 
    sudo apt-get install python3-pip -y
    # https://github.com/robbyrussell/oh-my-zsh
    # git config --global --unset http.proxy 
    # git config --global --unset https.proxy

    sudo apt-get install autojump -y
}


install_centos(){
    # get this script, you may need to run:
    # yum update && yum install curl -y  
    # curl raw URL > thinkycx-zsh.sh
    # bash thinkycx-zsh.sh

    # yum install sudo -y
    sudo yum update -y
    sudo yum install tmux -y
    sudo yum install git -y
    sudo yum install git -y # for not install strange bug 20180831
    sudo yum install curl -y 
    sudo yum install zsh -y

    #optional
    #sudo yum install terminator -y 
    sudo yum install vim -y 
    sudo yum install python3-pip -y
    # https://github.com/robbyrussell/oh-my-zsh
    # git config --global --unset http.proxy 
    # git config --global --unset https.proxy

    install_autojump_by_git 
}


install_macOS(){
    # 20190917
    # install brew 20200622
    brew -v >/dev/null
    if [[ $? -ne 0 ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi
    echo "[+] brew install some dependencies..."

    # brew update && brew upgrade
    su - $USER -c brew install git
    su - $USER -c brew install curl
    su - $USER -c brew install zsh
    su - $USER -c brew install tmux

    #optional
    # brew install vim  | brew upgrade vim 
    # https://github.com/robbyrussell/oh-my-zsh
    # git config --global --unset http.proxy 
    # git config --global --unset https.proxy

    su - $USER -c brew install autojump | su - $USER -c brew upgrade autojump
    # install_autojump_by_git
}

install_dependencies(){
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        source /etc/os-release
        echo "OS: " $ID 
        # linux
        if [ $ID == "centos" ]; then
          install_centos
        elif [ $ID == "ubuntu" ]; then
          install_ubuntu
        else
          echo "[!] cannot support your OS. (not centos or ubuntu)"
          exit
        fi 
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "OS: macOS"
        install_macOS
    else
        echo "[!] cannot support your OS. (not linux or macOS)"
        exit
    fi
}

install_oh_my_zsh(){
    echo "[!] ENTER exit manually!"
    # sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o /tmp/install.sh &&
        sed -i 's/CHSH=no/CHSH=yes/g' /tmp/install.sh &&
        echo "Y" | sh /tmp/install.sh 
    echo "[*] remove /tmp/install.sh"
    rm -f /tmp/install.sh
}

config_zshrc_bash_aliases(){
    bash_aliases=$(cat ~/.zshrc | grep "~/.bash_aliases")
    if [ -z "$bash_aliases" ];then
      echo "[*] add ~/.bash_aliases in ~/.zshrc"
cat <<EOF  >>~/.zshrc
# add ~/.bash_aliases 
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOF
    else
      echo "[*] ~/.bash_aliases exists in ~/.zshrc"
    fi
}

install_zsh_plugins(){
    ZSH_CUSTOM="$USER_HOME/.oh-my-zsh/custom"
    export ZSH_CUSTOM
    plugins="zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search"
    for plugin in $plugins; do
      if [ ! -d "${ZSH_CUSTOM}/plugins/${plugin}" ]; then
        echo "[*] install ${plugin}..."
        git clone https://github.com/zsh-users/${plugin}.git "${ZSH_CUSTOM}"/plugins/${plugin}
       else 
        echo "[*] ${plugin} exists..."
      fi
    done
}

config_zsh_plugins(){
    sed -i 's/^plugins=.*/plugins=(git extract last-working-dir sudo autojump jsontools colored-man-pages zsh-autosuggestions zsh-syntax-highlighting history-substring-search)/g' ~/.zshrc
    cat <<EOF >>~/.zshrc
# export TERM
export TERM=xterm-256color
# zsh autosuggest-accept by shift+tab
bindkey '^[[Z' autosuggest-accept
EOF
}

change_zsh_default_theme(){
    # use ys as default theme
    sed -i "s/^ZSH_THEME=.*/ZSH_THEME=${ZSHTHEME}/g" ~/.zshrc
}

change_zsh_bash_history(){

cat <<EOF >>~/.zshrc
# zsh history
HISTFILE="\$HOME/.zsh_history"
HISTSIZE=100000000
SAVEHIST=100000000
EOF

}

config_change_default_shell(){
    # change zsh to default shell
    sudo chsh ${USER_NAME} -s /bin/zsh
}

install_done(){
    echo "[*] ENJOY!"
    /bin/zsh
}

install_tmux(){
    git clone https://github.com/gpakosz/.tmux.git ~/.tmux
    ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
    cp ~/.tmux/.tmux.conf.local ~/.tmux.conf.local
cat <<'EOF' >>~/.tmux.conf.local
set -g mouse on
EOF
}

uninstall_tmux(){
    rm -rf ~/.tmux
    rm -f ~/.tmux.conf
    rm -f ~/.tmux.conf.local
}

install_vimrc(){
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
    git clone https://github.com/lifepillar/vim-solarized8.git \
        ~/.vim_runtime/my_plugins/solarized8
    cat <<EOF  >~/.vim_runtime/my_configs.vim
" 显示行号
set number
" 显示标尺
set ruler
" 设置当文件被改动时自动载入
set autoread
" 自动保存
set autowrite
" 自动缩进
set autoindent
" 智能缩进
set smartindent
set cindent
" 制表符
set noexpandtab
set smarttab
" Tab键的宽度
set tabstop=4
set expandtab
" 统一缩进为4
set softtabstop=4
set shiftwidth=4
" 搜索逐字符高亮
set hlsearch
set incsearch
set smartcase
" 不自动添加空行
set noendofline

syntax on
filetype plugin indent on
runtime macros/matchit.vim

" 关闭 vi 兼容模式
set nocompatible

" Highlight current line
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

set showcmd       " display incomplete commands
set laststatus=2  " Always display the status line
set fileencodings=utf-8,gb18030,gbk,big5

execute pathogen#infect()
" 不支持箭头的系统可以设置为加号
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '+'

let g:neocomplete#enable_at_startup = 1

" 配色 需要放在pathogen#infect()后面
set background=dark
colorscheme solarized8
EOF

    if [ -f ~/.zshrc ]; then
        cat <<'EOF' >>~/.zshrc

# init vim solarized8 colorscheme
if [ -t 1 ] && [[ $- == *i* ]] && [ -z "$TMUX" ] && [ -f ~/.vim_runtime/my_plugins/solarized8/scripts/solarized8.sh ]; then
  sh ~/.vim_runtime/my_plugins/solarized8/scripts/solarized8.sh
fi
EOF
    fi
}

uninstall_vimrc(){
    rm -rf ~/.vim_runtime
    rm -rf ~/.vimrc
}

install(){
    install_dependencies
    install_oh_my_zsh
    config_zshrc_bash_aliases
    install_zsh_plugins
    config_zsh_plugins
    change_zsh_default_theme
    change_zsh_bash_history
    config_change_default_shell
    if [ "$ZSHEXTRA" = "true" ]; then
        install_tmux
        install_vimrc
    fi
    install_done
}
uninstall(){
    echo "start uninstall..."
    rm -rf ~/.oh-my-zsh 
    rm -r ~/.zshrc 
    rm ~/.zcompdump*
    rm ~/.zsh_history*
    sudo chsh ${USER_NAME} -s /bin/bash
    if [ "$ZSHEXTRA" = "true" ]; then
        uninstall_tmux
        uninstall_vimrc
    fi
    echo "uninstalled!!!"
    /bin/bash
}

ZSHTHEME="ys"
ZSHEXTRA="false"
USER_HOME=${HOME}
USER_NAME=$(whoami)

while getopts 'uiet:h' opt; do
  case "$opt" in
    e)
      ZSHEXTRA="true"
      echo "extra"
      ;;
    u)
      uninstall
      exit 0
      ;;
    i)
      ;;
    t)
      ZSHTHEME="$OPTARG"
      echo "ZSHTHEME: ${ZSHTHEME}"
      ;;
    ?|h)
      echo "Usage: $(basename $0) [-u] to uninstall"
      echo "       $(basename $0) [-i] to install default -i"
      echo "       $(basename $0) [-t] to install with theme like -t ys"
      echo "       $(basename $0) [-e] to install or uninstall with extra tmux and vimrc"
      exit 0
      ;;
  esac
done

shift "$(($OPTIND -1))"
install
