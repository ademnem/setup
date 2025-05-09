# Updating Packages
sudo apt update
sudo apt upgrade


# Downloading Personal Packages
apt_pkgs=(
    # for neovim
    "cmake" # and clangd
    "ninja-build"
    "gettext"
    "unzip"
    "curl"
    "build-essential"

    "tmux" # tmux
    "npm" # webdev
    "ripgrep" # nvim
)
for name in "${apt_pkgs[@]}"; do
    echo -n "Checking for $name... "
    if ! dpkg -s "$name" &> /dev/null; then
        echo "Done"
        echo -n "Installing $name... "
        echo "Done"
        sudo apt install "$name"
    else 
        echo "Found"
    fi
done
echo -n "Checking for nvim... "
if ! which nvim &> /dev/null; then
    echo "Done"
    echo -n "Installing nvim... "
    git clone https://github.com/neovim/neovim.git
    cd neovim
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    echo "Done"
else
    echo "Found"
fi


# Adding Personal Config Files
cd $HOME/.config/
configs=(
    "git@github.com:ademnem/nvim"
    "git@github.com:ademnem/tmux"
)
for url in "${configs[@]}"; do
    git clone "$url"
done


lines="
# SETUP ADDITIONS
# Aliases
alias rm=\"rm -iv\"

# NVIM
alias vim=nvim
alias vi=nvim
export MANPAGER='nvim +Man!'

# TMUX
export TMUX_CONF=\$HOME/.config/tmux/tmux.conf
if [ -n \"\$TMUX\" ]; then
    tmux source-file "$TMUX_CONF"
fi
"

# grep is not good with multiline inputs so just check for the first
echo -n "Check for lines in .bashrc... "
if ! grep -qF "# SETUP ADDITIONS" "$HOME/.bashrc"; then
    echo "Done"
    echo -n "Adding lines... "
    echo "$lines" >> "$HOME/.bashrc"
    echo "Done"
    source "$HOME/.bashrc"
else
    echo "Found"
fi
