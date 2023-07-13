<template lang="pug">
template(@&MeMenu)
  ul
    li >config
    li >logout
template(@&SigninMenu)
  ul
    li >enter
    li >logout
template(@&ExitMenu)
  ul
    li >signIn
    li >remove
+if count !== undefined
  +if count
    main(class:run=RUN)
      +if SIGNIN.length
        .me
          i
            b
              b
                b {SIGNIN[0][1]}
                i {SIGNIN[0][3]}
              i
            a(@click=meMenu)
        +if SIGNIN.length > 1
          .signin
            +each SIGNIN.slice(1) as u,i
              i
                b(@click={enter(u[0])})
                  b
                    b {u[1]}
                    i {u[3]}
                  i
                a(@click=signinMenu rel="{ u[0] }")
      .exit
        +each EXIT as u,i
          i
            b(@click={sign(u[0])})
              b
                b {u[1]}
                i {u[3]}
              b >exited
            a(@click=exitMenu rel="{ u[0] }")
      footer
        a(@click=addAccount) >addAccount
        +if SIGNIN.length
          a(@click=exitAll) >exitAll
          +else
            a(@click=rmAll) >rmAll
    +else
      u-auth(@&uAuth)
  +else
    s
</template>

<script lang="coffee">
> !/_/SDK.js
  ./User.js > exit onLi rmAll:_rmAll exitUid exitAll enter:_enter rm
  wtax/assign.js
  wtax/On.js
  !/_/Menu.js
  ./conf.js
  ./WAY.js
  !/_/bindLi.js
  !/_/byTag.js > byTag0
  ./Sign.auth.js > auth

< agree
< next = =>

+ uAuth, count, SigninMenu, ExitMenu, signinMenu, exitMenu, MeMenu, meMenu, RUN

EXIT = SIGNIN = []

rmAll = =>
  _rmAll()
  next()
  return

addAccount = =>
  auth()
  next()
  return

enter = (uid)=>
  RUN = true
  await _enter uid
  RUN = undefined
  next()
  return

sign = (uid)=>
  box = auth()
  for [id, _, w, account] from EXIT
    if uid == id
      # TODO 根据way判断是否微信登录
      byTag0(
        box
        'u-auth'
      ).account = account
      break
  next()
  return

onMount =>
  await tick()
  meMenu = menu(
    MeMenu
    (elem)=>
      uid = SIGNIN[0][0]
      bindLi(
        conf.bind 0, uid
        exit.bind 0, uid
      ) elem
  )
  signinMenu = menu(
    SigninMenu
    (elem)->
      {rel:uid} = @
      uid -= 0
      bindLi(
        enter.bind 0, uid
        exitUid.bind 0, uid
      ) elem
  )
  exitMenu = menu ExitMenu, (elem)->
    {rel:uid} = @
    uid -= 0
    bindLi(
      sign.bind 0, uid
      rm.bind 0, uid
    ) elem
    return
  return

onLi (signin,exit)=>
  SIGNIN = signin
  EXIT = exit
  count = signin.length+exit.length
  return

:$
  if uAuth
    assign(
      uAuth
      {
        next
        agree
      }
    )
</script>

