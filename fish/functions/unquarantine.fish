function unquarantine --description "Manually remove a downloaded app or file from the quarantine"
    for attribute in com.apple.metadata:kMDItemDownloadedDate com.apple.metadata:kMDItemWhereFroms com.apple.quarantine
        xattr -r -d "$attribute" $argv
    end
end
