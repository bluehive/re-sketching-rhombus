# Color サンプル

色の束縛・相対的な見え方・グラデーション。

[一覧](../examples.md) · 実行: `racket examples/manual/color/...`

## Color Variables

色を `color(...)` で変数に束縛し、入れ子の矩形（Albers へのオマージュ）を描きます。

ファイル: [`examples/manual/color/color-variables.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/color/color-variables.rhm)

```rhombus
#lang re_sketching
// Color Variables (Homage to Albers).
// Color を名前付き変数に束縛し、数値ではなく名前で参照する例。
// Original: Processing ColorVariables / Sketching color-variables

def inside = color(204, 102, 0)
def middle = color(204, 153, 0)
def outside = color(153, 51, 0)

fun setup():
  size(640, 360)

fun draw():
  no_stroke()
  background(51, 0, 0)

  push_matrix()
  translate(80, 80)
  fill(outside)
  rect(0, 0, 200, 200)
  fill(middle)
  rect(40, 60, 120, 120)
  fill(inside)
  rect(60, 90, 80, 80)
  pop_matrix()

  push_matrix()
  translate(360, 80)
  fill(inside)
  rect(0, 0, 200, 200)
  fill(outside)
  rect(40, 60, 120, 120)
  fill(middle)
  rect(60, 90, 80, 80)
  pop_matrix()
```

## Relativity

同じ 5 色でも並び順が変わると印象が変わることを、上下 2 本の帯で示します。

ファイル: [`examples/manual/color/relativity.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/color/relativity.rhm)

```rhombus
#lang re_sketching
// Relativity.
// 同じ色の並びでも順序が変わると見え方が変わる例。
// Original: Processing Relativity / Sketching relativity

def a = color(165, 167, 20)
def b = color(77, 86, 59)
def c = color(42, 106, 105)
def d = color(165, 89, 20)
def e = color(146, 150, 127)

fun setup():
  size(640, 360)
  no_loop()

fun draw_band(colors, y_pos, bar_w):
  let num = colors.length()
  def mutable i = 0.0
  while i < width:
    def mutable j = 0
    for (col in colors):
      fill(col)
      rect(i + j * bar_w, y_pos, bar_w, height / 2.0)
      j := j + 1
    i := i + bar_w * num

fun draw():
  let bar_w = width / 128.0
  draw_band([a, b, c, d, e], 0, bar_w)
  draw_band([c, a, d, b, e], height / 2.0, bar_w)
```

## Linear Gradient

`remap` と RGB 補間で水平・垂直グラデーションを描きます（`lerp-color` 未実装のため自前補間）。

ファイル: [`examples/manual/color/linear-gradient.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/color/linear-gradient.rhm)

```rhombus
#lang re_sketching
// Simple Linear Gradient.
// remap + RGB 補間でグラデーションを描く（lerp-color 未実装のため自前補間）。
// Original: Processing LinearGradient / Sketching linear-gradient

fun mix(r1, g1, b1, r2, g2, b2, t):
  color(lerp(r1, r2, t), lerp(g1, g2, t), lerp(b1, b2, t))

fun set_gradient(x, y, w, h, r1, g1, b1, r2, g2, b2, axis):
  no_fill()
  match axis
  | #'y_axis:
      def mutable i = y
      while i <= y + h:
        let t = remap(i, y, y + h, 0, 1)
        stroke(mix(r1, g1, b1, r2, g2, b2, t))
        line(x, i, x + w, i)
        i := i + 1
  | #'x_axis:
      def mutable i = x
      while i <= x + w:
        let t = remap(i, x, x + w, 0, 1)
        stroke(mix(r1, g1, b1, r2, g2, b2, t))
        line(i, y, i, y + h)
        i := i + 1
  | ~else:
      #void

fun setup():
  size(640, 360)
  no_loop()

fun draw():
  // 背景: 白→黒 / 黒→白
  set_gradient(0, 0, width / 2.0, height, 255, 255, 255, 0, 0, 0, #'x_axis)
  set_gradient(width / 2.0, 0, width / 2.0, height, 0, 0, 0, 255, 255, 255, #'x_axis)
  // 前景: オレンジ→青 / 青→オレンジ
  set_gradient(50, 90, 540, 80, 204, 102, 0, 0, 102, 153, #'y_axis)
  set_gradient(50, 190, 540, 80, 0, 102, 153, 204, 102, 0, #'x_axis)
```
