# agent-tools

A collection of CLI tools for AI-assisted development workflows.

## Repository
- **Remote:** https://github.com/ksirrah13/agent-tools
- **Owner:** ksirrah13
- Push changes to `origin main` (ksirrah13/agent-tools)

## Structure
Each tool lives in its own subdirectory:
- `csession/` - Claude Code session manager (worktrees, tmux, per-session state)

## Conventions
- Each tool directory should contain its own README.md and install.sh
- Install scripts should use `curl` from the public GitHub raw URL, not `gh api`
- Raw URL base: `https://raw.githubusercontent.com/ksirrah13/agent-tools/main/`
- Keep tools self-contained — no cross-dependencies between tool directories

## Commits
- Commit messages should be concise and describe the change
- Push to `main` branch on ksirrah13/agent-tools
