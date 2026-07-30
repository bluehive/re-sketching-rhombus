# Color and Style

塗り・線・背景色と、図形の解釈モードを設定します。

---

## 色の指定方法

`background` / `fill` / `stroke` / `color` は同じ色引数を受け付けます。

| 形式 | 例 | 意味 |
|------|-----|------|
| グレー | `51` | 0–255 のグレースケール |
| グレー + α | `51, 128` | α は 0–1 または 0–255 |
| RGB | `255, 204, 0` | 各 0–255 |
| RGBA | `0, 126, 255, 102` | α は 0–1 または 0–255 |
| 名前 | `"orange"`, `"red"` | black, white, red, green, blue, yellow, cyan, magenta, orange, gray/grey |
| hex 文字列 | `"#ccffaa"` | Racket `color%` が解釈可能な文字列 |
| color オブジェクト | `color(...)` の戻り値 | そのまま使用 |

> 現状 `color_mode` / HSB / `lerp_color` は未実装です（常に RGB 的な解釈）。

---

## background

キャンバス全体の背景色を塗りつぶします。通常は `draw` の先頭で毎フレーム呼び出します。

### Rhombus

```rhombus
background(240)
background(255, 204, 0)
background("black")
```

### Racket

```racket
(background 240)
(background 255 204 0)
(background "black")
```

座標変換の影響を受けず、キャンバス全体をクリアします。

---

## fill

図形の塗り色を設定します。

```rhombus
fill(153)
fill(204, 102, 0)
fill("#ccffaa")
fill("green")
```

```racket
(fill 153)
(fill 204 102 0)
```

---

## no_fill

塗りを無効にします（輪郭のみ）。

```rhombus
no_fill()
```

```racket
(no-fill)
```

---

## stroke

線・輪郭の色を設定します。

```rhombus
stroke("red")
stroke(0)
stroke(255, 255, 255)
```

```racket
(stroke "red")
(stroke 0)
```

---

## no_stroke

輪郭描画を無効にします。

```rhombus
no_stroke()
```

```racket
(no-stroke)
```

`no_fill` と `no_stroke` を両方使うと何も描かれません。

---

## stroke_weight

線の太さ（ピクセル）。

```rhombus
stroke_weight(5)
```

```racket
(stroke-weight 5)
```

---

## stroke_cap

線端の形状。

| 値 | 意味 |
|----|------|
| `#'round` | 丸 |
| `#'square` / `#'project` | 突き出し（projecting） |
| `#'butt` | 切り落とし |

```rhombus
stroke_cap(#'round)
```

```racket
(stroke-cap 'round)
```

---

## stroke_join

折れ線の接合部。

| 値 | 意味 |
|----|------|
| `#'miter` | 尖り |
| `#'bevel` | 面取り |
| `#'round` | 丸 |

```rhombus
stroke_join(#'miter)
```

```racket
(stroke-join 'miter)
```

---

## ellipse_mode / rect_mode

`ellipse` / `circle` / `arc` と `rect` / `square` の座標解釈を切り替えます。

| モード | 意味 |
|--------|------|
| `#'center` | `(x, y)` が中心、`w`/`h` が幅・高さ（ellipse 既定） |
| `#'corner` | `(x, y)` が左上（rect 既定） |
| `#'corners` | `(x, y)` と `(w, h)` が対角の 2 点 |
| `#'radius` | `(x, y)` が中心、`w`/`h` が半幅・半高 |

```rhombus
ellipse_mode(#'corners)
ellipse(150, 150, 50, 100)
ellipse_mode(#'center)

rect_mode(#'center)
rect(300, 50, 20, 40)
```

```racket
(ellipse-mode 'corners)
(rect-mode 'center)
```

---

## color

色オブジェクトを生成します（Racket 表面では `red` / `green` / `blue` / `alpha` で成分抽出可）。

```rhombus
let c = color(255, 204, 0)
fill(c)
```

```racket
(define c (color 255 204 0))
(fill c)
(red c)    ; => 255
(green c)
(blue c)
(alpha c)
```

---

## 関連

- 図形: [Drawing Primitives](Drawing-Primitives)
- チートシート: [Cheat Sheet](Cheat-Sheet)
