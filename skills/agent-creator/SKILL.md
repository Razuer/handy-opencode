---
name: agent-creator
description: Create and configure OpenCode agents using the native OpenCode agent format (markdown files with YAML frontmatter). Use this skill whenever the user mentions creating, configuring, or editing agents, wants to set up subagents or primary agents, talks about agent delegation or orchestration, or asks about the OpenCode agent system. Also use when the user mentions @mention agents, agent-switching, Tab to switch agents, or wants specialized AI assistants for their project. Avoid using for general coding tasks unless the user explicitly asks about the agent system.
---

# Agent Creator

Create OpenCode agents that work well — the right type, the right permissions, the right prompt, the right model.

OpenCode agents are configured in two formats: JSON (in `opencode.json`) and Markdown (in `.opencode/agents/` or `~/.config/opencode/agents/`). This skill guides you through making great agents in the OpenCode format.

Consult the reference at `references/opencode-agent-format.md` when you need field-level details, advanced options, or examples not covered here.

## Start Here: What Kind of Agent?

Before writing anything, figure out what the user needs by asking these questions (or inferring from context):

1. **What task will this agent handle?** The more specific, the better. "Code review" is vague; "Review PRs for security vulnerabilities in Express.js APIs" is specific enough to create a useful agent.

2. **Primary or subagent?**
   - **Primary** (`mode: "primary"`): The user selects this agent with Tab and talks to it directly. Good for distinct workflows (e.g., a "planning" agent that never edits files, a "pair programming" agent).
   - **Subagent** (`mode: "subagent"`): Other agents delegate work to it via the Task tool or users invoke it with `@name`. Good for focused, automatable tasks (e.g., a "test writer" that other agents can spin up, a "security scanner" that runs in the background).
   - **Both** (`mode: "all"`): Available both in the Tab selector and via `@mention`/Task delegation. This is the default if `mode` is omitted.
   - When in doubt, make it a subagent — they're more composable and can always be promoted to primary later.

3. **What should it be allowed to do?** This determines permissions. Ask yourself: "What's the minimum set of tools this agent needs to accomplish its task?" Restrict everything else. See the Permission Decision Guide below.

4. **How creative should it be?** Analysis, debugging, and security work want temperature 0-0.1. General development: 0.3-0.5. Writing and brainstorming: 0.6-0.8.

5. **Where should this agent live?** Project-level (`.opencode/agents/`) for project-specific agents that should be checked into version control. User-level (`~/.config/opencode/agents/`) for personal agents useful across all projects.

## Permission Decision Guide

Permissions are the most important and most commonly misconfigured part of an agent. Here's how to decide:

**The principle**: Give the agent exactly what it needs, nothing more. An agent that can edit files but shouldn't is dangerous. An agent that can't edit files but should is frustrating.

### Available tools you can control

See `references/opencode-agent-format.md` for the full tools table. The most commonly configured tools are: `read`, `edit`, `glob`, `grep`, `list`, `bash`, `task`, `webfetch`, `websearch`, `codesearch`, `lsp`, `todowrite`, `question`, `external_directory`, `skill`, and `doom_loop`.

Tools that support command-level rules (`bash`, `task`, `lsp`, `external_directory`, `skill`) accept an object with glob patterns instead of a simple `"allow"`/`"deny"`/`"ask"`. Put broader patterns first and specific overrides after — the **last matching rule wins**:

```yaml
permission:
  bash:
    "*": "ask"
    "git diff*": "allow"
    "git log*": "allow"
    "npm test*": "allow"
  task:
    "*": "deny"
    "researcher": "allow"
    "tester-*": "ask"
```

### Quick permission patterns

| Question | Permission |
|----------|-----------|
| Does it need to modify files? | If yes → `edit: "allow"` or `"ask"`. If no → `edit: "deny"` |
| Does it need to run commands? | If yes → `bash: "allow"` or configure specific commands. If no → `bash: "deny"` |
| Does it need to fetch web content? | If yes → `webfetch: "allow"`. If no → `webfetch: "deny"` |
| Does it need to call other agents? | If yes → `task: "allow"` (or restrict which ones). If no → `task: "deny"` |

**Use `"ask"` when you want the user to approve actions.** This is great for agents that should show what they'd do before doing it (review agents, planning agents) or for agents where you want safety rails (debugging agents that might run destructive commands).

**For subagents that other agents delegate to**, think about what the delegating agent expects. If a build agent delegates to a test-writer, the test-writer needs edit access to test files but probably shouldn't be running arbitrary bash commands.

## Nested Delegation: Agents Calling Agents

Subagents can spawn their own subagents, creating multi-level hierarchies. Three controls govern this:

- **`task_budget`** (per-agent): How many times this agent can invoke the `task` tool. Caps breadth.
- **`level_limit`** (global, in top-level config): Max depth of the session tree. Caps depth. Default is 5.
- **`permission.task`** (per-agent): Which subagents this agent can spawn, using glob patterns.

**Default to leaving `task_budget` and `steps` unset.** Caps cause hallucinated conclusions from thin evidence — especially for planners, researchers, architects, and debuggers, whose whole job is iterative context-gathering. Set caps only for bounded work (formatters, fixers, leaf specialists). Use `permission.task` — not `task_budget` — as the safety lever.

See `references/opencode-agent-format.md` for full details, configuration examples, session persistence (reusing `task_id`), and the orchestrator pattern.

## Writing the System Prompt

The system prompt is the heart of an agent. A good prompt makes the difference between an agent that's genuinely useful and one that's just an LLM with a label.

### Structure

Order your prompt from most to least important — LLMs pay more attention to the beginning:

1. **Identity**: Who this agent is (1-2 sentences)
2. **Core behavior**: What it does and how (the main instructions)
3. **Approach**: Step-by-step process or decision framework
4. **Constraints**: What not to do, edge cases, failures to watch for
5. **Output format**: How to present results (only if non-obvious)

### What makes prompts work

**Explain why, not just what.** Instead of "Always check for SQL injection," write "SQL injection is the #1 vulnerability because user input is often concatenated directly into queries — always parameterize or escape."

**Use concrete examples in instructions**, not abstract rules. Instead of "Format your output clearly," show the format:

```
For each finding:
1. File and line number
2. Severity (Critical/High/Medium/Low)
3. What's wrong (one sentence)
4. How to fix it (code example)
```

**Set scope boundaries.** Tell the agent what it should NOT do: "Do not modify files outside the test directory" or "Do not suggest architectural changes — focus on line-level issues only."

**Match specificity to purpose.** A security auditor needs specific vulnerability classes to check. A general-purpose coder needs flexibility. Over-constraining a general agent or under-constraining a specialist both fail.

**Temperature matters.** A prompt that says "be creative" with temperature 0 won't be creative no matter what. A prompt that says "be precise" with temperature 0.8 will hallucinate precision. Match the prompt's intent to the temperature setting.

### Anti-patterns to avoid

- **Wall of MUST/NEVER/ALWAYS**: These are red flags that the prompt isn't well-designed. If you need that many hard rules, the instructions are probably contradictory. Replace with explanations of why something matters.
- **Role-playing without substance**: "You are an expert developer" is redundant — just give the instructions an expert would need.
- **Vague instructions**: "Write good code" is not actionable. "Write code that passes the existing test suite and follows the patterns in the adjacent files" is.
- **Every possible edge case**: Cover the common cases well and trust the model to handle unusual ones. A 50-item checklist means nothing will get attention.

## Choosing a Model

**Always run `opencode models` first** to see which models are available (with their full `provider/model-id` names). Choosing a model the user doesn't have access to will break the agent.

General guidance by use case:

| Use Case | Kind of Model | Why |
|----------|---------------|-----|
| Analysis, planning, security audit | Most capable available | Complex reasoning needs the strongest model |
| General code tasks, debugging | Balanced speed/quality | Good enough for most tasks, faster responses |
| Fast lookups, quick edits | Smallest/fastest available | Cheap and fast for simple work |
| Frontend/UI work | Models with visual understanding | Better at interpreting screenshots and UI layouts |

If you don't specify a model, primary agents use whatever the user has selected in the UI, and subagents inherit from the agent that called them. This is often the right default — only override when the agent specifically needs a different model.

**Extended thinking** is valuable for complex reasoning tasks (architecture, debugging, security). Add it for agents that need to think deeply:

```yaml
thinking:
  type: "enabled"
  budgetTokens: 32000
```

## Where to Put Agent Files

### Markdown agents (recommended for most cases)

Create `.md` files with YAML frontmatter:

- **Project agents**: `.opencode/agents/your-agent.md` — version-controlled, shared with the team
- **User agents**: `~/.config/opencode/agents/your-agent.md` — personal, available everywhere

The filename becomes the agent name. `security-auditor.md` → agent name `security-auditor`. The `description` field in the frontmatter is **required** — it's shown in the UI and used by other agents to decide when to delegate work.

### JSON configuration

Add to `opencode.json` under the `"agent"` key. Better for:
- Overriding built-in agents (like changing `build`'s model)
- Simple agents where the prompt is short
- When you want all configuration in one place

### Using external prompt files

For long prompts, keep them in a separate file:

```json
"prompt": "{file:./prompts/my-agent-prompt.txt}"
```

The path is relative to the config file location. This is cleaner than embedding large prompts in JSON.

## Creating the Agent Files

Once you've gathered the requirements from the user (or inferred them from context), create the agent file. Here's the workflow:

1. Determine agent name, mode, and where it lives (project vs user)
2. Choose permissions based on the Permission Decision Guide above
3. Write the system prompt following the structure in "Writing the System Prompt"
4. Select appropriate model and temperature
5. Leave `steps` and `task_budget` unset by default. Cap only bounded work (formatters, fixers) — never exploratory agents.
6. Create the file in the right location
7. Tell the user how to test it (switch to it with Tab for primary, `@name` for subagent)

After creating the agent, suggest the user test it by:
- For primary agents: Press Tab to switch to the agent, then give it a task
- For subagents: Type `@agent-name your task here` in the chat

## Iterating on Agents

Agent creation is iterative. After the user tests the agent, they may want to adjust:

- **The prompt**: Most common iteration. Add specificity where the agent goes wrong, remove constraints that are too tight.
- **Permissions**: If the agent keeps asking for approval it doesn't need, or does things it shouldn't.
- **Model**: If the agent is too slow, too expensive, or not capable enough for the task.
- **Temperature**: If outputs are too random or too rigid.
- **Steps / task_budget**: Tune both directions. Hallucinating or stopping mid-investigation means the cap is too tight — raise or remove it. Burning cost on bounded work means add one. Default unset.