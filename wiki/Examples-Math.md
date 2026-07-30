# Examples — Math

距離・写像・三角関数・極座標。

[← Examples 一覧](Examples) · ソース: `examples/manual/math/`

## Distance 2D

マウスからの距離で楕円サイズが変わる距離場。

ファイル: [`examples/manual/math/distance-2d.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/math/distance-2d.rhm)

```rhombus
#lang re_sketching
// Distance 2D.
// マウスからの距離で楕円サイズを変える距離場。
// Original: Processing Distance2D / Sketching distance2d

def mutable max_distance = 1.0

fun setup():
  size(640, 360)
  no_stroke()
  frame_rate(60)
  max_distance := dist(0, 0, width, height)

fun draw():
  background(0)
  def mutable i = 0.0
  while i <= width:
    def mutable j = 0.0
    while j <= height:
      let size0 = dist(mouse_x, mouse_y, i, j)
      let s = (size0 / max_distance) * 66.0
      ellipse(i, j, s, s)
      j := j + 20
    i := i + 20
```

## Remap

`mouse_x` を色と直径に写像。

ファイル: [`examples/manual/math/remap.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/math/remap.rhm)

```rhombus
#lang re_sketching
// Remap (Map).
// mouse_x を色と直径に写像する。
// Original: Processing Map / Sketching remap

fun setup():
  size(640, 360)
  no_stroke()
  frame_rate(60)

fun draw():
  background(0)
  let c = math.max(remap(mouse_x, 0, width, 0, 175), 0)
  let d = remap(mouse_x, 0, width, 40, 300)
  fill(255, c, 0)
  ellipse(width / 2.0, height / 2.0, d, d)
```

## Sine

`sin` で直径が脈動する 3 円。

ファイル: [`examples/manual/math/sine.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/math/sine.rhm)

```rhombus
#lang re_sketching
// Sine.
// sin で直径が脈動する 3 つの円。
// Original: Processing Sine / Sketching sine

def mutable diameter = 100.0
def mutable angle = 0.0

fun setup():
  size(640, 360)
  no_stroke()
  frame_rate(60)
  diameter := height - 10.0
  fill(255, 204, 0)

fun draw():
  background(0)
  let dh = diameter / 2.0
  let hh = height / 2.0
  let wh = width / 2.0
  let d1 = 10 + math.sin(angle) * dh + dh
  let d2 = 10 + math.sin(angle + pi / 2.0) * dh + dh
  let d3 = 10 + math.sin(angle + pi) * dh + dh
  ellipse(0, hh, d1, d1)
  ellipse(wh, hh, d2, d2)
  ellipse(width, hh, d3, d3)
  angle := angle + 0.02
```

## Sine Cosine

sin/cos で中心矩形の周囲を回る円。

ファイル: [`examples/manual/math/sine-cosine.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/math/sine-cosine.rhm)

```rhombus
#lang re_sketching
// Sine Cosine.
// sin / cos で中心矩形の周囲を回る円。
// Original: Processing SineCosine / Sketching sine-cosine

def mutable x1 = 0.0
def mutable x2 = 0.0
def mutable y1 = 0.0
def mutable y2 = 0.0
def mutable angle1 = 0.0
def mutable angle2 = 0.0
def scalar = 70.0

fun setup():
  size(640, 360)
  no_stroke()
  rect_mode(#'center)
  frame_rate(60)

fun draw():
  background(0)
  let ang1 = radians(angle1)
  let ang2 = radians(angle2)
  let wh = width / 2.0
  let hh = height / 2.0
  x1 := wh + scalar * math.cos(ang1)
  x2 := wh + scalar * math.cos(ang2)
  y1 := hh + scalar * math.sin(ang1)
  y2 := hh + scalar * math.sin(ang2)
  fill(255)
  rect(wh, hh, 140, 140)
  fill(0, 102, 153)
  ellipse(x1, hh - 120, scalar, scalar)
  ellipse(x2, hh + 120, scalar, scalar)
  fill(255, 204, 0)
  ellipse(wh - 120, y1, scalar, scalar)
  ellipse(wh + 120, y2, scalar, scalar)
  angle1 := angle1 + 2
  angle2 := angle2 + 3
```

## Sine Wave

横並びの円でサイン波をアニメーション。

ファイル: [`examples/manual/math/sine-wave.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/math/sine-wave.rhm)

```rhombus
#lang re_sketching
// Sine Wave.
// 横に並んだ円でサイン波をアニメーション。
// Original: Processing SineWave / Sketching sine-wave

def x_spacing = 16.0
def mutable w = 0.0
def mutable theta = 0.0
def amplitude = 75.0
def period = 500.0
def mutable dx = 0.0
def mutable y_values = []

fun setup():
  size(640, 360)
  frame_rate(60)
  w := width + 16.0
  dx := (2.0 * pi / period) * x_spacing
  // 波のサンプル数
  let n = math.floor(w / x_spacing)
  def mutable ys = []
  def mutable k = 0
  while k < n:
    ys := ys ++ [0.0]
    k := k + 1
  y_values := ys

fun calc_wave():
  theta := theta + 0.02
  def mutable x = theta
  def mutable ys = []
  for (_ in y_values):
    ys := ys ++ [math.sin(x) * amplitude]
    x := x + dx
  y_values := ys

fun render_wave():
  no_stroke()
  fill(255)
  def mutable v = 0
  for (yv in y_values):
    ellipse(v * x_spacing, height / 2.0 + yv, 16, 16)
    v := v + 1

fun draw():
  background(0)
  calc_wave()
  render_wave()
```

## Polar to Cartesian

極座標 `(r, θ)` を直交座標へ変換して公転。

ファイル: [`examples/manual/math/polar-to-cartesian.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/math/polar-to-cartesian.rhm)

```rhombus
#lang re_sketching
// Polar to Cartesian.
// 極座標 (r, theta) を直交座標に変換して円を回す。
// Original: Processing PolarToCartesian / Sketching polar-to-cartesian

def mutable r = 0.0
def mutable theta = 0.0
def mutable theta_vel = 0.0
def theta_acc = 0.0001

fun setup():
  size(640, 360)
  frame_rate(60)
  ellipse_mode(#'center)
  no_stroke()
  fill(200)
  r := height * 0.45

fun draw():
  background(0)
  translate(width / 2.0, height / 2.0)
  let x = r * math.cos(theta)
  let y = r * math.sin(theta)
  ellipse(x, y, 32, 32)
  theta_vel := theta_vel + theta_acc
  theta := theta + theta_vel
```
