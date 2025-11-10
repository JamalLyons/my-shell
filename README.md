# my-shell

Fish shell configuration and setup scripts for macOS.

## What's Included

- **Fish Shell Configuration** - Custom aliases, functions, and settings
- **Setup Script** - Automated installation script for Fish shell, nvm, pnpm, and plugins
- **Custom Functions** - Helper functions for git, development, and system management

## Quick Start

### Automated Setup

Run the setup script to install everything:

```bash
bash fish/init-shell
```

This will:
- Install Fish shell (via Homebrew)
- Install Fisher plugin manager
- Install nvm.fish (Node version manager)
- Install latest Node.js
- Install pnpm (via Corepack)
- Install Fisher plugins (nvm.fish, done, bass, tide)
- Set Fish as your default shell
- Configure your Fish environment

### Manual Setup

1. Copy the config files to your Fish directory:
   ```bash
   cp fish/config.fish ~/.config/fish/config.fish
   cp fish/functions/* ~/.config/fish/functions/
   ```

2. Install Fisher:
   ```bash
   curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
   ```

3. Install plugins:
   ```bash
   fisher install jorgebucaran/nvm.fish
   fisher install franciscolourenco/done
   fisher install edc/bass
   fisher install IlanCosman/tide@v6
   ```

## Features

### Custom Commands

- `reload` - Reload Fish configuration
- `editfish` - Open Fish config in editor
- `helpme` - Show all custom commands
- `mkcd <dir>` - Create directory and cd into it
- `extract <file>` - Extract various archive formats
- `serve [port]` - Start HTTP server
- `note [text]` - Quick note taking
- `git-cred-clear` - Clear GitHub credentials
- `git-cred-update <user> <token>` - Update GitHub credentials
- `git-cred-view` - View GitHub username

### Git Abbreviations

Type these and press space to auto-expand:
- `gst` → `git status`
- `gco` → `git checkout`
- `gaa` → `git add --all`
- `gcm` → `git commit -m`
- `gps` → `git push`
- `gpl` → `git pull`

### Aliases

- `ll`, `la`, `l` - Enhanced ls commands
- `..`, `...`, `....` - Quick directory navigation
- `gs`, `ga`, `gc`, `gp` - Git shortcuts
- `ports` - Show listening ports
- `myip` - Show public IP
- `weather` - Show weather

## File Structure

```
my-shell/
├── fish/
│   ├── config.fish          # Main Fish configuration
│   ├── init-shell           # Setup script
│   └── functions/
│       ├── reload.fish      # Reload config function
│       └── editfish.fish    # Edit config function
├── .gitignore
└── README.md
```

## Requirements

- macOS
- Homebrew (for installing Fish shell)
- Git

## License

Apache-2.0
