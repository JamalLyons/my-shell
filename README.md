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
bash ./setup
```

This will:
- Install Fish shell (via Homebrew)
- Install Fisher plugin manager
- Install nvm.fish (Node version manager)
- Install Node.js v25.1.0
- Install pnpm (via Corepack)
- Install Fisher plugins (nvm.fish, done, bass, tide)
- Set Fish as your default shell
- Configure your Fish environment with all custom functions and aliases

### Manual Setup

1. Copy the config files to your Fish directory:
   ```bash
   cp fish/config.fish ~/.config/fish/config.fish
   cp fish/functions/* ~/.config/fish/functions/
   cp fish/conf.d/nvm-auto-setup.fish ~/.config/fish/conf.d/
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

4. Install Node.js v25.1.0:
   ```bash
   nvm install v25.1.0
   nvm use v25.1.0
   nvm use default
   ```

## Features

### Custom Commands

- `reload` - Reload Fish configuration
- `editfish` - Open Fish config in editor
- `helpme` - Show all custom commands
- `mkcd <dir>` - Create directory and cd into it
- `extract <file>` - Extract various archive formats
- `ff <name>` - Find files by name
- `fd <name>` - Find directories by name
- `duh` - Show disk usage of current directory
- `serve [port]` - Start HTTP server (default: 8000)
- `note [text]` - Quick note taking
- `git-cred-clear` - Clear GitHub credentials from keychain
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
- `gd` → `git diff`
- `gl` → `git log --oneline --graph --decorate --all`

### Aliases

- `ll`, `la`, `l` - Enhanced ls commands
- `..`, `...`, `....` - Quick directory navigation
- `gs`, `ga`, `gc`, `gp`, `gl`, `gd`, `gb`, `gco`, `gst`, `gsp` - Git shortcuts
- `showfiles` / `hidefiles` - Toggle hidden files in Finder
- `cleanup` - Remove .DS_Store files
- `ports` - Show listening ports
- `myip` - Show public IP
- `weather` - Show weather
- `beep` - System beep sound

## File Structure

```
my-shell/
├── fish/
│   ├── config.fish          # Main Fish configuration
│   ├── init-shell           # Setup script (executable)
│   ├── functions/
│   │   ├── reload.fish      # Reload config function
│   │   ├── editfish.fish    # Edit config function
│   │   ├── mkcd.fish        # Create and cd function
│   │   ├── extract.fish     # Extract archives function
│   │   ├── ff.fish          # Find files function
│   │   ├── fd.fish          # Find directories function
│   │   ├── grep.fish        # Colored grep function
│   │   ├── duh.fish         # Disk usage function
│   │   ├── serve.fish       # HTTP server function
│   │   ├── note.fish        # Note taking function
│   │   ├── git-cred-clear.fish    # Clear git credentials
│   │   ├── git-cred-update.fish   # Update git credentials
│   │   ├── git-cred-view.fish     # View git credentials
│   │   └── helpme.fish      # Help function
│   └── conf.d/
│       └── nvm-auto-setup.fish    # Auto-install Node.js v25.1.0
├── .gitignore
└── README.md
```

## Requirements

- macOS
- Homebrew (for installing Fish shell)
- Git

## Node.js Version

The setup script installs and configures **Node.js v25.1.0** by default. This version is automatically activated on shell startup via the `nvm-auto-setup.fish` configuration file.

To use a different version:
```bash
nvm install <version>
nvm use <version>
nvm use default
```

## License

Apache-2.0
