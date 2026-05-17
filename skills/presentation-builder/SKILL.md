---
name: presentation-builder
description: Produce a polished, customizable HTML presentation deck plus a matching teleprompter-style speaker script from the user's topic, outline, or source material. Use this skill whenever the user wants to build, draft, generate, or write a presentation, slide deck, seminar talk, lecture, conference talk, lightning talk, thesis defence, journal-club talk, or any kind of slides — even if they don't say the word "template". Also use when the user provides a paper, notes, or outline and asks to "turn this into slides", "make a talk out of this", "prepare a presentation for X", or wants a speaker script / teleprompter script to accompany a deck. The skill chooses the right template from a registry (currently `seminar` for generic academic talks, `university` for Politechnika Wrocławska / Wrocław University of Science and Technology talks with built-in EN/PL bilingual support), tailors theme/colors/density/dark mode/language to the user's taste, lays out a coherent narrative arc using the catalog of 24 slide patterns (cover, agenda, definition, full-bleed, equation, code, bar-chart, contributions, limitations, acknowledgements, and more), and writes both the deck.html and a spoken-style script.md.
---

# Presentation Builder

You build two artifacts together: a self-contained **HTML deck** (based on one of the bundled templates) and a **teleprompter-style speaker script** (`script.md`) that the user can read aloud while presenting. The deck is the artifact; the script is the performance.

Treat this as one job, not two. The script is written from the same outline as the deck, in the same voice, in the same order. They ship together.

## When to engage

Trigger on any request that resembles building slides, writing a talk, or preparing a presentation — including when the user is vague ("help me prepare for Friday's seminar"), when they hand you a paper or notes and ask for "slides", when they ask for just a speaker script for an existing deck, or when they want to redesign / re-theme an existing deck of this style.

Don't trigger for: requests to *review* slides without producing new ones, generic writing tasks unrelated to presenting, or non-slide visual design (posters, infographics, etc.).

## The workflow

The work happens in five phases. Do them in order. Don't skip the intake — bad inputs make bad decks.

### 1. Pick a template

Read `references/templates.md` to see the registry of available templates and what each one is good for. Match the user's brief against the listed strengths:

- If exactly one template is a clear fit, use it and tell the user which one and why in one sentence.
- If two or more could fit, ask the user to choose, briefly characterizing each option.
- If none clearly fits but one is close, propose it and offer to deviate from its default slide set.

The registry currently has two entries:
- **`seminar`** — generic academic style, fully customizable colors/fonts/density, no institutional branding.
- **`university`** — Politechnika Wrocławska (Wrocław University of Science and Technology) brand-locked template with bilingual EN/PL support and partner logos. Pick this if the user is a PWR student/staff or asks for "my university template", "Polish university", a bilingual deck, etc.

Match the user's brief against `references/templates.md` — the "Choosing between them" table at the bottom is the short version. Write your choice into the deck folder's `README` so it's obvious later.

### 2. Intake

Before drafting anything, you need four things. Ask for whatever is missing in a single batched question (use `AskUserQuestion`), not one at a time:

1. **Topic and angle.** What's the talk about, and what's the one thing the audience should walk away with? If they gave a paper/notes, read those first and propose the angle yourself for confirmation.
2. **Audience and duration.** Who's in the room? How long do they have to talk (and how long for Q&A)? Duration sets slide count — see `references/best-practices.md` for the rule of thumb.
3. **Source material.** Is there a paper, draft, repo, or set of notes you should base this on? Read it before drafting. If they only have a topic, that's fine — flag that you'll be writing more from general knowledge.
4. **Style preferences.** Light or dark? Accent color (or "pick one")? Density (compact / regular / spacious)? Title style (topic-style nouns or action-style sentences)? Font swap (defaults are IBM Plex Sans/Mono — see `references/customization.md` for swap options)? Footer on or off? It's fine for the user to say "you pick" — make reasonable choices and note them.

If the user already gave most of this in their initial message, only ask for what's actually missing. Don't make them repeat themselves.

### 3. Plan the deck structure

Before writing any HTML, write a slide-by-slide outline in plain text and show it to the user for sign-off. Each line: slide number, slide-type (from the patterns catalog), one-sentence purpose.

The point of this step is to surface structural problems while they're cheap to fix. If you write 14 full slides and *then* the user says "actually I don't want a section on related work", you've wasted both of your time.

Read `references/best-practices.md` for guidance on narrative arc, pacing, and how to map duration to slide count. Read `references/slide-patterns.md` to know which slide types are available and what each is for.

Once the user signs off (or after a reasonable wait if they said "just go"), proceed.

### 4. Assemble the deck

Copy the chosen template's source files into a new output folder (default: the user's current working directory, inside a subfolder named after the topic). The template lives at `assets/templates/<template-id>/` — you'll find an HTML file plus its companion JS web components (`deck-stage.js`, `image-slot.js`) and the React tweaks panel.

**Copy the entire template folder, not just the HTML.** For `university` specifically, this means also copying the `assets/uni/` subfolder containing the official PWR logos (`pwr-en-horiz.png`, `pwr-pl-horiz-white.png`, partner badges, etc.) — without those, the red rail and cover panel will render as broken image icons. The HTML references them via relative paths like `assets/uni/pwr-en-horiz.png`, so the folder structure inside the output must mirror the template.

Then edit the HTML in-place:

1. **Replace slide content** with the user's material. Use `references/slide-patterns.md` as the catalog — there are now ~24 patterns (cover, agenda, section-divider, definition, bullets, quote, full-bleed, pipeline, comparison, comparison-3col, equation, code, big-number, bar-chart, table, image-led, image-grid, contributions, limitations, timeline, acknowledgements, references, qa, appendix-divider). Pick what fits the user's content rather than mechanically using all 24. Preserve the surrounding chrome (header/footer or rail/footer) and update page numbers.
2. **Apply customizations.** Read `references/customization.md`. The two templates have different knobs:
   - **seminar:** body classes `dark`, `compact`, `spacious`, `action-titles`, `no-footer`, `code-light`; CSS vars `--accent`, `--bg`, `--fg`, `--font-sans`, `--font-display`, `--font-mono`.
   - **university:** body classes `lang-en` / `lang-pl`, `dark`, `compact`, `spacious`, `no-footer`, `no-partners`, `code-light`, `bullets-square`, `bullets-dash`. Brand colors (`--pwr-red`, `--pwr-cream`) are **locked** — do not override unless the user explicitly requests a brand exception. For bilingual decks, every translatable string must be wrapped in `<span class="i18n" data-en="..." data-pl="...">` and matching images need `lang-en`/`lang-pl` variants.
   - For both: edit the speaker-notes JSON array (one note per slide) — keep in sync with `script.md` as a fallback.
3. **Update metadata** at the top: `<title>`, the cover slide's title/subtitle/speaker/affiliation/date/programme, and every slide's footer/header text. For `university`, replace **every** occurrence of `Your Name` in `<span class="speaker">` — there's no single template variable, the name appears on every slide's footer.
4. **Renumber.** When you add or remove slides, fix every `NN / NN` reference in both headers (or rail's `.meta`) and footers. Don't leave stale counts.

### 5. Write the speaker script

Create `script.md` next to the HTML. One section per slide, in the same order as the deck. Read `references/script-style.md` for the voice — it's a teleprompter style, written for speaking aloud, with natural transitions between slides ("Alright, moving on..." / "Now, here's where it gets interesting...").

Each section should include:
- A heading with the slide number and title.
- The spoken text itself — short sentences, contractions OK, written the way the user would actually talk.
- A bracketed cue at the start of any slide where they should pause, click something, or change tone (e.g. `[pause, then click to advance]`).

Time the script: target roughly the user's slot duration at ~140 words per minute. If it's way off, say so and offer to expand or trim.

## Output

Deliver, in the output folder:
- `deck.html` (renamed from the template file)
- `script.md` (unless the user explicitly opted out)
- `deck-stage.js`, `image-slot.js`, `tweaks-panel.jsx` (copied verbatim from the template)
- For the `university` template: `assets/uni/` folder with all the PWR logos and partner badges (copied verbatim) — the HTML references these via relative paths and the deck won't render correctly without them.
- A short `README.md` recording the template used, the customization choices made, the language (for university), and how to open the deck (just open `deck.html` in a browser).

Tell the user where the files are and how to view them. Don't print the full HTML or script into the chat — link them to the files.

## Adding more templates later

When the user later adds a new template, append an entry to `references/templates.md` (the registry), drop the template's source files into a new `assets/templates/<id>/` folder, and — if it has slide patterns that don't already exist in `slide-patterns.md` — add them there with HTML snippets. The selection step in phase 1 then automatically considers the new template.

## Reference files

- `references/templates.md` — registry of available templates and what each one is for.
- `references/best-practices.md` — narrative arc, slide count per duration, density, type hierarchy, what to avoid.
- `references/slide-patterns.md` — catalog of slide patterns with copy-pasteable HTML snippets (cover, agenda, section divider, bullets, quote, pipeline, comparison, big-number, table, image-led, timeline, references, Q&A).
- `references/customization.md` — every tweak the seminar template supports, with the exact CSS variables and body classes to change.
- `references/script-style.md` — how to write the teleprompter script. Voice, transitions, pacing, examples.
