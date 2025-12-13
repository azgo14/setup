#!/bin/bash

# Load git-completion.bash for __git_complete to work
# Try common locations for macOS and Linux
_git_completion_paths=(
  # macOS Homebrew (Intel)
  "/usr/local/share/git-core/contrib/completion/git-completion.bash"
  # macOS Homebrew (Apple Silicon)
  "/opt/homebrew/share/git-core/contrib/completion/git-completion.bash"
  # macOS Xcode
  "/Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash"
  # Linux (Debian/Ubuntu)
  "/usr/share/bash-completion/completions/git"
  # Linux (older)
  "/etc/bash_completion.d/git"
  # Linux (git package)
  "/usr/share/git-core/contrib/completion/git-completion.bash"
)

for _path in "${_git_completion_paths[@]}"; do
  if [[ -f "$_path" ]]; then
    source "$_path"
    break
  fi
done
unset _path _git_completion_paths

# Fallback: define a no-op __git_complete if not available
if ! type __git_complete &>/dev/null; then
  __git_complete() { :; }
fi

# Base git alias

alias g='git'; __git_complete g _git

# git clone

alias gcl='git clone'; __git_complete gcl _git_clone

# git pull / git push

alias gpl='git pull';                   __git_complete gpl   _git_pull

alias gplr='git pull --rebase';         __git_complete gplr  _git_pull

alias gplum='git pull upstream master'

alias gpu='git push';                 __git_complete gpu   _git_push

alias gput='git push --tags';         __git_complete gput  _git_push

alias gpuf='git push --force';        __git_complete gpuf  _git_push

alias gpuu='git push --set-upstream'; __git_complete gpuu  _git_push

alias gpuo='git push origin'

alias gpuom='git push origin master'

alias gpuar='git remote | xargs -L1 git push'

alias gpp='git pull && git push'

# git fetch

alias gf='git fetch --all --prune';                    __git_complete gf   _git_fetch

alias gft='git fetch --all --prune --tags';            __git_complete gft  _git_fetch

alias gfv='git fetch --all --prune --verbose';         __git_complete gfv  _git_fetch

alias gftv='git fetch --all --prune --tags --verbose'; __git_complete gftv _git_fetch

alias gfr='git fetch && git rebase'

# git add / git rm / git mv

alias ga='git add';                __git_complete ga   _git_add

alias gap='git add --patch';       __git_complete gap  _git_add

alias gall='git add --all';        __git_complete gall _git_add

alias gai='git add --interactive'; __git_complete gai  _git_add

alias gau='git add --update';      __git_complete gau  _git_add

alias grm='git rm'; __git_complete grm _git_rm

alias gmv='git mv'; __git_complete gmv _git_mv

# git status / git diff

alias gs='git status';                      __git_complete gs  _git_status

alias gss='git status --short';             __git_complete gss _git_status

alias gd='git diff';                        __git_complete gd  _git_diff

alias gdw='git diff --word-diff';           __git_complete gdw  _git_diff

alias gds='git diff --staged';              __git_complete gds _git_diff

alias gdws='git diff --word-diff --staged'; __git_complete gdws  _git_diff

alias gdv='git diff -w "$@" | vim -R -'

# git commit

alias gc='git commit --verbose';           __git_complete gc   _git_commit

alias gcam='git commit --verbose --amend'; __git_complete gcam _git_commit

alias gca='git commit --verbose --all';    __git_complete gca  _git_commit

alias gcm='git commit --verbose -m';       __git_complete gcm  _git_commit

alias gci='git commit --interactive';      __git_complete gci  _git_commit

# git stash

alias gst='git stash';        __git_complete gst   _git_stash

alias gstpu='git stash push'

alias gstpo='git stash pop'

alias gstd="git stash drop"

alias gstl="git stash list"

alias gsts="git stash show -p"

# git reset / git clean

alias grst='git reset'; __git_complete grst _git_reset

alias gnuke='git reset --hard && git clean -d --force -x'

alias gclean='git clean -d --force'

# git branch

alias gb='git branch';                     __git_complete gb    _git_branch

alias gba='git branch --all';              __git_complete gba   _git_branch

alias gbt='git branch --track';            __git_complete gbt   _git_branch

alias gbm='git branch --move';             __git_complete gbm   _git_branch

alias gbdel='git branch --delete --force'; __git_complete gbdel _git_branch

# git checkout

alias gco='git checkout';         __git_complete gco  _git_checkout

alias gcob='git checkout -b';     __git_complete gcob _git_checkout

alias gct='git checkout --track'; __git_complete gct  _git_checkout

# git cherrypick

alias gcp='git cherry-pick';             __git_complete gcp  _git_cherry_pick

alias gcpa='git cherry-pick --abort';    __git_complete gcpa _git_cherry_pick

alias gcpc='git cherry-pick --continue'; __git_complete gcpc _git_cherry_pick

# git merge / git rebase

alias gm='git merge';             __git_complete gm  _git_merge

alias gma='git merge --abort';    __git_complete gma _git_merge

alias gmc='git merge --continue'; __git_complete gmc _git_merge

alias grb='git rebase';                __git_complete grb  _git_rebase

alias grba='gir rebase --abort';       __git_complete grba _git_rebase

alias grbc='git rebase --continue';    __git_complete grbc _git_rebase

alias grbi='git rebase --interactive'; __git_complete grbi _git_rebase

# git tag

alias gt="git tag";             __git_complete gt  _git_tag

alias gta="git tag --annotate"; __git_complete gta _git_tag

alias gtd="git tag --delete";   __git_complete gtd _git_tag

alias gtl="git tag --list";     __git_complete gtl _git_tag

# git log

alias gl='git log --graph --pretty=format:"%C(yellow)%h%Creset%C(green)%d%Creset %s %C(red)<%an> %C(cyan)(%cr)%Creset" --abbrev-commit'; __git_complete gl _git_log

alias gls='gl --stat';                                  __git_complete gls  _git_log

alias gsl='git shortlog --email';                       __git_complete gsl  _git_shortlog

alias gsls='git shortlog --email --summary --numbered'; __git_complete gsls _git_shortlog

# git remote

alias gr='git remote';      __git_complete gr  _git_remote

alias grv='git remote -v';  __git_complete grv _git_remote

alias gra='git remote add'; __git_complete gra _git_remote

# git bisect

alias gbs='git bisect'; __git_complete gbs  _git_bisect

alias gbsb='git bisect bad'

alias gbsg='git bisect good'

alias gbsr='git bisect reset'

alias gbss='git bisect start'

# Misc

alias gignore='git update-index --assume-unchanged'

# Help command
ghelp() {
  cat << 'EOF'
Git Aliases Help
================

BASE
  g         git

CLONE
  gcl       git clone

PULL / PUSH
  gpl       git pull
  gplr      git pull --rebase
  gplum     git pull upstream master
  gpu       git push
  gput      git push --tags
  gpuf      git push --force
  gpuu      git push --set-upstream
  gpuo      git push origin
  gpuom     git push origin master
  gpuar     git push to all remotes
  gpp       git pull && git push

FETCH
  gf        git fetch --all --prune
  gft       git fetch --all --prune --tags
  gfv       git fetch --all --prune --verbose
  gftv      git fetch --all --prune --tags --verbose
  gfr       git fetch && git rebase

ADD / RM / MV
  ga        git add
  gap       git add --patch
  gall      git add --all
  gai       git add --interactive
  gau       git add --update
  grm       git rm
  gmv       git mv

STATUS / DIFF
  gs        git status
  gss       git status --short
  gd        git diff
  gdw       git diff --word-diff
  gds       git diff --staged
  gdws      git diff --word-diff --staged
  gdv       git diff in vim

COMMIT
  gc        git commit --verbose
  gcam      git commit --verbose --amend
  gca       git commit --verbose --all
  gcm       git commit --verbose -m
  gci       git commit --interactive

STASH
  gst       git stash
  gstpu     git stash push
  gstpo     git stash pop
  gstd      git stash drop
  gstl      git stash list
  gsts      git stash show -p

RESET / CLEAN
  grst      git reset
  gnuke     git reset --hard && git clean -dfx
  gclean    git clean -df

BRANCH
  gb        git branch
  gba       git branch --all
  gbt       git branch --track
  gbm       git branch --move
  gbdel     git branch --delete --force

CHECKOUT
  gco       git checkout
  gcob      git checkout -b
  gct       git checkout --track

CHERRY-PICK
  gcp       git cherry-pick
  gcpa      git cherry-pick --abort
  gcpc      git cherry-pick --continue

MERGE / REBASE
  gm        git merge
  gma       git merge --abort
  gmc       git merge --continue
  grb       git rebase
  grba      git rebase --abort
  grbc      git rebase --continue
  grbi      git rebase --interactive

TAG
  gt        git tag
  gta       git tag --annotate
  gtd       git tag --delete
  gtl       git tag --list

LOG
  gl        git log (graph, pretty format)
  gls       git log --stat
  gsl       git shortlog --email
  gsls      git shortlog --email --summary --numbered

REMOTE
  gr        git remote
  grv       git remote -v
  gra       git remote add

BISECT
  gbs       git bisect
  gbsb      git bisect bad
  gbsg      git bisect good
  gbsr      git bisect reset
  gbss      git bisect start

MISC
  gignore   git update-index --assume-unchanged
  ghelp     show this help
EOF
}
