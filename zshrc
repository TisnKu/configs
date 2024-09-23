# kill port
function ko() {
    kill $(lsof -i:$1 -t)
}

# vpn
function vpn() {
    export ALL_PROXY=http://127.0.0.1:7890
}

function unvpn() {
    unset ALL_PROXY
}


# autojump
if [[ $(uname) == "Darwin" ]]; then
  [ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
fi

# arch
function x86() {
    arch -x86_64 zsh
}

function arm() {
    arch -arm64 zsh
}

function findKeychainPassword() {
    security find-generic-password -s $1 -a $2 -w # $1: service, $2: account
}

function otp {
    local secret=$(findKeychainPassword 'OTP' $1)
    local code=$(oathtool --totp -d 6 -b $secret)
    echo $code | pbcopy
    echo $code
}

# git alias
function gcob() {
    saveIFS="$IFS"
    IFS="\\n"
    branches=("${(@f)$(git branch -a)}")
    IFS="$saveIFS"

    for branch in $branches; do
        if [[ $branch == *$1* ]]; then
            git checkout "$(echo $branch | sed -E "s/\*?[[:space:]]?(remotes\/origin\/)?//g")"
            break
        fi
    done;
}

alias currentbranch="git branch | grep \* | cut -d ' ' -f2"
alias lg="lazygit"

function gps() {
    gp --set-upstream origin $(currentbranch);
}

function pruneBranches() {
    git remote prune origin && git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -D
}

# UUID
function uuid() {
    uuidgen | tr -d '\n' | tr '[:upper:]' '[:lower:]' | pbcopy
}

# user/bin to path

function pullmain() {
    git pull origin main
}

# qemu
alias qemu="qemu-system-x86_64"

# Teams
alias tmp="cd ~/projects/teams-modular-packages"
alias tsw="cd ~/projects/teamspace-web"

# rust
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

# os-tutorial gcc cross compile
# export CC=/opt/homebrew/Cellar/gcc/11.2.0_3
#export CC=/usr/bin/gcc
#export LD=/opt/homebrew/Cellar/gcc/11.2.0_3
#export GCC_PREFIX="/usr/local/i386elfgcc"
#export TARGET=i386-elf
#export PATH="$GCC_PREFIX/bin:$PATH"

if [[ $(uname) == "Darwin" ]]; then
  # Brew usts mirror
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
  HOMEBREW_NO_AUTO_UPDATE=1
  # homebrew
  ## usts mirror
  HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
  export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
  export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
  export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#zprof

#export PATH="$PATH:/Users/txku/riscv64-gcc/bin"
#PATH=$PATH:/usr/local/opt/riscv-gnu-toolchain/bin


function clearRemoteRef {
  #git branch -a | awk -F/ '/\/origin\/.*/ {branchName=$0; sub("remotes/","",branchName); print branchName}' | xargs -I {} git branch -d -r {}
  git branch -r | awk -F/ '/origin\/.*/ {branchName=$0; sub("origin/","",branchName); print branchName}' | xargs -I {} git branch -d -r origin/{}
}

# Search and open files/folders with vim using fzf (directories only)
function vif() {
  local dir=$(find * -maxdepth 0 -type d | fzf --query="$1" --select-1 --exit-0 --preview 'ls -la {} | sed 1d | grep "^d" | head -50')
  if [[ -n "$dir" ]]; then
    cd $dir
    vi .
  fi
}

# write a non stop beep function after $arg minutes
function beep() {
  local arg=$1
  local i=0
  # wait for $arg minutes
  while [ $i -lt $arg ]; do
    sleep 60
    i=$((i + 1))
  done
  # play sound non stop until quit
  while true; do
    afplay /System/Library/Sounds/Hero.aiff
  done
}

# Git utils
function hardreset() {
  git fetch --all
  git reset --hard origin/$(currentbranch)
}

function syncm() {
  git fetch origin master:master && git merge master --no-edit
}

function gcne() {
  git commit --no-edit
}

function shallowfetch() {
  git fetch --depth=1
  git reflog expire --expire-unreachable=now --all
  git gc --aggressive --prune=all
}

function ryzen() {
  local domain=$(findKeychainPassword 'ryzen' 'domain')
  local ryzenuser=$(findKeychainPassword 'ryzen' 'user')
  local ryzenpwd=$(findKeychainPassword 'ryzen' 'password')

  wakeRyzen

  local cmdstr="xfreerdp /u:$ryzenuser /p:$ryzenpwd /v:$domain /sound /microphone /prevent-session-lock +clipboard +dynamic-resolution > ~/xfreerdp.log"
  tmux new-session -d -s ryzen $cmdstr
}

function wakeRyzen ()
{
  # send wake up signal
  dig +short ktx.ddns.net | xargs wol 58:11:22:BF:74:FF -c
}

function kry() {
  tmux kill-session -t ryzen
}

function sry() {
  wakeRyzen
  ssh ryzen
}


# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
