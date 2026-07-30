# サンプルコード集

[Sketching Examples](https://docs.racket-lang.org/manual-sketching/Examples.html) に沿った `#lang re_sketching` の移植例です。

実行:

```bash
racket examples/manual/<category>/<name>.rhm
```

Wiki: [Examples](https://github.com/bluehive/re-sketching-rhombus/wiki/Examples)

未移植・差分: Typography / Image / 一部 Color(HSB) / millis 依存の厳密移植 など。  
**実装済みの追加例:** `bezier` · `begin_shape` / `vertex` · `noise`（下記 Form / Math）。

## Color

色の束縛・相対的な見え方・グラデーション。

- **[Color Variables](examples/color.md#color-variables)** — 色を `color(...)` で変数に束縛し、入れ子の矩形（Albers へのオマージュ）を描きます。 (`examples/manual/color/color-variables.rhm`)
- **[Relativity](examples/color.md#relativity)** — 同じ 5 色でも並び順が変わると印象が変わることを、上下 2 本の帯で示します。 (`examples/manual/color/relativity.rhm`)
- **[Linear Gradient](examples/color.md#linear-gradient)** — `remap` と RGB 補間で水平・垂直グラデーションを描きます（`lerp-color` 未実装のため自前補間）。 (`examples/manual/color/linear-gradient.rhm`)

## Input

マウス・キーボード入力とイベントハンドラ。

- **[Mouse 1D](examples/input.md#mouse-1d)** — `mouse_x` で左右の矩形の大きさと明度のバランスを制御します。 (`examples/manual/input/mouse-1d.rhm`)
- **[Mouse 2D](examples/input.md#mouse-2d)** — マウス位置に連動する矩形と、その対称コピーを描きます。 (`examples/manual/input/mouse-2d.rhm`)
- **[Mouse Press](examples/input.md#mouse-press)** — マウス位置に十字。`mouse_pressed` で線色を反転します。 (`examples/manual/input/mouse-press.rhm`)
- **[Easing](examples/input.md#easing)** — カーソルへ滑らかに追従する円（イージング係数 0.05）。 (`examples/manual/input/easing.rhm`)
- **[Constrain](examples/input.md#constrain)** — イージング移動を `constrain` で枠内に制限します。 (`examples/manual/input/constrain.rhm`)
- **[Mouse Functions](examples/input.md#mouse-functions)** — `on_mouse_pressed` / `dragged` / `released` で矩形をドラッグ。 (`examples/manual/input/mouse-functions.rhm`)
- **[Keyboard](examples/input.md#keyboard)** — 文字キーで縦帯を描画。非文字でクリア（色は `frame_count` 由来）。 (`examples/manual/input/keyboard.rhm`)

## Transform

座標変換（translate / scale / rotate）と行列スタック。

- **[Translate](examples/transform.md#translate)** — 原点を動かし、同じ引数の矩形が異なる速度でスライドする様子。 (`examples/manual/transform/translate.rhm`)
- **[Scale](examples/transform.md#scale)** — `cos` でスケールを変え、拡大縮小する矩形。 (`examples/manual/transform/scale.rhm`)
- **[Rotate](examples/transform.md#rotate)** — 中心まわりに回転する正方形。ジッターで不規則な回転。 (`examples/manual/transform/rotate.rhm`)
- **[Arm](examples/transform.md#arm)** — 2 セグメントの腕。`mouse_x` / `mouse_y` が関節角。 (`examples/manual/transform/arm.rhm`)

## Form

基本図形・円グラフ・正多角形・曲線・頂点。

- **[Points and Lines](examples/form.md#points-and-lines)** — `point` と `line` による基本幾何。 (`examples/manual/form/points-and-lines.rhm`)
- **[Pie Chart](examples/form.md#pie-chart)** — `arc` と角度データから円グラフ。 (`examples/manual/form/pie-chart.rhm`)
- **[Regular Polygons](examples/form.md#regular-polygons)** — `begin_shape` / `vertex` で正多角形を描き回転。 (`examples/manual/form/regular-polygons.rhm`)
- **[Bezier](../examples/manual/form/bezier.rhm)** — 3 次ベジェ曲線（マウスが制御点）。 (`examples/manual/form/bezier.rhm`)
- **[Begin Shape](../examples/manual/form/begin-shape.rhm)** — 星形・折れ線・points モード。 (`examples/manual/form/begin-shape.rhm`)
- **[Fractal: Sierpinski](../examples/manual/form/fractal-sierpinski.rhm)** — シェルピンスキーの三角形。 (`examples/manual/form/fractal-sierpinski.rhm`)
- **[Fractal: Koch Snowflake](../examples/manual/form/fractal-koch.rhm)** — コッホ雪片。 (`examples/manual/form/fractal-koch.rhm`)
- **[Fractal: Tree](../examples/manual/form/fractal-tree.rhm)** — 再帰ツリー（マウスで角・深さ）。 (`examples/manual/form/fractal-tree.rhm`)

## Math

距離・写像・三角関数・極座標・ノイズ。

- **[Distance 2D](examples/math.md#distance-2d)** — マウスからの距離で楕円サイズが変わる距離場。 (`examples/manual/math/distance-2d.rhm`)
- **[Remap](examples/math.md#remap)** — `mouse_x` を色と直径に写像。 (`examples/manual/math/remap.rhm`)
- **[Sine](examples/math.md#sine)** — `sin` で直径が脈動する 3 円。 (`examples/manual/math/sine.rhm`)
- **[Sine Cosine](examples/math.md#sine-cosine)** — sin/cos で中心矩形の周囲を回る円。 (`examples/manual/math/sine-cosine.rhm`)
- **[Sine Wave](examples/math.md#sine-wave)** — 横並びの円でサイン波をアニメーション。 (`examples/manual/math/sine-wave.rhm`)
- **[Noise Wave](../examples/manual/math/noise-wave.rhm)** — 1D Perlin `noise` で波を揺らす。 (`examples/manual/math/noise-wave.rhm`)
- **[Polar to Cartesian](examples/math.md#polar-to-cartesian)** — 極座標 `(r, θ)` を直交座標へ変換して公転。 (`examples/manual/math/polar-to-cartesian.rhm`)
