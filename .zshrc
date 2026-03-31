#====================
# Zinit（プラグインマネージャ）
#====================

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

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

#====================
# シェルオプション
#====================

setopt correct
setopt EXTENDED_HISTORY
setopt share_history
setopt histignorealldups

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# 区切り文字
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-style unspecified

#====================
# 補完
#====================

autoload -U compinit && compinit -u
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

#====================
# キーバインド
#====================

bindkey "^[[3~" delete-char

# 履歴検索
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end

# fzf: 履歴のインクリメンタル検索
function fzf_incremental_search_history() {
  selected=`history -E 1 | fzf | cut -b 25-`
  BUFFER=`[ ${#selected} -gt 0 ] && echo $selected || echo $BUFFER`
  CURSOR=${#BUFFER}
  zle redisplay
}
zle -N fzf_incremental_search_history
bindkey "^R" fzf_incremental_search_history

# fzf: ghq リポジトリ選択
fzf-ghq() {
  local repo=$(ghq list | fzf --preview "ghq list --full-path --exact {} | xargs eza -h --long --icons --classify --git --no-permissions --no-user --no-filesize --git-ignore --sort modified --reverse --tree --level 2")
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

#====================
# エイリアス
#====================

# 安全策
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'

# eza
alias ls='eza --icons --classify'
alias ll='ls -l'
alias la='ls -a'
chpwd() { eza --icons --classify }

# その他
alias vim='nvim'
alias diff='diff -U1'
alias grep='grep --color'

# Git
alias gs='git s'
alias ga='git a'
alias gc='git c'
alias gp='git p'

# プラットフォーム別
case "${OSTYPE}" in
  darwin*)
    alias ps='ps auxwm'
    alias date='gdate'
    ;;
  linux*)
    alias ps='ps --sort=start_time -rss'
    ;;
esac

#====================
# PATH
#====================

typeset -U path PATH
path=(
  /run/current-system/sw/bin(N-/)
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

export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.pulumi/bin:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

#====================
# ツール初期化
#====================

# Homebrew
export HOMEBREW_NO_INSTALL_UPGRADE=1

# Starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.dotfiles/starship.toml

# mise（言語バージョン管理）
[[ -x ~/.local/bin/mise ]] && eval "$(~/.local/bin/mise activate zsh)"

# difftastic
export GIT_EXTERNAL_DIFF=difft

# Google Cloud SDK
[[ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]] && source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"

# git-wt
eval "$(git wt --init zsh)"
wt() {
  git wt "$(git wt | tail -n +2 | fzf | awk '{print $(NF-1)}')"
}

# マシン固有の設定（git 管理外）
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
