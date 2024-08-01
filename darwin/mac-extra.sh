# Icon Settings
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:iconSize 44" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:gridSpacing 60" ~/Library/Preferences/com.apple.finder.plist

# Restart Finder
killall Finder
