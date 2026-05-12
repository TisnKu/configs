Import-Module Microsoft.PowerShell.Management
remove-alias gcb -ErrorAction SilentlyContinue
remove-alias gps -Force -ErrorAction SilentlyContinue 2>&1 | Out-Null

function gcb
{
  param([string]$branch)
  git checkout -b $branch
}

function pruneBranches
{
  gcm
  $localBranches = git branch | Where-Object { $_ -notmatch "\*" } | ForEach-Object { $_.replace("origin/", "").Trim() }
  $remoteBranches = git branch -r | Where-Object { $_ -notmatch "/HEAD" } | ForEach-Object { $_.replace("origin/", "").Trim() }


  write-host "`nLocal Branches"
  write-host "---------------"
  $localBranches | Format-List

  write-host "`nRemote Branches"
  write-host "---------------"
  $remoteBranches | Format-List

  $branchesToDelete = $localBranches | Where-Object { $remoteBranches -notcontains $_ }
  write-host "`nBranches to delete"
  write-host "------------------"
  $branchesToDelete | ForEach-Object { git branch -D $_ }
}

function removeAllRemoteBranches
{
  $branches = git branch -r
  foreach ($branch in $branches)
  {
    # skip master branch and main branch and with ->
    if ($branch -match "origin/(master|main)$" -or $branch -match "->")
    {
      continue
    }
    $trimmedBranch = $branch.Replace('*', '').Replace(' ', '')
    if ($trimmedBranch -notcontains 'tiaku')
    {
      git branch -rd $trimmedBranch
    }
  }
}

function gcob
{
  param([string]$keyword)
  $branches = git branch -a
  foreach ($branch in $branches)
  {
    $trimmedBranch = $branch.Replace('*', '').Replace(' ', '').Replace('remotes/', '').Replace('origin/', '')
    if ($trimmedBranch -like "*$keyword*")
    {
      git checkout $trimmedBranch
      break
    }
  }
}

function pullmaster
{
  git pull origin master 2> $null || git pull origin main
}

function pullmain
{
  git pull origin main
}

function pulldev
{
  git pull origin develop
}

function resetmain
{
  git reset origin/main
}

function resetmainhard
{
  git reset --hard origin/main
}

function gbd
{
  param([string]$keyword)
  $branches = git branch
  foreach ($branch in $branches)
  {
    $trimmedBranch = $branch.Replace('*', '').Replace(' ', '')
    if ($trimmedBranch -like "*$keyword*")
    {
      git branch -D $trimmedBranch
      break
    }
  }
}

function gps
{
  Write-Output "Invoke-Expression" "git push $args --set-upstream origin $(git rev-parse --abbrev-ref HEAD)"
  Invoke-Expression "git push $args --set-upstream origin $(git rev-parse --abbrev-ref HEAD)"
}

function gitsync
{
  foreach ($branch in @('master', 'main', 'develop'))
  {
    if (git branch --list $branch)
    {
      git fetch origin "$branch`:$branch"
    }
  }
}

function hardreset
{
  gfa;
  git reset --hard origin/$(currentBranch) | Out-Null;
  git add * 2>&1 | Out-Null;
  gsta 2>&1 | Out-Null;
  gstd 2>&1 | Out-Null;
  gst;
}

function syncm
{
  gitsync;

  foreach ($branch in @('master', 'main', 'develop'))
  {
    if (git branch --list $branch)
    {
      git merge $branch --no-edit
    }
  }
}

function gcne
{
  git commit --no-edit
}

function gcm
{
  git checkout develop 2> $null  || git checkout master 2> $null || git checkout main 2> $null
}

function gitproxy
{
  git config --global http.proxy 'socks5://127.0.0.1:7890'
}

function gitnoproxy
{
  git config --global --unset http.proxy
}

function currentBranch
{
  git rev-parse --abbrev-ref HEAD
}

function shallowfetch()
{
  git fetch --depth=1
  git reflog expire --expire-unreachable=now --all
  git gc --aggressive --prune=all
}

function gitignorelocally($path)
{
  git update-index --assume-unchanged $path
}

function resetToMaster()
{
  git merge -s ours master --no-edit
  #git diff --name-only --diff-filter=A master...HEAD | ForEach-Object { git rm $_ }
  removeAddedFiles
  git checkout master -- .
  git commit --amend --no-edit
  removeAddedFiles
  git commit --amend --no-edit
}

function removeAddedFiles()
{
  git diff --name-status master...HEAD | Where-Object { $_ -match '^A\s' } | ForEach-Object {
    $file = $_ -replace '^A\s+', ''
    git rm $file
  }
}


