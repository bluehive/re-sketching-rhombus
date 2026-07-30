# Examples — Form

基本図形・円グラフ・正多角形・**フラクタル**。

[← Examples 一覧](Examples) · ソース: `examples/manual/form/`

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

## Fractal: Sierpinski

シェルピンスキーの三角形。再帰的に中点を取って 3 つの小さな三角形を描きます。

ファイル: [`examples/manual/form/fractal-sierpinski.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/form/fractal-sierpinski.rhm)

```rhombus
#lang re_sketching
// Fractal: Sierpinski triangle.
// 再帰的に三角形を分割して描く。

fun sierpinski(x1, y1, x2, y2, x3, y3, depth):
  if depth <= 0
  | no_stroke()
    fill(220, 80, 60)
    triangle(x1, y1, x2, y2, x3, y3)
  | let mx12 = (x1 + x2) / 2.0
    let my12 = (y1 + y2) / 2.0
    let mx23 = (x2 + x3) / 2.0
    let my23 = (y2 + y3) / 2.0
    let mx31 = (x3 + x1) / 2.0
    let my31 = (y3 + y1) / 2.0
    sierpinski(x1, y1, mx12, my12, mx31, my31, depth - 1)
    sierpinski(mx12, my12, x2, y2, mx23, my23, depth - 1)
    sierpinski(mx31, my31, mx23, my23, x3, y3, depth - 1)

fun setup():
  size(640, 400)
  no_loop()

fun draw():
  background(20)
  let pad = 40.0
  sierpinski(width / 2.0, pad,
             pad, height - pad,
             width - pad, height - pad,
             6)
```

## Fractal: Koch Snowflake

コッホ曲線を正三角形の 3 辺に適用した雪片。再帰の深さでギザギザが増えます。

ファイル: [`examples/manual/form/fractal-koch.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/form/fractal-koch.rhm)

```rhombus
#lang re_sketching
// Fractal: Koch snowflake.
// コッホ曲線を 3 辺に適用して雪片を描く。

fun koch(x1, y1, x2, y2, depth):
  if depth <= 0
  | line(x1, y1, x2, y2)
  | let dx = x2 - x1
    let dy = y2 - y1
    // 3 等分点
    let xA = x1 + dx / 3.0
    let yA = y1 + dy / 3.0
    let xB = x1 + 2.0 * dx / 3.0
    let yB = y1 + 2.0 * dy / 3.0
    // 外側の頂点（60° 回転）
    let px = xB - xA
    let py = yB - yA
    let ang = -pi / 3.0
    let xC = xA + px * math.cos(ang) - py * math.sin(ang)
    let yC = yA + px * math.sin(ang) + py * math.cos(ang)
    koch(x1, y1, xA, yA, depth - 1)
    koch(xA, yA, xC, yC, depth - 1)
    koch(xC, yC, xB, yB, depth - 1)
    koch(xB, yB, x2, y2, depth - 1)

fun setup():
  size(640, 400)
  no_loop()

fun draw():
  background(12, 20, 40)
  stroke(180, 220, 255)
  stroke_weight(1.5)
  no_fill()
  let cx = width / 2.0
  let cy = height / 2.0 + 30.0
  let r = 160.0
  // 正三角形の 3 頂点
  let a0 = -pi / 2.0
  let a1 = a0 + 2.0 * pi / 3.0
  let a2 = a0 + 4.0 * pi / 3.0
  let x0 = cx + r * math.cos(a0)
  let y0 = cy + r * math.sin(a0)
  let x1 = cx + r * math.cos(a1)
  let y1 = cy + r * math.sin(a1)
  let x2 = cx + r * math.cos(a2)
  let y2 = cy + r * math.sin(a2)
  let depth = 4
  koch(x0, y0, x1, y1, depth)
  koch(x1, y1, x2, y2, depth)
  koch(x2, y2, x0, y0, depth)
```

## Fractal: Tree

枝分かれするフラクタルツリー。マウス X で開き角、Y で再帰深さを変えられます。

ファイル: [`examples/manual/form/fractal-tree.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/form/fractal-tree.rhm)

```rhombus
#lang re_sketching
// Fractal: recursive tree.
// 枝分かれする木。マウス X で開き角、Y で深さを変える。

fun branch(len, depth, angle_spread):
  stroke(120 + depth * 18, 180, 100)
  stroke_weight(math.max(1.0, depth * 0.6))
  line(0, 0, 0, -len)
  when depth > 0
  | translate(0, -len)
    let next = len * 0.72
    push_matrix()
    rotate(-angle_spread)
    branch(next, depth - 1, angle_spread)
    pop_matrix()
    push_matrix()
    rotate(angle_spread)
    branch(next, depth - 1, angle_spread)
    pop_matrix()

fun setup():
  size(640, 400)
  frame_rate(30)

fun draw():
  background(15, 18, 28)
  // 開き角: マウス X、深さ: マウス Y
  let spread = remap(mouse_x, 0, width, 0.15, 1.1)
  let depth = math.floor(remap(mouse_y, 0, height, 3, 10))
  translate(width / 2.0, height - 20.0)
  branch(90.0, depth, spread)
```
