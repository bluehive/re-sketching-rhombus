# re-sketching-rhombus — Implementation Plan

**Project:** Processing-style creative coding on Rhombus (Sketching as reference).  
**Repo:** `~/my-project/re-sketching-rhombus`  
**Issue:** [bluehive/mypublish-gameoflife#14](https://github.com/bluehive/mypublish-gameoflife/issues/14)  
**Implemented by:** Grok (xAI)  
**License:** MIT  

## Decisions (user-approved)

| # | Choice |
|---|--------|
| Compatibility | (a) Rhombus syntax + Processing-like API; rewrite sketching-tests |
| Entry | (a) `#lang re_sketching` auto setup / draw |
| Repo name | `re-sketching-rhombus` (typo fixed) |

## Architecture

```
re-sketching-rhombus/
  re-sketching/              # meta package
  re-sketching-lib/          # implementation
    re_sketching/
      private/               # Racket runtime (draw/gui)
      lang/reader.rkt        # #lang reader (Rhombus when available, Racket fallback)
      main.rkt / api.rhm
  examples/test/             # sketch1..9 equivalents
  plan.md
  mise.toml
```

Runtime is **Racket** (`racket/draw` + `racket/gui`) so the event loop is reliable.  
Surface is **`#lang re_sketching`**: preferred form is Rhombus/shrubbery when `rhombus` is installed; a Racket S-expression surface is always available for CI / older Racket.

## Phases

### Phase 0 — Scaffold ✅
- [x] Repo init, MIT, plan.md, mise.toml
- [x] Package `info.rkt` layout

### Phase 1 — Runtime core ✅
- [x] State parameters (size, mouse, keys, frame)
- [x] Graphics: background, stroke/fill, line, ellipse, circle, arc, rect, quad, triangle, point
- [x] Modes: ellipse-mode, rect-mode, stroke-weight/cap/join
- [x] Transform: translate, push/pop-matrix
- [x] GUI: frame, canvas, timer loop, mouse/key events
- [x] `#lang re_sketching` module-begin (auto setup/draw)

### Phase 2 — Examples (sketching-test equivalents) ✅
- [x] sketch1–9 as `.rkt` (compile-checked; visual run)
- [x] Handler names: `on-mouse-*` / `on-key-*`

### Phase 3 — Rhombus surface (in progress)
- [ ] Install Racket ≥8.14 + rhombus via mise (install running / pending)
- [ ] `#lang re_sketching` shrubbery reader
- [x] sketch1.rhm placeholder documenting intended syntax
- [ ] Optional: wire `rhombus/draw` / `rhombus/gui` backends later

### Phase 4 — Polish
- [x] README usage
- [x] `mise run` tasks (install, example, test-list)
- [x] GitHub remote push
- [x] Issue #14 progress comment

## Success criteria

1. `examples/test/sketch1`–`sketch9` run and show expected interactive behaviour (visual parity with sketching-test intent).
2. Entry is `#lang re_sketching` with automatic `setup` / `draw`.
3. MIT + “Implemented by Grok” in README.
4. Remote on github.com/bluehive/re-sketching-rhombus.

## Notes / risks

- System Racket may be 8.10; Rhombus needs ≥8.14 → pin via `mise.toml`.
- sketching-test is visual, not assert-based; we may add lightweight smoke checks later.
- Event handler names: use `on-mouse-pressed` (and aliases) to avoid clashing with boolean `mouse-pressed`.
