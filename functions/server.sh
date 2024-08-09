# Server

server() {
    if command -v browser-sync >/dev/null 2>&1; then
        echo "Starting Browser-Sync server..."
        browser-sync start --server --files "${1:-**}" "${@:2}"
    else
        echo "Error: browser-sync is not installed or not in the PATH."
        echo "Please install it using npm: npm install -g browser-sync"
    fi
}
