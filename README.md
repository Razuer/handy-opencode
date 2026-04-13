# handy-opencode

Repository of [OpenCode](https://opencode.ai) skills and agents for a plan-first, execution-oriented workflow.

## Workflow

This setup separates planning from implementation so repository analysis, code changes, and review can happen with clear boundaries.

### Planning

`athena` is the planning agent. It inspects the repository, resolves ambiguity, and produces a concrete implementation plan instead of making code changes directly.

For larger or cross-cutting requests, Athena delegates repository discovery to `athena-explore`. That subagent stays read-only and returns the exact files, symbols, implementation order, risks, and verification signals needed to write a plan that is specific enough for implementation without guesswork.

The output of this phase is a repository-grounded markdown plan that can be handed off to implementation.

### Execution

`hermes` is the implementation orchestrator. It takes an approved plan, breaks the work into dependency-ordered workstreams, and runs independent work in parallel where the repository allows it.

Hermes uses three specialized subagents:

- `hermes-explore` for read-only implementation scouting, dependency mapping, and verification signals before code changes begin
- `hermes-build` for focused, scoped implementation workstreams
- `hermes-review` for independent review of completed or integrated work, with emphasis on correctness, regression risk, and missing verification

Hermes remains responsible for integrating results, sending follow-up fixes back through the same workstream when needed, and running the final verification needed to finish the change cleanly.

### End-To-End Flow

1. `athena` creates the implementation plan.
2. `athena-explore` supports planning with read-only repository analysis.
3. `hermes` turns the plan into parallelizable workstreams.
4. `hermes-build` implements those workstreams, with `hermes-explore` filling context gaps where needed.
5. `hermes-review` performs independent review on risky or integrated changes.
6. `hermes` resolves remaining issues, verifies the result, and closes the work.

## Installation

Use the installer to choose what to add to your OpenCode config:

```bash
./install.sh
```

The installer runs interactively by default and lets you install:

- skills only
- agents only
- both skills and agents

It creates symlinks inside `~/.config/opencode/` so updates in this repository are reflected immediately.

For non-interactive usage:

```bash
./install.sh --skills
./install.sh --agents
./install.sh --all
./install.sh --all --force
```

You can override the target config directory with `OPENCODE_DIR` if needed:

```bash
OPENCODE_DIR=/path/to/opencode ./install.sh --all
```
