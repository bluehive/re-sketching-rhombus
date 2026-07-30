# Examples

[Sketching Examples](https://docs.racket-lang.org/manual-sketching/Examples.html) に沿った描写サンプルです。

ソース: リポジトリ `examples/manual/` · Markdown ミラー: `docs/examples/`

```bash
racket examples/manual/input/easing.rhm
```

| カテゴリ | 内容 |
|----------|------|
| [Color](Examples-Color) | 色の束縛・相対的な見え方・グラデーション。 |
| [Input](Examples-Input) | マウス・キーボード入力とイベントハンドラ。 |
| [Transform](Examples-Transform) | 座標変換（translate / scale / rotate）と行列スタック。 |
| [Form](Examples-Form) | 基本図形・曲線・頂点・円グラフ・正多角形・フラクタル。 |
| [Math](Examples-Math) | 距離・写像・三角関数・ノイズ・極座標。 |

## カテゴリ

### [Color](Examples-Color)

- **Color Variables** — 色を `color(...)` で変数に束縛し、入れ子の矩形（Albers へのオマージュ）を描きます。
- **Relativity** — 同じ 5 色でも並び順が変わると印象が変わることを、上下 2 本の帯で示します。
- **Linear Gradient** — `remap` と RGB 補間で水平・垂直グラデーションを描きます（`lerp-color` 未実装のため自前補間）。

### [Input](Examples-Input)

- **Mouse 1D** — `mouse_x` で左右の矩形の大きさと明度のバランスを制御します。
- **Mouse 2D** — マウス位置に連動する矩形と、その対称コピーを描きます。
- **Mouse Press** — マウス位置に十字。`mouse_pressed` で線色を反転します。
- **Easing** — カーソルへ滑らかに追従する円（イージング係数 0.05）。
- **Constrain** — イージング移動を `constrain` で枠内に制限します。
- **Mouse Functions** — `on_mouse_pressed` / `dragged` / `released` で矩形をドラッグ。
- **Keyboard** — 文字キーで縦帯を描画。非文字でクリア（色は `frame_count` 由来）。

### [Transform](Examples-Transform)

- **Translate** — 原点を動かし、同じ引数の矩形が異なる速度でスライドする様子。
- **Scale** — `cos` でスケールを変え、拡大縮小する矩形。
- **Rotate** — 中心まわりに回転する正方形。ジッターで不規則な回転。
- **Arm** — 2 セグメントの腕。`mouse_x` / `mouse_y` が関節角。

### [Form](Examples-Form)

- **Points and Lines** — `point` と `line` による基本幾何。
- **Pie Chart** — `arc` と角度データから円グラフ。
- **Regular Polygons** — `begin_shape` / `vertex` で正多角形を描き回転。
- **Bezier** — 3 次ベジェ曲線。
- **Begin Shape** — 星形・折れ線・points モード。
- **Fractal: Sierpinski** — シェルピンスキーの三角形（再帰分割）。
- **Fractal: Koch Snowflake** — コッホ雪片。
- **Fractal: Tree** — マウスで開く角・深さを変える再帰ツリー。

### [Math](Examples-Math)

- **Distance 2D** — マウスからの距離で楕円サイズが変わる距離場。
- **Remap** — `mouse_x` を色と直径に写像。
- **Sine** — `sin` で直径が脈動する 3 円。
- **Sine Cosine** — sin/cos で中心矩形の周囲を回る円。
- **Sine Wave** — 横並びの円でサイン波をアニメーション。
- **Noise Wave** — 1D Perlin `noise` で波を揺らす。
- **Polar to Cartesian** — 極座標 `(r, θ)` を直交座標へ変換して公転。

## 注意

- 主表面は Rhombus（`#lang re_sketching`）。
- HSB `color_mode` / `lerp_color` / `text` / `image` / `millis` などは未実装のため、同等の意図で改変している例があります。
- `bezier` / `begin_shape` / `noise` は実装済み（`examples/manual/form/` · `math/noise-wave.rhm`）。
- 元: [Sketching manual-examples](https://github.com/soegaard/sketching/tree/main/sketching-doc/sketching-doc/manual-examples) · [Processing Examples](https://processing.org/examples/)
