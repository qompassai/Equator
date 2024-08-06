#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#.Bash 
PS1='[\u@\h \W]\$ '


#Alias 
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias snvim="sudo -E nvim"
export SUDO_EDITOR=nvim
export EDITOR=nvim


# Bun.js
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

#Conda 
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/phaedrus/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/phaedrus/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/phaedrus/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/phaedrus/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# Prevent auto-activation of base environment
conda config --set auto_activate_base false
# <<< conda initialize <<<

#C++ ABI for Pytorch https://gcc.gnu.org/onlinedocs/libstdc++/manual/using_dual_abi.html
export _GLIBCXX_USE_CXX11_ABI=1
#Cuda/CUDNN
export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:/opt/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH

#Docker
export PATH=/home/testuser/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock

#Erlang
export PATH=$PATH:/usr/lib/erlang/bin
export PATH=$PATH:$HOME/.erlang/bin
#Docker BuildX
export BUILDX_EXPERIMENTAL=1

#Golang
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export GOROOT=/usr/lib/go
export PATH=$PATH:/usr/lib/go/bin

#Haskell
export PATH="$HOME/.local/bin:$PATH"
export PATH=$HOME/.stack/programs/x86_64-linux/ghc-tinfo6-9.6.5/bin:$PATH
[ -f "/home/phaedrus/.ghcup/env" ] && . "/home/phaedrus/.ghcup/env" # ghcup-env

#HuggingFace
export HF_HUB_ENABLE_HF_TRANSFER=1
export HF_HOME=/home/phaedrus/Forge/HF/Models/Flux-dev
#JAVA
export PATH=$PATH:/usr/lib/jvm/java-22-openjdk/bin

# Language servers
for lang_server in beancount-language-server clarity-lsp erlang-debugger erlang-ls gitlab-ci-ls hdl-checker java-language-server nimlsp pkgbuild-language-server salt-lsp vetur-vls; do
  export PATH=$PATH:/usr/bin/$lang_server
done

#Liboqs
LIBOQS_INCLUDE_DIR=/usr/include
LIBOQS_LIB_DIR=/usr/lib

#Lua
export PATH=$PATH:/usr/bin/

#Luarocks
export PATH=$PATH:/usr/bin/luarocks

#Make
export PATH=$PATH:/usr/local/bin

#Models
export FLUX_DEV=/home/phaedrus/Forge/HF/Models/Flux-dev/flux1-dev.sft
export AE=/home/phaedrus/Forge/HF/Models/Flux-dev/ae.sft
#Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  
#Vim/Neovim/Neovide
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.npm/bin
#Opam
 test -r /home/phaedrus/.opam/opam-init/init.sh && . /home/phaedrus/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

#OpenSSL
export OPENSSL_MODULES=/usr/lib/ossl-modules


#Podman
export PATH=$PATH:/usr/lib/podman

#Python
export PATH=$PATH:/usr/bin/python

#Pkgconfig
export PKG_CONFIG_PATH=/usr/lib/pkgconfig

# Ruby
export PATH=$PATH:/usr/bin/ruby

# Ruby Gems
export PATH=$PATH:/usr/bin/gem
export GEM_HOME=~/.gem
export PATH=$PATH:$GEM_HOME/bin


#Rust
. "$HOME/.cargo/env"
export PATH=$PATH:/usr/bin/cargo:/usr/bin/rustc
export PATH=$PATH:$HOME/.cargo/bin

#Swapfile
set noswapfile

#TensorRT
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/TensorRT-10.1.0.27/lib
export PATH=$PATH:/opt/TensorRT-10.1.0.27/bin



#XDG Runtime
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# Zig
export PATH=$ZIG_HOME/bin:$PATH
export PATH+=:$ZIG_HOME/bin

#Zoxide
eval "$(zoxide init bash)"
export PATH=/home/phaedrus/.nimble/bin:$PATH
