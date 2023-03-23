<template lang="pug">
include /_/p_input.pug

+if ING
  s
  +else
    main(@&main)
      +each LI as l,i
        +if l[0] == 1
          +if EDIT[i]
            form(@submit|preventDefault={y(i)})
              +p_input("{I18N[l[1]]}")(&TMP[i] id:{'u'+i})
              b
                a(@click={y(i)})
                a(@click={n(i)})
            +else
              b {I18N[l[1]]}
              i {VAL[i]}
              +if EDIT[i] == 0
                u
                +else
                  a(@click={edit(i)})
      +if account
        b >Password
        i
          a(@click=resetPassword) >resetPassword
        a(@click=resetPassword)
</template>

<script lang="coffee">
> !/_/SDK.js
  ./i18n/code.js > NAME INVALID
  ./User.js > setNameWay USER_SIGNIN onMe
  wtax/wcut.js
  !/_/Alert.js
  ./WAY.js
  ./setPassword.js

+ main, LI, account, tip

< x, UID

ING = 1
VAL = []
EDIT = {}
TMP = {}

onMount =>
  await tick()
  r = await SDK.u.conf(UID)
  if not r
    x()
    return
  setNameWay UID,...r
  [name, li] = r

  val_li = [name]

  exist = new Map
  li.forEach (i)=>
    exist.set i[0],i[1]
    return

  account = undefined
  tip = []
  way = {}
  for [id,func] from WAY
    way[id] = func
    if not exist.has id
      li.push [id,'']
    else if not account
      account = exist.get id
    tip.push I18N[id]
  tip = tip.join(' / ')

  LI = [
    [
      1
      NAME
      (v, i)=>
        v = v.trim()
        if v
          VAL[i] = v = wcut v,24
          await SDK.u.name UID,v
          setNameWay UID, v
        v
    ]
    ...li.map ([w, val])=>
      val_li.push val
      [
        1
        w
        (v, i)=>
          f = =>
            setTimeout(
              =>
                _focus i
                return
            )
            return
          old = VAL[i]
          r = way[w](v)
          if r
            t = await r[2](UID,old,v)
            if t != false
              if t
                Alert(
                  t
                  f
                )
                return false
              else
                setNameWay(UID, 0, [[w,v]])
            else
              f()
              return t
            return now
          Alert(
            => I18N[w]+' '+I18N[INVALID]+' : '+TMP[i]
            f
          )
          return false
      ]
  ]
  VAL = val_li
  ING = 0
  return

onMe =>
  await tick()
  for [id] from USER_SIGNIN
    if id == UID
      return
  x()
  return

n = (i)=>
  EDIT[i] = undefined
  delete EDIT[i]
  return

y = (i)=>
  val = TMP[i]
  if val != VAL[i]
    EDIT[i] = 0
    if TMP[i]
      try
        p = LI[i][2](val,i)
        pre = VAL[i]
        VAL[i] = TMP[i]
        r = await p
        if r == false
          VAL[i] = pre
          return
        else
          VAL[i] = r
      n i
    return
  else
    n i
  return

_focus = (i)=>
  EDIT[i] = 1
  await tick()
  main.querySelector('#u'+i).focus()
  return

edit = (i)=>
  TMP[i] = VAL[i]
  _focus i
  return

resetPassword = =>
  setPassword(
    tip
    account
    ''
  )
  return
</script>

