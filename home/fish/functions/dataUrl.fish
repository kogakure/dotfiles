function dataUrl --description "Create a data URL from a file"
    set mimeType (file -b --mime-type $argv)
    if string match -r '^text/' $mimeType
        set mimeType "$mimeType;charset=utf-8"
    end
    echo "data:$mimeType;base64,(openssl base64 -in $argv | tr -d '\n')"
end
