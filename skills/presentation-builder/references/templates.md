# Template registry

Each entry below is one template available to this skill. To pick a template, match the user's brief against the "best for" line and the strengths/weaknesses.

When adding a new template:
1. Drop its source files into `assets/templates/<id>/` (and any image/logo dependencies in a nested folder).
2. Append a new section here following the format below.
3. If the template introduces slide patterns that don't already exist in `slide-patterns.md`, add them there.

---

## seminar

- **ID:** `seminar`
- **Folder:** `assets/templates/seminar/`
- **Entry file:** `seminar-template.html`
- **Companion files:** `deck-stage.js`, `image-slot.js`, `tweaks-panel.jsx`
- **Asset dependencies:** none — fully self-contained, only Google Fonts over the network.
- **Aspect / resolution:** 1920 × 1080 (16:9)
- **Default deck length:** 25 slides
- **Default fonts:** IBM Plex Sans (display + body), IBM Plex Mono (chrome/labels). Plex Serif available for italic math variables.
- **Default palette:** off-white background `#fafaf7`, near-black foreground `#1a1a1a`, slate-blue accent `#2a5d8a`. Dark mode swaps to `#111111` / `#f3f1eb`.

**Best for**
- Academic seminars, thesis defences, conference talks, journal-club presentations, workshop walkthroughs, lab meetings.
- Anything where text density is moderate and credibility matters more than spectacle.
- Talks with a clear narrative arc: background → method → results → discussion → next steps.
- When the speaker is **not** representing a specific institution that mandates a brand.

**Strengths**
- Serious editorial typography; reads like a research paper, not a sales pitch.
- Rich primitives for the slide types academics actually need: definition card, numbered/bulleted lists, pull-quote, full-bleed photo intro, pipeline/process diagram, 2- and 3-column comparison, equation showcase, syntax-highlighted code, big-number stat, bar chart, data table with delta highlighting, image-led layout, 6-tile image grid, numbered contributions cards, paired limitation-with-mitigation list, timeline, two-column references list, acknowledgements, formal Q&A closer, dark appendix divider.
- Built-in theme tokens: light/dark, three density variants (`compact`/regular/`spacious`), action-style vs topic-style titles, footer toggle, light vs dark code blocks, fully customizable accent color and font stack.

**Weaknesses / when not to pick**
- Not designed for product/marketing decks — feels too dry for sales.
- Not built for very short (≤5 min) talks; the chrome and structural slides assume 15–60 min.
- No animation. If the user wants kinetic typography or build-ins, this template won't deliver.
- No institutional branding — pick `university` if the user needs PWR (Wrocław Tech) chrome.

**Available slide patterns** (see `slide-patterns.md` for snippets)
`cover`, `agenda`, `section-divider`, `definition`, `bullets`, `quote`, `full-bleed`, `pipeline`, `comparison`, `comparison-3col`, `equation`, `code`, `big-number`, `bar-chart`, `table`, `image-led`, `image-grid`, `contributions`, `limitations`, `timeline`, `acknowledgements`, `references`, `qa`, `appendix-divider`.

**Built-in customization knobs** (see `customization.md`)
- `body.dark` — dark mode
- `body.compact` / `body.spacious` — density
- `body.action-titles` — sentence-style titles instead of noun-style
- `body.no-footer` — hide the bottom chrome
- `body.code-light` — render code blocks on a light background instead of the default near-black
- CSS vars on `:root`: `--accent`, `--bg`, `--fg`, `--muted`, `--hair`, `--soft`, `--font-sans`, `--font-display`, `--font-mono`, plus the type and spacing scale.

---

## university

- **ID:** `university`
- **Folder:** `assets/templates/university/`
- **Entry file:** `university-template.html`
- **Companion files:** `deck-stage.js`, `image-slot.js`, `tweaks-panel.jsx`
- **Asset dependencies:** `assets/uni/*.png` — official PWR (Politechnika Wrocławska / Wrocław University of Science and Technology) logos and partner marks. **These must be copied alongside the HTML** for the deck to render correctly. Filenames the HTML expects:
  - `pwr-en-horiz.png`, `pwr-pl-horiz.png` — horizontal lockups (cover, English/Polish)
  - `pwr-en-horiz-white.png`, `pwr-pl-horiz-white.png` — horizontal lockups on red rail (white versions, all non-cover slides)
  - `pwr-en-vert.png`, `pwr-pl-vert.png`, `pwr-en-vert-white.png`, `pwr-pl-vert-white.png` — vertical eagle marks for cover panel
  - `hr-excellence.png`, `unite.png`, `iep-evaluated.png` — partner badges on cover footer strip
- **Aspect / resolution:** 1920 × 1080 (16:9)
- **Default deck length:** 25 slides (mirrors seminar)
- **Default fonts:** Trebuchet MS (official PWR font) with Source Sans 3 web fallback; JetBrains Mono for code/chrome; Source Serif 4 for italic math.
- **Default palette:** PWR red `#9A342D` (Pantone 484) on cream `#F1D1A2` (Pantone 156) — these are **brand-mandated** and should not be overridden. Black ink on white. Dark mode inverts to deep brown background with cream ink.

**Best for**
- Any presentation given as a Politechnika Wrocławska / Wrocław University of Science and Technology affiliate (student, PhD candidate, faculty).
- Thesis defences, MSc/PhD seminars, project reviews, conference talks where institutional affiliation should be visible on every slide.
- **Bilingual EN/PL talks** — every translatable string is wrapped in an `<span class="i18n" data-en="..." data-pl="...">` and a single body class toggles language. Useful for talks where you want to ship one deck and switch language at a button.

**Strengths**
- Locked, audit-able brand. Top red rail with white horizontal lockup, footer with partner logos (HR Excellence, Unite!, IEP), red-paneled cover with vertical eagle.
- Same 25-slide pattern catalog as seminar, with PWR-styled chrome on every slide.
- First-class i18n: write content twice (EN + PL), flip with `<body class="lang-en">` / `<body class="lang-pl">`.

**Weaknesses / when not to pick**
- Only appropriate for PWR-affiliated speakers. Using PWR chrome without affiliation is brand misuse.
- The brand palette dominates — if the user wants a custom color scheme, `seminar` is the better base.
- The cover slide layout is hard-coded around the eagle logo and red panel; can't be substantially restructured without breaking the brand.

**Available slide patterns** (see `slide-patterns.md` for snippets)
Same catalog as seminar, but with PWR chrome: `cover`, `agenda`, `section-divider`, `definition`, `bullets`, `quote`, `full-bleed`, `pipeline`, `comparison`, `comparison-3col`, `equation`, `code`, `big-number`, `bar-chart`, `table`, `image-led`, `image-grid`, `contributions`, `limitations`, `timeline`, `acknowledgements`, `references`, `qa`, `appendix-divider`.

**Built-in customization knobs** (see `customization.md`)
- `body.lang-en` / `body.lang-pl` — language swap (mutually exclusive; default `lang-en`)
- `body.dark` — dark mode (inverts to brown/cream)
- `body.compact` / `body.spacious` — density
- `body.no-footer` — hide footer entirely
- `body.no-partners` — hide just the partner logos (keep speaker/page chrome)
- `body.code-light` — render code blocks on cream background instead of near-black
- `body.bullets-square` / `body.bullets-dash` — bullet glyph variants
- CSS vars on `:root`: brand-locked `--pwr-red`, `--pwr-cream`, `--pwr-bg`, `--pwr-ink`, `--pwr-muted`, `--pwr-hair`. Type scale (`--t-title`, `--t-body`, etc.) and spacing tokens are tweakable. Do **not** change `--pwr-red` or `--pwr-cream` unless the user explicitly invokes a brand exception.

---

## Choosing between them

| User cue                                                          | Pick         |
|-------------------------------------------------------------------|--------------|
| Mentions PWR, Politechnika Wrocławska, Wrocław Tech, W11/C-16, "my university", a Polish university context | `university` |
| Needs Polish/English bilingual deck                               | `university` |
| Wants custom colors / specific brand palette                      | `seminar`    |
| Generic academic talk with no affiliation requirement             | `seminar`    |
| Reading group, lab meeting, journal club, workshop                | `seminar`    |
| Conference talk where they want to advertise a specific institution that *isn't* PWR | `seminar` (or add a new template) |
| Ambiguous                                                         | Ask          |
