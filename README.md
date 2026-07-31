# my-shell

Brewfile-driven macOS coding environment bootstrap: Fish shell, Tide prompt, fnm (Node), and the CLI/GUI tools you declare in a Brewfile.

**Repo:** [https://github.com/JamalLyons/my-shell](https://github.com/JamalLyons/my-shell)

## Quick start

```bash
bash ./setup.sh
```

Useful flags:

```bash
bash ./setup.sh --dry-run       # preview only
bash ./setup.sh --skip-casks    # formulas only (no GUI apps)
bash ./setup.sh --skip-shell    # keep your current login shell
bash ./setup.sh --skip-xcode    # skip latest Xcode download/install
```

## What it does

1. Installs Homebrew if missing
2. Applies [`Brewfile`](Brewfile) (CLI formulas + casks)
3. Syncs checked-in [`fish/`](fish/) templates into `~/.config/fish` (backs up changed files)
4. Installs Fisher + plugins (Tide, done, bass)
5. Installs **Node.js LTS** via [fnm](https://github.com/Schniz/fnm) and enables **pnpm** via Corepack
6. Installs the **latest Xcode** via [xcodes](https://github.com/XcodesOrg/xcodes) (Apple ID may be required; large download)
7. Optionally sets Fish as your login shell

## Layout

```
my-shell/
├── setup.sh              # Thin orchestrator
├── Brewfile              # Declarative packages + casks
├── lib/
│   ├── log.sh
│   ├── brew.sh
│   ├── fish.sh
│   └── node.sh
├── fish/
│   ├── config.fish
│   ├── fish_plugins
│   ├── conf.d/fnm.fish
│   └── functions/
└── README.md
```

## Adding software

- **CLI / Homebrew apps:** edit `Brewfile`, then re-run `bash ./setup.sh` (or `brew bundle --file=Brewfile`).
- **Fish plugins:** edit `fish/fish_plugins`, then re-run setup (or `fisher update` in Fish).
- **Fish config / functions:** edit files under `fish/`, then re-run setup to sync.

### Local environment variables

Shared config must not contain secrets. Setup creates (once):

```text
~/.config/fish/conf.d/local.fish
```

from the documented empty template [`fish/conf.d/local.fish`](fish/conf.d/local.fish). Later `setup.sh` runs **never overwrite** that file. Put project IDs, tokens, and machine-only paths there (`editenv`), then `reload`.

### GUI apps (casks)

Included today (matched to `/Applications` where a cask exists):

- Ghostty, Zed, Raycast, Ollama, Rectangle, JetBrains Toolbox
- Discord, Lark, Docker Desktop, Brave, Chrome, Spotify, OBS
- GitHub Desktop, Cursor, Claude, DBeaver, Inkscape, MEGAsync
- Steam, Audacity, Cloudflare WARP, eqMac, pgAdmin 4
- Antigravity, Google Gemini, Juicy, Epic Games, Minecraft, Roblox
- Windows App, melonDS

**No Homebrew cask** (install/update manually or via Mac App Store):

- Blackmagic Proxy Generator Lite, Blackmagic RAW, DaVinci Resolve
- VMware Fusion, LockDown Browser, Magic Garden, Developer (WWDC)
- Keynote, Numbers, Pages, Safari, Xcode
- Python 3.13.app (python.org; CLI Python is covered by Brewfile `python`)

Full **Xcode** is installed by `setup.sh` via `xcodes` (not a Homebrew cask). Use `--skip-xcode` to skip.

### Updating packages

In Fish, run `brewup` to refresh Homebrew formulas/casks (and Fisher plugins) — similar to `apt update && apt upgrade` on Linux.

## Node via fnm

This setup uses **fnm**, not nvm / nvm.fish.

- Default: latest **LTS** (`fnm install --lts`)
- Per-project: `.node-version` or `.nvmrc` with `fnm env --use-on-cd`

```fish
fnm list
fnm install lts
fnm use 22
```

If you previously used nvm, `~/.nvm` is left alone. After confirming fnm works you can remove it and `brew uninstall nvm` if present.

## Prompt

Uses [Tide](https://github.com/IlanCosman/tide) (`ilancosman/tide@v6`). Configure with `tide configure`.

## Custom Fish commands

In Fish, run `helpme` for the full list. Highlights:

| Command | Description |
|---------|-------------|
| `helpme` | List custom commands (links to this repo) |
| `brewup` | Update Homebrew formulas, casks, and Fisher |
| `reload` | Reload Fish config |
| `editfish` | Open config in `$EDITOR` |
| `editenv` | Open `~/.config/fish/conf.d/local.fish` in `$EDITOR` |
| `mkcd <dir>` | mkdir + cd |
| `extract <file>` | Unpack common archives |
| `ff` / `fdir` | Find files / directories |
| `ql <file>` | Quick Look |
| `cdf` | cd to frontmost Finder window |
| `flushdns` | Flush macOS DNS cache |
| `path` | Print `$PATH` one entry per line |
| `serve [port]` | Python HTTP server |
| `note [text]` | Quick notes |

Git abbreviations: `gst`, `gco`, `gaa`, `gcm`, `gps`, `gpl`, …

## Requirements

- macOS
- Network access (Homebrew, Fisher, fnm)
- Git (usually via Xcode CLT / Homebrew)

## License

Apache-2.0
