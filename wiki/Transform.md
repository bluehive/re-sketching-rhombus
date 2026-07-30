# Transform（座標変換）

描画コンテキストの変換行列を操作します。以降の図形座標に影響します。

正の `rotate` は Processing / Sketching と同様 **時計回り** です。

---

## translate

原点を移動します。

```rhombus
translate(dx, dy)
```

```racket
(translate dx dy)
```

---

## rotate

原点まわりに回転します（ラジアン、時計回り）。

```rhombus
rotate(angle)
```

```racket
(rotate angle)
```

度から変換する場合は [radians](Math#radians) を使います。

```rhombus
rotate(radians(45))
```

---

## scale

拡大縮小します。

```rhombus
scale(s)        // 等方
scale(sx, sy)   // 軸ごと
```

```racket
(scale s)
(scale sx sy)
```

---

## push_matrix / pop_matrix

変換行列をスタックに保存・復元します。局所的な変換に使います。

```rhombus
push_matrix()
translate(100, 100)
rotate(pi / 4)
rect(0, 0, 50, 20)
pop_matrix()
// ここからは変換前に戻る
```

```racket
(push-matrix)
(translate 100 100)
(rotate (/ pi 4))
(rect 0 0 50 20)
(pop-matrix)
```

空スタックで `pop_matrix` するとエラーになります。

---

## reset_matrix

変換を単位行列に戻します。

```rhombus
reset_matrix()
```

```racket
(reset-matrix)
```

---

## get_matrix / set_matrix（Racket 表面）

低レベル API。`dc` の transformation を取得・設定します。

```racket
(define t (get-matrix))
(set-matrix t)
```

---

## 関連

- 図形: [Drawing Primitives](Drawing-Primitives)
- 角度: [Math](Math)
