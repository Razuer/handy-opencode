# Customization guide

Every tweak the bundled templates support, by template. Each section gives the exact place to edit.

The two templates share the same body-class conventions where possible (`dark`, `compact`, `spacious`, `no-footer`, `code-light`), but their CSS variable namespaces differ — `seminar` uses generic tokens (`--bg`, `--fg`, `--accent`), `university` uses brand-prefixed tokens (`--pwr-bg`, `--pwr-ink`, `--pwr-red`).

---

## seminar template

### Body classes — the on/off switches

Apply zero or more by adding to `<body class="...">`:

| Class            | Effect                                                                              |
|------------------|-------------------------------------------------------------------------------------|
| `dark`           | Dark theme. Swaps bg/fg/muted/hair/soft tokens.                                     |
| `compact`        | Tighter padding, smaller gaps. Good for content-heavy decks.                        |
| `spacious`       | Looser padding, larger gaps. Good for keynote / lightning decks.                    |
| `action-titles`  | Shows the `.title-action` span instead of `.title-topic`. Use for assertive titles. |
| `no-footer`      | Hides every `.slide-footer`.                                                        |
| `code-light`     | Renders code blocks on a light background instead of the default near-black.        |

Examples:
```html
<body class="dark action-titles">
<body class="compact code-light">
<body class="spacious action-titles no-footer">
```

Density and dark mode compose. `compact` + `dark` is a common "long technical talk in a dark room" choice. `code-light` is mainly useful in **light** decks where the dark code block stands out too aggressively.

### CSS variables — the theme

Defined in the `:root { ... }` block. Edit values in place.

#### Color tokens

```css
--bg:    #fafaf7;   /* page background */
--fg:    #1a1a1a;   /* primary text */
--muted: #6b6b6b;   /* secondary text, captions, chrome */
--hair:  #d8d6d0;   /* hairline borders */
--soft:  #efece5;   /* subtle fills (table best rows, def card bg, divider numerals) */
--accent: #2a5d8a;  /* the one accent color */
```

The `body.dark` block overrides the first five. **If you change `--bg` / `--fg` / `--muted` / `--hair` / `--soft` in `:root`, also update the `body.dark` block** so dark mode stays coherent.

The accent **is not** swapped in dark mode by default — the same accent works on both. If you pick a low-contrast accent (e.g. yellow `#e2c044`), add an explicit override:

```css
body.dark { --accent: #f0d260; }
```

#### Suggested palettes

| Mood              | --accent  | Pairs with    |
|-------------------|-----------|---------------|
| Editorial blue    | `#2a5d8a` | default       |
| Forest            | `#2e6b4a` | warm light bg |
| Burgundy          | `#8a2a3a` | warm light bg |
| Slate             | `#4a5566` | cool light bg |
| Coral             | `#d97757` | warm light bg |
| Electric          | `#3756f5` | cool light bg |
| Amber (dark only) | `#f0a830` | dark bg       |
| Chartreuse (dark) | `#b8e040` | dark bg       |

#### Type tokens

```css
--type-display:  120px;  /* cover title */
--type-title:    64px;   /* slide titles */
--type-subtitle: 40px;   /* slide subtitles */
--type-body:     30px;   /* paragraph body */
--type-small:    26px;   /* captions, list descriptions */
--type-mono:     24px;   /* chrome, eyebrows */
```

Designed for 1920×1080. Don't change these to fit more content — change the content.

#### Font tokens

```css
--font-sans:    "IBM Plex Sans", ui-sans-serif, system-ui, sans-serif;
--font-mono:    "IBM Plex Mono", ui-monospace, "SF Mono", Menlo, monospace;
--font-display: "IBM Plex Sans", ui-sans-serif, system-ui, sans-serif;
```

The Google Fonts `<link>` in `<head>` already preloads these families: IBM Plex Sans/Serif/Mono, JetBrains Mono, Space Grotesk, DM Sans/Mono.

Common swaps:

```css
/* Classical (paper-like) */
--font-display: "IBM Plex Serif", Georgia, serif;
--font-sans:    "IBM Plex Sans", system-ui, sans-serif;

/* Contemporary tech */
--font-display: "Space Grotesk", system-ui, sans-serif;
--font-sans:    "DM Sans", system-ui, sans-serif;
--font-mono:    "JetBrains Mono", ui-monospace, monospace;

/* Warm */
--font-display: "DM Sans", system-ui, sans-serif;
--font-sans:    "DM Sans", system-ui, sans-serif;
--font-mono:    "DM Mono", ui-monospace, monospace;
```

Equation glyphs (math variables) are hard-coded to IBM Plex Serif italic, regardless of `--font-display`. If you swap to a non-Plex display font, the equation slide will still render math in serif — that's intentional, since math is more readable in serif.

Never pair two display-y fonts.

#### Spacing tokens

```css
--pad-top:    110px;
--pad-bottom: 110px;
--pad-x:      110px;
--gap-title:  56px;
--gap-item:   28px;
--gap-tight:  16px;
```

Usually you don't touch these directly — use the `compact` / `spacious` body classes, which override them.

### Speaker notes

There's a `<script type="application/json" id="speaker-notes">` block in `<head>`. JSON array, one string per slide, in document order. Keep this in sync with `script.md` (1–2 sentence condensed cues per slide).

### Per-slide overrides

Inline-style on a single `<section class="slide" style="--bg: #1a1a1a; --fg: #fafaf7;">` cascades to that slide only. Use for one-off effects; for systemic changes, edit `:root`.

---

## university template

The university template is **brand-locked**. Most of the customization knobs that exist on `seminar` are deliberately absent here — the point of the template is to look like Politechnika Wrocławska every time. You can still tune density, language, and a few presentation details.

### Body classes

| Class             | Effect                                                                              |
|-------------------|-------------------------------------------------------------------------------------|
| `lang-en`         | English locale (default). Shows `.lang-en` images and `data-en` text in `.i18n` spans. |
| `lang-pl`         | Polish locale. Shows `.lang-pl` images and `data-pl` text. **Mutually exclusive with `lang-en`.** |
| `dark`            | Inverts to deep brown background (`#161312`) with cream ink (`#F1D1A2`).            |
| `compact`         | Tighter padding.                                                                    |
| `spacious`        | Looser padding.                                                                     |
| `no-footer`       | Hides the entire bottom footer (including page numbers and partner logos).          |
| `no-partners`     | Hides only the partner-logo strip in the footer; keeps speaker/page info.           |
| `code-light`      | Renders code blocks on cream-light background instead of near-black.                |
| `bullets-square`  | Changes bullet glyph to a square marker.                                            |
| `bullets-dash`    | Changes bullet glyph to an em-dash.                                                 |

You can compose freely except `lang-en`/`lang-pl` — pick one. Default in the source file is whichever is set on `<body>`; switching at runtime is wired via the i18n script at the bottom of the HTML.

### Switching languages at runtime

The template ships with a JS handler that listens on a button and toggles the body class + every `<span class="i18n">`. The handler is in a `<script id="i18n">` block near the bottom of the HTML. It does:

1. `document.body.classList.toggle('lang-en', key === 'en')`
2. `document.body.classList.toggle('lang-pl', key === 'pl')`
3. For every `.i18n` span, sets `textContent = el.dataset[key]`.

Don't remove the i18n handler — it's required for any deck where you want both languages live. If the talk is English-only, leave it in anyway; it's inert.

### Brand-locked tokens

```css
--pwr-red:    #9A342D;   /* PANTONE 484 — primary */
--pwr-red-d:  #6c241f;   /* derived deep */
--pwr-cream:  #F1D1A2;   /* PANTONE 156 */
--pwr-cream-l:#f9ecd5;   /* tint */
--pwr-ink:    #000000;   /* black */
--pwr-muted:  #6a625a;   /* warm grey */
--pwr-hair:   #e3d8c8;   /* warm hairline */
--pwr-bg:     #ffffff;
--pwr-on-red: #F1D1A2;   /* cream sits on red */
--pwr-on-red-soft: rgba(241, 209, 162, 0.78);
```

**Do not change `--pwr-red` or `--pwr-cream`.** These are the official Pantone colors; changing them is brand misuse. If a user specifically asks for "PWR colors but slightly different", push back — explain that the brand is fixed and the right answer is to switch to the seminar template instead.

The other tokens (`--pwr-muted`, `--pwr-hair`, `--pwr-bg`) are derived and can be adjusted for legibility if needed.

### Type tokens

```css
--t-cover-title: 92px;
--t-divider:     132px;
--t-title:       60px;
--t-subtitle:    34px;
--t-body:        28px;
--t-small:       24px;
--t-mono:        24px;
```

Smaller than seminar — the rail + footer chrome eats vertical space, so type scales down.

### Fonts

```css
--font-sans:    "Trebuchet MS", "Source Sans 3", system-ui, sans-serif;
--font-display: "Trebuchet MS", "Source Sans 3", system-ui, sans-serif;
--font-mono:    "JetBrains Mono", ui-monospace, "SF Mono", Menlo, monospace;
--font-serif:   "Source Serif 4", "Times New Roman", serif;
```

Trebuchet MS is the official PWR font (with Source Sans 3 as web fallback). Don't change it unless the user explicitly wants a brand-deviation override.

### Spacing tokens

```css
--pad-top:    150px;   /* clears top rail (70px) + breathing room */
--pad-bottom: 130px;   /* clears footer chrome (60px) + breathing room */
--pad-x:      120px;
--gap-title:  48px;
--gap-item:   24px;
--gap-tight:  14px;

--rail-h:    70px;     /* top red rail */
--footer-h:  68px;     /* bottom chrome */
```

If you remove the footer (`body.no-footer`), reduce `--pad-bottom` to ~80px so the slide content doesn't look bottom-heavy.

### Partner logos

The footer's partner strip ships with three logos:
- `hr-excellence.png` — HR Excellence in Research badge
- `unite.png` — Unite! University Network
- `iep-evaluated.png` — IEP (Institutional Evaluation Programme)

These are pre-bundled in `assets/uni/`. To add or remove, edit the `.partners` block in **every** slide's footer (they're inline, not templated), or just use `body.no-partners` to hide the whole strip.

### Speaker name on every slide

Each slide's footer has `<span class="speaker">{Name}</span>`. When generating a deck, replace **every** occurrence (one per slide). Don't rely on a single template variable — the HTML doesn't have one.

---

## Choosing customizations from user cues

When a user gives style cues in natural language, map them to concrete edits:

| User says                          | Apply                                                  |
|------------------------------------|--------------------------------------------------------|
| "make it pop" / "modern" / "tech"  | Space Grotesk display, electric accent `#3756f5`       |
| "make it warm"                     | Coral accent `#d97757`, warm bg `#faf7f2`              |
| "serious" / "academic"             | Defaults (editorial blue, IBM Plex)                    |
| "match the paper aesthetic"        | IBM Plex Serif as display                              |
| "presenting in a dark room"        | `body.dark`                                            |
| "lots of content, content-dense"   | `body.compact`                                         |
| "keynote style" / "minimal"        | `body.spacious`, fewer slides                          |
| "the titles should be assertive"   | `body.action-titles`                                   |
| "no chrome" / "clean"              | `body.no-footer`                                       |
| "code looks too dark"              | `body.code-light`                                      |
| "in Polish too" / "bilingual"      | university template; add `data-pl` everywhere          |
| "for my thesis defence at PWr"     | university template                                    |
| "without the partner logos"        | `body.no-partners`                                     |
