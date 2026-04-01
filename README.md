# The DevContainer

Reusable dev container setup for VS Code / GitHub Codespaces with Copilot agent mode, MCP servers, and Python/Node tooling.

## What's included

```
.devcontainer/
├── devcontainer.json    # Container config, extensions, Copilot settings
├── Dockerfile           # Python 3.13 + ripgrep + uv
├── postCreate.sh        # Git credentials, Azure CLI (optional)
├── .env.example         # Template for git/Azure DevOps credentials
.vscode/
└── mcp.json             # MCP server configs (WorkIQ, Backlog.md, Azure DevOps)
.env.ado.example         # Template for Azure DevOps MCP PAT
.gitignore               # Ignores .env files, Python/Node artifacts
```

## Quick start

```bash
# 1. Clone this into your project (or use as template)
# 2. Copy the env templates
cp .devcontainer/.env.example .devcontainer/.env
cp .env.ado.example .env.ado

# 3. Edit with your credentials
#    .devcontainer/.env  → git name, email, Azure DevOps PAT
#    .env.ado            → Azure DevOps MCP PAT

# 4. Open in VS Code → "Reopen in Container"
```

## What you get

### Dev Container
- **Python 3.13** with `uv` package manager
- **Node.js LTS** (for npx, frontend tools)
- **Git** + **GitHub CLI** (`gh`)
- **ripgrep** for fast search
- Auto-configured git credentials from `.env`
- Optional Azure CLI install (`INSTALL_AZURE_CLI=true`)

### VS Code Settings
- Format on save
- Bracket pair colorization
- Copilot agent mode enabled (subagents, skills, memory, auto-approve tools)

### Extensions
- Python + Jupyter
- Markdown Mermaid diagrams

### MCP Servers
- **[WorkIQ](https://github.com/datorresb/workiq-mcp-bridge)** — Microsoft WorkIQ via HTTP bridge (runs on Windows host, see below)
- **[Backlog.md](https://github.com/MrLesk/Backlog.md)** — Task management via MCP
- **[Azure DevOps](https://www.npmjs.com/package/@azure-devops/mcp)** — Work items via MCP (requires `.env.ado`)

## Credentials setup

### `.devcontainer/.env`

Controls git identity and optional Azure DevOps repo access:

```env
GIT_USER_NAME=Your Name
GIT_USER_EMAIL=your.email@company.com
AZURE_DEVOPS_USER=your-ado-username    # optional
AZURE_DEVOPS_PAT=your-ado-pat          # optional
INSTALL_AZURE_CLI=false                 # set true if needed
```

### `.env.ado`

Controls the Azure DevOps MCP server:

```env
ADO_ORG=your-azure-devops-org-name
ADO_MCP_AUTH_TOKEN=your-pat-here
```

> **Neither file is committed to git.** Both are in `.gitignore`. Only the `.example` templates are tracked.

### WorkIQ MCP (Windows host)

WorkIQ uses stdio and needs host machine registration — it can't run inside the container. Use the [workiq-mcp-bridge](https://github.com/datorresb/workiq-mcp-bridge) to expose it as HTTP from your Windows host:

```powershell
# On Windows (one-time firewall setup)
.\start-workiq-bridge.ps1 -Firewall

# Start the bridge (leave running)
.\start-workiq-bridge.ps1
```

The devcontainer connects automatically via `http://host.docker.internal:3100/mcp` (already configured in `.vscode/mcp.json`).

## Adding to an existing project

Copy the folders into your repo:

```bash
cp -r .devcontainer/ /path/to/your/project/.devcontainer/
cp -r .vscode/ /path/to/your/project/.vscode/
cp .env.ado.example /path/to/your/project/
cp .gitignore /path/to/your/project/   # or merge with existing
```

Then update `.env.ado` with your Azure DevOps org name and PAT.

## Customization

### Add more MCP servers

Edit `.vscode/mcp.json`. Example adding a local server:

```json
"my-server": {
    "url": "http://host.docker.internal:3100/mcp"
}
```

### Change Python version

Edit `.devcontainer/Dockerfile`:

```dockerfile
ARG VARIANT="3.13"
```

### Add VS Code extensions

Edit `.devcontainer/devcontainer.json` → `customizations.vscode.extensions`.

### Add system packages

Edit `.devcontainer/Dockerfile` → add to the `apt-get install` line.
