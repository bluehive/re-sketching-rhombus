# Drawing Primitives（2D 図形）

Processing / Sketching 風の 2D プリミティブです。座標はキャンバス左上が `(0, 0)`、右方向が +x、下方向が +y。

現在の [fill](Color-and-Style#fill) / [stroke](Color-and-Style#stroke) と、[ellipse_mode](Color-and-Style#ellipse_mode--rect_mode) / [rect_mode](Color-and-Style#ellipse_mode--rect_mode) が適用されます。

---

## point

点を描画します。

### Rhombus

```rhombus
point(x, y)
```

### Racket

```racket
(point x y)
```

### 引数

| 名前 | 意味 |
|------|------|
| `x`, `y` | 点の座標 |

### 例

```rhombus
stroke(0)
stroke_weight(4)
point(50, 50)
```

---

## line

2 点を結ぶ線分を描画します。

### Rhombus

```rhombus
line(x1, y1, x2, y2)
```

### Racket

```racket
(line x1 y1 x2 y2)
```

### 引数

| 名前 | 意味 |
|------|------|
| `x1`, `y1` | 始点 |
| `x2`, `y2` | 終点 |

### 例

```rhombus
stroke("red")
stroke_weight(5)
line(0, 0, width, height)
```

---

## ellipse

楕円を描画します。位置・サイズの解釈は [ellipse_mode](Color-and-Style#ellipse_mode--rect_mode) に従います（既定: `#'center`）。

### Rhombus

```rhombus
ellipse(x, y, w, h)
```

### Racket

```racket
(ellipse x y w h)
```

### 引数

| 名前 | 意味（`#'center` 時） |
|------|----------------------|
| `x`, `y` | 中心 |
| `w`, `h` | 幅・高さ |

### 例

```rhombus
fill("green")
ellipse(300, 300, 50, 100)
```

---

## circle

円を描画します。`ellipse(x, y, extent, extent)` と同等です。

### Rhombus

```rhombus
circle(x, y, extent)
```

### Racket

```racket
(circle x y extent)
```

### 引数

| 名前 | 意味（`#'center` 時） |
|------|----------------------|
| `x`, `y` | 中心 |
| `extent` | 直径（幅＝高さ） |

### 例

```rhombus
fill("orange")
circle(mouse_x, mouse_y, 40)
```

---

## arc

円弧を描画します。角度は **ラジアン**、Processing と同様に **3 時の位置を 0** とし **時計回り** です。

### Rhombus

```rhombus
arc(x, y, w, h, start, stop)
// mode 引数は現状予約（省略可）
arc(x, y, w, h, start, stop, mode)
```

### Racket

```racket
(arc x y w h start stop)
(arc x y w h start stop mode)
```

### 引数

| 名前 | 意味 |
|------|------|
| `x`, `y`, `w`, `h` | 楕円と同じ（`ellipse_mode` 適用） |
| `start`, `stop` | 開始角・終了角（ラジアン、時計回り） |
| `mode` | 省略可（将来用） |

### 例

```rhombus
fill("blue")
stroke("white")
arc(50, 50, 100, 100, 0, 3.14)
```

---

## rect

矩形を描画します。位置・サイズは [rect_mode](Color-and-Style#ellipse_mode--rect_mode) に従います（既定: `#'corner`）。

### Rhombus

```rhombus
rect(x, y, w, h)
rect(x, y, w, h, r)   // 角丸半径 r
```

### Racket

```racket
(rect x y w h)
(rect x y w h r)
```

### 引数

| 名前 | 意味（`#'corner` 時） |
|------|----------------------|
| `x`, `y` | 左上 |
| `w`, `h` | 幅・高さ |
| `r` | 角丸半径（省略時は直角） |

### 例

```rhombus
rect_mode(#'center)
rect(300, 50, 20, 40, 5)
```

---

## square

正方形。`rect(x, y, extent, extent)` と同等です。

### Rhombus

```rhombus
square(x, y, extent)
```

### Racket

```racket
(square x y extent)
```

---

## quad

4 頂点の四角形を描画します。

### Rhombus

```rhombus
quad(x1, y1, x2, y2, x3, y3, x4, y4)
```

### Racket

```racket
(quad x1 y1 x2 y2 x3 y3 x4 y4)
```

### 例

```rhombus
quad(300, 100, 300, 200, 400, 200, 400, 100)
```

---

## triangle

3 頂点の三角形を描画します。

### Rhombus

```rhombus
triangle(x1, y1, x2, y2, x3, y3)
```

### Racket

```racket
(triangle x1 y1 x2 y2 x3 y3)
```

### 例

```rhombus
triangle(10, 10, 20, 20, 0, 50)
```

---

## bezier

3 次ベジェ曲線（始点 → 制御点1 → 制御点2 → 終点）。

### Rhombus

```rhombus
bezier(x1, y1, x2, y2, x3, y3, x4, y4)
```

### Racket

```racket
(bezier x1 y1 x2 y2 x3 y3 x4 y4)
```

### 例

```rhombus
no_fill()
stroke(255)
bezier(80, 180, mouse_x, mouse_y, 400, 50, 560, 180)
```

ファイル: `examples/manual/form/bezier.rhm`

---

## begin_shape / vertex / end_shape

自由形状。`begin_shape` のあと `vertex` を並べ、`end_shape` で描画します。

### Rhombus

```rhombus
begin_shape()                 // または begin_shape(#'points) など
vertex(x, y)
// ...
end_shape()                   // 開いた折れ線
end_shape(#'close)            // 閉じた多角形
```

### Racket

```racket
(begin-shape)
(begin-shape 'points)
(vertex x y)
(end-shape)
(end-shape 'close)
```

### kind（任意）

| kind | 意味 |
|------|------|
| 省略 / `#'default` | 折れ線・多角形（パス） |
| `#'points` | 各頂点を点で描画 |
| `#'lines` | 2 点ずつ線分 |
| `#'triangles` | 3 点ずつ三角形 |

### 例

```rhombus
begin_shape()
vertex(50, 50)
vertex(150, 50)
vertex(100, 150)
end_shape(#'close)
```

ファイル: `examples/manual/form/begin-shape.rhm` · `examples/manual/form/regular-polygons.rhm`

---

## 関連

- 色・線・モード: [Color and Style](Color-and-Style)
- 座標変換: [Transform](Transform)
- チートシート: [Cheat Sheet](Cheat-Sheet)
