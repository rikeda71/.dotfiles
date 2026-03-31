{ ... }:

{
  # ========================
  # macOS システム設定 (macos.sh の置き換え)
  # ========================

  system.defaults = {
    # トラックパッド
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    # キーボード
    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
    };

    # Dock
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.3;
      tilesize = 62;
      show-recents = false;
    };

    # Finder
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferredViewStyle = "Nlsv";
      FXDefaultSearchScope = "SCcf";
    };

    # スクリーンショット
    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
      disable-shadow = true;
    };

    # その他 (defaults write で直接指定が必要なもの)
    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.CrashReporter" = {
        DialogType = "none";
      };
    };
  };

  # Screenshots ディレクトリ作成
  system.activationScripts.postActivation.text = ''
    mkdir -p "$HOME/Pictures/Screenshots"
  '';

  # ========================
  # Homebrew (GUI アプリのみ)
  # ========================

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };
    casks = [
      "ghostty"
      "obsidian"
      "raycast"
    ];
  };
}
