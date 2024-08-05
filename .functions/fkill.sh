# fkill - kill process

fkill() {
    local pid
    local signal="${1:-9}"
    local pattern="$2"

    if ! [ "$signal" -eq "$signal" ] 2>/dev/null; then
        echo "Invalid signal: $signal"
        return 1
    fi

    if [ -n "$pattern" ]; then
        pid=$(ps -ef | sed 1d | grep "$pattern" | fzf -m --header='[kill:process]' --preview 'echo {}' --preview-window down:3:wrap | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m --header='[kill:process]' --preview 'echo {}' --preview-window down:3:wrap | awk '{print $2}')
    fi

    if [ -n "$pid" ]; then
        echo "Killing processes with PID: $pid"
        echo "$pid" | xargs kill "-$signal"
    else
        echo "No process selected."
    fi
}
