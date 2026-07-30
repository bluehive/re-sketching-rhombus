# re-sketching-rhombus

**Racket / Rhombus** 向けの Processing 風クリエイティブコーディング環境です。[Sketching](https://github.com/soegaard/sketching) を参照実装として再実装しています（フォークではありません）。

**Implemented by Grok (xAI).**  
**ライセンス:** MIT  

[English README](README.en.md)

関連 Issue: [bluehive/mypublish-gameoflife#14](https://github.com/bluehive/mypublish-gameoflife/issues/14)

## 目標

- `#lang re_sketching` で `setup` / `draw` を自動起動（イベントハンドラも任意で定義可能）
- Processing 風 API（描画・マウス/キーのシステム変数・座標変換）
- **主表面は Rhombus（shrubbery / 「S 式のカッコなし」）**
- 互換用に Racket S 式表面 `#lang re_sketching/racket` も提供
- [sketching-examples/test](https://github.com/soegaard/sketching/tree/main/sketching-examples/test) の意図を `examples/test/` の書き直しスケッチで再現

## 必要環境

- **Racket ≥ 8.14**（Rhombus 用。mise で `racket = "8.18"` を**必須**に近い）
- パッケージ: `rhombus` / `shrubbery`（および draw / gui）

### 重要: システム Racket 8.10 では動かない

Ubuntu 等に入っている **DrRacket 8.10** では `#lang re_sketching`（Rhombus 表面）は実行できません。  
`shrubbery` / `rhombus` は **8.18 側のパッケージ領域**に入っており、8.10 からは見えません。また公式 Rhombus も base ≥ 8.14 を要求します。

| 使い方 | コマンド / 手順 |
|--------|----------------|
| CLI | `export PATH="$HOME/.local/share/mise/installs/racket/8.18/bin:$PATH"` のあと `racket examples/test/sketch1.rhm` |
| DrRacket | **8.18 付属の** `drracket` を起動する（下参照）。メニューの 8.10 版は使わない |
| S 式だけ 8.10 で試す | `#lang re_sketching/racket`（`shrubbery` 不要。ただし 8.10 に `re-sketching-lib` が入っている必要あり） |

```bash
# mise 利用時
mise install
eval "$(mise activate bash)"   # または mise の shims を PATH に

# ローカルに rhombus がある場合の例（必ず 8.18 の raco で）
export PATH="$HOME/.local/share/mise/installs/racket/8.18/bin:$PATH"
raco pkg install --auto --link \
  ~/my-project/rhombus/shrubbery-lib \
  ~/my-project/rhombus/enforest-lib \
  ~/my-project/rhombus/shrubbery \
  ~/my-project/rhombus/enforest \
  ~/my-project/rhombus/rhombus-lib \
  ~/my-project/rhombus/rhombus

raco pkg install --auto --link re-sketching-lib re-sketching
```

### DrRacket（8.18）で最小例を開く

```bash
export PATH="$HOME/.local/share/mise/installs/racket/8.18/bin:$PATH"
# バージョン確認 → 8.18 であること
racket --version
drracket ~/my-project/re-sketching-rhombus/examples/test/sketch6.rhm
```

または:

```bash
cd ~/my-project/re-sketching-rhombus
mise run drracket -- examples/test/sketch6.rhm
```

起動後、ウィンドウ下部に **「ようこそ DrRacket, バージョン 8.18」** と出ていることを確認してください。  
**8.10** のままなら、別バイナリ（`/usr/bin/drracket`）が起動しています。

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

### インデントに注意（Rhombus）

`draw` / `setup` の中身は **必ずその関数のブロック内**（`:` の下に字下げ）に書いてください。  
行頭に戻ったコメントや文は **関数の外**（モジュール先頭）として実行され、毎フレーム再描画されません。

```rhombus
// NG: line/ellipse が draw の外
fun draw():
  background(128)

// ここは draw の外
stroke(200)
line(0, height/2, width, height/2)

// OK
fun draw():
  background(128)
  stroke(200)
  line(0, height/2, width, height/2)
```

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

## ドキュメント

| 場所 | 内容 |
|------|------|
| [Cheat Sheet](docs/cheat-sheet.md) | Sketching Overview 風の関数一覧 |
| [Examples](docs/examples.md) | Sketching Examples 風の描写サンプル（説明 + コード） |
| [Rhombus Essentials (Wiki)](https://github.com/bluehive/re-sketching-rhombus/wiki/Rhombus-Essentials) | Rhombus 基本文法・シンタックス |
| [GitHub Wiki](https://github.com/bluehive/re-sketching-rhombus/wiki) | 描写 API・Rhombus 文法・サンプルの詳細 |
| `wiki/*.md` | Wiki のソース（リポジトリ内ミラー） |
| `scripts/publish-wiki.sh` | `wiki/` → GitHub Wiki へ同期 |

マニュアル例の実行:

```bash
racket examples/manual/input/easing.rhm
racket examples/manual/math/sine-wave.rhm
```

## ディレクトリ構成

| パス | 役割 |
|------|------|
| `re-sketching-lib/re_sketching/` | ランタイム + `#lang re_sketching`（Rhombus） |
| `re-sketching-lib/re_sketching/racket/` | `#lang re_sketching/racket` |
| `re-sketching/` | メタパッケージ |
| `examples/test/*.rhm` | sketch1–9（Rhombus・主） |
| `examples/test/*.rkt` | 同上（Racket 互換） |
| `examples/manual/` | Sketching Examples 相当の描写サンプル |
| `docs/cheat-sheet.md` | API チートシート |
| `docs/examples.md` | サンプル説明 + コード |
| `wiki/` | GitHub Wiki 用 Markdown |
| `plan.md` | エージェント向け進捗プラン |

## アーキテクチャメモ

- 描画・ウィンドウは当面 **`racket/draw` + `racket/gui`**（イベントループが安定）
- Rhombus 層は API の再エクスポートと `#%module_block` による setup/draw 自動起動
- 将来 `rhombus/draw` / `rhombus/gui` バックエンドも検討可能

## 未実装 API と現状の制限

本プロジェクトは Sketching の**フォークではなく**、API を参考にした**ゼロからの再実装**です。  
最初の目標は「`setup` / `draw` が回り、基本的な 2D 図形・入力・座標変換で sketching-test 相当が動くこと」であり、Sketching / Processing の全 API 網羅は意図的に後回しにしています。

### なぜ未実装があるか

1. **スコープを切っている** — ランタイム（状態・GUI ループ）と Rhombus 表面を先に安定させ、周辺 API は段階的に足す方針です（`plan.md` の Phase 1–3）。
2. **フォークではない** — Sketching のソースを引き継いでいないため、未使用の大量 API をコピーするのではなく、使うものから実装しています。
3. **参照実装との差分** — 例やドキュメントは Sketching に揃えていますが、HSB・文字・画像・ベジェなどはまだコアに含めていません。
4. **回避策があるもの** — 例: グラデーションは `remap` + RGB 補間、正多角形は `triangle` 扇、三角関数は Rhombus の `math.sin` / `math.cos` など。

### 主な未実装（Sketching / Processing 相当）

| 領域 | 例 | 備考 |
|------|-----|------|
| 色モード | `color_mode` (HSB), `lerp_color`, `hue` / `saturation` / `brightness` | 現状は RGB 的な解釈のみ |
| 曲線・頂点 | `bezier`, `begin_shape` / `vertex` / `end_shape` | 多角形は `triangle` / `quad` 等で近似可 |
| タイポグラフィ | `text`, `text_size`, `text_align`, … | 未実装 |
| 画像・ピクセル | `image`, `load_image`, `load_pixels`, `set_pixel`, … | 未実装 |
| 時刻 | `millis`, `year` / `month` / `day` / `hour` / … | `frame_count` で代替する例あり |
| ノイズ | `noise`, simplex-noise | 未実装 |
| 数学の一部 | Sketching 専用の `+=` / `sin` 束縛など | Rhombus/Racket 標準を利用 |
| その他 | `smoothing` / `no_smooth`, `nap`, `save`, Sketching の `class` 糖衣 など | 未実装または言語側で代替 |

**実装済みの中心:** 2D プリミティブ（`point` / `line` / `ellipse` / `circle` / `arc` / `rect` / `square` / `quad` / `triangle`）、fill/stroke、transform、マウス/キーとイベント、`dist` / `lerp` / `constrain` / `remap` / `random` など。一覧は [docs/cheat-sheet.md](docs/cheat-sheet.md) と [Wiki](https://github.com/bluehive/re-sketching-rhombus/wiki) を参照。

マニュアル例（`examples/manual/`）のうち、上記に依存する Sketching 元例は**意図を保った改変**か**未移植**として [docs/examples.md](docs/examples.md) に記載しています。

## 謝辞

- [Sketching](https://github.com/soegaard/sketching) — Jens Axel Søgaard ほか（API の着想元）
- [Processing](https://processing.org/) — Ben Fry & Casey Reas
- [Rhombus](https://rhombus-lang.org/)
