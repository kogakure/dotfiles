# Tool init hooks. See shell/README.md for the syntax.
#
# Emitted to generated/hooks.bash, generated/hooks.zsh and
# config/fish/conf.d/30-hooks.fish, each wrapped in a single interactive guard.
#
# These seven were written three times, in three files, with three different
# `command -v` idioms — `>/dev/null 2>&1` in bashrc, `&>/dev/null` in zshrc
# (except `wt`, which used the bash form), and `type -q` for mise in config.fish.
# One spec, one idiom.
#
# Two files kept separate for bash and zsh rather than one POSIX hooks.sh: the
# init commands genuinely differ (`fzf --bash` vs `source <(fzf --zsh)`,
# `mise activate bash` vs `zsh`), so a shared file would have to detect the
# shell in order to say the same thing twice.

# mise first, so the `command -v` guards below can see mise-managed tools.
# The shims are on PATH already (shell/path.spec) — this is the shell
# integration on top: env switching on `cd`, and `mise use` taking effect in the
# running shell.
tool mise
guard @cmd:mise
bash eval "$(mise activate bash)"
zsh eval "$(mise activate zsh)"
fish mise activate fish | source

tool gh
guard @cmd:gh
bash eval "$(gh completion -s bash)"
zsh eval "$(gh completion -s zsh)"
fish gh completion -s fish | source

tool jj
guard @cmd:jj
bash eval "$(jj util completion bash)"
zsh eval "$(jj util completion zsh)"
fish jj util completion fish | source

tool fzf
guard @cmd:fzf
bash eval "$(fzf --bash)"
zsh source <(fzf --zsh)
fish fzf --fish | source

tool direnv
guard @cmd:direnv
bash eval "$(direnv hook bash)"
zsh eval "$(direnv hook zsh)"
fish direnv hook fish | source

tool zoxide
guard @cmd:zoxide
bash eval "$(zoxide init bash)"
zsh eval "$(zoxide init zsh)"
fish zoxide init fish | source

tool atuin
guard @cmd:atuin
bash eval "$(atuin init bash)"
zsh eval "$(atuin init zsh)"
fish atuin init fish | source

# `command wt` rather than `wt`: worktrunk may also be a shell function once
# this has run, and re-initialising from the function would recurse.
tool worktrunk
guard @cmd:wt
bash eval "$(command wt config shell init bash)"
zsh eval "$(command wt config shell init zsh)"
fish command wt config shell init fish | source

# Last, so the prompt wraps everything the hooks above installed.
#
# bashrc used to follow `starship init bash` with a one-shot
# PS1="$(/opt/homebrew/bin/starship prompt)" — which overwrote the dynamic
# prompt starship had just installed with a single frozen render, and hardcoded
# an Apple Silicon path while doing it. Dropped.
tool starship
guard @cmd:starship
bash eval "$(starship init bash)"
zsh eval "$(starship init zsh)"
fish starship init fish | source
