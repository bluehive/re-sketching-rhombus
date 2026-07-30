# Math

スケッチ向けの数値ユーティリティ。三角関数そのものは Rhombus / Racket 標準を使います。

---

## dist

2 点間のユークリッド距離。

```rhombus
dist(x1, y1, x2, y2)
```

```racket
(dist x1 y1 x2 y2)
```

---

## lerp

線形補間。`t = 0` で `a`、`t = 1` で `b`。

```rhombus
lerp(a, b, t)
```

```racket
(lerp a b t)
```

---

## constrain

値を `[lo, hi]` にクランプ。

```rhombus
constrain(v, lo, hi)
```

```racket
(constrain v lo hi)
```

---

## norm

`start`–`stop` を 0–1 に正規化。

```rhombus
norm(v, start, stop)
```

```racket
(norm v start stop)
```

---

## remap

ある範囲から別範囲へ写像（Processing の `map` に相当）。

```rhombus
remap(v, start1, stop1, start2, stop2)
```

```racket
(remap v start1 stop1 start2 stop2)
```

---

## mag

2D ベクトルの長さ。

```rhombus
mag(x, y)
```

```racket
(mag x y)
```

---

## sq

二乗。

```rhombus
sq(x)
```

```racket
(sq x)
```

---

## random

乱数。

| 呼び出し | 結果 |
|----------|------|
| `random()` | `[0, 1)` |
| `random(hi)` | `[0, hi)` |
| `random(lo, hi)` | `[lo, hi)` |

```rhombus
random()
random(100)
random(10, 20)
```

```racket
(random)
(random 100)
(random 10 20)
```

> Racket 標準の `random` を上書きした Processing 風実装です。

---

## noise

Perlin 風の滑らかなノイズ（1–3 次元）。戻り値はおおよそ **0–1**。

### Rhombus

```rhombus
noise(x)
noise(x, y)
noise(x, y, z)
noise_seed(42)
noise_detail(4)           // オクターブ数
noise_detail(4, 0.5)      // オクターブ, falloff
```

### Racket

```racket
(noise x)
(noise x y)
(noise x y z)
(noise-seed 42)
(noise-detail 4 0.5)
```

### 例

```rhombus
let n = noise(frame_count * 0.01)
let y = height / 2.0 + (n - 0.5) * 100
```

ファイル: `examples/manual/math/noise-wave.rhm`

---

## radians / degrees

度 ↔ ラジアン。

```rhombus
radians(180)   // ≈ pi
degrees(pi)    // ≈ 180
```

```racket
(radians 180)
(degrees pi)
```

---

## Constants

| 名前 | 値 |
|------|-----|
| `pi` / `π` | π |
| `pi/2` / `π/2` | π/2（主に Racket 表面） |
| `pi/4` / `π/4` | π/4 |
| `2pi` / `2π` | 2π |

Rhombus 表面では `pi` をエクスポートしています。

---

## 関連

- 変換: [Transform](Transform)
- 円弧の角度: [Drawing Primitives — arc](Drawing-Primitives#arc)
