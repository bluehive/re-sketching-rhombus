# Environment

ウィンドウサイズ、フレーム、ループ制御など。

---

## setup / draw

モジュール読み込み時に自動起動されます。

| 関数 | 役割 |
|------|------|
| `setup` | 初期化（`size` / `frame_rate` など）。1 回 |
| `draw` | 毎フレームの描画 |

未定義の場合は何もしないデフォルトが使われます。

```rhombus
#lang re_sketching

fun setup():
  size(400, 300)
  frame_rate(30)

fun draw():
  background(240)
  circle(mouse_x, mouse_y, 40)
```

---

## size

キャンバス（ウィンドウ）サイズを設定します。通常は `setup` 内で呼び出します。

```rhombus
size(width, height)
```

```racket
(size w h)
```

---

## width / height

現在のキャンバス幅・高さ（システム変数。括弧なし）。

```rhombus
line(0, 0, width, height)
```

```racket
(line 0 0 width height)
```

---

## pixel_density

高 DPI 向けピクセル密度（例: Retina で `2`）。

```rhombus
pixel_density(2)
```

```racket
(pixel-density 2)
```

---

## pixel_width / pixel_height

物理ピクセル幅・高さ（`size` × `pixel_density` 相当の内部バッファ）。

---

## frame_count

開始からのフレーム番号（システム変数）。

```rhombus
let n = frame_count
```

---

## frame_rate

目標 FPS を設定します。Rhombus では `frame_rate(30)`。Racket では `(frame-rate 30)` または `(set-frame-rate! 30)`。識別子として読むと実測 FPS（Racket 表面の `actual-frame-rate`）も利用可能です。

```rhombus
frame_rate(30)
```

```racket
(frame-rate 30)
```

---

## loop / no_loop

描画ループの再開・停止。

```rhombus
no_loop()   // draw を止める
loop()      // 再開
```

```racket
(no-loop)
(loop)
```

---

## no_gui

GUI なしモード（ヘッドレス寄り）。テスト用途。

```rhombus
no_gui()
```

```racket
(no-gui)
```

---

## fullscreen

フルスクリーン表示を試みます。

```rhombus
fullscreen()
```

```racket
(fullscreen)
```

---

## set_title

ウィンドウタイトル。

```rhombus
set_title("My Sketch")
```

```racket
(set-title "My Sketch")
```

---

## cursor / no_cursor

マウスカーソルの表示制御。

```rhombus
cursor(#'arrow)  // 実装依存のシンボル
no_cursor()
```

```racket
(cursor 'arrow)
(no-cursor)
```

---

## focused

ウィンドウがフォーカスを持つか。Rhombus では `focused()`、Racket では `focused?`。

```rhombus
when focused():
  // ...
```

```racket
(when (focused?) ...)
```

---

## 関連

- 入力: [Input](Input)
- チートシート: [Cheat Sheet](Cheat-Sheet)
