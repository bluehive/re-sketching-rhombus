# Cheat Sheet

[Sketching Overview](https://docs.racket-lang.org/manual-sketching/overview.html) と同様の「どこに何があるか」一覧です。  
実装済み API のみ。詳細は各 Wiki ページへ。

**命名:** Rhombus = `snake_case` / Racket = `kebab-case`（例: `no_fill` ↔ `no-fill`）。

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

**2D Primitives:** [arc](Drawing-Primitives#arc) · [circle](Drawing-Primitives#circle) · [ellipse](Drawing-Primitives#ellipse) · [line](Drawing-Primitives#line) · [point](Drawing-Primitives#point) · [quad](Drawing-Primitives#quad) · [rect](Drawing-Primitives#rect) · [square](Drawing-Primitives#square) · [triangle](Drawing-Primitives#triangle)

**Curves & vertices:** [bezier](Drawing-Primitives#bezier) · [begin_shape](Drawing-Primitives#begin_shape--vertex--end_shape) · [vertex](Drawing-Primitives#begin_shape--vertex--end_shape) · [end_shape](Drawing-Primitives#begin_shape--vertex--end_shape)

**Modes:** [ellipse_mode](Color-and-Style#ellipse_mode--rect_mode) · [rect_mode](Color-and-Style#ellipse_mode--rect_mode)

**Stroke:** [stroke_cap](Color-and-Style#stroke_cap) · [stroke_join](Color-and-Style#stroke_join) · [stroke_weight](Color-and-Style#stroke_weight)

---

## Transform

[rotate](Transform#rotate) · [scale](Transform#scale) · [translate](Transform#translate) · [push_matrix](Transform#push_matrix--pop_matrix) · [pop_matrix](Transform#push_matrix--pop_matrix) · [reset_matrix](Transform#reset_matrix)

---

## Math

**Calculation:** [dist](Math#dist) · [lerp](Math#lerp) · [constrain](Math#constrain) · [norm](Math#norm) · [remap](Math#remap) · [mag](Math#mag) · [sq](Math#sq) · [random](Math#random)

**Noise:** [noise](Math#noise) · [noise_seed](Math#noise) · [noise_detail](Math#noise)

**Angle:** [radians](Math#radians) · [degrees](Math#degrees)

**Constants:** [pi](Math#constants) · π
