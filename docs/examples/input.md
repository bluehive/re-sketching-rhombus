# Input サンプル

マウス・キーボード入力とイベントハンドラ。

[一覧](../examples.md) · 実行: `racket examples/manual/input/...`

## Mouse 1D

`mouse_x` で左右の矩形の大きさと明度のバランスを制御します。

ファイル: [`examples/manual/input/mouse-1d.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/input/mouse-1d.rhm)

```rhombus
#lang re_sketching
// Mouse 1D.
// mouse_x で左右の矩形の大きさと明度をバランスさせる。
// Original: Processing Mouse1D / Sketching mouse-1d

fun setup():
  size(640, 360)
  no_stroke()
  rect_mode(#'center)

fun draw():
  background(0)
  let r1 = remap(mouse_x, 0, width, 0, height)
  let r2 = height - r1
  fill(r1)
  rect((width + r1) / 2.0, height / 2.0, r1, r1)
  fill(r2)
  rect((width - r1) / 2.0, height / 2.0, r2, r2)
```

## Mouse 2D

マウス位置に連動する矩形と、その対称コピーを描きます。

ファイル: [`examples/manual/input/mouse-2d.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/input/mouse-2d.rhm)

```rhombus
#lang re_sketching
// Mouse 2D.
// マウス位置で矩形の位置とサイズを変え、対称にもう一つ描く。
// Original: Processing Mouse2D / Sketching mouse-2d

fun setup():
  size(640, 360)
  no_stroke()
  rect_mode(#'center)

fun draw():
  background(51)
  fill(255, 204)
  rect(mouse_x, height / 2.0, mouse_y / 2.0 + 10, mouse_y / 2.0 + 10)
  let inverse_x = width - mouse_x
  let inverse_y = height - mouse_y
  fill(255, 204)
  rect(inverse_x, height / 2.0, inverse_y / 2.0 + 10, inverse_y / 2.0 + 10)
```

## Mouse Press

マウス位置に十字。`mouse_pressed` で線色を反転します。

ファイル: [`examples/manual/input/mouse-press.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/input/mouse-press.rhm)

```rhombus
#lang re_sketching
// Mouse Press.
// マウス位置に十字。ボタン押下で線色を反転。
// Original: Processing MousePress / Sketching mouse-press

fun setup():
  size(640, 360)
  fill(126)
  background(102)

fun draw_cross(x, y):
  line(x - 66, y, x + 66, y)
  line(x, y - 66, x, y + 66)

fun draw():
  if mouse_pressed
  | stroke(255)
  | stroke(0)
  draw_cross(mouse_x, mouse_y)
```

## Easing

カーソルへ滑らかに追従する円（イージング係数 0.05）。

ファイル: [`examples/manual/input/easing.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/input/easing.rhm)

```rhombus
#lang re_sketching
// Easing.
// 図形がカーソルへ滑らかに追従（イージング）。
// Original: Processing Easing / Sketching easing

def mutable x = 0.0
def mutable y = 0.0
def easing = 0.05

fun setup():
  size(640, 360)
  frame_rate(60)
  no_stroke()

fun draw():
  background(51)
  let dx = mouse_x - x
  let dy = mouse_y - y
  x := x + dx * easing
  y := y + dy * easing
  ellipse(x, y, 66, 66)
```

## Constrain

イージング移動を `constrain` で枠内に制限します。

ファイル: [`examples/manual/input/constrain.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/input/constrain.rhm)

```rhombus
#lang re_sketching
// Constrain.
// イージングで円を動かし、constrain で枠内に制限する。
// Original: Processing Constrain / Sketching constrain

def easing = 0.05
def radius = 24.0
def edge = 100.0
def inner = edge + radius

def mutable mx = 0.0
def mutable my = 0.0

fun setup():
  size(640, 360)
  frame_rate(60)
  no_stroke()
  ellipse_mode(#'radius)
  rect_mode(#'corners)

fun draw():
  background(51)
  when math.abs(mouse_x - mx) > 0.1
  | mx := mx + (mouse_x - mx) * easing
  when math.abs(mouse_y - my) > 0.1
  | my := my + (mouse_y - my) * easing
  mx := constrain(mx, inner, width - inner)
  my := constrain(my, inner, height - inner)
  fill(76)
  rect(edge, edge, width - edge, height - edge)
  fill(255)
  ellipse(mx, my, radius, radius)
```

## Mouse Functions

`on_mouse_pressed` / `dragged` / `released` で矩形をドラッグ。

ファイル: [`examples/manual/input/mouse-functions.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/input/mouse-functions.rhm)

```rhombus
#lang re_sketching
// Mouse Functions.
// ドラッグで矩形を掴んで移動（on_mouse_* ハンドラ）。
// Original: Processing MouseFunctions / Sketching mouse-functions

def mutable bx = 0.0
def mutable by = 0.0
def box_size = 75.0
def mutable locked = #false
def mutable x_offset = 0.0
def mutable y_offset = 0.0

fun setup():
  size(640, 360)
  bx := width / 2.0
  by := height / 2.0
  rect_mode(#'radius)

fun in_the_box(x, y):
  x > bx - box_size && x < bx + box_size
    && y > by - box_size && y < by + box_size

fun draw():
  background(0)
  cond
  | in_the_box(mouse_x, mouse_y) && locked:
      stroke(255)
      fill(255)
  | in_the_box(mouse_x, mouse_y):
      stroke(255)
      fill(153)
  | ~else:
      stroke(153)
      fill(153)
  rect(bx, by, box_size, box_size)

fun on_mouse_pressed():
  locked := in_the_box(mouse_x, mouse_y)
  x_offset := mouse_x - bx
  y_offset := mouse_y - by

fun on_mouse_dragged():
  when locked
  | bx := mouse_x - x_offset
    by := mouse_y - y_offset

fun on_mouse_released():
  locked := #false
```

## Keyboard

文字キーで縦帯を描画。非文字でクリア（色は `frame_count` 由来）。

ファイル: [`examples/manual/input/keyboard.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/input/keyboard.rhm)

```rhombus
#lang re_sketching
// Keyboard.
// 文字キーで縦帯を描画。非文字キーで画面クリア。
// Original: Processing Keyboard / Sketching keyboard
// 注: millis 未実装のため frame_count で色を変化。

def mutable rect_width = 0.0

fun setup():
  size(640, 360)
  no_stroke()
  background(0)
  rect_width := width / 4.0

fun draw():
  // 描画はキーイベント側
  #void

fun on_key_pressed():
  match key
  | s :: String:
      when s.length() == 1:
        let ch = s[0]
        // a-z / A-Z
        let code = Char.to_int(ch)
        let lower = if code >= Char.to_int(Char"A") && code <= Char.to_int(Char"Z")
                    | code + 32
                    | code
        when lower >= Char.to_int(Char"a") && lower <= Char.to_int(Char"z")
        | let key_index = lower - Char.to_int(Char"a")
          fill(math.modulo(frame_count * 7, 255))
          let x = remap(key_index, 0, 25, 0, width - rect_width)
          rect(x, 0, rect_width, height)
        | ~else:
          background(0)
      | ~else:
        background(0)
  | ~else:
      background(0)
```
