#lang rhombus
// #lang re_sketching language module (Rhombus surface)
// Implemented by Grok (xAI).
//
// Rhombus funs are invisible to namespace-variable-value. We extract the
// Identifier nodes from user `fun setup`/`fun draw` forms (correct scopes)
// and pass those procedures into api.go-with.

import:
  rhombus/meta open
  lib("re_sketching/private/api-rkt.rkt") as api
  meta:
    lib("re_sketching/private/intro.rkt") as intro

module configure_runtime ~lang rhombus:
  import: lib("rhombus/runtime_config.rhm")
  export: all_from(.runtime_config)

module configure_expand ~lang rhombus:
  import: lib("rhombus/expand_config.rhm")
  export: all_from(.expand_config)

export:
  all_from(rhombus):
    except #%module_block
  rename:
    re_sketching_module_block as #%module_block
  rename:
    api.background as background
    api.fill as fill
    api.#{no-fill} as no_fill
    api.stroke as stroke
    api.#{no-stroke} as no_stroke
    api.#{stroke-weight} as stroke_weight
    api.#{stroke-cap} as stroke_cap
    api.#{stroke-join} as stroke_join
    api.#{ellipse-mode} as ellipse_mode
    api.#{rect-mode} as rect_mode
    api.point as point
    api.line as line
    api.ellipse as ellipse
    api.circle as circle
    api.arc as arc
    api.rect as rect
    api.square as square
    api.quad as quad
    api.triangle as triangle
    api.bezier as bezier
    api.#{begin-shape} as begin_shape
    api.#{end-shape} as end_shape
    api.vertex as vertex
    api.color as color
  rename:
    api.translate as translate
    api.rotate as rotate
    api.scale as scale
    api.#{push-matrix} as push_matrix
    api.#{pop-matrix} as pop_matrix
    api.#{reset-matrix} as reset_matrix
  rename:
    api.dist as dist
    api.lerp as lerp
    api.constrain as constrain
    api.remap as remap
    api.norm as norm
    api.mag as mag
    api.sq as sq
    api.radians as radians
    api.degrees as degrees
    api.pi as pi
    api.random as random
    api.noise as noise
    api.#{noise-seed} as noise_seed
    api.#{noise-detail} as noise_detail
  rename:
    api.size as size
    api.#{pixel-density} as pixel_density
    api.#{set-frame-rate!} as frame_rate
    api.loop as loop
    api.#{no-loop} as no_loop
    api.#{no-gui} as no_gui
    api.cursor as cursor
    api.#{no-cursor} as no_cursor
    api.fullscreen as fullscreen
    api.#{set-title} as set_title
  width
  height
  frame_count
  mouse_x
  mouse_y
  pmouse_x
  pmouse_y
  mouse_pressed
  mouse_button
  key
  key_pressed
  key_released
  pixel_width
  pixel_height
  focused

expr.macro 'width':
  'api.#{get-width}()'

expr.macro 'height':
  'api.#{get-height}()'

expr.macro 'frame_count':
  'api.#{get-frame-count}()'

expr.macro 'mouse_x':
  'api.#{get-mouse-x}()'

expr.macro 'mouse_y':
  'api.#{get-mouse-y}()'

expr.macro 'pmouse_x':
  'api.#{get-pmouse-x}()'

expr.macro 'pmouse_y':
  'api.#{get-pmouse-y}()'

expr.macro 'mouse_pressed':
  'api.#{get-mouse-pressed}()'

expr.macro 'mouse_button':
  'api.#{get-mouse-button}()'

expr.macro 'key':
  'api.#{get-key}()'

expr.macro 'key_pressed':
  'api.#{get-key-pressed}()'

expr.macro 'key_released':
  'api.#{get-key-released}()'

expr.macro 'pixel_width':
  'api.#{get-pixel-width}()'

expr.macro 'pixel_height':
  'api.#{get-pixel-height}()'

fun focused():
  api.#{focused?}()

meta:
  // Return the Identifier syntax for `fun <name> ...` if present
  fun find_fun_id(forms :: List, want :: Symbol):
    for values(found = #false):
      each f in forms
      block:
        let id:
          match f
          | 'fun $(name :: Identifier) $_ ...': name
          | ~else: #false
        if id && (Syntax.unwrap(id) == want) | id | found

  fun cid(ctx, name :: Symbol):
    intro.#{contextual-id}(ctx, name)

decl.macro 're_sketching_module_block:
              $form
              ...':
  let forms = [form, ...]
  let ctx:
    match forms
    | [f, & _]: f
    | []: #'here
  // Prefer Identifier extracted from user `fun` (correct scopes);
  // otherwise introduce a contextual id + no-op default.
  let setup_id = find_fun_id(forms, #'setup) || cid(ctx, #'setup)
  let draw_id = find_fun_id(forms, #'draw) || cid(ctx, #'draw)
  let omp = find_fun_id(forms, #'on_mouse_pressed) || cid(ctx, #'on_mouse_pressed)
  let omr = find_fun_id(forms, #'on_mouse_released) || cid(ctx, #'on_mouse_released)
  let omm = find_fun_id(forms, #'on_mouse_moved) || cid(ctx, #'on_mouse_moved)
  let omd = find_fun_id(forms, #'on_mouse_dragged) || cid(ctx, #'on_mouse_dragged)
  let okp = find_fun_id(forms, #'on_key_pressed) || cid(ctx, #'on_key_pressed)
  let okr = find_fun_id(forms, #'on_key_released) || cid(ctx, #'on_key_released)
  let orz = find_fun_id(forms, #'on_resize) || cid(ctx, #'on_resize)
  let need_setup = !find_fun_id(forms, #'setup)
  let need_draw = !find_fun_id(forms, #'draw)
  let need_omp = !find_fun_id(forms, #'on_mouse_pressed)
  let need_omr = !find_fun_id(forms, #'on_mouse_released)
  let need_omm = !find_fun_id(forms, #'on_mouse_moved)
  let need_omd = !find_fun_id(forms, #'on_mouse_dragged)
  let need_okp = !find_fun_id(forms, #'on_key_pressed)
  let need_okr = !find_fun_id(forms, #'on_key_released)
  let need_orz = !find_fun_id(forms, #'on_resize)
  // Build default defs only for missing names
  let [d_stx, ...] = for List (pair in [[need_setup, setup_id],
                                        [need_draw, draw_id],
                                        [need_omp, omp],
                                        [need_omr, omr],
                                        [need_omm, omm],
                                        [need_omd, omd],
                                        [need_okp, okp],
                                        [need_okr, okr],
                                        [need_orz, orz]]):
                       keep_when pair[0]
                       let id = pair[1]
                       'fun $id(): #void'
  '#%module_block:
     api.initialize()
     $form
     ...
     $d_stx
     ...
     api.#{go-with}($setup_id,
                    $draw_id,
                    $omp,
                    $omr,
                    $omm,
                    $omd,
                    $okp,
                    $okr,
                    $orz)
'
