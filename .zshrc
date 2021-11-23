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
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

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
alias note='jupyter notebook'
alias lab='jupyter lab'
alias tmux='tmux -u -2'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='gig push'

# cdの後にlsを実行
case "${OSTYPE}" in
  darwin*)
    # Mac
    chpwd() { ls -GF }
    ;;
  linux*)
    # Linux
    chpwd() { ls --color }
    ;;
esac

# lsの自動カラー表示設定
case "${OSTYPE}" in
  darwin*)
    # Mac
    alias ls="ls -GF"
    ;;
  linux*)
    # Linux
    alias ls='ls --color'
    ;;
esac

# コマンドを途中まで入力後、historyから絞り込み
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end

# anyenv settings
if [[ "${+commands[anyenv]}" == 1 ]]
then
  eval "$(anyenv init - --no-rehash zsh)"
fi

# tmux settings
if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && [ -z $TMUX ]; then
  if $(tmux has-session); then
    option="attach"
  fi
  tmux $option && exit
fi

# peco setting
function peco-history-selection() {
    BUFFER=$(history 1 | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\*?\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$LBUFFER")
    CURSOR=${#BUFFER}
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection
export PATH="/usr/local/opt/krb5/bin:$PATH"
export PATH="/usr/local/opt/krb5/sbin:$PATH"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
