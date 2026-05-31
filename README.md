# Homebrew Tap for Trace CLI

Official [Homebrew](https://brew.sh) tap for [Trace](https://buildwithtrace.com) — the AI-powered PCB design CLI.

## Installation

```bash
brew tap buildwithtrace/tap
brew install buildwithtrace
```

## Upgrade

```bash
brew upgrade buildwithtrace
```

## Uninstall

```bash
brew uninstall buildwithtrace
brew untap buildwithtrace/tap
```

## Usage

```bash
buildwithtrace --help
buildwithtrace auth login
buildwithtrace chat        # interactive AI design session
```

> The command is `buildwithtrace`. We don't ship a `trace` binary (it collides with the macOS system `/usr/bin/trace`); add `alias trace=buildwithtrace` yourself if you want a shorter name.

## Requirements

- macOS (Intel or Apple Silicon)
- Python 3.12 (installed automatically by Homebrew)

## Troubleshooting

If you encounter issues, try:

```bash
brew doctor
brew reinstall buildwithtrace
```

For more help, visit [buildwithtrace.com/docs](https://buildwithtrace.com/docs) or open an issue on [GitHub](https://github.com/buildwithtrace/cli/issues).
