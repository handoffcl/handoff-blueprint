#!/bin/bash
# Install Handoff Blueprint commands into the user's global agent directory.
# Works with the Handoff VS Code extension (~/.handoff/commands/) and any
# AI agent that reads commands from there.

echo "Installing Handoff Blueprint..."
mkdir -p ~/.handoff/commands
cp commands/*.md ~/.handoff/commands/
echo "✓ Done. Use /bootstrap-app, /architecture-review, /code-quality, /security-review"
echo "  in any session of your AI agent that reads ~/.handoff/commands/."
