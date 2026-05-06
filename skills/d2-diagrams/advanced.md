# D2 Advanced Diagram Kinds

Beyond architecture/infrastructure: sequence, ERD, class, flowcharts, and multi-frame boards. Snippets here drop into a standalone `.d2` file and render with the same command.

## Sequence diagrams

Use `shape: sequence_diagram` on a container. Participants are auto-ordered by first appearance.

```d2
flow: {
  shape: sequence_diagram

  user:    User
  web:     Web App
  api:     API (Go)
  db:      Postgres { shape: cylinder }

  user -> web:  Click "Buy"
  web  -> api:  POST /orders
  api  -> db:   INSERT order
  db   -> api:  ok
  api  -> web:  201 Created
  web  -> user: Show receipt

  # Notes and spans
  span1: {
    web -> api: retry {
      style.stroke-dash: 3
    }
  }
}
```

## ERD / SQL tables

`shape: sql_table` renders rows as typed fields; connections create FK arrows automatically.

```d2
users: {
  shape: sql_table
  id:         int {constraint: primary_key}
  email:      varchar(255) {constraint: unique}
  created_at: timestamptz
}

orders: {
  shape: sql_table
  id:      int {constraint: primary_key}
  user_id: int {constraint: foreign_key}
  total:   numeric(10,2)
  status:  varchar(32)
}

orders.user_id -> users.id: belongs_to
```

## Class diagrams

```d2
Animal: {
  shape: class

  +name: string
  -age: int
  +speak(): void
  #move(distance: int): bool
}

Dog: {
  shape: class
  +breed: string
  +bark(): void
}

Dog -> Animal: extends { style.stroke-dash: 3 }
```

## Flowcharts

```d2
direction: down

start: Start { shape: oval }
check: Valid input? { shape: diamond }
run:   Run job
fail:  Show error
done:  Done { shape: oval }

start -> check
check -> run:  yes
check -> fail: no
run  -> done
fail -> done
```

## Multi-frame boards: layers / scenarios / steps

Boards let one `.d2` render as a navigable SVG with multiple frames.

- `layers.*` - nested detail. Clicking a node reveals its layer.
- `scenarios.*` - alternative states of the same diagram.
- `steps.*` - ordered walkthrough (step N inherits step N-1 and diffs it).

```d2
direction: right
api -> db

layers: {
  db-internals: {
    title: Inside the DB
    wal:     WAL
    indexes: Indexes
    wal -> indexes
  }
}

scenarios: {
  failure: {
    title: DB down
    api -> db: "timeout" { style.stroke: "#D32F2F" }
  }
}

steps: {
  step1: {
    cache: Redis
    api -> cache: read-through
  }
  step2: {
    api -> db: cache miss
  }
}
```

## Legend

Add a small `class`-swatch legend so readers decode colors without docs.

```d2
legend: Legend {
  near: bottom-right
  grid-columns: 2
  grid-gap: 8
  style.stroke-width: 0

  sync:    sync call      { class: compute }
  async:   async event    { class: queue }
  data:    data store     { class: data }
  ext:     external SaaS  { class: external }
}
```

## Rich labels: markdown, code, LaTeX

```d2
note: |md
  ### Cache policy
  - TTL: **60s**
  - Stampede protection via `singleflight`
|

snippet: |go
  func handler(w http.ResponseWriter, r *http.Request) {
      io.Copy(w, r.Body)
  }
|

math: |latex
  \sum_{i=0}^{n} x_i^2
|
```

## Invisible grouping: `shape: null`

Group nodes for layout without drawing the container.

```d2
group: {
  shape: null
  a
  b
  c
}
```

## Edge placement hints

```d2
title: System Overview { near: top-center; style.font-size: 28; style.bold: true }
legend: Legend          { near: bottom-right }
footer: v2.3 - 2026-04   { near: bottom-left; style.italic: true }
```
