# re-sketching-rhombus

**Racket / Rhombus** 向けの Processing 風クリエイティブコーディング環境です。[Sketching](https://github.com/soegaard/sketching) を参照実装として再実装しています（フォークではありません）。

**Implemented by Grok (xAI).**  
**ライセンス:** MIT  

関連 Issue: [bluehive/mypublish-gameoflife#14](https://github.com/bluehive/mypublish-gameoflife/issues/14)

## 目標

- `#lang re_sketching` で `setup` / `draw` を自動起動（イベントハンドラも任意で定義可能）
- Processing 風 API（描画・マウス/キーのシステム変数・座標変換）
- **主表面は Rhombus（shrubbery / 「S 式のカッコなし」）**
- 互換用に Racket S 式表面 `#lang re_sketching/racket` も提供
- [sketching-examples/test](https://github.com/soegaard/sketching/tree/main/sketching-examples/test) の意図を `examples/test/` の書き直しスケッチで再現

## 必要環境

- **Racket ≥ 8.14**（Rhombus 用。mise で `racket = "8.18"` を推奨）
- パッケージ: `rhombus`（および draw / gui）

```bash
# mise 利用時
mise install
eval "$(mise activate bash)"   # または mise の shims を PATH に

# ローカルに rhombus がある場合の例
raco pkg install --auto --link \
  ~/my-project/rhombus/shrubbery-lib \
  ~/my-project/rhombus/enforest-lib \
  ~/my-project/rhombus/shrubbery \
  ~/my-project/rhombus/enforest \
  ~/my-project/rhombus/rhombus-lib \
  ~/my-project/rhombus/rhombus

raco pkg install --auto --link re-sketching-lib re-sketching
```

## クイックスタート

```bash
cd ~/my-project/re-sketching-rhombus
racket examples/test/sketch1.rhm
```

mise タスク:

```bash
mise run install
mise run run-sketch -- sketch1
```

## 最小スケッチ（Rhombus）

```rhombus
#lang re_sketching

fun setup():
  size(400, 300)
  frame_rate(30)

fun draw():
  background(240)
  fill("orange")
  circle(mouse_x, mouse_y, 40)
```

### イベントハンドラ

`on_mouse_pressed`, `on_mouse_released`, `on_mouse_moved`, `on_mouse_dragged`,  
`on_key_pressed`, `on_key_released`  

（真偽値のシステム変数 `mouse_pressed` との衝突を避けるためです。Racket 表面ではハイフン形 `on-mouse-pressed` も可。）

### システム変数（括弧なしの識別子）

`width`, `height`, `frame_count`, `mouse_x`, `mouse_y`, `pmouse_x`, `pmouse_y`,  
`mouse_pressed`, `mouse_button`, `key`, `key_pressed`, `key_released`,  
`pixel_width`, `pixel_height`

## Racket S 式表面

```racket
#lang re_sketching/racket

(define (setup)
  (size 400 300))

(define (draw)
  (background 240)
  (circle mouse-x mouse-y 40))
```

`examples/test/sketch*.rkt` がこの表面です。

## ディレクトリ構成

| パス | 役割 |
|------|------|
| `re-sketching-lib/re_sketching/` | ランタイム + `#lang re_sketching`（Rhombus） |
| `re-sketching-lib/re_sketching/racket/` | `#lang re_sketching/racket` |
| `re-sketching/` | メタパッケージ |
| `examples/test/*.rhm` | sketch1–9（Rhombus・主） |
| `examples/test/*.rkt` | 同上（Racket 互換） |
| `plan.md` | エージェント向け進捗プラン |

## アーキテクチャメモ

- 描画・ウィンドウは当面 **`racket/draw` + `racket/gui`**（イベントループが安定）
- Rhombus 層は API の再エクスポートと `#%module_block` による setup/draw 自動起動
- 将来 `rhombus/draw` / `rhombus/gui` バックエンドも検討可能

## 謝辞

- [Sketching](https://github.com/soegaard/sketching) — Jens Axel Søgaard ほか（API の着想元）
- [Processing](https://processing.org/) — Ben Fry & Casey Reas
- [Rhombus](https://rhombus-lang.org/)
