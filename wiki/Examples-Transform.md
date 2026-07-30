# Examples — Transform

座標変換（translate / scale / rotate）と行列スタック。

[← Examples 一覧](Examples) · ソース: `examples/manual/transform/`

## Translate

原点を動かし、同じ引数の矩形が異なる速度でスライドする様子。

ファイル: [`examples/manual/transform/translate.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/transform/translate.rhm)

```rhombus
#lang re_sketching
// Translate.
// translate で原点を動かし、同じ座標の矩形がスライドする。
// Original: Processing Translate / Sketching translate

def mutable x = 0.0
def dim = 80.0

fun setup():
  size(640, 360)
  frame_rate(60)
  rect_mode(#'center)

fun draw():
  background(102)
  no_stroke()
  x := x + 0.8
  when x > width + dim
  | x := -dim
  translate(x, height / 2.0 - dim / 2.0)
  fill(255)
  rect(0, 0, dim, dim)
  // 変換は積み重なるので、この矩形は 2 倍速
  translate(x, dim)
  fill(0)
  rect(0, 0, dim, dim)
```

## Scale

`cos` でスケールを変え、拡大縮小する矩形。

ファイル: [`examples/manual/transform/scale.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/transform/scale.rhm)

```rhombus
#lang re_sketching
// Scale.
// cos でスケールを変化させ、拡大縮小する矩形。
// Original: Processing Scale / Sketching scale

def mutable a = 0.0
def mutable s = 0.0

fun setup():
  size(640, 360)
  rect_mode(#'center)
  no_stroke()
  frame_rate(30)

fun draw():
  background(102)
  a := a + 0.04
  s := 2.0 * math.cos(a)
  translate(width / 2.0, height / 2.0)
  scale(s)
  fill(51)
  rect(0, 0, 50, 50)
  translate(75, 0)
  fill(255)
  scale(s)
  rect(0, 0, 50, 50)
```

## Rotate

中心まわりに回転する正方形。ジッターで不規則な回転。

ファイル: [`examples/manual/transform/rotate.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/transform/rotate.rhm)

```rhombus
#lang re_sketching
// Rotate.
// 中心まわりに回転する正方形。時々ジッターを加える。
// Original: Processing Rotate / Sketching rotate
// 注: second() 未実装のため frame_count でジッター更新。

def mutable angle = 0.0
def mutable jitter = 0.0

fun setup():
  size(640, 360)
  frame_rate(60)
  no_stroke()
  fill(255)
  rect_mode(#'center)

fun draw():
  background(51)
  when (frame_count mod 60) == 0
  | jitter := random(-0.1, 0.1)
  angle := angle + jitter
  let c = math.cos(angle)
  translate(width / 2.0, height / 2.0)
  rotate(c)
  rect(0, 0, 180, 180)
```

## Arm

2 セグメントの腕。`mouse_x` / `mouse_y` が関節角。

ファイル: [`examples/manual/transform/arm.rhm`](https://github.com/bluehive/re-sketching-rhombus/blob/main/examples/manual/transform/arm.rhm)

```rhombus
#lang re_sketching
// Arm.
// 2 セグメントの腕。mouse_x / mouse_y で各関節角を制御。
// Original: Processing Arm / Sketching arm

def mutable x = 0.0
def mutable y = 0.0
def seg_length = 100.0

fun setup():
  size(640, 360)
  stroke_weight(30)
  stroke(255, 160)
  x := 0.3 * width
  y := 0.5 * height

fun segment(sx, sy, a):
  translate(sx, sy)
  rotate(a)
  line(0, 0, seg_length, 0)

fun draw():
  background(0)
  let angle1 = -1.0 * pi * (mouse_x / width - 0.5)
  let angle2 = -1.0 * pi * (mouse_y / height - 0.5)
  push_matrix()
  segment(x, y, angle1)
  segment(seg_length, 0, angle2)
  pop_matrix()
```
