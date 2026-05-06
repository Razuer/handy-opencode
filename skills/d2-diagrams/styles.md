# D2 Style Palettes

Copy-paste `classes` blocks for consistent, theme-safe diagrams. **Never set `style.fill`** - D2 themes handle it. Use `style.stroke`, `style.stroke-width`, `style.stroke-dash`, `style.border-radius`, and `shape`.

## Infrastructure palette

```d2
classes: {
  edge:     { style.stroke: "#1565C0"; style.stroke-width: 3 }              # Load balancers, CDN, edge
  compute:  { style.stroke: "#00838F"; style.stroke-width: 3 }              # API, workers, services
  lambda:   { style.stroke: "#3949AB"; style.stroke-width: 2; shape: parallelogram }
  data:     { style.stroke: "#E65100"; style.stroke-width: 3; shape: cylinder }   # RDBMS, NoSQL
  cache:    { style.stroke: "#7B1FA2"; style.stroke-width: 2; shape: hexagon }
  storage:  { style.stroke: "#2E7D32"; style.stroke-width: 2; shape: stored_data } # S3, blob
  queue:    { style.stroke: "#FF8F00"; style.stroke-width: 3; shape: queue }       # Kafka, SQS, NATS
  network:  { style.stroke: "#424242"; style.stroke-width: 1; style.stroke-dash: 3 }
  external: { style.stroke: "#C62828"; style.stroke-width: 3; shape: cloud }       # 3rd-party SaaS
}
```

## Architecture (logical) palette

```d2
classes: {
  presentation: { style.stroke: "#3949AB"; style.stroke-width: 2; style.border-radius: 12 }
  application:  { style.stroke: "#00838F"; style.stroke-width: 2; style.border-radius: 8 }
  domain:       { style.stroke: "#FF8F00"; style.stroke-width: 2; style.border-radius: 8 }
  data:         { style.stroke: "#5D4037"; style.stroke-width: 2 }
  integration:  { style.stroke: "#AD1457"; style.stroke-width: 2; style.stroke-dash: 5 }
}
```

## Edge (connection) styles

```d2
# Synchronous HTTP/REST/gRPC
a -> b: "REST"  { style.stroke: "#1976D2"; style.stroke-width: 2 }

# Async message / event
a -> b: "event" { style.stroke: "#7B1FA2"; style.stroke-width: 2; style.stroke-dash: 5; style.animated: true }

# Data read
a -> b: "read"  { style.stroke: "#F57C00"; target-arrowhead: { shape: arrow } }

# Data write
a -> b: "write" { style.stroke: "#D32F2F"; target-arrowhead: { shape: diamond; style.filled: true } }

# Telemetry / observability
a -> b: "traces" { style.stroke-dash: 3 }
```

## Shape cheatsheet

| Use case                 | Shape             |
| ------------------------ | ----------------- |
| Relational DB            | `cylinder`        |
| NoSQL / doc store        | `cylinder`        |
| Cache                    | `hexagon`         |
| Message broker / queue   | `queue`           |
| Object storage           | `stored_data`     |
| Lambda / function        | `parallelogram`   |
| 3rd-party SaaS / CDN     | `cloud`           |
| Person / actor           | `person`          |
| Decision                 | `diamond`         |
| Document                 | `document`        |
| Page / UI                | `page`            |

## Alternative palettes

Swap the `classes` block when the default "material" palette feels too loud.

### Slate monochrome (corporate / whitepaper)

```d2
classes: {
  edge:     { style.stroke: "#0F172A"; style.stroke-width: 2 }
  compute:  { style.stroke: "#334155"; style.stroke-width: 2 }
  data:     { style.stroke: "#475569"; style.stroke-width: 2; shape: cylinder }
  cache:    { style.stroke: "#64748B"; style.stroke-width: 2; shape: hexagon }
  queue:    { style.stroke: "#94A3B8"; style.stroke-width: 2; shape: queue }
  external: { style.stroke: "#CBD5E1"; style.stroke-width: 2; shape: cloud }
}
```

### Ocean (cool, calm, modern SaaS)

```d2
classes: {
  edge:     { style.stroke: "#0EA5E9"; style.stroke-width: 3 }
  compute:  { style.stroke: "#0891B2"; style.stroke-width: 3 }
  data:     { style.stroke: "#0E7490"; style.stroke-width: 3; shape: cylinder }
  cache:    { style.stroke: "#22D3EE"; style.stroke-width: 2; shape: hexagon }
  queue:    { style.stroke: "#6366F1"; style.stroke-width: 3; shape: queue }
  external: { style.stroke: "#A855F7"; style.stroke-width: 2; shape: cloud }
}
```

### Sunset (high-contrast presentations)

```d2
classes: {
  edge:     { style.stroke: "#F43F5E"; style.stroke-width: 3 }
  compute:  { style.stroke: "#F97316"; style.stroke-width: 3 }
  data:     { style.stroke: "#EAB308"; style.stroke-width: 3; shape: cylinder }
  cache:    { style.stroke: "#84CC16"; style.stroke-width: 2; shape: hexagon }
  queue:    { style.stroke: "#14B8A6"; style.stroke-width: 3; shape: queue }
  external: { style.stroke: "#6366F1"; style.stroke-width: 2; shape: cloud }
}
```

## Theming via `vars`

Centralize colors so swapping a palette is one-line. D2 resolves `${name}` inside values.

```d2
vars: {
  c-edge:    "#1565C0"
  c-compute: "#00838F"
  c-data:    "#E65100"
  c-async:   "#FF8F00"
}

classes: {
  edge:    { style.stroke: ${c-edge};    style.stroke-width: 3 }
  compute: { style.stroke: ${c-compute}; style.stroke-width: 3 }
  data:    { style.stroke: ${c-data};    style.stroke-width: 3; shape: cylinder }
  queue:   { style.stroke: ${c-async};   style.stroke-width: 3; shape: queue }
}
```

## Global tweaks via glob selectors

```d2
# Apply once to every node/edge:
*.style.font-size: 14
*.style.stroke-width: 2
(* -> *).style.stroke-width: 2    # every directed connection
```

## Typography

```d2
title: Payments Platform {
  near: top-center
  style.font-size: 28
  style.bold: true
  style.underline: false
}

note: draft {
  style.italic: true
  style.font-color: "#64748B"
  style.font-size: 12
}

# Monospace / code font for tech labels is automatic via `shape: code` / |go ... | blocks.
```

## Depth: shadows, 3D, multiple

Use sparingly for hero diagrams or to signal "cluster / fleet / replicated".

```d2
api: API (Go) {
  class: compute
  style.shadow: true       # subtle drop shadow
}

cluster: Workers {
  class: compute
  style.multiple: true     # stacked paper look = fleet / N instances
}

block: Legacy Mainframe {
  style.3d: true           # isometric 3D (blocks/containers only)
}
```

## Sketch / hand-drawn mode

Perfect for early design docs, ADRs, whiteboard vibes. Pass at render time:

```bash
d2 --sketch --bundle diagram.d2 diagram.svg --theme 0 --layout elk
```

## Extra render flags worth knowing

| Flag                        | Effect                                                    |
| --------------------------- | --------------------------------------------------------- |
| `--sketch`                  | Hand-drawn look.                                          |
| `--pad=N`                   | Padding around the diagram (default 100).                 |
| `--scale=1.5`               | Upscale for presentations / retina.                       |
| `--dark-theme=200`          | Emit a second theme embedded; hosts pick by CSS.          |
| `--animate-interval=1200`   | Ms between animated traffic pulses on dashed edges.       |
| `--timeout=120`             | Render timeout in seconds (raise for huge diagrams).      |
| `--stdout-format=svg`       | Pipe SVG to stdout for chaining/post-processing.          |

## Invisible group / spacer

```d2
spacer: {
  shape: null
  a
  b
}
```

## Grid layout for layers

```d2
direction: down

presentation: Presentation Layer {
  grid-columns: 3
  web:    Web App
  mobile: Mobile App
  cli:    CLI
}

application: Application Layer {
  grid-columns: 2
  api:      API Gateway
  services: Microservices
}

presentation -> application
```
