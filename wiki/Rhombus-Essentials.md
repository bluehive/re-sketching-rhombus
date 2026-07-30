# Rhombus Essentials（基本文法・シンタックス）

本ページは [Rhombus Guide — Rhombus Essentials](https://docs.racket-lang.org/rhombus-guide/Rhombus_Essentials.html) を、**re-sketching / 初めて Rhombus に触れる人向け**に噛み砕いた解説です。  
コード断片は理解用の要約であり、仕様の細部は必ず公式ガイドを正としてください。

## このページの読み方

Rhombus は Racket の上に乗る言語で、見た目は Python に近い（インデントと `:`）一方、中身は **束縛（binding）・パターン・アノテーション** が中心の設計です。

| 用語 | ざっくりした意味 |
|------|------------------|
| **束縛（binding）** | 名前に値を結びつけること（`def` / 関数引数 / `match` の `|` など） |
| **パターン** | 「この形の値なら受け取り、中身を取り出す」記述（例: `Posn(x, y)`） |
| **アノテーション** | 「この値はこういう種類である」という約束（例: `Int`, `Posn`） |
| **shrubbery** | カッコだらけの S 式の代わりに、行・インデントで木構造を表す記法 |

**re-sketching との関係:** スケッチは `#lang re_sketching` ですが、文法は Rhombus そのものです。`def` / `fun` / `if` / `match` / `class` などがそのまま使えます。描画 API は [Cheat Sheet](Cheat-Sheet) を参照。

**短い一覧だけ欲しいとき:** [Rhombus Cheat Sheet](Rhombus-Cheat-Sheet)

---

## 全体の地図（概要）

Essentials は次の流れで理解するとスムーズです。

1. **どう書くか（記法）** — インデントと `:` / `|` が「カッコ」の代わり  
2. **名前と関数（モジュール）** — `def` / `fun` / `import`  
3. **データの形（クラス・パターン）** — `class Posn(x, y)` と分解  
4. **種類の約束（アノテーション）** — `::` / `:~` と `.`  
5. **関数の柔軟性** — 省略引数・キーワード引数  
6. **分岐** — `if` / `cond` / `match`  
7. **演算子・可変・名前空間** — 補足  

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
10. [re-sketching での実践](#10-re-sketching-での実践)

---

## 1. 記法（Notation）

### 概要

多くの言語は「文字 → トークン → 構文木」と進みますが、Lisp 系は途中に **S 式** というカッコの木があります。Rhombus はそこを **shrubbery 記法** に置き換え、**中置演算子**と**行・インデントによるネスト**を自然に書けるようにしています。

「見た目は普通の言語、構造は Lisp のように一貫した木」——それが Rhombus の土台です。

### 重要なポイント

| ポイント | 説明 |
|----------|------|
| **空白に敏感** | 改行とインデントが構文の一部。Python と同様、字下げの深さがブロックの境界 |
| **`:` と `\|` は演算子ではない** | ブロック開始や分岐（then/else、`cond` の枝など）を作る**構造トークン** |
| **キーワードは `~` 始まり** | 例: `~else`, `~scale`。識別子（変数名）とは別カテゴリなので、引数と誤認しにくい |
| **`'...'` はコードのクォート** | 文字列は `"..."`。単一引用符は shrubbery（コード片）を表す用途 |
| **カッコの中でもインデント規則** | `(...)`, `[...]`, `{...}`, `'...'` の内側でも改行・字下げが意味を持つ |

### ブロックのイメージ

```rhombus
// `:` のあとがブロック。中身は字下げする
fun greet(name):
  // この行は greet の中
  "Hello, " +& name

// 行頭に戻るとブロックの外
```

### コメント

行コメントは `//` です（re-sketching の例でも同じ）。

### 公式

[Notation](https://docs.racket-lang.org/rhombus-guide/Notation.html) · [Shrubbery Notation](https://docs.racket-lang.org/shrubbery/)

---

## 2. モジュール・変数・関数

### 概要

**モジュール**は「1 つのプログラム／ライブラリの単位」です。ファイルの先頭に `#lang ...` を書き、その下に定義と式を並べます。

- **`def`** … 名前に値を束縛する（基本は**書き換え不可**）  
- **`fun`** … 関数を定義する  
- **`import` / `export`** … 他モジュールとの受け渡し  

モジュール先頭に式を書くと、その**結果が表示**されます（REPL や実行時の出力）。

### 最小モジュール

```rhombus
#lang rhombus

1 + 4                 // 5 と表示
"Hello, world!"       // 引用符付きで表示
```

re-sketching では描画ループ用の言語になります:

```rhombus
#lang re_sketching

fun setup():
  size(400, 300)

fun draw():
  background(240)
```

### `def` — 値に名前を付ける

```rhombus
// 短い式: `=` が読みやすい（慣習）
def fahrenheit_freezing = 32

// 長い式や、中に `:` がある式: ブロック形
def fahrenheit_freezing:
  32
```

`=` と `:` が使える場面はフォームごとに決まっています。`def` ではどちらもよく使いますが、**一行で収まる単純な右辺は `=`**、という慣習です。

### `fun` — 関数

```rhombus
fun fahrenheit_to_celsius(f):
  (f - 32) * 5/9

fahrenheit_to_celsius(fahrenheit_freezing)  // => 0
```

呼び出しは `名前(引数, ...)` です。引数のところには「単なる識別子」だけでなく、**パターンやアノテーション**も書けます（後述）。

### `import` / `export` — モジュールをつなぐ

別ファイルの定義を使う・公開するための仕組みです。

```rhombus
// ---- f2c.rhm ----
#lang rhombus
export:
  fahrenheit_freezing
  fahrenheit_to_celsius

def fahrenheit_freezing = 32
fun fahrenheit_to_celsius(f):
  (f - 32) * 5/9

// ---- freezing.rhm ----
#lang rhombus
import:
  "f2c.rhm"

// 既定ではファイル名から接頭辞 f2c が付く
f2c.fahrenheit_to_celsius(f2c.fahrenheit_freezing)
```

| 書き方 | 意味 |
|--------|------|
| `"file.rhm"` | 相対パス。既定接頭辞はファイル名（拡張子除く） |
| `as convert` | 接頭辞を `convert` にする |
| `open` | 接頭辞なしで取り込む（名前衝突に注意） |
| `rhombus/measure` | インストール済みライブラリ（`/` 区切り） |
| `lib("racket/math.rkt")` | Racket 側のモジュール |

```rhombus
import:
  "f2c.rhm" as convert

convert.fahrenheit_to_celsius(convert.fahrenheit_freezing)
```

### 公式

[Modules, Variables, and Functions](https://docs.racket-lang.org/rhombus-guide/Modules.html)

---

## 3. クラスと束縛パターン

### 概要

**クラス**は「いくつかのフィールドをまとめたデータの型＋コンストラクタ」です。Processing 風の `PVector` のような「点」を表すのに向いています。

Rhombus のクラスは、次の**複数の役割を同じ名前で兼ねる**のが特徴です。

| 役割 | 例 | 意味 |
|------|-----|------|
| 型の名前 | `Posn` | アノテーションとしても使える |
| コンストラクタ | `Posn(0, 0)` | インスタンスを作る |
| パターン | `fun f(Posn(x, y)):` | 受け取って中身を取り出す |
| 名前空間 | `Posn.x` | フィールド専用のアクセサ関数 |

慣習として、クラス名は **大文字始まり**（`Posn`, `Line`）にします。

### 定義とフィールドアクセス

```rhombus
class Posn(x, y)

def origin = Posn(0, 0)

origin          // 表示: Posn(0, 0)
origin.x        // 0  （インスタンスのフィールド）
origin.y        // 0
```

### クラス専用アクセサ `Posn.x`

```rhombus
Posn.x(origin)  // 0
```

`Posn.x` は「任意のオブジェクトの `.x`」ではなく、**Posn 専用の取り出し関数**です。`origin.x` は「左辺が何でも `.x` を探す」一般的なドット（後述の動的モード）と組み合わせると意味が広がりますが、`Posn.x(...)` は型がはっきりしている分、意図と効率が明確です。

### 束縛パターンとは何か

**束縛位置**（`def` の左、関数の引数、`match` の枝など）に書けるのは「ただの名前」だけではありません。**パターン**を書くと:

1. 値がその形かどうかを確かめ、  
2. 合えば中の部品に名前を付け、  
3. 合わなければエラー（または次の枝へ）  

となります。

```rhombus
// 引数そのものが「Posn であること」を要求し、同時に x, y を取り出す
fun flip(Posn(x, y)):
  Posn(y, x)

flip(Posn(1, 2))  // Posn(2, 1)
flip(0)           // エラー（Posn ではない）
```

さらに内側もパターンです:

```rhombus
// 原点だけ受け付ける
fun flip_origin(Posn(0, 0)):
  origin
```

### アノテーション付き引数（クラスとセットで使う）

```rhombus
// 引数 p が Posn であることを実行時にチェック
fun flip(p :: Posn):
  Posn(p.y, p.x)
```

- `p :: Posn` … 「p は Posn」という約束（詳細は [§4](#4-アノテーションとドット)）  
- `Posn(x, y)` … 約束しつつ分解  

どちらも「Posn 以外を弾く」効果がありますが、**分解したいならパターン、フィールドを `.` で触るなら `::` 付きの名前**、という使い分けが分かりやすいです。

### フィールドの型まで指定する `Posn.of`

```rhombus
fun flip_ints(p :: Posn.of(Int, Int)):
  Posn(p.y, p.x)

flip_ints(Posn(1, 2))       // OK
flip_ints(Posn("a", 2))    // エラー（x が Int でない）
```

「Posn である」だけでなく「各フィールドの種類」まで言いたいときに使います。

### 戻り値の約束

```rhombus
// 戻り値を「Posn として扱う」情報を付ける（: ~ は実行時の強制チェックが弱い側）
fun same_posn(p) :~ Posn:
  p

// 戻り値を毎回実行時チェック
fun checked_same_posn(p) :: Posn:
  p
```

### `let` と `_`

```rhombus
// let: この定義より「後」から見える。同名を積み重ねて更新するのにも便利
def accum = 0
let accum = accum + 1
let accum = accum + 1
// accum は 2

// _: 値は受け取るが名前は付けない
fun omnivore(_): "yum"
fun nomivore(_ :: Number): "yum"   // Number であることは要求
```

### re-sketching での使いどころ

ボールやパーティクルを `class Ball(x, y, vx, vy)` のようにまとめると、`draw` 内が読みやすくなります。フィールドを毎フレーム書き換えるなら [§8](#8-変数と値ミュータブル) の `mutable` フィールドと組み合わせます。

### 公式

[Classes and Binding Patterns](https://docs.racket-lang.org/rhombus-guide/classes_and_patterns.html)

---

## 4. アノテーションとドット

### 概要

**アノテーション（annotation）**は、「この式・この束縛の値は、こういう種類である」と書く仕組みです。  
静的型言語の「型」に近い役割をしますが、Rhombus では次の特徴があります。

- すべてが必須ではない（書かなくても動く）  
- **`::` は実行時チェックを伴う**ことが多い  
- **`:~` はチェックを弱め／遅らせ、代わりに静的情報（効率的な `.` など）を伝える**  
- クラス名や `Int` / `String` などがアノテーションになる  

「型を書く」というより、**「検査の強さ」と「コンパイラ／実行系へのヒント」を選ぶ**感覚です。

### よく使うアノテーション

| 名前 | 意味の例 |
|------|----------|
| `Int` | 正確な整数 |
| `Number` | 数 |
| `String` | 文字列 |
| `Keyword` | `~foo` のようなキーワード |
| `Any` | 任意 |
| `Posn` など | `class` で定義したクラス |

### `::` と `:~` の違い（最重要）

| | `::` | `:~` |
|--|------|------|
| **イメージ** | 「今ここで確かめる」 | 「そう扱ってよいと伝える」 |
| **実行時** | 値が合わなければ例外 | 即時の厳格チェックはしない（用途による） |
| **向いている場所** | 公開 API の引数、安価なチェック | コストが高い検査を避けたいとき、静的情報だけ欲しいとき |
| **フィールドアクセス** | チェック後、安全に `.` できる | クラス専用の `.` 解釈を選ぶのに使えるが、不正値は後で落ち得る |

```rhombus
fun flip(p :: Posn):
  Posn(p.y, p.x)

// 非 Posn を渡すと「引数がアノテーションを満たさない」で即エラー
// flip(0)
```

```rhombus
fun flip_soft(p :~ Posn):
  Posn(p.y, p.x)

// 呼び出し自体は通る場合があるが、.y の段階で契約違反になり得る
// flip_soft(0)
```

**実務の指針（公式ガイドの精神）:**

- 境界（外から来る値）では `::` で守る  
- 高価な検査（大きなリストの要素すべて、など）を毎回 `::` すると遅くなりがち  
- 「必ずこの型を返す」ことを伝えるだけなら、戻り値は `:~` が適切なことも多い  

### 式の位置でも使える `::` / `is_a`

```rhombus
// 左辺の結果が Posn か検査してから .x
(flip(origin) :: Posn).x

// 真偽だけ欲しいとき
origin is_a Posn   // #true
1 is_a Posn        // #false
```

### ドット演算子 `.` とは

`.` は複数の仕事をします。

1. **オブジェクトのフィールド／メソッド** … `origin.x`  
2. **インポートや名前空間の選択** … `f2c.fahrenheit_to_celsius`  
3. **クラス名前空間のアクセサ** … `Posn.x`  

#### Dot provider（ドット提供者）

識別子を `p :: Posn` や `p :~ Posn` のように束縛すると、`p` は **「Posn として `.` できる」情報を持つ**ことがあります。これを **dot provider** と呼びます。  
その結果、`p.x` が「汎用の動的ルックアップ」ではなく、**Posn の x を直接取る効率的な形**にできます。

```rhombus
class Line(p1 :: Posn, p2 :: Posn)

def l1 :: Line:
  Line(Posn(1, 2), Posn(3, 4))

l1.p2.x   // 3  （連鎖も可能）
```

#### `use_static` / `use_dynamic`

| フォーム | 意味 |
|----------|------|
| `use_dynamic` | 左辺が静的に型不明でも `.` を実行時解決しうる（`#lang rhombus` に近い既定） |
| `use_static` | 左辺が dot provider でない `.` は**コンパイルエラー**（安全・効率寄り） |

```rhombus
use_static
// (1).x  のようなものは、静的情報がないので拒否されやすい
```

`#lang rhombus/static` は最初から `use_static` 寄りです。

### re-sketching での使いどころ

描画 API 自体はアノテーション必須ではありませんが、自分で `class` を作るとき、

```rhombus
fun draw_ball(b :: Ball):
  circle(b.x, b.y, b.r)
```

のようにすると、「色や数を Ball のつもりで渡してしまった」ミスを早く検出できます。

### 公式

[Annotations and the Dot Operator](https://docs.racket-lang.org/rhombus-guide/annotation.html) · [Annotations 章](https://docs.racket-lang.org/rhombus-guide/annot-more.html)

---

## 5. 省略可能引数とキーワード引数

### 概要

関数をより使いやすくするための機能です。

- **省略可能引数** … 渡さなければ既定値が使われる（`name = 既定`）  
- **キーワード引数** … 順番ではなく **名前（`~scale:` など）** で渡す  

オプションが多い関数（座標変換、スタイル設定など）で特に有効です。

### 位置引数の既定値

```rhombus
fun scale(Posn(x, y), factor = 1):
  Posn(factor * x, factor * y)

scale(Posn(1, 2))      // factor = 1
scale(Posn(1, 2), 3)   // factor = 3
```

### キーワード引数

キーワードは shrubbery 上 `~` で始まり、呼び出しでも `~名前: 値` と書きます。

```rhombus
fun transform(Posn(x, y),
              ~scale: factor = 1,
              ~dx: dx = 0,
              ~dy: dy = 0):
  Posn(factor * x + dx, factor * y + dy)

transform(Posn(1, 2))
transform(Posn(1, 2), ~dx: 7)
transform(Posn(1, 2), ~dx: 7, ~scale: 2)
```

**なぜキーワードが安全か:** キーワード単体は式にもパターンにもならないため、「うっかり変数のつもりで `scale` と書いて別の引数に食われた」事故が起きにくい、という設計です。

### 短縮形（キーワード名＝変数名）

```rhombus
fun transform(Posn(x, y),
              ~scale: factor = 1,
              ~dx = 0,    // 変数名も dx
              ~dy = 0):
  Posn(factor * x + dx, factor * y + dy)
```

### 匿名関数（名前のない `fun`）

```rhombus
def curried_add:
  fun (x):
    fun (y):
      x + y

curried_add(10)(20)  // 30
```

### キーワードを「値」として扱う

```rhombus
#'~scale   // キーワード値
#'x        // シンボル
```

re-sketching では `rect_mode(#'center)` のように、**モードを表すシンボル／キーワード**を渡す場面があります。

### 公式

[Optional and Keyword Arguments](https://docs.racket-lang.org/rhombus-guide/functions_optional.html)

---

## 6. 条件とパターンマッチ

### 概要

Rhombus の分岐は大きく分けて:

| フォーム | 向いていること |
|----------|----------------|
| `if` | 単純な二者択一（then / else 必須） |
| `cond` | 上から順に条件を試す多岐分岐 |
| `match` | **値の形**で分岐し、同時に分解する |
| `fun` の複数ケース | 引数パターンで関数を定義する（match の融合） |
| `guard` | 「前提がダメならすぐ抜ける」早期脱出 |

真偽値は、`#false` 以外を真として扱う短絡演算もあります。

### 論理・比較

| 演算子 | 意味 |
|--------|------|
| `&&` | 短絡 and。左が真なら右を評価し、最後の非 `#false` を返す |
| `\|\|` | 短絡 or。最初の非 `#false` を返す |
| `!` | 否定 |
| `==` | 構造的な等価（不変な部品） |
| `is_now` | 可変フィールドの**今の値**も含めて構造比較 |
| `===` | 同一オブジェクトか（参照の一致。乱用注意） |

優先順位の目安: **算術 > 比較 / `!` > `&&` > `||`**

```rhombus
1 < 2 && "ok"    // "ok"
```

### `if` — then と else が両方必要

```rhombus
if 1 == 2
| "same"         // then（1 本目の |）
| "different"    // else（2 本目の |）
```

「else なしの if」は `if` では書けません。その場合は `when` / `cond` / `guard` などを検討します（re-sketching の例では `when` もよく使います）。

### `cond` — 条件の列

```rhombus
fun fib(n):
  cond
  | n == 0: 1
  | n == 1: 1
  | ~else: fib(n - 1) + fib(n - 2)
```

どれにも当たらず `~else` も無いと実行時エラーになります。

### `match` — 形で分ける

```rhombus
fun fib(n):
  match n
  | 0: 1
  | 1: 1
  | _: fib(n - 1) + fib(n - 2)
```

`0` や `1` は「その定数と等しい」、`_` は「何でもよいが束縛しない」パターンです。

### `fun` の複数ケース（推奨パターン）

引数をすぐパターンマッチする関数は、定義と match を融合できます。

```rhombus
fun
| fib(0): 1
| fib(1): 1
| fib(n): fib(n - 1) + fib(n - 2)
```

引数の個数がケースごとに違っても構いません。

```rhombus
fun
| hello(name):
    "Hello, " +& name      // +& は文字列化して連結
| hello(first, last):
    hello(first +& " " +& last)
```

結果アノテーションを一度だけ書く形:

```rhombus
fun fib :: PosInt:
| fib(0): 1
| fib(1): 1
| fib(n :: Nat): fib(n - 1) + fib(n - 2)
```

### `guard` — 邪魔な条件を先に片付ける

「エラーなら即 return」のような流れを、深い `cond` のネストなしで書けます。

```rhombus
fun show_user_stats(user_id):
  guard user_id != "" | #false   // 条件が偽なら #false で抜ける
  // ここからが本処理
  ...
```

`guard.let` は「パターンに合うか」を調べ、合わなければ別結果で抜けます。

### re-sketching での例

```rhombus
fun draw():
  if mouse_pressed
  | fill("orange")
  | fill(200)
  circle(mouse_x, mouse_y, 40)

fun on_key_pressed():
  match key
  | Char"r": fill("red")
  | Char"g": fill("green")
  | ~else: #void
```

### 公式

[Conditionals and Pattern-Matching Dispatch](https://docs.racket-lang.org/rhombus-guide/conditional.html)

---

## 7. 演算子

### 概要

`+` や `*` のような中置記法を、自分でも定義できます。関数でも書けますが、数式や DSL を自然に見せたいときに使います。

### 定義の基本

括弧の中に **ちょうど 2 または 3 個の項**を置き、そのうち 1 つが定義する演算子（または識別子）です。

```rhombus
// 中置
operator (x <> y):
  Posn(x, y)

1 <> 2   // Posn(1, 2)

// 前置
operator (<<>> x):
  Posn(x, x)

// 後置
operator (x <<<>>>):
  Posn(x, x)
```

引数側にパターンや `::` を付けるときは、**1 項にまとまるよう括弧**が必要になることがあります。

```rhombus
operator ((x :: Int) <> (y :: Int)):
  Posn(x, y)
```

### 優先順位と結合性

未宣言の演算子を `*` の隣に置くと「括弧を明示せよ」と怒られることがあります。  
`~weaker_than` / `~stronger_than` / `~associativity` などで関係を宣言します。

```rhombus
operator (x <> y):
  ~weaker_than: * / + -
  ~associativity: ~right
  Posn(x, y)

1 <> 2 * 3    // Posn(1, 6)
1 <> 2 <> 3   // 右結合: Posn(1, Posn(2, 3))
```

`~weaker_than: arithmetic` のように演算子群をまとめて指定する方法もあります。

### エクスポートとインポート

```rhombus
export:
  <>

import:
  "posn.rhm".(<>)   // 接頭辞なしで <> を使う
```

接頭辞付きだと `posn.(<>)` のようになり、演算子の「短さ」の利点が薄れるため、DSL 用途では `expose` や上記の書き方がよく使われます。

### 公式

[Operators](https://docs.racket-lang.org/rhombus-guide/operator.html)

---

## 8. 変数と値（ミュータブル）

### 概要

Rhombus の `def` は**デフォルトで不変**です。再代入したい名前だけ `mutable` を付け、代入は `:=` で行います。

アニメーションやゲームでは「毎フレーム位置を更新する」必要があるため、re-sketching でも `def mutable` が頻出します。

### ミュータブル変数

```rhombus
def mutable todays_weather = "sunny"
todays_weather          // "sunny"
todays_weather := "rainy"
todays_weather          // "rainy"
```

関数引数も `mutable` にできます（その関数内でのみ書き換え）。

```rhombus
fun f(mutable x):
  x := x + 8
  x

f(10)   // 18
// f := 5  はエラー（f 自体は mutable ではない）
```

### ミュータブルなクラスフィールド

```rhombus
class Boxed(mutable content)

def present = Boxed("socks")
present.content           // "socks"
present.content := "toy"
present.content           // "toy"
```

### 複数の戻り値

1 つの式が**複数の値**を返すことがあります（リスト 1 個とは違う）。

```rhombus
values(1, "apple")

// 受け取り: 左辺を複数の束縛に
def (n, s) = values(1, "apple")
// または明示的に
def values(n, s) = values(1, "apple")

match values(1, "apple")
| (n, s): n + s.length()
```

### re-sketching

```rhombus
def mutable x = 0.0
def mutable v = 1.0

fun draw():
  x := x + v
  circle(x, height / 2.0, 20)
```

### 公式

[Variables and Values](https://docs.racket-lang.org/rhombus-guide/mutable-vars.html)

---

## 9. 名前空間

### 概要

名前が増えると衝突します。**名前空間**は、名前を階層に分けて整理する仕組みです。

Rhombus では次が名前空間的に働きます。

| もの | 例 |
|------|-----|
| `import` の接頭辞 | `f2c.fahrenheit_to_celsius` |
| `namespace` 定義 | （ガイド後半・モジュール章） |
| クラス名 | `Posn.x`（フィールドアクセサ） |

### ドットの二面性（再掲）

```rhombus
import:
  "f2c.rhm"

f2c.fahrenheit_to_celsius(32)   // インポート接頭辞

def p = Posn(1, 2)
p.x                             // オブジェクトのフィールド
Posn.x(p)                       // クラス名前空間の関数
```

見た目は同じ `.` でも、左辺が「モジュール接頭辞」か「値」かで意味が違います。読み慣れるまでは、**左が import 名ならモジュール、値ならオブジェクト**、と覚えるとよいです。

### 公式

[Namespaces](https://docs.racket-lang.org/rhombus-guide/namespaces-overview.html)

---

## 10. re-sketching での実践

### 総合サンプル

```rhombus
#lang re_sketching

// 不変の定数
def ball_r = 20.0

// 毎フレーム更新する状態
def mutable angle = 0.0

fun setup():
  size(400, 300)
  frame_rate(60)

fun draw():
  background(240)

  // 二者択一
  if mouse_pressed
  | fill("orange")
  | fill(200)

  // 状態更新
  angle := angle + 0.02

  // 変換 + 図形
  push_matrix()
  translate(width / 2.0, height / 2.0)
  rotate(angle)
  rect_mode(#'center)
  rect(0, 0, 80, 80)
  pop_matrix()

  // マウス位置の円
  no_stroke()
  circle(mouse_x, mouse_y, ball_r)

fun on_key_pressed():
  match key
  | Char"r":
      angle := 0.0
  | ~else:
      #void
```

### インデントの落とし穴（最重要）

`draw` / `setup` / イベントハンドラの本体は、**必ず `:` の下に字下げ**してください。

行頭（字下げゼロ）に書いた文は、**モジュール先頭**として読み込み時に一度だけ実行されます。毎フレームの描画には入りません。

```rhombus
// ---- NG ----
fun draw():
  background(128)
// 字下げが戻っている → draw の外
line(0, 0, width, height)

// ---- OK ----
fun draw():
  background(128)
  line(0, 0, width, height)
```

### ループ（参考）

反復は別章（Collections and Iteration）の主題ですが、よく使う形だけ:

```rhombus
for (i in 0..10):
  println(i)

// ステップが必要なときは while も明確
def mutable i = 0
while i <= width:
  line(i, 0, i, height)
  i := i + 20
```

（Rhombus の版によって range のステップ記法が異なることがあるため、サンプルでは `while` を多用しています。）

### クラスを使ったスケッチのイメージ

```rhombus
#lang re_sketching

class Ball(mutable x, mutable y, mutable vx, r)

def mutable ball = Ball(50.0, 50.0, 2.0, 15.0)

fun setup():
  size(400, 300)

fun draw():
  background(240)
  ball.x := ball.x + ball.vx
  when ball.x > width - ball.r || ball.x < ball.r
  | ball.vx := 0.0 - ball.vx
  fill("steelblue")
  circle(ball.x, ball.y, ball.r * 2.0)
```

（上記は説明用。実行環境の `when` や色名の有無は実装に依存します。）

---

## 用語ミニ辞典

| 用語 | 説明 |
|------|------|
| shrubbery | Rhombus の表層記法。インデントと `:` / `\|` で木を作る |
| 束縛 (binding) | 名前と値を結びつけること |
| パターン | 値の形を記述し、分解・検査する記法 |
| アノテーション | 値の「種類」に関する約束。`Int` やクラス名など |
| `::` | 主に実行時検査付きのアノテーション結合 |
| `:~` | 検査を弱め、静的情報を伝える寄りの結合 |
| dot provider | `.` を効率的・型付きに解決できる式／束縛 |
| mutable / `:=` | 書き換え可能な変数と代入 |
| キーワード | `~name`。識別子とは別。引数ラベルなどに使う |

---

## 参照

- クイックリファレンス: [Rhombus Cheat Sheet](Rhombus-Cheat-Sheet)
- 公式 Essentials: [Rhombus Essentials](https://docs.racket-lang.org/rhombus-guide/Rhombus_Essentials.html)
- ガイド全体: [Rhombus Guide](https://docs.racket-lang.org/rhombus-guide/)
- 本リポジトリ: [Cheat Sheet](Cheat-Sheet)（描画） · [Examples](Examples) · [Home](Home)
