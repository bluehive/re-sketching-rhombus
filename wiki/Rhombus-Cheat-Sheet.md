# Rhombus Cheat Sheet

[Rhombus Essentials](https://docs.racket-lang.org/rhombus-guide/Rhombus_Essentials.html) の **クイックリファレンス** です。  
詳しい説明は [Rhombus Essentials（解説）](Rhombus-Essentials)。描画 API は [Cheat Sheet](Cheat-Sheet)（re-sketching）。

**re-sketching:** `#lang re_sketching` でも同じ文法が使えます。

---

## Notation（記法）

| 項目 | 要点 |
|------|------|
| 空白 | **インデントと改行**が構文 |
| `:` | ブロック開始（構造トークン、演算子ではない） |
| `\|` | 分岐の枝（`if` / `cond` / `match` / 複数ケース） |
| `~name` | **キーワード**（識別子とは別） |
| `"..."` | 文字列 |
| `'...'` | コード（shrubbery）のクォート |
| `//` | 行コメント |

```rhombus
fun f(x):
  x + 1    // 字下げ = ブロック内
```

→ [詳細](Rhombus-Essentials#1-記法notation)

---

## Module / def / fun

```rhombus
#lang rhombus          // re-sketching なら #lang re_sketching

def n = 32
def big:
  1 + 2

fun add(a, b):
  a + b

add(1, 2)
```

| フォーム | 役割 |
|----------|------|
| `def name = expr` | 不変束縛（短い右辺） |
| `def name: block` | 不変束縛（ブロック） |
| `fun name(args): body` | 関数定義 |
| `fun (args): body` | 匿名関数 |

### import / export

```rhombus
export:
  name1
  name2

import:
  "file.rhm"              // 接頭辞 = ファイル名
  "file.rhm" as pref      // 接頭辞 pref
  "file.rhm" open         // 接頭辞なし
  rhombus/measure         // ライブラリ
  lib("racket/math.rkt") as rkt_math
```

→ [詳細](Rhombus-Essentials#2-モジュール変数関数)

---

## Class / pattern

```rhombus
class Posn(x, y)

def p = Posn(1, 2)
p.x
Posn.x(p)                 // クラス専用アクセサ

fun flip(Posn(x, y)):     // パターン分解
  Posn(y, x)

fun only_origin(Posn(0, 0)):
  p
```

| 同じ名前 `Posn` の役割 | 例 |
|------------------------|-----|
| コンストラクタ | `Posn(0, 0)` |
| 型・アノテーション | `p :: Posn` |
| パターン | `fun f(Posn(x, y)):` |
| 名前空間 | `Posn.x` |

```rhombus
fun f(p :: Posn.of(Int, Int)):
  Posn(p.y, p.x)
```

| その他 | 意味 |
|--------|------|
| `let` | 後方スコープの局所束縛（影付き可） |
| `_` | マッチするが束縛しない |

→ [詳細](Rhombus-Essentials#3-クラスと束縛パターン)

---

## Annotation / `.`

| 演算子 | 意味 | いつ使う |
|--------|------|----------|
| `::` | 実行時チェックあり | 境界・安価な検査 |
| `:~` | チェック弱め／静的情報 | 高価な検査を避けたいとき |
| `is_a` | 真偽を返す | 分岐で型を知りたいとき |

```rhombus
fun flip(p :: Posn):
  Posn(p.y, p.x)

(p :: Posn).x
p is_a Posn

// よく使う注釈: Int · Number · String · Keyword · Any · クラス名
```

| `.` の用法 | 例 |
|------------|-----|
| フィールド | `p.x` |
| import 接頭辞 | `mod.foo` |
| クラス名前空間 | `Posn.x` |

```rhombus
use_static     // . は効率モードのみ（コンパイル時に厳格）
use_dynamic    // 動的ルックアップ許容（#lang rhombus に近い）
```

→ [詳細](Rhombus-Essentials#4-アノテーションとドット)

---

## Optional / keyword args

```rhombus
fun scale(Posn(x, y), factor = 1):
  Posn(factor * x, factor * y)

fun transform(Posn(x, y),
              ~scale: factor = 1,
              ~dx = 0,
              ~dy = 0):
  Posn(factor * x + dx, factor * y + dy)

transform(Posn(1, 2), ~dx: 7, ~scale: 2)
```

```rhombus
def curried:
  fun (x):
    fun (y):
      x + y

#'~scale    // キーワード値
#'center    // シンボル（re-sketching の mode などで使用）
```

→ [詳細](Rhombus-Essentials#5-省略可能引数とキーワード引数)

---

## Conditionals / match

| 演算子 | 意味 |
|--------|------|
| `&&` `\|\|` `!` | 短絡 and / or / not |
| `==` | 構造的等価（不変） |
| `is_now` | 可変も含む構造比較 |
| `===` | 同一オブジェクト |

優先順位目安: 算術 > 比較 / `!` > `&&` > `||`

```rhombus
if cond
| then_expr
| else_expr

cond
| test1: body1
| test2: body2
| ~else: body

match value
| pattern1: body1
| pattern2: body2
| _: default

// fun 複数ケース
fun
| fib(0): 1
| fib(1): 1
| fib(n): fib(n - 1) + fib(n - 2)

guard ok? | early_result     // 偽なら early_result でブロック脱出
```

→ [詳細](Rhombus-Essentials#6-条件とパターンマッチ)

---

## Operators

```rhombus
operator (x <> y):
  ~weaker_than: * / + -
  ~associativity: ~right
  Posn(x, y)

1 <> 2 * 3

export:
  <>

import:
  "posn.rhm".(<>)
```

| キーワード | 意味 |
|------------|------|
| `~weaker_than` | これらより弱い |
| `~stronger_than` | これらより強い |
| `~associativity: ~left` / `~right` | 結合性 |

→ [詳細](Rhombus-Essentials#7-演算子)

---

## Mutable / values

```rhombus
def mutable x = 0
x := x + 1

fun f(mutable n):
  n := n + 1
  n

class Box(mutable content)
def b = Box(1)
b.content := 2

values(1, "a")
def (n, s) = values(1, "a")
def values(n, s) = values(1, "a")
```

| 既定 | 書き換え |
|------|----------|
| `def` は不変 | `mutable` + `:=` |

→ [詳細](Rhombus-Essentials#8-変数と値ミュータブル)

---

## Namespaces（名前空間）

| 形 | 例 |
|----|-----|
| import 接頭辞 | `f2c.foo` |
| クラス名前空間 | `Posn.x` |
| オブジェクト | `p.x` |

→ [詳細](Rhombus-Essentials#9-名前空間)

---

## re-sketching ミニ

```rhombus
#lang re_sketching

def mutable angle = 0.0

fun setup():
  size(400, 300)

fun draw():
  background(240)
  if mouse_pressed
  | fill("orange")
  | fill(200)
  angle := angle + 0.02
  translate(width / 2.0, height / 2.0)
  rotate(angle)
  rect_mode(#'center)
  rect(0, 0, 80, 80)
```

| 落とし穴 | 対策 |
|----------|------|
| `draw` の外に書いた描画 | **`:` の下に字下げ**する |
| 行頭の文 | モジュール先頭＝1 回だけ実行 |

```rhombus
// 反復の一例
for (i in 0..10):
  println(i)

def mutable i = 0
while i < 10:
  i := i + 2
```

→ [詳細](Rhombus-Essentials#10-re-sketching-での実践) · 描画 API [Cheat Sheet](Cheat-Sheet)

---

## 用語（1 行）

| 用語 | 一行 |
|------|------|
| 束縛 | 名前に値を結びつける |
| パターン | 形で受け取り、分解する |
| アノテーション | 種類の約束（`Int`, `Posn`…） |
| shrubbery | インデントで木を表す記法 |
| dot provider | `.` を型付き／効率的に解決できる束縛 |

---

## リンク

- 解説: [Rhombus Essentials](Rhombus-Essentials)
- 公式: [Rhombus Essentials](https://docs.racket-lang.org/rhombus-guide/Rhombus_Essentials.html)
- 描画: [Cheat Sheet](Cheat-Sheet) · [Examples](Examples)
