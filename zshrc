#zmodload zsh/zprof

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# User configuration

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

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
# usts mirror
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
HOMEBREW_NO_AUTO_UPDATE=1

# autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

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

function gps() {
    gp --set-upstream origin $(currentbranch);
}

function pruneBranches() {
    git remote prune origin && git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -D
    # git checkout main

    # # Update our list of remotes
    # git fetch origin
    # git remote prune origin

    # # Remove local fully merged branches
    # git branch --merged main | grep -v 'main$' | xargs git branch -d

    # # Show remote fully merged branches
    # echo "The following remote branches are fully merged and will be removed:"
    # git branch -r --merged main | grep 'origin\/' | sed 's/ *origin\///' | grep -v 'main$'
    
    # # Remove remote fully merged branches
    # git branch -r --merged main | grep 'origin\/' | sed 's/ *origin\///' \
    #             | grep -v 'main$' | xargs -I% git push origin :%
    # echo "Done!"
    # say "Stale feature branches have been deleted"
}

# UUID
function uuid() {
    uuidgen | tr -d '\n' | tr '[:upper:]' '[:lower:]' | pbcopy
}

# user/bin to path
PATH=$PATH:~/bin/

# Android
export ANDROID_HOME=/Users/txku/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Java
export JAVA_HOME=$(/usr/libexec/java_home)

function pullmain() {
    git pull origin main
}

# Teams
function link {
  j msteams-cdl && yarn unlink:cdl;
  j webclient && git clean -fdx;
  yarn;

  j modular && yarn unlink:cdl;
  yarn && yarn link:cdl;

  j msteams-cdl && yarn link:cdl;
  j webclient && grunt build --notests=true --nolint=true && ./shim/listen.sh
}

function callingbuild {
  yarn workspace @msteams/calling build:ng && yarn workspace @msteams/calling-cdl build:ng
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

# Brew usts mirror
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
HOMEBREW_NO_AUTO_UPDATE=1

eval "$(nodenv init -)"

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


function pruneRemoteBranches {
  azureDevOpsUrl="https://dev.azure.com/TBD"
  projectName="TBD"
  repositoryNames=("a", "b", "c")
  apiVersion="7"
  pat=$(echo -n ":ado_pat" | base64)
  branchPrefixToRemove="some_prefix/"
  userEmail="your_email"

  for repositoryName in "${repositoryNames[@]}"; do
    echo -e "\n#####################################"
    echo "Processing repository $repositoryName"

    # Get a list of all remote Git branches that do not have a related pull request
    uri="$azureDevOpsUrl/$projectName/_apis/git/repositories/$repositoryName/refs?filterContains=$branchPrefixToRemove&api-version=$apiVersion"
    headers=(
      "Authorization: Basic $pat"
    )
    branches=$(curl -sS -H "${headers[@]}" "$uri")
    if [ -z "$branches" ]; then
      echo "Failed to query Azure DevOps API for Git branches with error: $apiError"
      continue
    fi
    count=$(echo "$branches" | jq '.count')
    if [ "$count" -eq 0 ]; then
      echo "No Git branches found with prefix $branchPrefixToRemove"
      continue
    fi

    # Filter branches created by user
    branches=$(echo "$branches" | jq ".value")

    echo -e "\nAll branches:"
    echo "$branches" | jq -r '.[] | .name'

    # Get all pull requests by creatorId
    creatorId=$(echo "$branches" | jq '.[0].creator.id' | tr -d '"')
    echo -e "\nCreator ID: $creatorId"
    uri="$azureDevOpsUrl/$projectName/_apis/git/repositories/$repositoryName/pullrequests?searchCriteria.creatorId=$creatorId&api-version=$apiVersion"
    echo -e "\nQuerying pull requests with URI: $uri"
    pullRequests=$(curl -sS -H "${headers[@]}" "$uri" | jq -r '.value[] | .sourceRefName')
    branchSet=$(echo "$pullRequests" | sort -u)
    branchSetJson=$(printf '%s\n' "${branchSet[@]}" | jq -R -s -c 'split("\n")[:-1]')

    echo -e "\nBranches with pull requests:"
    printf '%s\n' "${branchSet[@]}"

    branchesWithoutPullRequest=$(echo "$branches" | jq --argjson exclude "$branchSetJson" '.[] | select(.name | IN($exclude[]) | not)')

    if [ -z "$branchesWithoutPullRequest" ]; then
      echo -e "\nNo remote Git branches found to delete"
      continue
    fi

    echo -e "\nBranches without pull request:"
    echo "$branchesWithoutPullRequest" | jq -r '.name'


    # Delete each branch that does not have a related pull request
    branchReferences=$(echo "$branchesWithoutPullRequest" | jq -c '[. | {name: .name, oldObjectId: .objectId, newObjectId: "0000000000000000000000000000000000000000"}]')

    echo "$branchReferences" | jq
    uri="$azureDevOpsUrl/$projectName/_apis/git/repositories/$repositoryName/refs?api-version=$apiVersion"
    deleteResponse=$(curl -sS -X POST -H "${headers[@]}" -d "$branchReferences" -H "Content-Type: application/json" "$uri")

    echo -e "\nDelete response:"
    echo "$deleteResponse" | jq
  done
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

function syncmaster() {
  git fetch origin master:master && git merge master
}
