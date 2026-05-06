---
name: d2-diagrams
description: Author clean, modern, professional D2 diagrams (architecture, infrastructure, flows, sequences) and render them as themed SVGs. Use when the user asks to create, update, or render a diagram, mentions D2 / d2lang, requests architecture/infrastructure/system/data-flow diagrams, or wants to visualize a codebase's services, deployments, or components.
---

# D2 Diagrams

Create readable, modern D2 diagrams and render them to light/dark SVGs. Prefer minimal syntax, logical grouping, consistent colors via `classes`, and theme-safe styling that avoids explicit fills.

## Operating principles

- Ask only for missing essentials: system boundary, audience, desired detail level, output path, or whether source-only `.d2` is enough.
- Preserve existing diagram style when updating files. For new diagrams, start from the quickstart template and apply a palette from `styles.md`.
- Use progressive detail: a simplified 3-8 node diagram for READMEs and a detailed diagram for design docs or repo documentation.
- When generating diagrams from a repository, scan first and ground every service/resource in source, config, IaC, docs, or an explicit user-provided assumption.
- Render and validate before claiming completion whenever the `d2` CLI is available.

## Prerequisites

Diagrams are authored as `.d2` source and rendered with the `d2` CLI.

```bash
d2 --version
```

Install options: `brew install d2` on macOS, `yay -S d2` on Arch, or `curl -fsSL https://d2lang.com/install.sh | sh -s --`.

If `d2` is missing and rendering is needed, tell the user and offer to install it before rendering. If the user only needs source, write the `.d2` file and note that rendering was skipped.

## Core authoring rules

Follow these to get professional, readable diagrams:

1. **Pick a direction up front**: `direction: down` for layered stacks, `direction: right` for east/west flows (client -> edge -> compute -> data).
2. **Style via `classes`, never per-node inline**. Colors stay consistent and dark-mode safe.
3. **Never set `style.fill`**. D2 themes handle fills. Use `style.stroke`, `style.stroke-width`, `style.stroke-dash`, `style.border-radius`, `shape`, and `icon`. `style.filled` is acceptable for arrowheads.
4. **Give each technology node `class:` and a vetted `icon:` when available**. `--bundle` does not propagate icons from imported class files, so icons must live on the node. If the icon is not in `icons.md`, omit `icon:` and use a clear label plus shape.
5. **Group logically with containers**. Keep inter-container edges few; intra-container edges are short and clear.
6. **Order nodes along the data-flow**. Elk uses source order as a layout hint, which dramatically reduces crossings and bends.
7. **Use edge styling to convey semantics**: solid = sync, `stroke-dash: 5` = async/events, `stroke-dash: 3` = telemetry/observability.
8. **Keep labels short and meaningful**: `API Gateway (Go)`, `Primary DB (PostgreSQL)`. Put tech in parentheses.
9. **Produce a simplified variant for detailed system diagrams**. Keep it to 3-8 nodes so it works in READMEs and overview docs.
10. **Render light and dark SVGs** with `--bundle` so icons embed as data URIs and work on GitHub/Pages without CORS.

## Quickstart template

Save as `diagrams/architecture.d2`:

```d2
direction: down

classes: {
  edge:    { style.stroke: "#1565C0"; style.stroke-width: 3 }
  compute: { style.stroke: "#00838F"; style.stroke-width: 3 }
  data:    { style.stroke: "#E65100"; style.stroke-width: 3 }
  async:   { style.stroke: "#FF8F00"; style.stroke-width: 3; shape: queue }
  ext:     { style.stroke: "#C62828"; style.stroke-width: 3; shape: cloud }
}

users: End Users {
  class: ext
  icon: https://icons.terrastruct.com/essentials%2F359-users.svg
}

aws: AWS (us-east-1) {
  alb: Load Balancer (ALB) { class: edge; shape: hexagon }
  api: API Service (Go) {
    class: compute
    icon: https://icons.terrastruct.com/dev%2Fgo.svg
  }
  broker: Events (Kafka) { class: async }
  db: Primary DB (PostgreSQL) {
    class: data; shape: cylinder
    icon: https://icons.terrastruct.com/dev%2Fpostgresql.svg
  }
  cache: Cache (Redis) {
    class: data; shape: hexagon
    icon: https://icons.terrastruct.com/dev%2Fredis.svg
  }
}

users -> aws.alb: HTTPS
aws.alb -> aws.api: route
aws.api -> aws.db: read/write
aws.api -> aws.cache: session
aws.api -> aws.broker: publish { style.stroke-dash: 5 }
```

Render:

```bash
d2 --bundle diagrams/architecture.d2 diagrams/architecture-light.svg --theme 0   --layout elk --animate-interval=1200
d2 --bundle diagrams/architecture.d2 diagrams/architecture-dark.svg  --theme 200 --layout elk --animate-interval=1200
```

If `elk` fails on complex layouts, retry with `--layout dagre`.

## Workflow

1. Confirm intent: what system, what audience, what detail level, and whether to deliver `.d2`, SVGs, or both.
2. Pick the diagram kind:
   - **Architecture** - logical layers (presentation/app/domain/data/integration).
   - **Infrastructure** - physical/cloud resources (VPC, subnets, ALB, ECS, RDS, S3).
   - **Sequence** - request lifecycle / protocol handshake (`shape: sequence_diagram`).
   - **ERD / SQL** - data model with typed columns and FK arrows (`shape: sql_table`).
   - **Class** - OO relationships (`shape: class`).
   - **Flowchart** - decisions and branching (`shape: diamond` + `oval`).
   - **Multi-frame board** - `layers` / `scenarios` / `steps` for walkthroughs.
   See [advanced.md](advanced.md) for snippets of each.
3. Author the `.d2` file using the template plus `styles.md` for class palettes.
4. Add icons from `icons.md` only when a vetted URL exists. For known unavailable icons, use shape-only (`queue`, `cloud`, `hexagon`, `cylinder`) and a precise label.
5. Run `d2 validate` or render once to catch syntax errors.
6. Render light and dark SVGs with `--bundle`.
7. If rendering fails, read the error, fix it using "Error recovery", and retry up to 3 times.
8. For READMEs, also emit a simplified variant with 3-8 nodes and embed both SVGs using HTML `<picture>` so GitHub dark mode picks the right one:

```html
<picture>
  <source media="(prefers-color-scheme: dark)"  srcset="diagrams/architecture-dark.svg">
  <img alt="Architecture" src="diagrams/architecture-light.svg">
</picture>
```

## Edge semantics cheatsheet

```d2
a -> b: sync HTTP                                    # solid, default
a -> b: async event  { style.stroke-dash: 5 }        # async / pub-sub
a -> b: telemetry    { style.stroke-dash: 3 }        # metrics / traces
a -> b: write        { target-arrowhead: { shape: diamond; style.filled: true } }
a <-> b: bidirectional
```

## Codebase-scan mode (optional)

When the user says "diagram this repo" or wants infra/architecture generated from source, follow [codebase-scan.md](codebase-scan.md). It describes the scan -> document -> render -> verify pipeline for IaC files, Kubernetes manifests, Dockerfiles, source entry points, manifests, and existing docs.

## Error recovery

| Error                     | Fix                                                  |
| ------------------------- | ---------------------------------------------------- |
| `unexpected token`        | Keep IDs simple (`api`, `db`) and quote complex labels after `:`. |
| `undefined shape`         | Check spelling; valid: `cylinder`, `queue`, `cloud`, `hexagon`, `parallelogram`, `stored_data`, `document`, `page`, `person`, `diamond`. |
| `cycle detected`          | Flatten circular container nesting.                  |
| `elk failed` / messy      | Retry with `--layout dagre`.                         |
| Icons missing in output   | Ensure each node has its own vetted `icon:` line; re-render with `--bundle`. For known-unavailable icons, remove `icon:` and use shape-only. |
| Dark-mode looks broken    | Remove any `style.fill` you added; themes handle fills. |

## Anti-patterns

- Setting `style.fill` on classes or nodes (breaks dark theme).
- Putting all nodes at the top level with no containers (layout explodes).
- One mega-diagram with 40+ nodes and no simplified variant.
- Rendering without `--bundle` (icons 404 when hosted).
- Inventing icon URLs. Only use render-verified URLs from `icons.md` or shape-only nodes.
- Generic labels (`service1`, `db`) - always include the tech in parentheses.

## Polish options (pick sparingly)

- `--sketch` at render time for a hand-drawn whiteboard look (great for ADRs).
- `style.shadow: true` on hero nodes; `style.multiple: true` to signal fleets/replicas; `style.3d: true` on legacy blocks.
- Add a legend container with `near: bottom-right` and class swatches so readers can decode colors.
- Centralize colors in a `vars:` block and reference them with `${name}` - swapping palette becomes one edit.
- Use glob selectors (`*.style.font-size: 14`) once instead of per-node styling.

## Reference files

- [styles.md](styles.md) - class palettes (material/slate/ocean/sunset), `vars` theming, typography, glob selectors, depth effects, render flags.
- [icons.md](icons.md) - render-verified Terrastruct icon URLs plus known-unavailable shape-only fallbacks.
- [advanced.md](advanced.md) - sequence, ERD/SQL, class, flowchart, boards (layers/scenarios/steps), legends, rich labels.
- [codebase-scan.md](codebase-scan.md) - scan-to-diagram pipeline for whole-repo documentation.
