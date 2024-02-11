function replaceWeztermLogo --description "Set a different icon for Kitty terminal"
    cp ~/Dropbox/Software/Wezterm/terminal.icns /Applications/WezTerm.app/Contents/Resources/terminal.icns
    sudo rm -rfv /Library/Caches/com.apple.iconservices.store
    sudo find /private/var/folders/ \( -name com.apple.dock.iconcache -or -name com.apple.iconservices \) -exec rm -rfv {} \;
    sleep 3;
    sudo touch /Applications/*;
    killall Dock;
    killall Finder;
end
