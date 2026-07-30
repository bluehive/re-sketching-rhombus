# Rhombus Essentials（基本文法・シンタックス）

本ページは [Rhombus Guide — Rhombus Essentials](https://docs.racket-lang.org/rhombus-guide/Rhombus_Essentials.html) を要約したチートシートです。  
完全な仕様は公式ガイドを正とします。

**re-sketching での注意:** スケッチは `#lang re_sketching` ですが、言語表面は Rhombus です。下記の `def` / `fun` / `if` / `match` などはスケッチ内でも使えます（描画 API は [Cheat Sheet](Cheat-Sheet)）。

---

## 目次

1. [記法（Notation）](#1-記法notation)
2. [モジュール・変数・関数](#2-モジュール変数関数)
3. [クラスと束縛パターン](#3-クラスと束縛パターン)
4. [アノテーションとドット](#4-アノテーションとドット)
5. [省略可能引数とキーワード引数](#5-省略可能引数とキーワード引数)
6. [条件とパターンマッチ](#6-条件とパターンマッチ)
7. [演算子](#7-演算子)
8. [変数と値（ミュータブル）](#8-変数と値ミュータブル)
9. [名前空間](#9-名前空間)
10. [re-sketching での例](#10-re-sketching-での例)

---

## 1. 記法（Notation）

Rhombus は **shrubbery 記法** を使います。Lisp の S 式（カッコだらけ）の代わりに、**行末・インデント**と `:` / `|` で構造を表します。

| ポイント | 内容 |
|----------|------|
| 空白に敏感 | **改行とインデント**が意味を持つ |
| `:` と `\|` | 通常の演算子ではなく、**構造トークン**（ブロック・分岐） |
| キーワード | `~` で始まる（例: `~else`, `~scale`）。識別子とは別カテゴリ |
| コードのクォート | 文字列ではなく **単一引用符 `'...'`** でコード（shrubbery）をクォート |
| `( )` `[ ]` `{ }` `' '` | 内側でもインデント規則が効く |

詳細: [Shrubbery Notation](https://docs.racket-lang.org/shrubbery/) · [Notation](https://docs.racket-lang.org/rhombus-guide/Notation.html)

---

## 2. モジュール・変数・関数

### モジュール先頭

```rhombus
#lang rhombus

1 + 4              // モジュール先頭の式は値が表示される
"Hello, world!"
```

re-sketching では:

```rhombus
#lang re_sketching

fun setup():
  size(400, 300)
```

### `def` — 不変の束縛

```rhombus
def fahrenheit_freezing = 32
// または（大きな式向き）
def fahrenheit_freezing:
  32
```

### `fun` — 関数定義

```rhombus
fun fahrenheit_to_celsius(f):
  (f - 32) * 5/9

fahrenheit_to_celsius(fahrenheit_freezing)  // => 0
```

### `import` / `export`

```rhombus
// f2c.rhm
export:
  fahrenheit_freezing
  fahrenheit_to_celsius

// freezing.rhm
import:
  "f2c.rhm"

f2c.fahrenheit_to_celsius(f2c.fahrenheit_freezing)

// 接頭辞を付ける
import:
  "f2c.rhm" as convert

// 接頭辞なし（衝突に注意）
import:
  "f2c.rhm" open

// ライブラリ（最後のパス要素が既定接頭辞）
import:
  rhombus/measure

// Racket モジュール
import:
  lib("racket/math.rkt") as rkt_math
```

詳細: [Modules, Variables, and Functions](https://docs.racket-lang.org/rhombus-guide/Modules.html)

---

## 3. クラスと束縛パターン

### クラス

慣習としてクラス名は **大文字始まり**。

```rhombus
class Posn(x, y)

def origin = Posn(0, 0)
origin.x          // フィールド
Posn.x(origin)    // クラス専用アクセサ関数
```

### アノテーション束縛 `::` と `:~`

| 演算子 | 意味 |
|--------|------|
| `::` | 実行時チェックあり（防御的。関数境界向き） |
| `:~` | チェックを遅延／静的情報用。コストの高い注釈向き |

```rhombus
fun flip(p :: Posn):
  Posn(p.y, p.x)

fun flip_soft(p :~ Posn):
  Posn(p.y, p.x)   // 非 Posn は .y で初めてエラーになり得る
```

### パターンとしてのクラス

```rhombus
fun flip(Posn(x, y)):
  Posn(y, x)

fun flip_origin(Posn(0, 0)):
  origin
```

### フィールド型付き注釈

```rhombus
fun flip_ints(p :: Posn.of(Int, Int)):
  Posn(p.y, p.x)
```

### 結果注釈

```rhombus
fun same_posn(p) :~ Posn:
  p

fun checked_same_posn(p) :: Posn:
  p
```

### `let` と `_`

- `let` — 定義の**後**から見える局所束縛。同名を影で隠せる  
- `_` — 任意にマッチし、変数は束縛しない  

```rhombus
fun omnivore(_): "yum"
fun nomivore(_ :: Number): "yum"
```

詳細: [Classes and Binding Patterns](https://docs.racket-lang.org/rhombus-guide/classes_and_patterns.html)

---

## 4. アノテーションとドット

### よく使う注釈

`Int`, `Number`, `String`, `Keyword`, `Any`, および `class` で定義した型。

### 式位置の `::` / `is_a`

```rhombus
(flip(origin) :: Posn).x
origin is_a Posn     // #true / #false
```

### ドット `.`

- `obj.field` — オブジェクトのフィールド／メソッド  
- `import` の `mod.name` — インポート接頭辞（別用途）  
- 束縛に `::` / `:~` がある識別子は **dot provider** になり、静的に効率的なアクセスになる  

```rhombus
use_static    // . を効率モードのみに制限（失敗はコンパイル時）
use_dynamic   // 動的ルックアップ許可（#lang rhombus 既定に近い）
```

`#lang rhombus/static` は既定で `use_static` 相当。

詳細: [Annotations and the Dot Operator](https://docs.racket-lang.org/rhombus-guide/annotation.html)

---

## 5. 省略可能引数とキーワード引数

### 既定値

```rhombus
fun scale(Posn(x, y), factor = 1):
  Posn(factor * x, factor * y)

scale(Posn(1, 2))
scale(Posn(1, 2), 3)
```

### キーワード引数（`~name:`）

```rhombus
fun transform(Posn(x, y),
              ~scale: factor = 1,
              ~dx: dx = 0,
              ~dy: dy = 0):
  Posn(factor * x + dx, factor * y + dy)

transform(Posn(1, 2), ~dx: 7, ~scale: 2)
```

変数名がキーワードと同じなら短縮形:

```rhombus
fun transform(Posn(x, y),
              ~scale: factor = 1,
              ~dx = 0,
              ~dy = 0):
  ...
```

### 匿名関数

```rhombus
def curried_add:
  fun (x):
    fun (y):
      x + y

curried_add(10)(20)  // 30
```

キーワードを値として扱うときは `#'~scale` のように `#'` を使う。

詳細: [Optional and Keyword Arguments](https://docs.racket-lang.org/rhombus-guide/functions_optional.html)

---

## 6. 条件とパターンマッチ

### 論理・比較

| 演算子 | 意味 |
|--------|------|
| `&&` | 短絡 and（最後の非 `#false`） |
| `\|\|` | 短絡 or（最初の非 `#false`） |
| `!` | not |
| `==` | 構造的等価（不変成分） |
| `is_now` | 可変成分の現在値を含む構造的等価 |
| `===` | オブジェクト同一性 |

優先順位の目安: 算術 > 比較 / `!` > `&&` > `||`

### `if`（必ず then / else の 2 分岐）

```rhombus
if 1 == 2
| "same"
| "different"
```

### `cond`

```rhombus
fun fib(n):
  cond
  | n == 0: 1
  | n == 1: 1
  | ~else: fib(n - 1) + fib(n - 2)
```

### `match` と `fun` の複数ケース

```rhombus
fun fib(n):
  match n
  | 0: 1
  | 1: 1
  | _: fib(n - 1) + fib(n - 2)

// 融合形
fun
| fib(0): 1
| fib(1): 1
| fib(n): fib(n - 1) + fib(n - 2)

// 引数個数がケースで違うことも可
fun
| hello(name): "Hello, " +& name
| hello(first, last): hello(first +& " " +& last)
```

### `guard` / `guard.let`（早期リターン的）

```rhombus
fun show_user_stats(user_id):
  guard user_id != "" | #false
  // 以降が本体
  ...
```

詳細: [Conditionals and Pattern-Matching Dispatch](https://docs.racket-lang.org/rhombus-guide/conditional.html)

---

## 7. 演算子

`operator` で prefix / infix / postfix を定義できる。

```rhombus
operator (x <> y):
  Posn(x, y)

1 <> 2

// 優先順位・結合性
operator (x <> y):
  ~weaker_than: * / + -
  ~associativity: ~right
  Posn(x, y)
```

複数ケース（prefix と infix など）:

```rhombus
operator
| ((x :: Int) <> (y :: Int)):
    Posn(x, y)
| (<> (x :: Int)):
    Posn(x, x)
```

エクスポート・インポート:

```rhombus
export:
  <>

import:
  "posn.rhm".(<>)   // 接頭辞なしで演算子を使う
```

詳細: [Operators](https://docs.racket-lang.org/rhombus-guide/operator.html)

---

## 8. 変数と値（ミュータブル）

既定の `def` は**不変**。書き換えには `mutable` と `:=`。

```rhombus
def mutable todays_weather = "sunny"
todays_weather := "rainy"

fun f(mutable x):
  x := x + 8
  x
```

クラスフィールドも `mutable` にできる:

```rhombus
class Boxed(mutable content)
def present = Boxed("socks")
present.content := "toy"
```

### 複数値

```rhombus
values(1, "apple")

def (n, s) = values(1, "apple")
// または
def values(n, s) = values(1, "apple")

match values(1, "apple")
| (n, s): n + s.length()
```

re-sketching のスケッチでも同様:

```rhombus
def mutable x = 0.0
x := x + 0.8
```

詳細: [Variables and Values](https://docs.racket-lang.org/rhombus-guide/mutable-vars.html)

---

## 9. 名前空間

- `import` の接頭辞（`f2c.foo`）や `namespace` で名前を階層化する  
- クラス名も名前空間としてフィールドアクセサ（`Posn.x`）を提供する  
- ドット `.` は「インポート／名前空間の参照」と「オブジェクトのフィールド」でオーバーロードされる  

詳細: [Namespaces](https://docs.racket-lang.org/rhombus-guide/namespaces-overview.html)

---

## 10. re-sketching での例

```rhombus
#lang re_sketching

def mutable angle = 0.0

fun setup():
  size(400, 300)
  frame_rate(60)

fun draw():
  background(240)
  // 条件
  if mouse_pressed
  | fill("orange")
  | fill(200)
  // ミュータブル更新
  angle := angle + 0.02
  translate(width / 2.0, height / 2.0)
  rotate(angle)
  rect_mode(#'center)
  rect(0, 0, 80, 80)

fun on_key_pressed():
  match key
  | Char"r": background(255, 0, 0)
  | ~else: #void
```

### インデントの落とし穴（重要）

`draw` / `setup` の本体は **`:` の下に字下げ**すること。行頭に戻した文はモジュール先頭として一度だけ実行され、毎フレーム再描画されません。

```rhombus
// NG
fun draw():
  background(128)
// ここは draw の外
line(0, 0, width, height)

// OK
fun draw():
  background(128)
  line(0, 0, width, height)
```

### ループ（参考）

Rhombus の `for` は括弧付き束縛が一般的です:

```rhombus
for (i in 0..10):
  println(i)
```

ステップ付きは `while` でも書けます（バージョンにより range の `~step` 記法が異なる場合があります）。

---

## 参照

- 公式: [Rhombus Essentials](https://docs.racket-lang.org/rhombus-guide/Rhombus_Essentials.html)
- ガイド目次: [Rhombus Guide](https://docs.racket-lang.org/rhombus-guide/)
- 本リポジトリ: [Cheat Sheet](Cheat-Sheet) · [Examples](Examples) · [Home](Home)
