# handy-opencode

My collection of [OpenCode](https://opencode.ai) skills, agents, and configuration.

## Structure

```
skills/           # OpenCode skills
  agent-creator/  # Skill for creating and configuring OpenCode agents
```

## Installation

Copy or symlink the skills into your OpenCode config:

```bash
ln -s $(pwd)/skills/* ~/.config/opencode/skills/
```