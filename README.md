# re-sketching-rhombus

Processing-style creative coding for **Racket / Rhombus**, reimplemented with [Sketching](https://github.com/soegaard/sketching) as the reference (not a fork).

**Implemented by Grok (xAI).**  
**License:** MIT  

Related issue: [bluehive/mypublish-gameoflife#14](https://github.com/bluehive/mypublish-gameoflife/issues/14)

## Goals

- `#lang re_sketching` with automatic `setup` / `draw` (and optional event handlers)
- Processing-like API (graphics, mouse/key system variables, transforms)
- Rhombus (shrubbery / “S-expression without parentheses”) as the preferred surface once Racket ≥ 8.14 + `rhombus` are available
- Pass the intent of [sketching-examples/test](https://github.com/soegaard/sketching/tree/main/sketching-examples/test) via rewritten sketches under `examples/test/`

## Quick start

```bash
cd ~/my-project/re-sketching-rhombus
# optional: mise install   # pins Racket 8.18 for Rhombus
raco pkg install --auto --link re-sketching-lib re-sketching
racket examples/test/sketch1.rkt
```

Or with mise tasks:

```bash
mise run install
mise run run-sketch -- sketch1
```

## Minimal sketch

```racket
#lang re_sketching

(define (setup)
  (size 400 300)
  (frame-rate 30))

(define (draw)
  (background 240)
  (fill "orange")
  (circle mouse-x mouse-y 40))
```

### Event handlers

Use `on-mouse-pressed`, `on-mouse-released`, `on-mouse-moved`, `on-mouse-dragged`,  
`on-key-pressed`, `on-key-released` (avoids clashing with the boolean system variable `mouse-pressed`).

### System variables (bare identifiers)

`width`, `height`, `frame-count`, `mouse-x`, `mouse-y`, `pmouse-x`, `pmouse-y`,  
`mouse-pressed`, `mouse-button`, `key`, `key-pressed`, `key-released`,  
`pixel-width`, `pixel-height`

## Layout

| Path | Role |
|------|------|
| `re-sketching-lib/` | Runtime (draw/gui/state) + `#lang re_sketching` |
| `re-sketching/` | Meta package |
| `examples/test/` | sketch1–9 (visual parity targets) |
| `plan.md` | Progress plan for agents |

## Rhombus surface

Phase 3 (see `plan.md`): with Racket ≥ 8.14 and `raco pkg install rhombus`, sketches can use shrubbery syntax under the same language name. Runtime stays on `racket/draw` + `racket/gui` for a solid event loop; optional `rhombus/draw` backend later.

## Acknowledgments

- [Sketching](https://github.com/soegaard/sketching) by Jens Axel Søgaard et al. (API inspiration)
- [Processing](https://processing.org/) by Ben Fry & Casey Reas
- [Rhombus](https://rhombus-lang.org/)
