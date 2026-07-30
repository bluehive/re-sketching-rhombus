# re-sketching-rhombus

A Processing-style creative-coding environment for **Racket / Rhombus**.  
It is a **reimplementation** inspired by [Sketching](https://github.com/soegaard/sketching) (not a fork).

**Implemented by Grok (xAI).**  
**License:** MIT  

[日本語 README](README.md)

Related issue: [bluehive/mypublish-gameoflife#14](https://github.com/bluehive/mypublish-gameoflife/issues/14)

## Goals

- Auto-start `setup` / `draw` under `#lang re_sketching` (optional event handlers)
- Processing-like API (drawing, mouse/key system variables, transforms)
- **Primary surface: Rhombus** (shrubbery / “S-expressions without parentheses”)
- Compatible Racket S-expression surface: `#lang re_sketching/racket`
- Recreate the intent of [sketching-examples/test](https://github.com/soegaard/sketching/tree/main/sketching-examples/test) in `examples/test/`

## Requirements

- **Racket ≥ 8.14** (for Rhombus; mise pins `racket = "8.18"` as nearly required)
- Packages: `rhombus` / `shrubbery` (plus draw / gui)

### Important: system Racket 8.10 will not work

On Ubuntu and similar systems, stock **DrRacket 8.10** cannot run `#lang re_sketching` (Rhombus surface).  
`shrubbery` / `rhombus` live in the **8.18 package scope** and are invisible to 8.10. Official Rhombus also requires base ≥ 8.14.

| Use case | Command / steps |
|----------|-----------------|
| CLI | `export PATH="$HOME/.local/share/mise/installs/racket/8.18/bin:$PATH"` then `racket examples/test/sketch1.rhm` |
| DrRacket | Launch the **8.18** `drracket` (see below). Do not use the menu’s 8.10 build |
| S-expr only on 8.10 | `#lang re_sketching/racket` (no `shrubbery`; `re-sketching-lib` must still be installed for that Racket) |

```bash
# with mise
mise install
eval "$(mise activate bash)"   # or put mise shims on PATH

# example: local rhombus trees (always use raco from 8.18)
export PATH="$HOME/.local/share/mise/installs/racket/8.18/bin:$PATH"
raco pkg install --auto --link \
  ~/my-project/rhombus/shrubbery-lib \
  ~/my-project/rhombus/enforest-lib \
  ~/my-project/rhombus/shrubbery \
  ~/my-project/rhombus/enforest \
  ~/my-project/rhombus/rhombus-lib \
  ~/my-project/rhombus/rhombus

raco pkg install --auto --link re-sketching-lib re-sketching
```

### Open a minimal sketch in DrRacket (8.18)

```bash
export PATH="$HOME/.local/share/mise/installs/racket/8.18/bin:$PATH"
# confirm version → 8.18
racket --version
drracket ~/my-project/re-sketching-rhombus/examples/test/sketch6.rhm
```

Or:

```bash
cd ~/my-project/re-sketching-rhombus
mise run drracket -- examples/test/sketch6.rhm
```

After launch, the bottom of the window should say **“Welcome to DrRacket, version 8.18”**.  
If it still says **8.10**, another binary (e.g. `/usr/bin/drracket`) was started.

## Quick start

```bash
cd ~/my-project/re-sketching-rhombus
racket examples/test/sketch1.rhm
```

mise tasks:

```bash
mise run install
mise run run-sketch -- sketch1
```

## Minimal sketch (Rhombus)

```rhombus
#lang re_sketching

fun setup():
  size(400, 300)
  frame_rate(30)

fun draw():
  background(240)
  fill("orange")
  circle(mouse_x, mouse_y, 40)
```

### Event handlers

`on_mouse_pressed`, `on_mouse_released`, `on_mouse_moved`, `on_mouse_dragged`,  
`on_key_pressed`, `on_key_released`  

(Named this way to avoid clashing with the boolean system variable `mouse_pressed`.  
On the Racket surface, hyphenated names like `on-mouse-pressed` are available.)

### Indentation matters (Rhombus)

Body statements of `draw` / `setup` must stay **inside that function’s block** (indented under `:`).  
A comment or statement that returns to column 0 runs at **module top level**, not every frame.

```rhombus
// BAD: line/ellipse are outside draw
fun draw():
  background(128)

// this is outside draw
stroke(200)
line(0, height/2, width, height/2)

// OK
fun draw():
  background(128)
  stroke(200)
  line(0, height/2, width, height/2)
```

### System variables (bare identifiers)

`width`, `height`, `frame_count`, `mouse_x`, `mouse_y`, `pmouse_x`, `pmouse_y`,  
`mouse_pressed`, `mouse_button`, `key`, `key_pressed`, `key_released`,  
`pixel_width`, `pixel_height`

## Racket S-expression surface

```racket
#lang re_sketching/racket

(define (setup)
  (size 400 300))

(define (draw)
  (background 240)
  (circle mouse-x mouse-y 40))
```

`examples/test/sketch*.rkt` use this surface.

## Documentation

| Location | Contents |
|----------|----------|
| [Cheat Sheet](docs/cheat-sheet.md) | Overview-style function index (Japanese) |
| [Examples](docs/examples.md) | Sketching Examples–style samples (description + code, Japanese) |
| [Rhombus Essentials (Wiki)](https://github.com/bluehive/re-sketching-rhombus/wiki/Rhombus-Essentials) | Rhombus syntax guide (Japanese) |
| [Rhombus Cheat Sheet (Wiki)](https://github.com/bluehive/re-sketching-rhombus/wiki/Rhombus-Cheat-Sheet) | Rhombus syntax quick reference (Japanese) |
| [GitHub Wiki](https://github.com/bluehive/re-sketching-rhombus/wiki) | Drawing API, Rhombus syntax, and samples |
| `wiki/*.md` | Wiki source (in-repo mirror) |
| `scripts/publish-wiki.sh` | Sync `wiki/` → GitHub Wiki |

Run manual examples:

```bash
racket examples/manual/input/easing.rhm
racket examples/manual/math/sine-wave.rhm
```

## Layout

| Path | Role |
|------|------|
| `re-sketching-lib/re_sketching/` | Runtime + `#lang re_sketching` (Rhombus) |
| `re-sketching-lib/re_sketching/racket/` | `#lang re_sketching/racket` |
| `re-sketching/` | Meta package |
| `examples/test/*.rhm` | sketch1–9 (Rhombus primary) |
| `examples/test/*.rkt` | Same (Racket compatible) |
| `examples/manual/` | Sketching Examples–style drawing samples |
| `docs/cheat-sheet.md` | API cheat sheet |
| `docs/examples.md` | Sample descriptions + code |
| `wiki/` | GitHub Wiki Markdown |
| `plan.md` | Agent-oriented progress plan |

## Architecture notes

- Drawing/window stack is currently **`racket/draw` + `racket/gui`** (stable event loop)
- Rhombus layer re-exports the API and auto-starts setup/draw via `#%module_block`
- Future backends (`rhombus/draw` / `rhombus/gui`) remain possible

## Unimplemented APIs and current limits

This project is **not a fork** of Sketching; it is a **from-scratch reimplementation** of a Processing-like API.  
The first milestone was: *get `setup` / `draw` running, with enough 2D primitives, input, and transforms to match sketching-test intent*. Full Sketching/Processing API coverage is intentionally deferred.

### Why some APIs are missing

1. **Scoped roadmap** — Stabilize the runtime (state + GUI loop) and Rhombus surface first; add peripheral APIs in phases (`plan.md` Phases 1–3).
2. **Not a code port** — We did not inherit Sketching’s tree, so unused bulk APIs are not copied; we implement what sketches need as we go.
3. **Docs vs core** — Examples and docs track Sketching’s structure, but HSB, text, images, Bézier, etc. are not in the core yet.
4. **Workarounds exist** — e.g. gradients via `remap` + RGB lerp, regular polygons via `triangle` fans, trig via Rhombus `math.sin` / `math.cos`.

### Main gaps (Sketching / Processing equivalents)

| Area | Examples | Notes |
|------|----------|--------|
| Color modes | `color_mode` (HSB), `lerp_color`, `hue` / `saturation` / `brightness` | RGB-style interpretation only for now |
| Curves / vertices | `bezier`, `begin_shape` / `vertex` / `end_shape` | Approximate polygons with `triangle` / `quad`, etc. |
| Typography | `text`, `text_size`, `text_align`, … | Not implemented |
| Image / pixels | `image`, `load_image`, `load_pixels`, `set_pixel`, … | Not implemented |
| Time | `millis`, `year` / `month` / `day` / `hour` / … | Some samples use `frame_count` instead |
| Noise | `noise`, simplex-noise | Not implemented |
| Math extras | Sketching-only `+=`, bound `sin`, … | Use Rhombus/Racket standard math |
| Other | `smoothing` / `no_smooth`, `nap`, `save`, Sketching `class` sugar, … | Missing or replaced by the host language |

**Core implemented:** 2D primitives (`point` / `line` / `ellipse` / `circle` / `arc` / `rect` / `square` / `quad` / `triangle`), fill/stroke, transforms, mouse/key + events, `dist` / `lerp` / `constrain` / `remap` / `random`, and more. See [docs/cheat-sheet.md](docs/cheat-sheet.md) and the [Wiki](https://github.com/bluehive/re-sketching-rhombus/wiki).

Manual samples under `examples/manual/` that depend on the above are either **adapted to preserve intent** or **left unported**, as noted in [docs/examples.md](docs/examples.md).

## Acknowledgments

- [Sketching](https://github.com/soegaard/sketching) — Jens Axel Søgaard et al. (API inspiration)
- [Processing](https://processing.org/) — Ben Fry & Casey Reas
- [Rhombus](https://rhombus-lang.org/)
