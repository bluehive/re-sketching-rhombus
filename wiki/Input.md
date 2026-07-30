# Input（マウス・キーボード）

システム変数は **括弧なし** の識別子として読めます。イベントは任意で `fun` / `define` するハンドラです。

> 真偽値の `mouse_pressed` と衝突しないよう、ハンドラ名は `on_mouse_pressed` です。

---

## mouse_x / mouse_y

現在のマウス座標（キャンバス基準）。

```rhombus
circle(mouse_x, mouse_y, 20)
```

```racket
(circle mouse-x mouse-y 20)
```

---

## pmouse_x / pmouse_y

前フレームのマウス座標。ドラッグ軌跡などに利用します。

```rhombus
line(pmouse_x, pmouse_y, mouse_x, mouse_y)
```

---

## mouse_pressed

いずれかのマウスボタンが押されていれば真。

```rhombus
when mouse_pressed:
  fill(255)
```

---

## mouse_button

押されているボタン。`#'left` / `#'right` / `#'middle` など。

```rhombus
fun on_mouse_pressed():
  match mouse_button
  | #'left: fill(255)
  | #'right: fill(0)
  | ~else: #void
```

```racket
(define (on-mouse-pressed)
  (case mouse-button
    [(left) (fill 255)]
    [(right) (fill 0)]
    [else (void)]))
```

---

## key / key_pressed / key_released

| 変数 | 意味 |
|------|------|
| `key` | 最後に関与したキー |
| `key_pressed` | キーが押されているか |
| `key_released` | リリース状態の補助フラグ |

---

## Event handlers

モジュール内で同名関数を定義すると、GUI ループから呼び出されます。未定義なら無視されます。

| Rhombus | Racket | タイミング |
|---------|--------|------------|
| `on_mouse_pressed` | `on-mouse-pressed` | ボタン押下 |
| `on_mouse_released` | `on-mouse-released` | ボタン解放 |
| `on_mouse_moved` | `on-mouse-moved` | 移動（ボタンなし） |
| `on_mouse_dragged` | `on-mouse-dragged` | ドラッグ |
| `on_key_pressed` | `on-key-pressed` | キー押下 |
| `on_key_released` | `on-key-released` | キー解放 |
| `on_resize` | `on-resize` | リサイズ |

### 例

```rhombus
#lang re_sketching

def mutable value = 0

fun setup():
  size(400, 300)

fun draw():
  background(value)

fun on_mouse_dragged():
  value := value + 5
  when value > 255
  | value := 0

fun on_key_pressed():
  println(key)
```

---

## 関連

- 環境: [Environment](Environment)
- 例: `examples/test/sketch1.rhm`
