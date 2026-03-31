{ username, ... }:

{
  system.defaults = {
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
    };

    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.3;
      tilesize = 62;
      show-recents = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferredViewStyle = "Nlsv";
      FXDefaultSearchScope = "SCcf";
    };

    screencapture = {
      location = "/Users/${username}/Pictures/Screenshots";
      type = "png";
      disable-shadow = true;
    };

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

  system.activationScripts.postActivation.text = ''
    mkdir -p "/Users/${username}/Pictures/Screenshots"
  '';

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
