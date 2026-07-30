#lang rhombus
// #lang re_sketching language module (Rhombus surface)
// Implemented by Grok (xAI).

import:
  rhombus/meta open
  lib("re_sketching/private/api-rkt.rkt") as api

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
  // graphics
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
    api.color as color
  // transform
  rename:
    api.translate as translate
    api.rotate as rotate
    api.scale as scale
    api.#{push-matrix} as push_matrix
    api.#{pop-matrix} as pop_matrix
    api.#{reset-matrix} as reset_matrix
  // math
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
  // environment
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
  // system variables + focused
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

decl.macro 're_sketching_module_block:
              $form
              ...':
  '#%module_block:
     api.initialize()
     $form
     ...
     api.go()
'
