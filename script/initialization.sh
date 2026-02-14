#!/bin/bash

# This script installs required packages on Ubuntu 22.04 or 24.04.
# It checks the Ubuntu version and installs accordingly.
# Run this script with sudo privileges where necessary, or as root.
# Note: Some changes (like docker group) require logout/login to take effect.

# Update package list
sudo apt update -y

# Install common dependencies
sudo apt install -y curl gnupg lsb-release unzip git wget ca-certificates

# Check Ubuntu version
UBUNTU_VERSION=$(lsb_release -rs)
echo "Detected Ubuntu version: $UBUNTU_VERSION"

# Install Docker and Docker Compose
if [[ "$UBUNTU_VERSION" == "22.04" || "$UBUNTU_VERSION" == "24.04" ]]; then
    # Remove old Docker versions if any
    sudo apt remove -y docker docker-engine docker.io containerd runc

    # Add Docker's official GPG key
    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Set up the repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update and install Docker
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Start and enable Docker service
    sudo systemctl start docker
    sudo systemctl enable docker

    # Add current user to docker group (requires logout/login)
    sudo usermod -aG docker $USER
    echo "Added user to docker group. Please log out and log back in for changes to take effect."
else
    echo "Unsupported Ubuntu version: $UBUNTU_VERSION. This script supports 22.04 or 24.04."
    exit 1
fi

# Install D2Coding font
wget https://github.com/naver/d2codingfont/releases/download/1.3.2/D2Coding-1.3.2-20180430.zip -O /tmp/d2coding.zip
unzip /tmp/d2coding.zip -d /tmp/d2coding
sudo mkdir -p /usr/share/fonts/truetype/d2coding
sudo cp /tmp/d2coding/D2Coding/*.ttf /usr/share/fonts/truetype/d2coding/
sudo fc-cache -fv
rm -rf /tmp/d2coding.zip /tmp/d2coding
echo "D2Coding font installed."

# Install Vim and related packages
sudo apt install -y vim vim-gtk3 universal-ctags

# Install clipboard tools (for vimrc clipboard integration)
sudo apt install -y xclip wl-clipboard

# Set up Vundle for Vim plugins
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Create .vimrc with the provided content
cat << EOF > ~/.vimrc
" ============================================================================
" Basic settings
" ============================================================================

set nocompatible                " Use Vim defaults (better than Vi defaults)
set tabstop=4                   " Number of spaces a tab counts for
set shiftwidth=4                " Number of spaces used for (auto)indent
set number                      " Show line numbers
set hlsearch                    " Highlight search matches
set smartindent                 " Smart auto-indenting
set tags=tags;/                 " Look for tags file up to root

" Filetype-specific indentation
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab

" Recognize .pyx / .pyi as Python
au BufNewFile,BufRead *.pyx,*.pyi set filetype=python

" Auto-generate ctags for C/C++ files (only on save? Consider manual :!ctags -R if slow)
autocmd BufNewFile,BufRead *.h,*.hpp,*.hh,*.c,*.cpp,*.cxx call system("ctags -R")

" ============================================================================
" Vundle plugin manager
" ============================================================================

set rtp+=\$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'preservim/nerdtree'
call vundle#end()

" Toggle NERDTree with Tab
nmap <Tab> :NERDTreeToggle<CR>

" ============================================================================
" System clipboard integration (Wayland / X11 compatible)
" ============================================================================

" Preferred: Install vim-gtk3 and uncomment this line for seamless yy / p behavior
" set clipboard=unnamedplus
set clipboard=unnamedplus

" Fallback: explicit mappings with correct tool (wl-clipboard or xclip)
if \$XDG_SESSION_TYPE == 'wayland'
    " Wayland → use wl-copy / wl-paste (install: sudo apt install wl-clipboard)
    vnoremap <silent> <leader>y :w !wl-copy<CR><CR>
    nnoremap <silent> <leader>y :call system('wl-copy', @")<CR>
    nnoremap <silent> <leader>p :r !wl-paste --no-newline<CR>
    nnoremap <silent> <leader>P :-1r !wl-paste --no-newline<CR>
else
    " X11 → use xclip (your original)
    vnoremap <silent> <leader>y :w !xclip -sel clip<CR><CR>
    nnoremap <silent> <leader>y V:w !xclip -sel clip<CR><CR>
    nnoremap <silent> <leader>p :r !xclip -o -sel clip<CR>
    nnoremap <silent> <leader>P :-1r !xclip -o -sel clip<CR>
endif

" Bonus: quick leader-less mappings if you prefer (optional)
" vnoremap <C-c> :w !wl-copy<CR><CR>     " Ctrl+C in visual → copy (Wayland)
" nnoremap <C-v> :r !wl-paste --no-newline<CR>   " Ctrl+V in normal → paste
EOF

# Install Vim plugins using Vundle
vim +PluginInstall +qall

echo "Vim setup complete with plugins and .vimrc applied."
echo "Script execution finished. Remember to log out and back in for Docker group changes."