# Slide patterns

Catalog of slide types available across the bundled templates. Each one is a drop-in `<section class="slide" ...>` block. Replace the textual content with the user's material; do not change the structural classes unless you intend to restyle.

Most patterns are identical in HTML structure between the `seminar` and `university` templates — the chrome (header rail, footer) differs but the body markup doesn't. Where a pattern needs a template-specific variation, both are shown.

The `data-label` attribute is used by `deck-stage` for the thumb-rail label. Keep it concise and informative.

Slide chrome (`.slide-header`/`.slide-footer` for seminar, `.rail`/`.footer` for university) is required for page numbers to render. Update **both** the header's "NN / NN" and the footer's "NN / NN" whenever you reorder slides or change the total.

---

## cover

First slide. Title, subtitle, speaker, date, advisor (or affiliation), duration/programme.

### seminar

```html
<section class="slide cover" data-label="01 Cover">
  <div class="cover-top">
    <span><span class="dot">●</span> SEMINAR · WS 2026/27</span>
    <span>CS 7340 · Machine Learning Reading Group</span>
  </div>

  <div class="cover-mid">
    <div class="cover-eyebrow">Student Seminar</div>
    <h1 class="cover-title">{Title — the punchline, balanced wrap}</h1>
    <p class="cover-sub">{One-sentence subtitle: what this talk argues or covers}</p>
  </div>

  <dl class="cover-bottom">
    <div><dt>Speaker</dt>  <dd>{Name}</dd></div>
    <div><dt>Date</dt>     <dd>{D Mon YYYY}</dd></div>
    <div><dt>Advisor</dt>  <dd>{Prof. X}</dd></div>
    <div><dt>Duration</dt> <dd>{30 min · 5 min Q&amp;A}</dd></div>
  </dl>
</section>
```

### university

Two-pane layout. Left pane: PWR logo + faculty tagline + bilingual title block. Right red pane: vertical eagle + speaker meta. Bottom strip: copyright + partner logos. **Every translatable string must be wrapped in `<span class="i18n" data-en="..." data-pl="...">`.**

```html
<section class="slide cover" data-label="01 Cover">
  <div class="cover-left">
    <div class="cover-brand">
      <div class="pwr-mark">
        <img class="lang-en" src="assets/uni/pwr-en-horiz.png" alt="Wrocław University of Science and Technology" />
        <img class="lang-pl" src="assets/uni/pwr-pl-horiz.png" alt="Politechnika Wrocławska" />
      </div>
      <div class="unit-line">
        <span class="i18n" data-en="{Faculty / department, EN}" data-pl="{Wydział, PL}">{Faculty, EN}</span>
      </div>
    </div>

    <div class="cover-title-block">
      <h1 class="cover-title">
        <span class="i18n" data-en="{Title part 1}" data-pl="{Tytuł cz. 1}">{Title part 1}</span>
        <em class="i18n" data-en="{italic emphasised part}" data-pl="{kursywa}">{italic emphasised part}</em>
      </h1>
      <p class="cover-sub">
        <span class="i18n" data-en="{One-sentence subtitle}" data-pl="{Jednozdaniowy podtytuł}">{Subtitle}</span>
      </p>
    </div>
  </div>

  <div class="cover-right">
    <div class="pwr-eagle">
      <img class="lang-en" src="assets/uni/pwr-en-vert-white.png" alt="Wrocław University of Science and Technology" />
      <img class="lang-pl" src="assets/uni/pwr-pl-vert-white.png" alt="Politechnika Wrocławska" />
    </div>
    <dl class="meta-block">
      <div>
        <dt><span class="i18n" data-en="Speaker" data-pl="Prelegent">Speaker</span></dt>
        <dd>{Name}</dd>
      </div>
      <div>
        <dt><span class="i18n" data-en="Advisor" data-pl="Promotor">Advisor</span></dt>
        <dd><span class="i18n" data-en="{Prof. X, PhD, DSc}" data-pl="{prof. X, dr hab. inż.}">{Prof. X}</span></dd>
      </div>
      <div>
        <dt><span class="i18n" data-en="Date · Venue" data-pl="Data · Miejsce">Date · Venue</span></dt>
        <dd><span class="i18n" data-en="{D Mon YYYY · Bldg, room}" data-pl="{D miesiąc YYYY · Bud, sala}">{Date · Venue}</span></dd>
      </div>
      <div>
        <dt><span class="i18n" data-en="Programme" data-pl="Program">Programme</span></dt>
        <dd><span class="i18n" data-en="{Programme / course code}" data-pl="{Program / kod kursu}">{Programme}</span></dd>
      </div>
    </dl>
  </div>

  <div class="cover-strip">
    <div class="copy">
      © 2026 <span class="i18n" data-en="Wrocław University of Science and Technology" data-pl="Politechnika Wrocławska">Wrocław University of Science and Technology</span> · pwr.edu.pl
    </div>
    <div class="partners">
      <img src="assets/uni/hr-excellence.png" alt="HR Excellence in Research" />
      <span class="sep"></span>
      <img src="assets/uni/unite.png" alt="Unite! Network" />
      <span class="sep"></span>
      <img src="assets/uni/iep-evaluated.png" alt="IEP Evaluated" />
    </div>
  </div>
</section>
```

If the talk is English-only, you can still leave the `data-pl` attributes — the lang toggle just won't be used. Don't drop the i18n spans wholesale; future readers will expect them.

---

## agenda

Numbered list of sections with right-aligned meta (subtitle / time estimate).

```html
<!-- seminar -->
<section class="slide" data-label="02 Agenda">
  <div class="slide-header">
    <span><span class="dot">●</span> 02 / NN</span>
    <span>Overview</span>
  </div>

  <div class="content" style="gap: 56px; padding-top: 24px;">
    <div class="stack-tight">
      <div class="eyebrow">Outline</div>
      <h2 class="title">
        <span class="title-topic">Agenda</span>
        <span class="title-action">{N sections, M minutes}</span>
      </h2>
    </div>

    <ol class="numbered agenda-list">
      <li>
        <span class="idx">01</span>
        <span class="li-title">{Section name}</span>
        <span class="li-meta">{One-line subtitle}</span>
      </li>
      <!-- repeat 3–6 times -->
    </ol>
  </div>

  <div class="slide-footer">
    <span>{Speaker} · {Term}</span>
    <span>02 / NN</span>
  </div>
</section>
```

For the university template, the structure is the same but the chrome wrapping changes (`.rail` + `.footer` with the PWR logo strip — see the template's slide 02 for the live version). The university template uses `<ol class="agenda">` and bilingual `.i18n` spans on every label.

---

## section-divider

Big numeral + section title between major chapters.

```html
<section class="slide divider" data-label="03 Section · Background">
  <div class="divider-num">01</div>
  <h2 class="divider-title">{Section title}</h2>
  <div class="divider-meta">
    <span>Section 01 of NN</span>
    <span>~6 minutes</span>
  </div>
</section>
```

For an inverted/dark variant (used for the appendix), see [`appendix-divider`](#appendix-divider).

---

## definition

A definition card on the left (term + formal notation + plain-language gloss) paired with a "in practice" bullet column on the right. Use when introducing the single key concept the talk hinges on.

```html
<section class="slide" data-label="03 Background · Definition">
  <div class="slide-header">
    <span><span class="dot">●</span> 03 / NN</span>
    <span>{Section · Key concept}</span>
  </div>

  <div class="content">
    <div class="stack-tight">
      <div class="eyebrow">Key concept</div>
      <h2 class="title">
        <span class="title-topic">Definition</span>
        <span class="title-action">{The term, in one breath}</span>
      </h2>
    </div>

    <div class="def-grid">
      <div class="def-card">
        <div class="def-tag">Definition</div>
        <h3 class="def-term">{Term}</h3>
        <p class="def-notation">{Formal notation, e.g. f<sub>θ</sub> : 𝒢 → ℝ<sup>d</sup>}</p>
        <p class="def-body">{Two-sentence plain-language definition.}</p>
      </div>
      <div>
        <div class="def-side-h">In practice</div>
        <ul class="bullets" style="margin-top: 8px;">
          <li><span class="idx">i.</span>
            <div><span class="li-title">{Property.}</span>
                 <span class="li-desc">{One-sentence elaboration.}</span></div></li>
          <!-- 2-3 more -->
        </ul>
      </div>
    </div>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>03 / NN</span></div>
</section>
```

---

## bullets

Slide title + subtitle + 3–6 list items. Each item has an index (`i.`, `ii.`, ... or `01`, `02`, ...), a bolded claim, and a muted elaboration.

```html
<section class="slide" data-label="05 Background · Problem">
  <div class="slide-header"><span><span class="dot">●</span> 05 / NN</span><span>{Section · subtitle}</span></div>

  <div class="content">
    <div class="stack-tight">
      <div class="eyebrow">{01 — Section}</div>
      <h2 class="title">
        <span class="title-topic">{Topic title}</span>
        <span class="title-action">{Action title — the assertion}</span>
      </h2>
      <p class="subtitle">{One-sentence framing.}</p>
    </div>

    <ul class="bullets">
      <li>
        <span class="idx">i.</span>
        <div>
          <span class="li-title">{Short bolded claim.}</span>
          <span class="li-desc">{One-sentence elaboration.}</span>
        </div>
      </li>
      <!-- 2–5 more -->
    </ul>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>05 / NN</span></div>
</section>
```

Swap `<ul class="bullets">` → `<ol class="numbered">` with `01`/`02`/... indices for numbered lists. On the university template, you can also apply `body.bullets-square` or `body.bullets-dash` to change the bullet glyph.

---

## quote

Pull-quote slide. Use sparingly — at most one per deck.

```html
<section class="slide" data-label="06 Motivation · Quote">
  <div class="slide-header"><span><span class="dot">●</span> 06 / NN</span><span>{Section · Motivation}</span></div>

  <div class="content">
    <div class="quote-wrap">
      <div class="quote-mark">"</div>
      <div>
        <p class="quote-body">{The quote — short, balanced wrap, one or two sentences.}</p>
        <div class="quote-attr">
          <span class="name">{Author}</span><span>·</span>
          <span>{Source title}</span><span>·</span>
          <span>{Year}</span>
        </div>
      </div>
    </div>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>06 / NN</span></div>
</section>
```

---

## full-bleed

Full-screen photo with a gradient shade and bottom-anchored title + subtitle. Used to drop the audience into a domain context (a lab photo, a hero molecule, a city skyline). The `image-slot` placeholder is filled at presentation time.

```html
<section class="slide bleed" data-label="07 Background · Domain context">
  <div class="bleed-img">
    <image-slot id="bleed-context" shape="rect" placeholder="Drop a hero image here"></image-slot>
  </div>
  <div class="bleed-shade"></div>

  <div class="bleed-chrome">
    <span><span class="dot">●</span> 07 / NN</span>
    <span>{Section · Domain context}</span>
  </div>

  <div class="bleed-content">
    <div class="bleed-eye">{Section}</div>
    <h2 class="bleed-title">{The single sentence the photo argues for.}</h2>
    <p class="bleed-sub">{Optional supporting detail — one sentence.}</p>
  </div>

  <div class="bleed-cred">PHOTO · {credit}</div>
</section>
```

Notes: the `.bleed` slide overrides default padding; the chrome (`.bleed-chrome` instead of `.slide-header`) sits on top of the photo with a translucent gradient behind it. Light *and* dark mode look the same here — the shade does the work.

---

## pipeline

Horizontal 5-step process. Each step: index + heading + description + small mono tag.

```html
<section class="slide" data-label="09 Method · Pipeline">
  <div class="slide-header"><span><span class="dot">●</span> 09 / NN</span><span>{Method · Pipeline}</span></div>

  <div class="content">
    <div class="stack-tight">
      <div class="eyebrow">{02 — Method}</div>
      <h2 class="title">
        <span class="title-topic">Pipeline</span>
        <span class="title-action">{N stages, end to end}</span>
      </h2>
    </div>

    <div class="pipeline">
      <div class="step">
        <div class="step-idx">01</div>
        <h3 class="step-h">{Stage name}</h3>
        <p class="step-d">{One-sentence description.}</p>
        <div class="step-tag">{tool · cost / unit}</div>
      </div>
      <!-- exactly 5 steps -->
    </div>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>09 / NN</span></div>
</section>
```

Grid is hard-coded to 5 columns. For 3 or 4 stages, either pad with input/output steps or change `grid-template-columns: repeat(5, 1fr)` to your actual count.

---

## comparison

Two-column side-by-side comparison. Column B (`.alt`) is accented.

```html
<section class="slide" data-label="10 Method · Comparison">
  <div class="slide-header"><span><span class="dot">●</span> 10 / NN</span><span>{Method · Related work}</span></div>

  <div class="content">
    <div class="stack-tight">
      <div class="eyebrow">{02 — Method}</div>
      <h2 class="title">
        <span class="title-topic">{Two-option topic}</span>
        <span class="title-action">{The differentiator}</span>
      </h2>
    </div>

    <div class="cols-2">
      <div class="compare-col">
        <div class="compare-tag">A · {Label}</div>
        <h3 class="compare-h">{One-sentence summary of A.}</h3>
        <p class="compare-body">{Two-sentence elaboration.}</p>
        <ul class="compare-list">
          <li>{Property.}</li>
          <li>{Property.}</li>
          <li>{Property.}</li>
        </ul>
      </div>
      <div class="compare-col alt">
        <div class="compare-tag">B · {Label}</div>
        <h3 class="compare-h">{One-sentence summary of B.}</h3>
        <p class="compare-body">{Two-sentence elaboration.}</p>
        <ul class="compare-list">
          <li>{Property.}</li>
          <li>{Property.}</li>
          <li>{Property.}</li>
        </ul>
      </div>
    </div>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>10 / NN</span></div>
</section>
```

---

## comparison-3col

Three-column variant — same `.compare-col` markup, wrapped in `<div class="cols-3">`. Use for "three families / three flavors / three approaches" overviews. The middle column is typically marked `.alt` to highlight the recommended option.

```html
<div class="cols-3">
  <div class="compare-col">
    <div class="compare-tag">A · {Label}</div>
    <h3 class="compare-h">{Summary of A.}</h3>
    <p class="compare-body">{Elaboration.}</p>
    <ul class="compare-list">
      <li>{Property.}</li><li>{Property.}</li><li>{Property.}</li>
    </ul>
  </div>
  <div class="compare-col alt">
    <div class="compare-tag">B · {Label}</div>
    <h3 class="compare-h">{Summary of B.}</h3>
    <p class="compare-body">{Elaboration.}</p>
    <ul class="compare-list">
      <li>{Property.}</li><li>{Property.}</li><li>{Property.}</li>
    </ul>
  </div>
  <div class="compare-col">
    <div class="compare-tag">C · {Label}</div>
    <h3 class="compare-h">{Summary of C.}</h3>
    <p class="compare-body">{Elaboration.}</p>
    <ul class="compare-list">
      <li>{Property.}</li><li>{Property.}</li><li>{Property.}</li>
    </ul>
  </div>
</div>
```

The 3-col grid auto-scales the headings down (`compare-h` is 36px instead of 52px). Keep summaries short or they'll line-wrap awkwardly.

---

## equation

Large display equation on a soft-bg panel + a "where" list of variable definitions on the right.

The equation uses semantic spans (`.var`, `.op`, `.fn`, `.agg`) so weights and colors render correctly. Italic math variables use the serif font.

```html
<section class="slide" data-label="12 Method · Update rule">
  <div class="slide-header"><span><span class="dot">●</span> 12 / NN</span><span>{Method · Update rule}</span></div>

  <div class="content">
    <div class="stack-tight">
      <div class="eyebrow">{02 — Method}</div>
      <h2 class="title">
        <span class="title-topic">{Equation name}</span>
        <span class="title-action">{The equation, in one line}</span>
      </h2>
    </div>

    <div class="eq-grid">
      <div class="eq-display">
        <p class="eq">
          <span class="var">h</span><sub><span class="var">v</span></sub><sup>(<span class="var">l</span>+1)</sup>
          <span class="op">=</span>
          <span class="fn">σ</span>
          <span class="paren">(</span>
            <span class="var">W</span><sup>(<span class="var">l</span>)</sup>
            <span class="op">·</span>
            <span class="agg">MEAN</span><sub><span class="var">u</span> ∈ 𝒩(<span class="var">v</span>)</sub>
            <span class="paren">(</span><span class="var">h</span><sub><span class="var">u</span></sub><sup>(<span class="var">l</span>)</sup><span class="paren">)</span>
          <span class="paren">)</span>
        </p>
        <p class="eq-cap">{One-line caption: when / how many times applied.}</p>
      </div>

      <dl class="eq-vars">
        <div><dt>h<sub>v</sub><sup>(l)</sup></dt><dd>{Definition.}</dd></div>
        <div><dt>𝒩(v)</dt><dd>{Definition.}</dd></div>
        <div><dt>σ</dt><dd>{Definition.}</dd></div>
        <!-- one row per symbol -->
      </dl>
    </div>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>12 / NN</span></div>
</section>
```

Use HTML entities for greek letters: `σ`, `θ`, `α`, `β`, `ε`, `λ`. Use `<sub>`/`<sup>` for indices. Wrap aggregators (MEAN, SUM, MAX) in `<span class="agg">` so they render in mono-caps.

---

## code

Syntax-highlighted pseudocode or snippet on the left, framed notes on the right.

The code block uses `<div class="line">` rows with a `<span class="ln">` for line number and a content span. Inline highlight classes: `.kw` (keyword), `.cm` (comment), `.fn` (function name), `.str` (string), `.num` (number), `.ind` (one indent level).

```html
<section class="slide" data-label="13 Method · Pseudocode">
  <div class="slide-header"><span><span class="dot">●</span> 13 / NN</span><span>{Method · Pseudocode}</span></div>

  <div class="content">
    <div class="stack-tight">
      <div class="eyebrow">{02 — Method}</div>
      <h2 class="title">
        <span class="title-topic">{Function name / topic}</span>
        <span class="title-action">{N phases, M lines of code}</span>
      </h2>
    </div>

    <div class="code-grid">
      <div class="code-block">
        <div class="filename">
          <span>{filename.py}</span>
          <span>{N lines · {lang}}</span>
        </div>
        <div class="line"><span class="ln">1</span><span><span class="kw">def</span> <span class="fn">forward</span>(self, batch):</span></div>
        <div class="line"><span class="ln">2</span><span><span class="ind"></span><span class="cm"># comment</span></span></div>
        <div class="line"><span class="ln">3</span><span><span class="ind"></span>h = self.atom_embed(batch.x)</span></div>
        <div class="line blank"><span class="ln"></span><span></span></div>
        <!-- ... -->
      </div>

      <div class="code-notes">
        <div class="code-note">
          <h4>{Phase 1 label}</h4>
          <p>{One-sentence explanation.}</p>
        </div>
        <div class="code-note">
          <h4>{Phase 2 label}</h4>
          <p>{One-sentence explanation.}</p>
        </div>
        <div class="code-note">
          <h4>{Phase 3 label}</h4>
          <p>{One-sentence explanation.}</p>
        </div>
      </div>
    </div>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>13 / NN</span></div>
</section>
```

Add `<body class="code-light">` if you want the code block on a light background (matches the rest of the deck in light mode). Default is near-black for contrast.

Keep snippets to ~15 lines max. The block doesn't scroll; longer code gets cut. Use `<div class="line blank">` for visual gaps.

---

## big-number

Headline statistic. One huge number, one label, one paragraph of context, one footnote.

```html
<section class="slide" data-label="14 Results · Headline">
  <div class="slide-header"><span><span class="dot">●</span> 14 / NN</span><span>{Results · Headline}</span></div>

  <div class="content">
    <div class="stat-grid">
      <div>
        <p class="big-num">{+8.4}<span class="unit">{%}</span></p>
      </div>
      <div class="stat-side">
        <div class="stat-label">{Metric · scope}</div>
        <p class="stat-desc">{What the number means, in context.}</p>
        <div class="stat-foot">{Methodology footnote — sample size, CI, etc.}</div>
      </div>
    </div>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>14 / NN</span></div>
</section>
```

---

## bar-chart

6-bar chart with a winning bar (`.win`, accent-filled with a star above) + callout sidebar.

Bars are sized with inline `style="height: NN%;"` (percent of plot area). Pick one bar as `.win` to highlight your method.

```html
<section class="slide" data-label="15 Results · Per-dataset chart">
  <div class="slide-header"><span><span class="dot">●</span> 15 / NN</span><span>{Results · Per-dataset}</span></div>

  <div class="content">
    <div class="stack-tight">
      <div class="eyebrow">{03 — Results}</div>
      <h2 class="title">
        <span class="title-topic">{Topic}</span>
        <span class="title-action">{The headline reading}</span>
      </h2>
    </div>

    <div class="chart-wrap">
      <div class="bar-chart">
        <div class="bars-row">
          <div class="bar"     style="height: 77%;"><span class="bar-val">{0.77}</span></div>
          <div class="bar"     style="height: 83%;"><span class="bar-val">{0.83}</span></div>
          <div class="bar"     style="height: 64%;"><span class="bar-val">{0.64}</span></div>
          <div class="bar win" style="height: 91%;"><span class="bar-val">{0.91}</span></div>
          <div class="bar"     style="height: 80%;"><span class="bar-val">{0.80}</span></div>
          <div class="bar"     style="height: 87%;"><span class="bar-val">{0.87}</span></div>
        </div>
        <div class="bar-labels">
          <span class="bar-label">{Label1}</span>
          <span class="bar-label">{Label2}</span>
          <!-- 6 total -->
        </div>
      </div>

      <div class="chart-side">
        <p class="chart-callout-num">{4 / 6}</p>
        <p class="chart-callout-lbl">{What the callout means}</p>
        <ul>
          <li>{Observation 1.}</li>
          <li>{Observation 2.}</li>
          <li>{Observation 3.}</li>
        </ul>
      </div>
    </div>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>15 / NN</span></div>
</section>
```

Grid is fixed to 6 bars. If you have fewer, change `grid-template-columns: repeat(6, 1fr)` on `.bars-row` and `.bar-labels` to your count.

---

## table

Data table with `.best` row highlighting and `.delta-pos` / `.delta-neg` cell highlighting. Cap at ~7 rows.

```html
<section class="slide" data-label="16 Results · Table">
  <div class="slide-header"><span><span class="dot">●</span> 16 / NN</span><span>{Results · Full numbers}</span></div>

  <div class="content">
    <div class="stack-tight">
      <div class="eyebrow">{03 — Results}</div>
      <h2 class="title">
        <span class="title-topic">{Topic}</span>
        <span class="title-action">{Headline reading}</span>
      </h2>
    </div>

    <table class="data">
      <thead>
        <tr>
          <th>{Row label}</th>
          <th class="num">{Numeric column}</th>
          <th class="num">Δ vs. baseline</th>
        </tr>
      </thead>
      <tbody>
        <tr class="best">
          <td>{Row}</td>
          <td class="num">{value}</td>
          <td class="num delta-pos">{+0.057}</td>
        </tr>
        <tr>
          <td>{Row}</td>
          <td class="num">{value}</td>
          <td class="num">{+0.034}</td>
        </tr>
      </tbody>
    </table>
    <div class="table-cap">{Caption: metric, splits, seeds, highlighting meaning.}</div>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>16 / NN</span></div>
</section>
```

---

## image-led

Figure on the right, framing text on the left. `<image-slot>` is filled at presentation time.

```html
<section class="slide" data-label="17 Results · Architecture">
  <div class="slide-header"><span><span class="dot">●</span> 17 / NN</span><span>{Results · Architecture}</span></div>

  <div class="content image-led">
    <div class="image-side stack-tight">
      <div class="eyebrow">{03 — Results}</div>
      <h2 class="title">
        <span class="title-topic">{Topic}</span>
        <span class="title-action">{What the figure shows}</span>
      </h2>
      <p class="subtitle" style="margin-top: 16px;">{One-paragraph framing.}</p>
      <div class="caption-row">
        <span>FIG. 1</span>
        <span>{Short figure caption}</span>
      </div>
    </div>
    <div class="image-frame">
      <image-slot id="fig-{slug}" shape="rect" placeholder="Drop your figure here"></image-slot>
    </div>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>17 / NN</span></div>
</section>
```

---

## image-grid

3 × 2 grid of 6 image tiles. Each tile has a caption row with a left label and a right value (use `.pos` for accent-colored positive values, `.neg` for muted negative values). Good for showing qualitative samples — predictions on test cases, exemplars, mode failures.

```html
<section class="slide" data-label="18 Results · Qualitative">
  <div class="slide-header"><span><span class="dot">●</span> 18 / NN</span><span>{Results · Qualitative samples}</span></div>

  <div class="content">
    <div class="stack-tight">
      <div class="eyebrow">{03 — Results}</div>
      <h2 class="title">
        <span class="title-topic">{Topic}</span>
        <span class="title-action">{What the grid demonstrates}</span>
      </h2>
    </div>

    <div class="img-grid">
      <div class="img-tile">
        <div class="img-tile-frame"><image-slot id="qual-1" shape="rect" placeholder="Sample 1"></image-slot></div>
        <div class="img-tile-cap"><span>{label}</span><span class="pos">{+ value}</span></div>
      </div>
      <!-- exactly 6 tiles -->
    </div>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>18 / NN</span></div>
</section>
```

---

## contributions

3-card grid for the deck's claims. Each card: huge index, claim heading, one-sentence elaboration, tag pointing to where it's substantiated (ablation, section, appendix).

```html
<section class="slide" data-label="19 Discussion · Contributions">
  <div class="slide-header"><span><span class="dot">●</span> 19 / NN</span><span>{Discussion · Contributions}</span></div>

  <div class="content">
    <div class="stack-tight">
      <div class="eyebrow">{04 — Discussion}</div>
      <h2 class="title">
        <span class="title-topic">Contributions</span>
        <span class="title-action">{Three claims, each backed by an ablation}</span>
      </h2>
      <p class="subtitle">{One-sentence framing — short, defensible, falsifiable.}</p>
    </div>

    <ol class="claims">
      <li>
        <span class="idx">01</span>
        <h3 class="claim-h">{First claim, as a single sentence.}</h3>
        <p class="claim-d">{What the evidence shows.}</p>
        <div class="claim-tag">→ {Ablation: §4.2}</div>
      </li>
      <li>
        <span class="idx">02</span>
        <h3 class="claim-h">{Second claim.}</h3>
        <p class="claim-d">{Evidence summary.}</p>
        <div class="claim-tag">→ {Ablation: §4.3}</div>
      </li>
      <li>
        <span class="idx">03</span>
        <h3 class="claim-h">{Third claim.}</h3>
        <p class="claim-d">{Evidence summary.}</p>
        <div class="claim-tag">→ {Ablation: §4.4}</div>
      </li>
    </ol>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>19 / NN</span></div>
</section>
```

Three cards is the design intent. Four works but feels tight; two looks empty.

---

## limitations

Three-column row per limit: warning glyph + (heading + body) + accent-bordered "what we did" box. Pair every limitation with a concrete mitigation.

```html
<section class="slide" data-label="20 Discussion · Limitations">
  <div class="slide-header"><span><span class="dot">●</span> 20 / NN</span><span>{Discussion · Limitations}</span></div>

  <div class="content">
    <div class="stack-tight">
      <div class="eyebrow">{04 — Discussion}</div>
      <h2 class="title">
        <span class="title-topic">Limitations</span>
        <span class="title-action">{N caveats — and what we did about each}</span>
      </h2>
    </div>

    <ul class="limits">
      <li>
        <span class="lim-sign">!</span>
        <div>
          <h3 class="lim-h">{Limitation, as a single sentence.}</h3>
          <p class="lim-d">{Why this is a problem.}</p>
        </div>
        <div class="lim-fix">
          <b>What we did</b>
          {Concrete mitigation, one sentence.}
        </div>
      </li>
      <!-- 2–4 more -->
    </ul>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>20 / NN</span></div>
</section>
```

The `<b>` inside `.lim-fix` is styled as an uppercase eyebrow — use it for tagging the fix type (`What we did`, `Next`, `Mitigation`, `Workaround`).

---

## timeline

6-column horizontal timeline. Each column: month, status pill (`.tl-pill` or `.tl-pill.alt` for milestone), one-line note.

```html
<section class="slide" data-label="21 Plan · Timeline">
  <div class="slide-header"><span><span class="dot">●</span> 21 / NN</span><span>{Plan · Schedule}</span></div>

  <div class="content">
    <div class="stack-tight">
      <div class="eyebrow">{Thesis plan}</div>
      <h2 class="title">
        <span class="title-topic">Schedule</span>
        <span class="title-action">{N months, M milestones}</span>
      </h2>
    </div>

    <div class="timeline">
      <div class="tl-col">
        <div class="tl-month">{May}</div>
        <span class="tl-pill">{Phase}</span>
        <p class="tl-note">{What happens this month}</p>
      </div>
      <!-- exactly 6 columns -->
    </div>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>21 / NN</span></div>
</section>
```

Use `<span class="tl-pill alt">` (accent-coloured) to mark milestone months.

---

## acknowledgements

3-column grid: People · Funding · Resources. Each column has a tag + list of credits with role/grant-number subtext.

```html
<section class="slide" data-label="22 Acknowledgements">
  <div class="slide-header"><span><span class="dot">●</span> 22 / NN</span><span>Acknowledgements</span></div>

  <div class="content">
    <div class="stack-tight">
      <div class="eyebrow">Thanks</div>
      <h2 class="title">
        <span class="title-topic">Acknowledgements</span>
        <span class="title-action">{People, funding, and resources I leaned on}</span>
      </h2>
    </div>

    <div class="ack-grid">
      <div class="ack-col">
        <div class="ack-tag">People</div>
        <ul>
          <li>{Name}<span class="role">{Role / contribution}</span></li>
          <li>{Name}<span class="role">{Role}</span></li>
        </ul>
      </div>
      <div class="ack-col">
        <div class="ack-tag">Funding</div>
        <ul>
          <li>{Funder name}<span class="grant">{Grant number / programme}</span></li>
        </ul>
      </div>
      <div class="ack-col">
        <div class="ack-tag">Resources</div>
        <ul>
          <li>{Resource}<span class="role">{What it gave you}</span></li>
        </ul>
      </div>
    </div>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>22 / NN</span></div>
</section>
```

The columns are right-aligned in intent: People first (most personal), then Funding (institutional), then Resources (tools/data). Don't pad with filler — three credits per column is plenty.

---

## references

Two-column references list. Cite venue in italic, DOI/arxiv in mono.

```html
<section class="slide" data-label="23 References">
  <div class="slide-header"><span><span class="dot">●</span> 23 / NN</span><span>References</span></div>

  <div class="content">
    <div class="stack-tight">
      <div class="eyebrow">Sources</div>
      <h2 class="title">
        <span class="title-topic">References</span>
        <span class="title-action">{The N papers this talk leans on}</span>
      </h2>
    </div>

    <ol class="refs">
      <li>
        <span class="ref-idx">[1]</span>
        <div class="ref-body">
          <span class="ref-authors">{Authors}</span>
          {Title.} <span class="ref-venue">{Venue}</span>, {year}.
          <span class="ref-doi">{arXiv:1234.5678}</span>
        </div>
      </li>
    </ol>
  </div>

  <div class="slide-footer"><span>{Speaker} · {Term}</span><span>23 / NN</span></div>
</section>
```

---

## qa

Closing slide. Large headline, optional sub, contact info at the bottom.

```html
<section class="slide qa" data-label="24 Q&amp;A">
  <div class="cover-top">
    <span><span class="dot">●</span> 24 / NN</span>
    <span>End of talk</span>
  </div>

  <div class="qa-mid">
    <div class="qa-eyebrow">{Thanks for listening}</div>
    <h2 class="qa-h">Q&amp;A</h2>
    <p class="qa-sub">{One-sentence restatement of the takeaway, or "ask me anything about X".}</p>
  </div>

  <dl class="qa-bottom">
    <div><dt>Contact</dt> <dd>{name@email}</dd></div>
    <div><dt>Code / data</dt> <dd>{github.com/...}</dd></div>
    <div><dt>Slides</dt> <dd>{short URL}</dd></div>
  </dl>
</section>
```

---

## appendix-divider

A dark-inverted variant of the section divider, used to introduce backup material that you'll only show if there's time at the end. Use the letter `A` (or `A1`, `A2` for multiple appendices) as the numeral.

```html
<section class="slide divider divider-dark" data-label="25 Appendix">
  <div class="divider-num">A</div>
  <h2 class="divider-title">Appendix</h2>
  <div class="divider-meta">
    <span>Backup material · if we have time</span>
    <span>25 / 25</span>
  </div>
</section>
```

After this divider, any further slides should be backup content — extra ablations, math derivations, FAQs you anticipate, contact-detail close-ups.

---

## Choosing patterns for a deck

For a default ~25–30-minute seminar, a strong sequence is:

1. cover
2. agenda
3. definition (if there's one key term the talk hinges on)
4. section-divider (background)
5. bullets (problem framing)
6. quote (motivation) — *optional*
7. full-bleed (domain photo) — *optional, scene-setting*
8. section-divider (method)
9. pipeline (method overview)
10. comparison or comparison-3col (related work / families)
11. equation (the one equation that matters)
12. code (the kernel of the method, in ~15 lines)
13. section-divider (results)
14. big-number (headline)
15. bar-chart (per-task)
16. table (full numbers)
17. image-led (architecture diagram)
18. image-grid (qualitative samples) — *optional*
19. contributions
20. limitations
21. timeline (thesis plan only; skip otherwise)
22. acknowledgements
23. references
24. qa
25. appendix-divider (+ backup slides) — *optional*

**Shorter (≤15 min):** drop section dividers, drop quote/full-bleed/image-grid, keep one results slide. Aim for 8–12 slides total.

**Longer (45–60 min):** add a second comparison, more code, a second bar-chart on ablations, and add appendix slides after the divider.

**Lightning (≤5 min):** cover → one definition or bullets → one big-number → qa. Skip section dividers entirely; they're more chrome than content for a 5-min slot.
