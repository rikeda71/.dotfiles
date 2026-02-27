### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# user settings
zinit light zsh-users/zsh-completions                  # コマンド補完
zinit light zsh-users/zsh-autosuggestions              # コマンド入力履歴の補完
zinit light zdharma-continuum/fast-syntax-highlighting # zsh のシンタックスハイライト

### End of Zinit's installer chunk

#====================
# 基本設定
#====================

# backspace,deleteキーを使えるように
bindkey "^[[3~" delete-char

# コマンドミスを修正
setopt correct

# 開始と終了を記録
setopt EXTENDED_HISTORY

# 区切り文字の設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-style unspecified

# 他のターミナルとヒストリーを共有
setopt share_history

# ヒストリーに重複を表示しない
setopt histignorealldups
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# 補完
autoload -U compinit && compinit -u
## 小文字でも大文字ディレクトリ、ファイルを補完できるようにする
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

#====================
# コマンド
#====================

# alias
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias diff='diff -U1'
alias ll='ls -l'
alias la='ls -a'
alias grep='grep --color'
case "${OSTYPE}" in
  darwin*)
    alias  ps='ps auxwm'
    ;;
  linux*)
    alias ps='ps --sort=start_time -rss'
    ;;
esac

alias gs='git s'
alias ga='git a'
alias gc='git c'
alias gp='git p'

# lsの自動カラー表示設定
# cdの後にlsを実行
case "${OSTYPE}" in
  darwin*)
    # Mac
    alias ls="ls -GF"
    chpwd() { ls -GF }
    ;;
  linux*)
    # Linux
    alias ls='ls --color'
    chpwd() { ls --color }
    ;;
esac

# コマンドを途中まで入力後、historyから絞り込み
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end

# fzf setting
function fzf_incremental_search_history() {
  selected=`history -E 1 | fzf | cut -b 25-`
  BUFFER=`[ ${#selected} -gt 0 ] && echo $selected || echo $BUFFER`
  CURSOR=${#BUFFER}
  zle redisplay
}
zle -N fzf_incremental_search_history
bindkey "^R" fzf_incremental_search_history

fzf-ghq() {
  local repo=$(ghq list | fzf --preview "ghq list --full-path --exact {} | xargs exa -h --long --icons --classify --git --no-permissions --no-user --no-filesize --git-ignore --sort modified --reverse --tree --level 2")
  if [ -n "$repo" ]; then
    repo=$(ghq list --full-path --exact $repo)
    BUFFER="cd ${repo}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-ghq
bindkey '^G' fzf-ghq
export FZF_DEFAULT_OPTS='--layout=reverse --border --exit-0'


typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  /Library/Apple/usr/bin
)

case "${OSTYPE}" in
  darwin*)
    # Mac

    # coreutils のエイリアス
    alias date='gdate'
    ;;
esac

# exports
export PATH="/usr/local/opt/krb5/bin:$PATH"
export PATH="/usr/local/opt/krb5/sbin:$PATH"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
## homebrew を勝手に更新しない
export HOMEBREW_NO_INSTALL_UPGRADE=1
# starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.dotfiles/starship.toml
# poetry
fpath+=~/.zfunc
autoload -Uz compinit && compinit
# terraform
export PATH="$PATH":"$HOME/.tfenv/bin"
export PATH="$PATH":"$HOME/.tgenv/bin"
# golangci-lint
export PATH="$PATH":"$HOME/go/bin"

. ~/.asdf/plugins/java/set-java-home.zsh
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/postgresql@16/lib/pkgconfig"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# difft
# https://github.com/Wilfred/difftastic
export GIT_EXTERNAL_DIFF=difft

if [ -z "$SSH_AUTH_SOCK" ]; then
   # Check for a currently running instance of the agent
   RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
   if [ "$RUNNING_AGENT" = "0" ]; then
        # Launch a new instance of the agent
        ssh-agent -s &> $HOME/.ssh/ssh-agent
   fi
   eval `cat $HOME/.ssh/ssh-agent` > /dev/null
   ssh-add $HOME/.ssh/id_ed25519 2> /dev/null
fi
eval "$(~/.local/bin/mise activate zsh)"

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin

eval $(/opt/homebrew/bin/brew shellenv)

. "/Users/rikeda/.deno/env"
# Added by Antigravity
export PATH="/Users/rikeda/.antigravity/antigravity/bin:$PATH"

# git wt
eval "$(git wt --init zsh)"
wt() {
  git wt "$(git wt | tail -n +2 | fzf | awk '{print $(NF-1)}')"
}

# terminal color
# コマンド実行直前に呼ばれる
precmd() {
    printf "\e]11;#1E1E2E\a"
}

