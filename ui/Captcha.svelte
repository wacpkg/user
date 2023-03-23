<template lang="pug">
main
  +if timer
    nav
      b >wait
    b { timer }
    +else
      nav
        +if show
          b
            | {@html tip}
          a(@click=refresh title=">refresh")
          +else
            b
              | >LOADING
              | ···
      img(@&img @click alt=">CAPTCHA_IMAGE" src:WAIT)
</template>

<script lang="coffee">
> !/_/SDK.js
  !/_/WAIT.js
  wtax/render.js:
  ./i18n/code.js > CAPTCHA_CLICK

+ img, ing, ID, timer, tip

show = 1

< next

radio = devicePixelRatio

< refresh = =>
  if ing
    return
  show = 0
  if img.src != WAIT
    timeout = setTimeout(
      =>
        img.src = WAIT
        return
      300
    )
  ing = new Promise (resolve)=>
    _new await SDK.captcha(radio)
    show = 1
    clearTimeout timeout
    resolve()
    return
  return

_new = (r)=>
  if Array.isArray r
    [webp, d, id] = r
    ID = id
    ing = undefined
    img.src = URL.createObjectURL new Blob [webp]
    tip = I18N[CAPTCHA_CLICK].render """<svg viewBox="0 0 1024 1024"><path d="#{d}"></path></svg>"""
  else
    timer = r
    interval = setInterval(
      =>
        if --timer
          return
        clearInterval interval
        ing = undefined
        await tick()
        refresh()
        return
      1e3
    )
  return

click = (e)=>
  if ing
    return
  {offsetX:x,offsetY:y} = e
  {offsetWidth:w} = img
  img.src = WAIT
  show = 0
  await next(
    ID
    ... [x,y].map((i)=>
      Math.round(i*700/w))
  )
  show = 1
  return

onMount =>
  img.src = WAIT
  refresh()
  return
</script>
