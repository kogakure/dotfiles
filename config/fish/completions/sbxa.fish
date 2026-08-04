# sbx agents, as reported by `sbx run --help`. All but docker-agent and shell
# also have a herdr detection manifest, so the argv0 rename makes them show up
# in herdr's agent list.
complete -c sbxa -n __fish_is_first_arg -f -a claude -d "Claude Code"
complete -c sbxa -n __fish_is_first_arg -f -a codex -d "Codex"
complete -c sbxa -n __fish_is_first_arg -f -a copilot -d "GitHub Copilot"
complete -c sbxa -n __fish_is_first_arg -f -a cursor -d "Cursor"
complete -c sbxa -n __fish_is_first_arg -f -a droid -d "Factory Droid"
complete -c sbxa -n __fish_is_first_arg -f -a gemini -d "Gemini CLI"
complete -c sbxa -n __fish_is_first_arg -f -a kiro -d "Kiro"
complete -c sbxa -n __fish_is_first_arg -f -a opencode -d "OpenCode"
complete -c sbxa -n __fish_is_first_arg -f -a docker-agent -d "Docker agent (no herdr detection)"
complete -c sbxa -n __fish_is_first_arg -f -a shell -d "Plain shell (no herdr detection)"

# Everything after the agent is passed to `sbx run`: workspace paths plus flags.
complete -c sbxa -n "not __fish_is_first_arg" -F
complete -c sbxa -n "not __fish_is_first_arg" -l name -r -d "Name for the sandbox"
complete -c sbxa -n "not __fish_is_first_arg" -l template -s t -r -d "Container image to use"
complete -c sbxa -n "not __fish_is_first_arg" -l profile -r -d "Governance profile"
complete -c sbxa -n "not __fish_is_first_arg" -l clone -d "Run on a private in-container clone of the repo"
complete -c sbxa -n "not __fish_is_first_arg" -l publish -s p -r -d "Publish a sandbox port to the host"
complete -c sbxa -n "not __fish_is_first_arg" -l memory -s m -r -d "Memory limit (e.g. 8g)"
complete -c sbxa -n "not __fish_is_first_arg" -l cpus -r -d "Number of CPUs"
