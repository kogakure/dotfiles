# Wrapper that picks the gh account matching the repository owner.
#
# The gh-token hook in shell/hooks.spec exports GITHUB_TOKEN so mise and other
# GitHub-aware tools get the authenticated API rate limit instead of 60
# requests/hour per IP. (It lived in config.fish until SI-84 moved the shell
# config into shell/*.spec; the export was dropped in that move and restored
# once an anonymous 60/hour ran out mid-`mise upgrade`.) But gh reads
# GITHUB_TOKEN at a *higher* precedence than its own keyring, so that export
# pins gh to whichever account was active when the shell started and makes
# `gh auth switch` a no-op.
#
# The failure mode is nasty because it is asymmetric: on a repo the pinned
# account cannot push to, reads keep working and only writes fail, with
# "must be a collaborator". Nothing looks broken until you try to open a PR.
#
# So: hide the variable from gh, and hand it the token of the logged-in account
# whose login matches the repository owner (kogakure/* -> the kogakure
# account). Everything else on the system still sees GITHUB_TOKEN unchanged --
# mise, and Homebrew, which shells out to the gh *binary* and so never sees
# this function at all.

function __gh_repo_owner --description "GitHub owner for the current repo, or from --repo/GH_REPO"
    # An explicit --repo/-R wins, exactly as it does for gh itself.
    set -l want_repo 0
    for arg in $argv
        if test $want_repo -eq 1
            set -l m (string match -r '^([^/]+)/' -- $arg)
            test (count $m) -ge 2; and echo $m[2]
            return
        end
        switch $arg
            case -R --repo
                set want_repo 1
            case '--repo=*'
                set -l m (string match -r '^--repo=([^/]+)/' -- $arg)
                test (count $m) -ge 2; and echo $m[2]
                return
        end
    end

    if set -q GH_REPO; and test -n "$GH_REPO"
        set -l m (string match -r '^([^/]+)/' -- $GH_REPO)
        test (count $m) -ge 2; and echo $m[2]
        return
    end

    # Otherwise the origin remote of the repo we are standing in. Read straight
    # from git config: no network, and it works in a bare or detached checkout.
    set -l url (command git config --get remote.origin.url 2>/dev/null)
    test -n "$url"; or return
    set -l m (string match -r '^(?:[^@]+@[^:]+:|ssh://[^/]+/|https?://[^/]+/)([^/]+)/' -- $url)
    test (count $m) -ge 2; and echo $m[2]
end

function gh --wraps gh --description "gh, with the account picked per repository owner"
    set -l owner (__gh_repo_owner $argv)

    if test -n "$owner"
        # Cache the owner -> token lookup for the life of the shell; each miss
        # costs a ~75ms `gh auth token` subprocess. Deliberately `set -g`, not
        # `set -gx`: the token stays in this shell and is never exported into
        # the environment of unrelated child processes.
        set -l key __gh_token_(string replace -ra '[^A-Za-z0-9]' _ -- $owner)
        if not set -q $key
            set -g $key (command env -u GITHUB_TOKEN -u GH_TOKEN gh auth token --user $owner 2>/dev/null)
        end

        if test -n "$$key"
            command env -u GITHUB_TOKEN GH_TOKEN=$$key gh $argv
            return $status
        end
    end

    # No account matches this owner (the common case at work, where the org
    # name and the account login differ): fall back to gh's own keyring, which
    # is what `gh auth switch` controls.
    command env -u GITHUB_TOKEN -u GH_TOKEN gh $argv
end
