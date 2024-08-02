function update --description "Updating Homebrew, Ruby, Python, Node.js, Neovim, and MacOS"
    sudo -v
    cd ~/.dotfiles

    # Update Nix flake
    nix flake update

    # Add to git
    git add .

    # Rebuild nix-darwin
    darwin-rebuild switch --flake .

    # Update Homebrew
    brew update
    brew outdated
    brew upgrade
    brew cleanup

    # Clean up Nix
    nix-collect-garbage -d

    # Update Neovim
    nvim --headless "+Lazy! sync" +qa
end
