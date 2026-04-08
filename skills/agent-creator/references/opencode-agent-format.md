# OpenCode Agent Format Reference

This reference covers the complete OpenCode agent configuration format. Use it when you need details on specific fields or want to explore advanced options.

## Table of Contents

1. [Agent Types](#agent-types)
2. [Configuration Formats](#configuration-formats)
3. [Configuration Options](#configuration-options)
4. [Permission System](#permission-system)
5. [Nested Delegation: Agents Calling Agents](#nested-delegation-agents-calling-agents)
6. [Built-in Agents](#built-in-agents)
7. [Common Patterns](#common-patterns)
8. [Examples](#examples)

---

## Agent Types

### Primary Agents

Primary agents appear in the UI agent selector. The user switches between them with Tab or the `switch_agent` keybind. They handle the main conversation and respect the model selected in the UI.

**When to create a primary agent:**
- The user will directly interact with this agent for extended conversations
- The agent needs its own presence in the agent switcher
- You want a different default behavior but still want the user to pick when to use it

**Key traits:**
- Uses the model the user selects in the UI (unless overridden with `model`)
- Appears in the Tab cycle
- Typically has broad tool access

### Subagents

Subagents are invoked by primary agents via the Task tool, or manually via `@mention`. They don't appear in the agent switcher (unless explicitly mentioned with `@`).

**When to create a subagent:**
- The agent does a specific, well-defined task
- It should be invocable by other agents for delegation
- You want to restrict its capabilities tightly
- It runs in the background or as a focused specialist

**Key traits:**
- Uses the model of the primary agent that invoked it (unless overridden)
- Invoked via `@name` in chat or programmatically via Task tool
- Typically has restricted tool access
- Can be hidden from autocomplete with `hidden: true`

### The `all` mode

Setting `mode: "all"` makes an agent available both as a primary agent and as a subagent. This is useful for agents that need to work both ways.

---

## Configuration Formats

### JSON Configuration

Add agents to your `opencode.json` config file (project root or `~/.config/opencode/`):

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "my-agent": {
      "description": "What this agent does and when to use it",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4",
      "prompt": "You are a specialist in...",
      "temperature": 0.1,
      "permission": {
        "edit": "deny",
        "bash": {
          "*": "ask",
          "git status": "allow",
          "git log*": "allow",
          "grep *": "allow"
        }
      }
    }
  }
}
```

**Agent name**: The key in the `agent` object becomes the agent name (e.g., `my-agent`). Names should be lowercase, use hyphens instead of spaces.

### Markdown Agent Files

Create `.md` files in:
- **Global**: `~/.config/opencode/agents/`
- **Per-project**: `.opencode/agents/`

The filename (without `.md`) becomes the agent name. For example, `security-auditor.md` creates the agent `security-auditor`.

```markdown
---
description: Performs security audits and identifies vulnerabilities
mode: subagent
model: anthropic/claude-sonnet-4
temperature: 0.1
permission:
  edit: deny
  bash:
    "*": ask
    "git diff": allow
    "git log*": allow
  webfetch: deny
---

You are a security expert. Focus on identifying potential security issues.

Look for:
- Input validation vulnerabilities
- Authentication and authorization flaws
- Data exposure risks
- Dependency vulnerabilities
- Configuration security issues

Provide specific, actionable recommendations with code examples where possible.
```

### Prompt External Files

Both JSON and Markdown formats support loading the system prompt from an external file:

```json
{
  "agent": {
    "my-agent": {
      "description": "...",
      "prompt": "{file:./prompts/my-agent-prompt.txt}"
    }
  }
}
```

The path is relative to the config file's location. This is useful for long prompts or prompts you want to version-control separately.

---

## Configuration Options

### description (required)

A brief description of what the agent does. This is shown in the UI and used by other agents to decide when to invoke this subagent.

```json
"description": "Reviews code for best practices and potential issues"
```

Write this so another agent reading it can decide whether to delegate work here. Include what the agent does AND when to use it.

### mode

Controls how the agent can be invoked:

| Value | Behavior |
|-------|----------|
| `"primary"` | Only in agent selector (Tab) |
| `"subagent"` | Only via Task tool or `@mention` |
| `"all"` | Both primary and subagent |

Defaults to `"all"` if not specified.

### model

Override the model for this agent. Format: `provider/model-id`.

```json
"model": "anthropic/claude-sonnet-4"
```

To see which models are available (with their full `provider/model-id` names), run `opencode models`. Always check this before choosing a model so you use one the user actually has access to.

Common provider prefixes: `anthropic`, `openai`, `google`, `opencode`.

For primary agents, the UI-selected model takes precedence unless you explicitly set this. For subagents, they inherit the primary agent's model unless overridden.

### temperature

Controls randomness and creativity (0.0 to 1.0):

| Range | Effect | Best For |
|-------|--------|----------|
| 0.0-0.2 | Very focused, deterministic | Code analysis, planning, security review |
| 0.3-0.5 | Balanced | General development, debugging, general tasks |
| 0.6-1.0 | Creative, varied | Brainstorming, writing, exploration |

Defaults vary by model (typically 0 for most, 0.55 for Qwen).

### steps (formerly maxSteps)

Maximum agentic iterations before the agent must respond with text only.

```json
"steps": 5
```

When the limit is reached, the agent receives a system prompt instructing it to summarize progress and recommend remaining work. Useful for controlling costs on subagents.

### task_budget

How many times this agent can invoke the `task` tool (delegate to subagents) in a single session. This is a horizontal limit per agent.

```json
"task_budget": 10
```

- `0` disables task delegation entirely (equivalent to `task: "deny"`)
- Each `task` invocation decrements the budget, whether it spawns a new subagent or continues an existing one
- The budget belongs to the agent, not the session — a subagent spawned with `task_budget: 5` gets its own 5-call budget independent of its parent

Works in combination with the global `level_limit` (see Nested Delegation section below).

### level_limit (global)

A top-level config option that caps the maximum depth of the session tree. Root session is depth 0, its children depth 1, etc. Default is 5.

```json
{
  "level_limit": 4,
  "agent": { ... }
}
```

When the depth limit is reached, any further `task` calls are blocked. This prevents infinite delegation loops.

### disable

Set to `true` to disable the agent without removing the configuration.

```json
"disable": true
```

### prompt

The system prompt that defines the agent's behavior, expertise, and constraints.

For Markdown agents, this is the content after the YAML frontmatter. For JSON config, it's a string value (or file reference with `{file:./path}`).

See the "Writing Effective Prompts" section of SKILL.md for guidance on crafting good prompts.

### permission

Fine-grained control over what the agent can do. See the Permission System section below.

### hidden

Hide a subagent from the `@` autocomplete menu. The agent can still be invoked programmatically via the Task tool.

```json
"hidden": true
```

Only applies to subagents.

### color

Customize the agent's appearance in the UI. Use a hex color (`#FF5733`) or a theme keyword (`primary`, `secondary`, `accent`, `success`, `warning`, `error`, `info`).

```json
"color": "#10B981"
```

### top_p

Alternative to temperature for controlling response diversity (0.0 to 1.0). Lower values = more focused.

```json
"top_p": 0.9
```

### Additional options (provider-specific)

Any other fields in the agent config are passed through to the provider as model options. This enables provider-specific features:

```json
{
  "agent": {
    "deep-thinker": {
      "description": "Uses high reasoning effort for complex problems",
      "model": "openai/gpt-5",
      "reasoningEffort": "high",
      "textVerbosity": "low"
    }
  }
}
```

For Claude models with extended thinking:
```json
{
  "agent": {
    "deep-analyst": {
      "description": "Deep analysis with extended thinking",
      "model": "anthropic/claude-opus-4",
      "thinking": {
        "type": "enabled",
        "budgetTokens": 32000
      }
    }
  }
}
```

---

## Permission System

Permissions control what actions an agent can take. There are three levels:

| Value | Behavior |
|-------|----------|
| `"allow"` | Always allowed, no prompt |
| `"ask"` | Prompt the user for approval |
| `"deny"` | Blocked entirely |

### All controllable tools

Every tool in OpenCode can be permission-controlled. These are the tools you can set permissions for:

| Tool | What it controls | Supports command-level rules? |
|------|-------------------|-------------------------------|
| `read` | Reading file contents | No |
| `edit` | Editing and writing files | No |
| `glob` | Finding files by pattern | No |
| `grep` | Searching file contents | No |
| `list` | Listing directory contents | No |
| `bash` | Running shell commands | Yes — allow/deny specific commands with glob patterns |
| `task` | Delegating work to subagents | Yes — allow/deny specific agent names with glob patterns |
| `webfetch` | Fetching web content from URLs | No |
| `websearch` | Searching the web | No |
| `codesearch` | Semantic code search | No |
| `lsp` | LSP operations (diagnostics, symbols, references, definitions) | Yes — allow/deny specific LSP operations |
| `todowrite` | Creating and updating todo lists | No |
| `question` | Asking the user questions | No |
| `external_directory` | Accessing files outside the project directory | Yes — allow/deny specific paths |
| `skill` | Loading and using skills | Yes — allow/deny specific skills by name |
| `doom_loop` | Entering interactive loop modes | No |

Tools marked "Yes" for command-level rules accept an object with glob patterns instead of a simple string. The **last matching rule wins**, so put broader patterns first and specific overrides after.

### Basic permission config

```json
"permission": {
  "edit": "deny",
  "bash": "ask",
  "webfetch": "allow"
}
```

### Command-level permissions

For tools that support it, you can use glob patterns to allow or deny specific commands or names:

```json
"permission": {
  "bash": {
    "*": "ask",
    "git status *": "allow",
    "git log*": "allow",
    "git diff*": "allow",
    "npm test*": "allow"
  }
}
```

**Rules are evaluated in order, and the last matching rule wins.** Put broader patterns first and specific overrides after:

```json
"permission": {
  "bash": {
    "*": "ask",
    "git status *": "allow"
  }
}
```

This means: ask for everything, but allow `git status` commands specifically.

### Task permissions

Control which subagents an agent can invoke. This is how you build delegation chains and restrict which specialists an orchestrator can reach:

```json
"permission": {
  "task": {
    "*": "deny",
    "my-specialist-*": "allow",
    "code-reviewer": "ask"
  }
}
```

Users can always invoke any subagent via `@mention`, even if task permissions deny it.

---

## Nested Delegation: Agents Calling Agents

The `task` permission unlocks one of the most powerful patterns in OpenCode: **nested delegation**, where subagents can spawn their own subagents. This creates multi-level agent hierarchies that massively accelerate complex workflows.

### How it works

Three variables control nested delegation:

| Variable | Scope | What it does |
|----------|-------|-------------|
| `task_budget` | Per-agent | Horizontal limit — how many times this agent can invoke the `task` tool in a single session. `0` disables delegation entirely. |
| `level_limit` | Global (top-level config) | Vertical limit — maximum depth of the session tree. Root is depth 0, its children depth 1, etc. Default is 5. Once hit, further task calls are blocked to prevent runaway recursion. |
| `permission.task` | Per-agent | Which subagents this agent is allowed to spawn. Uses standard permission rules (`allow`/`ask`/`deny`) with glob pattern matching on agent names. |

Together, these form a two-dimensional budget: `task_budget` caps breadth (how many subtasks per agent) and `level_limit` caps depth (how deep the delegation chain goes).

### Configuring nested delegation

**JSON (opencode.json):**

```json
{
  "level_limit": 4,
  "agent": {
    "architect": {
      "mode": "subagent",
      "task_budget": 10,
      "permission": {
        "task": {
          "reviewer": "allow",
          "tester-*": "ask"
        }
      }
    },
    "reviewer": {
      "mode": "subagent",
      "task_budget": 2,
      "permission": {
        "task": "allow"
      }
    }
  }
}
```

**Markdown (.opencode/agents/architect.md):**

```yaml
---
description: Architecture planning and delegation
mode: subagent
task_budget: 10
permission:
  task:
    "reviewer": "allow"
    "tester-*": "ask"
---
```

### Session persistence: reusing subagent context

When an agent invokes the `task` tool to spawn a subagent, the response includes a `task_id` (which is the underlying session ID, e.g. `ses_abc123`). To continue working with the same subagent context — keeping its memory of prior work — the parent agent passes this `task_id` back into the next `task` call. Without it, the system creates a fresh subagent session with no memory of previous work, consuming a new slot in the `task_budget`.

This is how multi-turn delegation works: spawn a subagent, get the task_id, then keep delegating to that same session until the work is done. The subagent retains full context across each call.

### Pattern: Orchestrator with specialist chain

A common and effective pattern is an orchestrator that delegates to specialist subagents, which themselves can delegate further:

```
architect (task_budget: 10)
  ├── reviewer (task_budget: 2)
  ├── coder (task_budget: 5)
  │    └── tester (task_budget: 3)
  └── researcher (task_budget: 3)
```

Each level has a budget that limits how many times it can call `task`, and `level_limit` prevents the tree from going too deep. The orchestrator doesn't do the work — it breaks tasks down and routes them to the right specialist.

### Tips for nested delegation

- **Start conservative**: Set `task_budget` low (3-5) and increase if the agent runs out. A `task_budget` of 10 is generous for most workflows.
- **Use `level_limit` to prevent runaway recursion**: The default of 5 is usually fine. Lower it to 3 if you want tighter control.
- **Restrict `permission.task` to specific agents**: Rather than `task: "allow"` (which lets the agent spawn any subagent), limit it to the agents that make sense for its role. A coder shouldn't need to spawn a researcher if it's not supposed to do web lookups.
- **The `task_budget` counts against the delegating agent, not the subagent**: If architect has `task_budget: 10`, it can spawn 10 total subagent sessions. Each subagent has its own independent budget.

---

## Built-in Agents

OpenCode ships with these agents:

| Agent | Mode | Purpose |
|-------|------|---------|
| build | primary | Default full-access dev agent |
| plan | primary | Read-only analysis and planning |
| general | subagent | General-purpose with full tools |
| explore | subagent | Fast read-only codebase search |

You can override built-in agents with the same name in your config. For example, to give `plan` a different model:

```json
{
  "agent": {
    "plan": {
      "model": "anthropic/claude-haiku-4"
    }
  }
}
```

---

## Common Patterns

### Specialist subagent pattern

Create focused subagents that primary agents can delegate to:

```json
{
  "agent": {
    "test-writer": {
      "description": "Writes comprehensive unit and integration tests. Invoke for any task involving writing or improving test coverage.",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4",
      "temperature": 0.1,
      "permission": {
        "edit": "allow",
        "bash": {
          "*": "ask",
          "npm test*": "allow",
          "bun test*": "allow"
        },
        "webfetch": "deny"
      }
    }
  }
}
```

### Orchestrator with restricted subagents

Create a primary agent that delegates to specialized subagents:

```json
{
  "agent": {
    "orchestrator": {
      "description": "Coordinates work across specialized agents for complex multi-step tasks",
      "mode": "primary",
      "model": "anthropic/claude-opus-4",
      "permission": {
        "task": {
          "*": "deny",
          "test-writer": "allow",
          "security-reviewer": "allow",
          "doc-writer": "allow"
        }
      }
    },
    "test-writer": {
      "description": "Writes tests. Read-only except for test files.",
      "mode": "subagent",
      "permission": {
        "edit": "allow"
      }
    },
    "security-reviewer": {
      "description": "Reviews code for security vulnerabilities. Read-only.",
      "mode": "subagent",
      "permission": {
        "edit": "deny",
        "bash": "deny"
      }
    },
    "doc-writer": {
      "description": "Writes documentation and comments.",
      "mode": "subagent",
      "permission": {
        "edit": "allow"
      }
    }
  }
}
```

### Hidden helper pattern

Create internal subagents that are only invoked programmatically:

```json
{
  "agent": {
    "code-formatter": {
      "description": "Formats code according to project style guidelines. Invoked by the build agent for formatting subtasks.",
      "mode": "subagent",
      "hidden": true,
      "steps": 3,
      "permission": {
        "edit": "allow",
        "bash": "allow"
      }
    }
  }
}
```

### Cost-controlled subagent

Limit iterations and use a fast model:

```json
{
  "agent": {
    "quick-researcher": {
      "description": "Fast web research for quick lookups and fact-checking",
      "mode": "subagent",
      "model": "anthropic/claude-haiku-4",
      "steps": 3,
      "temperature": 0,
      "permission": {
        "edit": "deny",
        "bash": "deny",
        "webfetch": "allow",
        "task": "deny"
      }
    }
  }
}
```

### Nested delegation pattern

An orchestrator that delegates to specialists, where some specialists can delegate further. This is where `task_budget` and `permission.task` really shine — they let you create deep agent hierarchies with controlled budgets:

```json
{
  "level_limit": 4,
  "agent": {
    "architect": {
      "description": "Breaks down complex tasks and delegates to specialists. Does not do work directly.",
      "mode": "subagent",
      "task_budget": 10,
      "permission": {
        "edit": "deny",
        "bash": "deny",
        "task": {
          "researcher": "allow",
          "coder": "allow",
          "tester": "allow"
        }
      }
    },
    "researcher": {
      "description": "Searches the web for information and documentation",
      "mode": "subagent",
      "permission": {
        "edit": "deny",
        "bash": "deny",
        "webfetch": "allow",
        "task": "deny"
      }
    },
    "coder": {
      "description": "Writes and edits source code",
      "mode": "subagent",
      "task_budget": 5,
      "permission": {
        "edit": "allow",
        "bash": {
          "*": "ask",
          "git diff*": "allow",
          "git log*": "allow"
        },
        "task": {
          "tester": "allow"
        }
      }
    },
    "tester": {
      "description": "Writes and runs tests to verify correctness",
      "mode": "subagent",
      "permission": {
        "edit": "allow",
        "bash": {
          "*": "ask",
          "npm test*": "allow",
          "bun test*": "allow"
        },
        "task": "deny"
      }
    }
  }
}
```

In this setup:
- `architect` can delegate to 3 agents but cannot edit files or run commands itself
- `coder` can edit files and also delegate test-running to `tester`
- `tester` and `researcher` are leaf agents — they cannot delegate further
- `level_limit: 4` prevents the delegation chain from going more than 4 levels deep

---

## Examples

### Documentation Agent

```markdown
---
description: Writes and maintains project documentation
mode: subagent
permission:
  edit: allow
  bash: deny
  webfetch: deny
---

You are a technical writer. Create clear, comprehensive documentation.

Focus on:
- Clear explanations with examples
- Proper structure (headings, lists, code blocks)
- API documentation with parameter descriptions
- User-friendly language avoiding jargon where possible

When writing documentation:
1. First understand the code or feature by reading relevant files
2. Identify the audience (developers, end users, both)
3. Structure content logically with a clear progression
4. Include runnable code examples
5. Cross-reference related documentation
```

### Security Auditor

```markdown
---
description: Performs security audits and identifies vulnerabilities. Use when reviewing code for security issues, checking for OWASP Top 10, auditing authentication, or assessing attack surfaces.
mode: subagent
model: anthropic/claude-opus-4
temperature: 0
permission:
  edit: deny
  bash:
    "*": ask
    "git log*": allow
    "git diff*": allow
  webfetch: deny
  task: deny
---

You are a security expert conducting a thorough audit. Focus on identifying potential security issues.

Look for:
- Input validation vulnerabilities (SQL injection, XSS, command injection)
- Authentication and authorization flaws
- Data exposure risks (sensitive data in logs, error messages, URLs)
- Dependency vulnerabilities
- Configuration security issues (default credentials, open CORS, missing TLS)
- Race conditions and timing attacks
- Insecure cryptography or key management

For each finding:
1. Describe the vulnerability clearly
2. Rate severity (Critical / High / Medium / Low)
3. Explain the potential impact
4. Provide a specific remediation with code examples

Be thorough but practical. Focus on real attack vectors, not theoretical concerns.
```

### Debug Agent

```markdown
---
description: Investigates bugs and errors by tracing code paths, checking logs, and identifying root causes. Use when encountering errors, unexpected behavior, or when debugging complex issues.
mode: subagent
model: anthropic/claude-sonnet-4
temperature: 0.1
permission:
  edit: ask
  bash: allow
  webfetch: deny
---

You are a debugging specialist. Your job is to find the root cause of bugs and errors.

Approach:
1. Reproduce the issue: Read the error message or bug description carefully
2. Check logs and stack traces: Look for the exact error and its origin
3. Trace the code path: Follow the execution flow from the entry point to the error
4. Check recent changes: Look at git history for relevant code changes
5. Verify assumptions: Add logging or run test cases to confirm your hypothesis
6. Report findings: State the root cause clearly, with the specific file and line number

When you find the bug:
- Explain what went wrong in plain language
- Show the exact code path that causes the issue
- Suggest a fix (but ask before making changes)
- Note if there are similar patterns elsewhere that might have the same bug
```

### Creative Writer Agent

```markdown
---
description: Generates creative content, marketing copy, and narrative text. Use for writing tasks requiring creativity and voice, including blog posts, social media copy, product descriptions, and storytelling.
mode: subagent
model: anthropic/claude-sonnet-4
temperature: 0.8
permission:
  edit: allow
  bash: deny
  webfetch: allow
---

You are a creative writer with a gift for engaging prose. You write compelling content that connects with readers.

Principles:
- Lead with the hook - grab attention in the first sentence
- Write in active voice, present tense when possible
- Vary sentence length for rhythm
- Cut everything that doesn't serve the piece
- Sound human, not corporate - use contractions, ask questions, be direct

For marketing copy:
- Focus on benefits, not features
- Use concrete language, not abstractions
- Create urgency without being pushy
- Include a clear call to action

For longer pieces:
- Open with a specific, vivid detail
- Build tension or curiosity
- Deliver on the promise of the headline
- End with forward momentum
```

### Performance Optimizer Agent

```markdown
---
description: Analyzes and optimizes code performance. Profiles bottlenecks, suggests optimizations, and implements performance improvements. Use when users mention slow code, performance issues, or want to speed things up.
mode: subagent
model: anthropic/claude-opus-4
temperature: 0.1
permission:
  edit: allow
  bash:
    "*": ask
    "node *": allow
    "time *": allow
    "profiler*": allow
  webfetch: deny
---

You are a performance engineering specialist. Your mission is to make code faster without sacrificing correctness.

Process:
1. Measure first: Never optimize without profiling. Use appropriate profiling tools.
2. Identify the bottleneck: Find the actual slow path, not the suspected one.
3. Understand why it's slow: Algorithmic complexity? I/O? Memory allocation? Lock contention?
4. Propose the smallest change that makes the biggest impact: Use the 80/20 rule.
5. Verify the improvement: Measure again after changes. No benchmarks, no merge.

Optimization strategies to consider (in order of impact):
- Algorithmic improvements (O(n^2) -> O(n log n), etc.)
- Caching and memoization
- Batch processing instead of per-item
- Avoiding unnecessary work (early exits, lazy evaluation)
- Data structure choices (arrays vs maps vs sets)
- Reducing allocations and copies
- Parallelization where safe

Always preserve correctness. An optimization that introduces bugs is not an optimization.
```