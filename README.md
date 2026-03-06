# csession - Claude Code Session Manager

Manage multiple isolated Claude Code sessions with git worktrees, tmux, and per-session state.

## Install

Requires `gh` CLI authenticated with access to `DataDog/experimental`.

```bash
gh api repos/DataDog/experimental/contents/users/kyle.harris/csession/install.sh --jq '.content' | base64 -d | bash
```

Or install to a custom directory:

```bash
CSESSION_INSTALL_DIR=~/bin gh api repos/DataDog/experimental/contents/users/kyle.harris/csession/install.sh --jq '.content' | base64 -d | bash
```

## Quick Start

```bash
# Create a session (worktree + tmux + Claude)
csession new AWSCORE-270 --repo dd-go

# Detach with Ctrl-b d, reattach later
csession attach AWSCORE-270

# See all sessions
csession list

# Clean up
csession destroy AWSCORE-270
```

## Commands

| Command | Description |
|---|---|
| `csession new <id> --repo <repo>` | Create session with worktree + tmux |
| `csession attach <id>` | Reattach to tmux session |
| `csession resume <id>` | Resume last Claude conversation |
| `csession list` | List all sessions |
| `csession info <id>` | Detailed session info |
| `csession window <id> <name>` | Add a sub-thread tmux window |
| `csession send <id> <message>` | Send input to running session |
| `csession watch <id>` | Stream session output (read-only) |
| `csession checkpoint <id>` | Save progress, optionally restart |
| `csession clone <id> <new-id>` | Fork a session |
| `csession run <id> --prompt "..."` | Run Claude headless |
| `csession batch <file.yaml>` | Launch multiple sessions |
| `csession dashboard` | Live overview of all sessions |
| `csession destroy <id>` | Clean up session |
| `csession template list` | List templates |
| `csession setup` | Reconfigure |

## Templates

```bash
csession template init   # Create defaults
csession template list   # See available templates

csession new task --repo dd-go --template autonomous   # Auto-commit, no questions
csession new task --repo dd-go --template research     # Read-only, notes only
csession new task --repo dd-go --template safe         # No shell access
csession new task --repo dd-go --template investigate  # Read + tests only
csession new task --repo dd-go --template fullsend     # Full autonomy
```

## Configuration

Config lives at `~/.csession.conf`. Run `csession setup` to configure interactively.

```bash
CSESSION_REPOS_ROOT="$HOME/go/src/github.com/DataDog"
CSESSION_WORKSPACES_DIR="$HOME/workspaces"
CSESSION_BRANCH_PREFIX="your.name"
CSESSION_SESSIONS_DIR="$HOME/.claude-sessions"
```
