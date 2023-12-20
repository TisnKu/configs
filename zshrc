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

# arch
function x86() {
    arch -x86_64 zsh
}

function arm() {
    arch -arm64 zsh
}

function findKeychainPassword() {
    security find-generic-password -s $1 -a $2 -w
}

function otp {
    local secret=$(findKeychainPassword 'OTP' $1)
    local code=$(oathtool --totp -d 6 -b $secret)
    echo $code | pbcopy
    echo $code
}

# UUID
function uuid() {
    uuidgen | tr -d '\n' | tr '[:upper:]' '[:lower:]' | pbcopy
}

if [[ $(uname) == "Darwin" ]]; then
  # Brew usts mirror
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
  HOMEBREW_NO_AUTO_UPDATE=1
  # homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"
  # usts mirror
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
  HOMEBREW_NO_AUTO_UPDATE=1

  eval "$(nodenv init -)"
fi

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

function clearRemoteRef {
  #git branch -a | awk -F/ '/\/origin\/.*/ {branchName=$0; sub("remotes/","",branchName); print branchName}' | xargs -I {} git branch -d -r {}
  git branch -r | awk -F/ '/origin\/.*/ {branchName=$0; sub("origin/","",branchName); print branchName}' | xargs -I {} git branch -d -r origin/{}
}

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

function gps() {
    gp --set-upstream origin $(currentbranch);
}

function pruneBranches() {
    git remote prune origin && git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -D
}

