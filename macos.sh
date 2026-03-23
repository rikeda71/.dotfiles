#!/bin/zsh

# macOS の設定をスクリプト化
# 新しい Mac をセットアップする際に実行する
# 一部の設定は再ログインまたは再起動後に反映される

echo "macOS の設定を適用します..."

#====================
# トラックパッド
#====================

# 三本指ドラッグを有効化
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# タップでクリック
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

#====================
# キーボード
#====================

# キーリピートを高速化
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# 長押しでアクセント文字を表示しない（キーリピートを優先）
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

#====================
# Dock
#====================

# Dock を自動的に非表示
defaults write com.apple.dock autohide -bool true

# Dock の表示遅延を短縮
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3

# Dock のアイコンサイズ
defaults write com.apple.dock tilesize -int 62

# 最近使ったアプリを Dock に表示しない
defaults write com.apple.dock show-recents -bool false

#====================
# Finder
#====================

# 拡張子を常に表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# パスバーを表示
defaults write com.apple.finder ShowPathbar -bool true

# ステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool true

# デフォルトでリスト表示
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# 検索時にデフォルトでカレントフォルダ内を検索
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# .DS_Store をネットワークドライブに作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

#====================
# スクリーンショット
#====================

# スクリーンショットの保存先を ~/Pictures に変更
mkdir -p ~/Pictures/Screenshots
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

# スクリーンショットの形式を PNG に
defaults write com.apple.screencapture type -string "png"

# スクリーンショットのファイル名から影を除去
defaults write com.apple.screencapture disable-shadow -bool true

#====================
# その他
#====================

# クラッシュレポーターを無効化
defaults write com.apple.CrashReporter DialogType -string "none"

# .DS_Store をリムーバブルメディアに作成しない
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

#====================
# 設定の反映
#====================

killall Dock
killall Finder
killall SystemUIServer

echo "macOS の設定を適用しました。一部の設定は再ログイン後に反映されます。"
