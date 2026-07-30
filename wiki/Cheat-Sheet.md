# Cheat Sheet

[Sketching Overview](https://docs.racket-lang.org/manual-sketching/overview.html) と同様の「どこに何があるか」一覧です。  
**実装済み API のみ。** 詳細は各 Wiki ページへ。

**命名:** Rhombus = `snake_case` / Racket = `kebab-case`（例: `no_fill` ↔ `no-fill`）。

関連: [Rhombus 文法チートシート](Rhombus-Cheat-Sheet) · [Rhombus Essentials](Rhombus-Essentials)

---

## Color

**Setting:** [stroke](Color-and-Style#stroke) · [no_stroke](Color-and-Style#no_stroke) · [fill](Color-and-Style#fill) · [no_fill](Color-and-Style#no_fill) · [background](Color-and-Style#background)

**Creating / Reading:** [color](Color-and-Style#color) · `red` · `green` · `blue` · `alpha`（Racket 表面）

---

## Input

**Coordinates:** [mouse_x](Input#mouse_x--mouse_y) · [mouse_y](Input#mouse_x--mouse_y) · [pmouse_x](Input#pmouse_x--pmouse_y) · [pmouse_y](Input#pmouse_x--pmouse_y)

**Buttons:** [mouse_button](Input#mouse_button) · [mouse_pressed](Input#mouse_pressed)

**Events:** [on_mouse_dragged](Input#event-handlers) · [on_mouse_moved](Input#event-handlers) · [on_mouse_pressed](Input#event-handlers) · [on_mouse_released](Input#event-handlers) · [on_resize](Input#event-handlers)

**Keys:** [key](Input#key) · [key_pressed](Input#key_pressed--key_released) · [key_released](Input#key_pressed--key_released)

**Keyboard Events:** [on_key_pressed](Input#event-handlers) · [on_key_released](Input#event-handlers)

---

## Environment

**Size:** [size](Environment#size) · [width](Environment#width--height) · [height](Environment#width--height) · [fullscreen](Environment#fullscreen) · [pixel_density](Environment#pixel_density)

**Frames:** [frame_count](Environment#frame_count) · [frame_rate](Environment#frame_rate)

**Mouse / Window:** [cursor](Environment#cursor--no_cursor) · [no_cursor](Environment#cursor--no_cursor) · [focused](Environment#focused) · [set_title](Environment#set_title)

**Loop:** [loop](Environment#loop--no_loop) · [no_loop](Environment#loop--no_loop) · [no_gui](Environment#no_gui)

**Lifecycle:** [setup](Environment#setup--draw) · [draw](Environment#setup--draw)

---

## Shape

### 2D Primitives

[arc](Drawing-Primitives#arc) · [circle](Drawing-Primitives#circle) · [ellipse](Drawing-Primitives#ellipse) · [line](Drawing-Primitives#line) · [point](Drawing-Primitives#point) · [quad](Drawing-Primitives#quad) · [rect](Drawing-Primitives#rect) · [square](Drawing-Primitives#square) · [triangle](Drawing-Primitives#triangle)

### Curves（曲線）

| Rhombus | Racket | 概要 |
|---------|--------|------|
| [bezier](Drawing-Primitives#bezier) | `bezier` | 3 次ベジェ（始点・制御点×2・終点） |

```rhombus
bezier(x1, y1, cx1, cy1, cx2, cy2, x2, y2)
```

```racket
(bezier x1 y1 cx1 cy1 cx2 cy2 x2 y2)
```

例: `examples/manual/form/bezier.rhm`

### Vertex（頂点・自由形状）

| Rhombus | Racket | 概要 |
|---------|--------|------|
| [begin_shape](Drawing-Primitives#begin_shape--vertex--end_shape) | `begin-shape` | 形状の開始（任意 kind） |
| [vertex](Drawing-Primitives#begin_shape--vertex--end_shape) | `vertex` | 頂点を追加 |
| [end_shape](Drawing-Primitives#begin_shape--vertex--end_shape) | `end-shape` | 描画して終了（`#'close` で閉じる） |

```rhombus
begin_shape()              // または begin_shape(#'points) など
vertex(x, y)
end_shape()                // 開いた折れ線
end_shape(#'close)         // 閉じた多角形
```

```racket
(begin-shape)
(begin-shape 'points)
(vertex x y)
(end-shape)
(end-shape 'close)
```

**kind（`begin_shape` の引数）:**

| kind | 意味 |
|------|------|
| 省略 / `#'default` | 折れ線・多角形パス |
| `#'points` | 各頂点を点で描画 |
| `#'lines` | 2 点ずつ線分 |
| `#'triangles` | 3 点ずつ三角形 |

例: `examples/manual/form/begin-shape.rhm` · `examples/manual/form/regular-polygons.rhm`

### Modes

[ellipse_mode](Color-and-Style#ellipse_mode--rect_mode) · [rect_mode](Color-and-Style#ellipse_mode--rect_mode)

`#'center` · `#'corner` · `#'corners` · `#'radius`

### Stroke

[stroke_cap](Color-and-Style#stroke_cap) · [stroke_join](Color-and-Style#stroke_join) · [stroke_weight](Color-and-Style#stroke_weight)

cap: `#'round` · `#'square` / `#'project` · `#'butt`  
join: `#'miter` · `#'bevel` · `#'round`

---

## Transform

[rotate](Transform#rotate) · [scale](Transform#scale) · [translate](Transform#translate) · [push_matrix](Transform#push_matrix--pop_matrix) · [pop_matrix](Transform#push_matrix--pop_matrix) · [reset_matrix](Transform#reset_matrix)

---

## Math

### Calculation

[dist](Math#dist) · [lerp](Math#lerp) · [constrain](Math#constrain) · [norm](Math#norm) · [remap](Math#remap) · [mag](Math#mag) · [sq](Math#sq) · [random](Math#random)

### Noise（ノイズ）

| Rhombus | Racket | 概要 |
|---------|--------|------|
| [noise](Math#noise) | `noise` | Perlin 風ノイズ（1–3 次元）→ おおよそ `[0, 1]` |
| [noise_seed](Math#noise) | `noise-seed` | 乱数シード（再現性） |
| [noise_detail](Math#noise) | `noise-detail` | オクターブ数 / falloff |

```rhombus
noise(x)
noise(x, y)
noise(x, y, z)
noise_seed(42)
noise_detail(4)          // オクターブ
noise_detail(4, 0.5)     // オクターブ, falloff
```

```racket
(noise x)
(noise x y)
(noise x y z)
(noise-seed 42)
(noise-detail 4 0.5)
```

例: `examples/manual/math/noise-wave.rhm`（sine-wave のノイズ版）

### Angle

[radians](Math#radians) · [degrees](Math#degrees)

### Constants

[pi](Math#constants) · π  
（Racket 表面: `pi/2` · `π/2` · `pi/4` · `π/4` · `2pi` · `2π` も）

---

## 最小例（ノイズ + 頂点）

```rhombus
#lang re_sketching

fun setup():
  size(400, 300)
  noise_seed(1)

fun draw():
  background(30)
  no_fill()
  stroke(255)
  begin_shape()
  def mutable x = 0.0
  while x <= width:
    let y = height / 2.0 + (noise(x * 0.01, frame_count * 0.02) - 0.5) * height
    vertex(x, y)
    x := x + 8
  end_shape()
```
