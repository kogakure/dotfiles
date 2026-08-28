# Tool init hooks. See shell/README.md for the syntax.
#
# Emitted to generated/hooks.bash, generated/hooks.zsh and
# generated/hooks.fish, each wrapped in a single interactive guard. The fish one
# is sourced from the bottom of config/fish/config.fish rather than living in
# conf.d/, so that zoxide's `z` wins over the vendored jethrokuan/z plugin —
# see docs/environment.md.
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

# Reuse gh's token so GitHub-aware tools — mise's github, aqua and ubi backends
# above all — get the authenticated 5000 req/hour instead of 60 per IP.
#
# A separate block from the completions above, not extra lines in it: parse_hooks
# assigns HOOK_BASH[i] rather than appending, so a second `bash` line in one
# block silently replaces the first.
#
# `command env -u …` rather than plain `gh` for two reasons. It must resolve to
# the keyring's active account deterministically — a bare `gh auth token` would
# echo back whatever GITHUB_TOKEN the shell already had — and in fish `gh` is the
# wrapper function in config/fish/functions/gh.fish, which picks an account from
# the cwd; `env` execs the binary and sidesteps both.
#
# Exported only when non-empty. An empty GITHUB_TOKEN is worse than an absent
# one: tools that merely test for the variable send an empty Authorization
# header and get a 401 instead of falling back to anonymous. On a fresh machine
# gh is installed long before anyone runs `gh auth login`, so this is the normal
# state during provisioning, not an edge case.
#
# One `&&` list rather than three statements separated by `;`, which would read
# better: a hook line is emitted verbatim and shfmt splits `a; b` onto separate
# lines, so the readable form makes `shfmt` and `drift` each demand what the
# other rejects. An assignment carries the exit status of its command
# substitution, so a failing `gh auth token` short-circuits the chain and the
# `[ -n … ]` catches a success that printed nothing. The fish line keeps its
# semicolons because shfmt does not read fish.
#
# This is also why the export cannot simply move to env.spec, which emits the
# shfmt-clean `X="$(cmd)"` / `export X` pair: a spec line there takes one guard,
# and @interactive would drop @cmd:gh and export the empty string above.
#
# This lived in config.fish until SI-84 retired the hand-written copy. It sat
# inside the `if command -v gh` block next to the completions, the spec has no
# file for completions, and so the export was dropped with them and never
# re-emitted. Nothing failed until an anonymous 60/hour ran out under
# `mise upgrade --bump`.
tool gh-token
guard @cmd:gh
bash __dl_gh_token="$(command env -u GITHUB_TOKEN -u GH_TOKEN gh auth token 2>/dev/null)" && [ -n "$__dl_gh_token" ] && export GITHUB_TOKEN="$__dl_gh_token"
zsh __dl_gh_token="$(command env -u GITHUB_TOKEN -u GH_TOKEN gh auth token 2>/dev/null)" && [ -n "$__dl_gh_token" ] && export GITHUB_TOKEN="$__dl_gh_token"
fish set -l __dl_gh_token (command env -u GITHUB_TOKEN -u GH_TOKEN gh auth token 2>/dev/null); test -n "$__dl_gh_token"; and set -gx GITHUB_TOKEN $__dl_gh_token

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
