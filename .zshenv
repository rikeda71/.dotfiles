#====================
# パス設定
#====================

# ruby
export RBENV_ROOT=~/.rbenv
export PATH="$RBENV_ROOT/shims:$RBENV_ROOT/bin:$PATH"
if which rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# python
export PIPENV_VENV_IN_PROJECT=true
export PYENV_ROOT=~/.pyenv
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
if which pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# libpq
export LDFLAGS="-L/usr/local/opt/libpq/lib"
export CPPFLAGS="-I/usr/local/opt/libpq/include"
