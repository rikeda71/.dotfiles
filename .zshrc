# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

#====================
# 基本設定
#====================

# vimキーバインド
bindkey -v

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
  eval "$(anyenv init - zsh)"
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

# use cool-peco
FPATH="$FPATH:$HOME/.dotfiles/cool-peco"
autoload -Uz cool-peco
cool-peco
bindkey '^r' cool-peco-history

# === cool-peco init ===
FPATH="$FPATH:/Users/rikeda/.dotfiles/cool-peco"
autoload -Uz cool-peco
cool-peco
# ======================
