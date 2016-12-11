# http://qiita.com/d-dai/items/d7f329b7d82e2165dab3$B$+$iGR<Z(B
# $BG[?'8+$d$9$/(B
local GREEN=$'%{\e[1;32m%}'
local YELLOW=$'%{\e[1;33m%}'
local BLUE=$'%{\e[1;34m%}'
local DEFAULT=$'%{\e[1;m%}'
PROMPT=$'\n'$GREEN'${USER}@${HOSTNAME} '$YELLOW'%~ '$'\n'$DEFAULT'%(!.#.$) '

# $BF|K\8l$r;HMQ(B
export LANG=ja_JP.UTF-8

# $B?'$r;HMQ(B
 autoload -Uz colors
 colors

# $BJd40(B
autoload -Uz compinit
compinit

# vim$B%-!<%P%$%s%I(B
bindkey -v

# $BB>$N%?!<%_%J%k$H%R%9%H%j!<$r6&M-(B
setopt share_history

# $B%R%9%H%j!<$K=EJ#$rI=<($7$J$$(B
setopt histignorealldups

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# $B%3%^%s%I%_%9$r=$@5(B
setopt correct

# history$B$KF|IU$rI=<((B
alias h='fc -lt '%F %T' 1'
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias ..='c ../'
alias back='pushd'
alias diff='diff -U1'

# backspace,delete$B%-!<$r;H$($k$h$&$K(B
stty erase ^H
bindkey "^[[3~" delete-char

# cd$B$N8e$K(Bls$B$r<B9T(B
chpwd() { ls --color=auto }

# $B6h@Z$jJ8;z$N@_Dj(B
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-style unspecified

# $BJd408e!"%a%K%e!<A*Br%b!<%I$K$J$j:81&%-!<$G0\F0$,=PMh$k(B
zstyle ':completion:*:default' menu select=2

# $BJd40$GBgJ8;z$K$b%^%C%A(B
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Ctrl+r$B$G%R%9%H%j!<$N%$%s%/%j%a%s%?%k%5!<%A!"(BCtrl+s$B$G5U=g(B
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward

# $B%3%^%s%I$rESCf$^$GF~NO8e!"(Bhistory$B$+$i9J$j9~$_(B
# $BNc(B ls $B$^$GBG$C$F(BCtrl+p$B$G(Bls$B%3%^%s%I$r$5$+$N$\$k!"(BCtrl+b$B$G5U=g(B
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end

# git$B@_Dj(B
RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'
