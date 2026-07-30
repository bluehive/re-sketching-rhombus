# re-sketching-rhombus Wiki

**Racket / Rhombus** 向け Processing 風クリエイティブコーディング環境のドキュメントです。  
[Sketching](https://github.com/soegaard/sketching) を参照実装として再実装しています（フォークではありません）。

| ページ | 内容 |
|--------|------|
| [Rhombus Essentials](Rhombus-Essentials) | Rhombus 基本文法・シンタックス（[公式 Essentials](https://docs.racket-lang.org/rhombus-guide/Rhombus_Essentials.html) 要約） |
| [Cheat Sheet](Cheat-Sheet) | 関数一覧のクイックリファレンス（[Sketching Overview](https://docs.racket-lang.org/manual-sketching/overview.html) 相当） |
| [Examples](Examples) | 描写サンプル（[Sketching Examples](https://docs.racket-lang.org/manual-sketching/Examples.html) 相当） |
| [Drawing Primitives](Drawing-Primitives) | `point` / `line` / `ellipse` / `circle` / `arc` / `rect` / `square` / `quad` / `triangle` |
| [Color and Style](Color-and-Style) | `background` / `fill` / `stroke` / ストローク属性 / モード |
| [Transform](Transform) | `translate` / `rotate` / `scale` / 行列スタック |
| [Environment](Environment) | `size` / `frame_rate` / ループ / ウィンドウ |
| [Input](Input) | マウス・キーのシステム変数とイベントハンドラ |
| [Math](Math) | 距離・補間・乱数・角度変換 |

## 言語表面

- **主:** `#lang re_sketching`（Rhombus / shrubbery、`snake_case`）
- **互換:** `#lang re_sketching/racket`（S 式、`kebab-case`）

`setup` / `draw` はモジュール読み込み時に自動起動します。イベントハンドラは任意定義です。

## リポジトリ

- ソース: https://github.com/bluehive/re-sketching-rhombus
- テスト例: `examples/test/sketch1.rhm` … `sketch9.rhm`
- マニュアル例: `examples/manual/`（[Examples](Examples)）
- リポジトリ内ミラー: `docs/` · `wiki/`

**Implemented by Grok (xAI).** MIT License.
