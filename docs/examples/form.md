# Form サンプル

基本図形・円グラフ・正多角形。

[一覧](../examples.md) · 実行: `racket examples/manual/form/...`

## Points and Lines

`point` と `line` による基本幾何。

ファイル: [`examples/manual/form/points-and-lines.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/form/points-and-lines.rhm)

```rhombus
#lang re_sketching
// Points and Lines.
// point と line で基本的な幾何を描く。d を変えるとスケールが変わる。
// Original: Processing PointsLines / Sketching point-and-lines

def d = 70.0
def p1 = d
def p2 = p1 + d
def p3 = p2 + d
def p4 = p3 + d

fun setup():
  size(640, 360)
  background(0)

fun draw():
  background(0)
  push_matrix()
  translate(140, 40)
  stroke(153)
  stroke_weight(1)
  line(p3, p3, p2, p3)
  line(p2, p3, p2, p2)
  line(p2, p2, p3, p2)
  line(p3, p2, p3, p3)
  stroke(255)
  stroke_weight(4)
  point(p1, p1)
  point(p1, p3)
  point(p2, p4)
  point(p3, p1)
  point(p4, p2)
  point(p4, p4)
  pop_matrix()
```

## Pie Chart

`arc` と角度データから円グラフ。

ファイル: [`examples/manual/form/pie-chart.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/form/pie-chart.rhm)

```rhombus
#lang re_sketching
// Pie Chart.
// arc で配列データから円グラフを描く。
// Original: Processing PieChart / Sketching pie-chart

def angles = [30.0, 10.0, 45.0, 35.0, 60.0, 38.0, 75.0, 67.0]

fun setup():
  size(640, 360)
  no_stroke()
  no_loop()

fun pie_chart(diameter, data):
  def mutable last_angle = 0.0
  def mutable i = 0
  let n = data.length()
  for (a in data):
    let gray = remap(i, 0, n, 0, 255)
    fill(gray)
    arc(width / 2.0, height / 2.0, diameter, diameter,
        last_angle, last_angle + radians(a))
    last_angle := last_angle + radians(a)
    i := i + 1

fun draw():
  background(100)
  pie_chart(300, angles)
```

## Regular Polygons

正多角形を `triangle` 扇で描き回転（`begin_shape` 未実装のため近似）。

ファイル: [`examples/manual/form/regular-polygons.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/form/regular-polygons.rhm)

```rhombus
#lang re_sketching
// Regular Polygons.
// 正多角形を triangle 扇で描き、回転させる。
// Original: Processing RegularPolygon / Sketching regular-polygons
// 注: begin_shape/vertex 未実装のため triangle で近似。

fun polygon(cx, cy, radius, npoints):
  let angle = 2.0 * pi / npoints
  def mutable a = 0.0
  def mutable px = cx + radius * math.cos(0.0)
  def mutable py = cy + radius * math.sin(0.0)
  def mutable i = 0
  while i < npoints:
    a := a + angle
    let sx = cx + radius * math.cos(a)
    let sy = cy + radius * math.sin(a)
    triangle(cx, cy, px, py, sx, sy)
    px := sx
    py := sy
    i := i + 1

fun setup():
  size(640, 360)
  frame_rate(60)

fun draw():
  background(102)
  no_stroke()
  fill(255)

  push_matrix()
  translate(0.2 * width, 0.5 * height)
  rotate(frame_count / 200.0)
  polygon(0, 0, 82, 3)
  pop_matrix()

  push_matrix()
  translate(0.5 * width, 0.5 * height)
  rotate(frame_count / 50.0)
  polygon(0, 0, 80, 20)
  pop_matrix()

  push_matrix()
  translate(0.8 * width, 0.5 * height)
  rotate(frame_count / -100.0)
  polygon(0, 0, 70, 7)
  pop_matrix()
```
