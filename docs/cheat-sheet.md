# re-sketching-rhombus — Cheat Sheet

[Sketching Overview](https://docs.racket-lang.org/manual-sketching/overview.html) に倣ったクイックリファレンスです。  
実装済み API のみを掲載しています（未実装は載せていません）。

**命名:** 主表面は Rhombus（`snake_case`）。Racket 表面（`#lang re_sketching/racket`）では `kebab-case`（例: `no_fill` → `no-fill`）。  
詳細は [GitHub Wiki](https://github.com/bluehive/re-sketching-rhombus/wiki) を参照。

---

## Color

### Setting

| Rhombus | Racket |
|---------|--------|
| `stroke` · `no_stroke` | `stroke` · `no-stroke` |
| `fill` · `no_fill` | `fill` · `no-fill` |
| `background` | `background` |

### Creating and Reading

| Rhombus | Racket |
|---------|--------|
| `color` | `color` · `red` · `green` · `blue` · `alpha` |

色の指定: グレースケール `0`–`255`、名前 `"red"` / `"orange"`、`"#rrggbb"`、RGB `(r, g, b)`、RGBA `(r, g, b, a)`（`a` は 0–1 または 0–255）。

---

## Input

### Coordinates

`mouse_x` · `mouse_y` · `pmouse_x` · `pmouse_y`  
（Racket: `mouse-x` · `mouse-y` · `pmouse-x` · `pmouse-y`）

### Buttons

`mouse_button` · `mouse_pressed`  
（Racket: `mouse-button` · `mouse-pressed`）  
`mouse_button` は `#'left` / `#'right` / `#'middle` など。

### Events（任意で定義）

`on_mouse_dragged` · `on_mouse_moved` · `on_mouse_pressed` · `on_mouse_released` · `on_resize`  
（Racket: `on-mouse-dragged` など）

### Keys

`key` · `key_pressed` · `key_released`  
（Racket: `key` · `key-pressed` · `key-released`）

### Keyboard Events

`on_key_pressed` · `on_key_released`  
（Racket: `on-key-pressed` · `on-key-released`）

---

## Environment

### Size

| Rhombus | Racket |
|---------|--------|
| `size` · `width` · `height` | `size` · `width` · `height` |
| `fullscreen` · `pixel_density` | `fullscreen` · `pixel-density` |
| `pixel_width` · `pixel_height` | `pixel-width` · `pixel-height` |

### Frames

| Rhombus | Racket |
|---------|--------|
| `frame_count` · `frame_rate` | `frame-count` · `frame-rate` / `set-frame-rate!` |

### Mouse / Window

| Rhombus | Racket |
|---------|--------|
| `cursor` · `no_cursor` · `focused` | `cursor` · `no-cursor` · `focused?` |
| `set_title` | `set-title` |

### Loop

| Rhombus | Racket |
|---------|--------|
| `loop` · `no_loop` · `no_gui` | `loop` · `no-loop` · `no-gui` |

### Lifecycle

| Rhombus | Racket |
|---------|--------|
| `setup` · `draw`（自動起動） | `setup` · `draw`（自動起動） |

---

## Shape

### 2D Primitives

| Rhombus / Racket |
|------------------|
| `arc` · `circle` · `ellipse` · `line` · `point` |
| `quad` · `rect` · `square` · `triangle` |

### Modes

| Rhombus | Racket |
|---------|--------|
| `ellipse_mode` · `rect_mode` | `ellipse-mode` · `rect-mode` |

モード: `#'center` · `#'corner` · `#'corners` · `#'radius`

### Stroke

| Rhombus | Racket |
|---------|--------|
| `stroke_cap` · `stroke_join` · `stroke_weight` | `stroke-cap` · `stroke-join` · `stroke-weight` |

cap: `#'round` · `#'square` / `#'project` · `#'butt`  
join: `#'miter` · `#'bevel` · `#'round`

---

## Transform

| Rhombus | Racket |
|---------|--------|
| `rotate` · `scale` · `translate` | `rotate` · `scale` · `translate` |
| `push_matrix` · `pop_matrix` · `reset_matrix` | `push-matrix` · `pop-matrix` · `reset-matrix` |

---

## Math

### Calculation

`dist` · `lerp` · `constrain` · `norm` · `remap` · `mag` · `sq` · `random`

### Trigonometry helpers

`radians` · `degrees`

### Constants

`pi` · `π`（Racket 表面ではさらに `pi/2` · `π/2` · `pi/4` · `π/4` · `2pi` · `2π`）

Rhombus の通常の数値演算（`sin` / `cos` など）は言語側を利用。

---

## 最小例

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

```racket
#lang re_sketching/racket

(define (setup)
  (size 400 300)
  (frame-rate 30))

(define (draw)
  (background 240)
  (fill "orange")
  (circle mouse-x mouse-y 40))
```
