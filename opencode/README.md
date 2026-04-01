# OpenCode

## Install

```bash
curl -fsSL https://opencode.ai/install | bash
opencode auth login
```

## Keybind Setup

To change OpenCode's command palette shortcut from `Ctrl+P` to `Ctrl+O` and prevent conflicts with VS Code's Quick Open, create a config file at `~/.opencode/opencode.json` with the following keybinds.

```bash
mkdir -p ~/.opencode && cat > ~/.opencode/opencode.json << 'EOF'
{
  "keybinds": {
    "command_list": "ctrl+o"
  }
}
EOF
```

### Verify

```bash
cat ~/.opencode/opencode.json
```

Restart OpenCode for changes to take effect.
