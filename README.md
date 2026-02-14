# Dev Constructor

A collection of Docker-based development environments and setup scripts for quickly bootstrapping development systems on Ubuntu.

## Overview

This repository provides:
- **Docker Development Environments**: Pre-configured containerized development environments with all necessary tools
- **System Initialization Scripts**: Automated setup scripts for Ubuntu 22.04/24.04
- **SSH Key Management**: Convenient SSH key generation utilities

## 📦 Available Environments

### C++ Development Environment

Full-featured C++ development container based on Ubuntu 22.04 LTS with:

**Build Tools & Compilers:**
- GCC (build-essential)
- Clang & LLVM toolchain
- CMake & Ninja build systems
- ccache (compile caching)

**Development Tools:**
- GDB & LLDB debuggers
- Valgrind (memory profiling)
- clang-tidy & clang-format (linting & formatting)
- Doxygen & Graphviz (documentation)

**Modern C++ Libraries:**
- libfmt-dev (formatting)
- librange-v3-dev (ranges)
- libstdc++-11-dev, libc++-dev, libc++abi-dev

**Enhanced Terminal:**
- Zsh with Oh My Zsh
- Powerlevel10k theme
- Plugins: zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions
- Modern CLI tools: ripgrep, fd-find, bat

**Editor:**
- Vim with common configurations

## 🚀 Quick Start

### Using Docker Environment (C++)

1. **Build the container:**
   ```bash
   cd docker/cpp-dev
   docker compose build
   ```

2. **Start the development environment:**
   ```bash
   docker compose up -d
   docker exec -it cpp-dev zsh
   ```

3. **Your workspace:**
   - Host directory `~/workspace` is mounted to `/root/workspace` in the container
   - SSH agent is forwarded for git operations
   - Network host mode enabled for seamless networking

### Ubuntu System Initialization

For setting up a fresh Ubuntu 22.04 or 24.04 system:

```bash
cd script
chmod +x initialization.sh
./initialization.sh
```

**This script installs:**
- Docker & Docker Compose
- D2Coding font (Korean coding font)
- Vim with Vundle plugin manager and NERDTree
- System clipboard tools (xclip, wl-clipboard)
- Common development dependencies (curl, git, wget, ca-certificates)

> **Note:** After running the script, log out and log back in for Docker group permissions to take effect.

### SSH Key Generation

Generate a secure RSA 4096-bit SSH key:

```bash
cd script
chmod +x generate-ssh-key.sh
./generate-ssh-key.sh
```

**Features:**
- Interactive SSH key generation
- Automatic permission setup (600 for private, 644 for public)
- Optional ssh-agent integration
- Displays public key for easy copying to GitHub/GitLab

## 📂 Repository Structure

```
dev-constructor/
├── docker/
│   └── cpp-dev/              # C++ development environment
│       ├── Dockerfile        # Container configuration
│       └── docker-compose.yaml
├── script/
│   ├── initialization.sh     # Ubuntu system setup script
│   └── generate-ssh-key.sh   # SSH key generation utility
└── README.md
```

## 🔧 Configuration

### Docker Compose Variables

The C++ dev environment uses these environment variables (automatically sourced):
- `${HOME}`: Your home directory (mapped to /root in container)
- `${SSH_AUTH_SOCK}}: SSH agent socket for git authentication

### Customizing the Vim Setup

The initialization script creates a `.vimrc` with:
- Tab/space settings (4 spaces for most, 2 for YAML)
- NERDTree toggle on `<Tab>`
- System clipboard integration (supports both X11 and Wayland)
- Automatic ctags generation for C/C++ files

To modify Vim plugins, edit the initialization script before running.

### Powerlevel10k Configuration

First time in the container, run:
```bash
p10k configure
```

This launches an interactive wizard to customize your terminal prompt.

## 🛠️ Requirements

**For Docker environments:**
- Docker Engine 20.10+
- Docker Compose V2

**For initialization script:**
- Ubuntu 22.04 or 24.04 LTS
- sudo privileges
- Internet connection

## 💡 Tips

**Docker Container Management:**
```bash
# Start container
docker compose up -d

# Enter container
docker exec -it cpp-dev zsh

# Stop container
docker compose down

# Rebuild after Dockerfile changes
docker compose build --no-cache
```

**Vim Clipboard Usage:**
- Copy: Select text in visual mode, then `<leader>y` (default leader is `\`)
- Paste: `<leader>p` in normal mode
- Or use `"+y` and `"+p` with vim-gtk3 installed

**SSH Key with Multiple Services:**
Add to `~/.ssh/config`:
```ssh
Host github.com
    IdentityFile ~/.ssh/id_rsa_4096

Host gitlab.com
    IdentityFile ~/.ssh/id_rsa_4096
```

## 📝 License

This project is provided as-is for development environment setup purposes.

## 🤝 Contributing

Feel free to submit issues or pull requests for:
- Additional language environments (Python, Rust, Go, etc.)
- Enhanced tooling configurations
- Bug fixes and improvements

---

**Author:** rnswo42b@gmail.com  
**Last Updated:** February 2026
