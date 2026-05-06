# Codebase-Scan Workflow

Use this when the user wants diagrams generated from a repository, for example "diagram this project" or "document our infra". The goal is to produce source-grounded architecture and infrastructure diagrams, not guesses.

## Output layout

```
diagrams/
├── README.md                        # Embeds both diagrams, light+dark
├── architecture.d2                   # Detailed logical diagram
├── architecture-simplified.d2        # 3-8 node summary
├── infrastructure.d2                 # Detailed cloud/K8s/container diagram
├── infrastructure-simplified.d2      # 3-8 node summary
├── architecture-{light,dark}.svg
├── architecture-simplified-{light,dark}.svg
├── infrastructure-{light,dark}.svg
└── infrastructure-simplified-{light,dark}.svg
```

## Pipeline

Work through these phases in order. Track progress when the task is large enough to need it.

### 1. Scan (read-only)

Run Glob/Grep searches in parallel for:

- **Terraform**: `**/*.tf`, `**/*.tfvars`, `terraform/`, `infrastructure/`
- **Pulumi**: `Pulumi.yaml`, `pulumi/`
- **CloudFormation**: `**/*.template.{json,yaml}`, `cloudformation/`
- **AWS CDK**: `cdk.json`, `lib/*-stack.ts`
- **Kubernetes**: `**/*.yaml` containing `apiVersion:`, `k8s/`, `kubernetes/`, `helm/`, `charts/`
- **Docker**: `Dockerfile*`, `docker-compose*.yml`
- **Serverless**: `serverless.yml`, `sam.yaml`, `*.bicep`
- **Source entry points**: `main.*`, `index.*`, `app.*`, `server.*`, `cmd/*/main.go`
- **Manifests**: `package.json`, `go.mod`, `Cargo.toml`, `pyproject.toml`, `pom.xml`
- **CI/CD**: `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, `.circleci/`
- **Existing docs**: `README.md`, `ARCHITECTURE.md`, `docs/`, `diagrams/`

Sample 1-2 files per category to confirm their kind. Cap at ~50 reads. Skip `node_modules`, `vendor`, `.git`, `target`, `dist`, `build`.

Honor `./diagrams/rules.md` if present (naming overrides, excludes, force-includes).

### 2. Synthesize

Produce two artifacts in `diagrams/`:

- `infrastructure.md` - bullet list of every cloud resource/container/service found, grouped by layer (edge, compute, data, messaging, external).
- `architecture.md` - bullet list of logical layers (presentation, application, domain, data, integration) with concrete modules/packages/services mapped in.

These drive the `.d2` generation and are useful prose docs in their own right.

### 3. Author `.d2`

For each of the four files (`infrastructure.d2`, `infrastructure-simplified.d2`, `architecture.d2`, `architecture-simplified.d2`):

- Start from the template in `SKILL.md`.
- Apply the correct palette from `styles.md` (infrastructure vs architecture).
- Pick `direction: right` for infra (flow left-to-right), `direction: down` for architecture layers.
- Each tech node gets `class:` and, when available, a vetted `icon:` from `icons.md`. Use shape-only for the known-unavailable list and for any technology without a verified icon.
- Order nodes along the data flow so elk produces minimal bends.
- **Simplified = 3-8 nodes max**, each labeled with the technology name.

### 4. Render

Run the 8 commands in parallel (or a loop):

```bash
for kind in infrastructure infrastructure-simplified architecture architecture-simplified; do
  d2 --bundle "diagrams/$kind.d2" "diagrams/$kind-light.svg" --theme 0   --layout elk --animate-interval=1200 &
  d2 --bundle "diagrams/$kind.d2" "diagrams/$kind-dark.svg"  --theme 200 --layout elk --animate-interval=1200 &
done
wait
```

On elk failure for any file, retry that one with `--layout dagre`. Up to 3 retries per file; if still failing, simplify the `.d2` (flatten a nested container) and retry.

### 5. Verify

- All 8 SVGs exist and are non-empty.
- Verify a couple of SVGs when possible; icons appear; no raw URL strings are left.
- Simplified variants have 3-8 nodes with tech names.
- No explicit `style.fill` anywhere (dark-mode safety).

### 6. Write `diagrams/README.md`

Embed both variants with `<picture>` so GitHub picks light/dark automatically:

```markdown
# Architecture

<picture>
  <source media="(prefers-color-scheme: dark)"  srcset="architecture-simplified-dark.svg">
  <img alt="Architecture (simplified)" src="architecture-simplified-light.svg">
</picture>

<details>
<summary>Detailed</summary>

<picture>
  <source media="(prefers-color-scheme: dark)"  srcset="architecture-dark.svg">
  <img alt="Architecture" src="architecture-light.svg">
</picture>

</details>

# Infrastructure

<picture>
  <source media="(prefers-color-scheme: dark)"  srcset="infrastructure-simplified-dark.svg">
  <img alt="Infrastructure (simplified)" src="infrastructure-simplified-light.svg">
</picture>
```

## Flags the user may pass

- `--incremental` - only regenerate diagrams whose source inputs changed since last run (check `git diff` of IaC/source paths).
- `--infrastructure-only` / `--architecture-only` - skip the other.
- `--scope=path/` - limit scanning to a subtree.

## Honoring `./diagrams/rules.md`

If present, parse sections like:

```markdown
## Naming
- Use "API Gateway" not "APIGW"

## Exclude
- test/
- examples/

## Include
- Cloudflare CDN
- Datadog monitoring
```

Apply name substitutions to labels, skip matching paths during scan, and force-add listed external components as `class: external` nodes even if not found in IaC.
