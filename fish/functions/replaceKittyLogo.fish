function replaceKittyLogo --description "Set a different icon for Kitty terminal"
  cp ~/Dropbox/Software/Kitty/kitty-icon/kitty-dark.icns /Applications/kitty.app/Contents/Resources/kitty.icns
  rm /var/folders/*/*/*/com.apple.dock.iconcache
  killall Dock
end
