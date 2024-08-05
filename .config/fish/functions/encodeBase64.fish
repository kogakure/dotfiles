function encodeBase64 --description "Encodes images in Base64"
    uuencode -m $argv[1] /dev/stdout | sed 1d | sed '$d'
end
