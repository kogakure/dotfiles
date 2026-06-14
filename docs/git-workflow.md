# Git Workflow

This repository uses conventional commits. When making changes:

1. Modify configuration files directly
2. Test changes (e.g., reload shell, restart tmux)
3. Commit using conventional commit format
4. Common pattern: User makes changes to configs, then runs backup scripts

## Conventional Commit Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Common types:**

- `feat`: New feature or configuration addition
- `fix`: Bug fix or configuration correction
- `chore`: Routine tasks (backups, updates, maintenance)
- `docs`: Documentation changes
- `refactor`: Code/config restructuring without behavior change
- `style`: Formatting, whitespace changes
- `perf`: Performance improvements

**Examples:**

```
chore: backup homebrew and preferences
feat(nvim): add new telescope extension
fix(fish): correct PATH order for mise shims
docs: update setup instructions
chore: update all plugins and packages
```
