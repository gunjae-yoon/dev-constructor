# Ubuntu 22.04 LTS (Jammy Jellyfish)
FROM ubuntu:22.04

# Avoid interactive prompts and set timezone
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Seoul

# ───────────────────────────────────────────────
# Install ca-certificates + curl + git FIRST
# (prevents HTTPS / certificate errors during downloads)
# ───────────────────────────────────────────────
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        ssh \
    && apt-get clean &"& \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /var/tmp/*

# ───────────────────────────────────────────────
# Upgrade + full C++ dev environment & utilities
# ───────────────────────────────────────────────
RUN apt-get update -qq && \
    apt-get upgrade -yqq && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        cmake-extras \
        ninja-build \
        gdb \
        valgrind \
        clang \
        clang-tidy \
        clang-format \
        lldb \
        libstdc++-11-dev \
        libc++-dev \
        libc++abi-dev \
        libfmt-dev \
        librange-v3-dev \
        wget \
        unzip \
        less \
        man-db \
        ripgrep \
        fd-find \
        bat \
        zsh \
        vim \
        ccache \
        doxygen \
        graphviz \
        sudo \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /var/tmp/*

# ───────────────────────────────────────────────
# Oh My Zsh + Powerlevel10k + useful plugins
# ───────────────────────────────────────────────
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone --depth=1 https://github.com/zsh-users/zsh-completions \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions && \
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' $HOME/.zshrc && \
    echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)' >> $HOME/.zshrc && \
    echo 'POWERLEVEL9K_MODE=nerdfont-complete' >> $HOME/.zshrc && \
    echo '[[ ! -f ~/.p10k.zsh ]] && echo "Run » p10k configure « to customize the prompt"' >> $HOME/.zshrc

# Set git pager to less with options for better readability in terminal
RUN git config --global core.pager 'less -FRX'
RUN git config --global user.email "rnswo42b@gmail.com"
RUN git config --global user.name "Gunjae Yoon"

# Working directory (mount your code here from host)
WORKDIR /root/workspace

# Use zsh as default shell
SHELL ["/bin/zsh", "-c"]

# Start interactive zsh as root
CMD ["zsh"]
