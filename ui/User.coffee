> wtax/assign.js
  !/_/SDK.js
  !/_/vote.js > CHANNEL reply USER_EXIT USER_SIGNIN
  wtax/sleep.js
  wtax/liSet.js
  !/_/DB.js > R W

+ USER,  _setUser

U = 'u'

save = =>
  W.conf.put {
    id:U
    v:[
      USER_SIGNIN
      USER_EXIT
    ]
  }
  return

liEq = (a,b)=>
  r = a?.length == b?.length
  if a and r
    return a.every (li,pos)=>
      t = b[pos]
      if Array.isArray li
        for i,p in li
          if i!=t[p]
            return false
        return true
      return li == t
  r

ON_ME = new Set()

< onMe = (func)=>
  ON_ME.add func
  if USER != undefined
    func USER
  =>
    ON_ME.delete func
    return

ON_LI = new Set()

< onLi = (func)=>
  ON_LI.add func
  if USER != undefined
    func USER_SIGNIN,USER_EXIT
  =>
    ON_LI.delete func
    return

_setMe = =>
  me = USER_SIGNIN[0]
  if me
    [id,name] = me
    USER = {id,name}
  else
    USER = {}
  for f from ON_ME
    f(USER)
  return

_toAllMe = =>
  reply(0)
  _setMe()
  _nextLi()
  save()
  return

_nextLi = (signin,exit)=>
  for f from ON_LI
    f(USER_SIGNIN,USER_EXIT)
  return

_signinExit = (signin,exit)=>
  liSet USER_SIGNIN,signin
  liSet USER_EXIT,exit
  return

_setLi = (signin,exit)=>
  if liEq(USER_EXIT,exit) and liEq(USER_SIGNIN,signin)
    return
  _signinExit signin,exit
  _nextLi()
  return true

_update = (signin,exit)=>
  pre = USER_SIGNIN[0]
  if _setLi signin,exit
    if not liEq signin[0], pre
      _setMe()
  return

INIT = new Promise (resolve)=>
  _setUser = (signin, exit)=>
    INIT = undefined
    _signinExit signin,exit
    _nextLi()
    _setMe()
    _setUser = _update
    resolve()
    return true
  return



< exitAll = =>
  await SDK.u.exitAll()
  _signinExit [],USER_SIGNIN.concat USER_EXIT
  _toAllMe()
  return

< rmAll = =>
  await SDK.u.rmAll()
  _signinExit [],[]
  _toAllMe()
  return



do =>
  await sleep 300

  if INIT
    set = (v)=>
      if _setUser ...v
        reply(0)
      return

    pre = (await R.conf.get U)?.v
    if pre
      set pre

    r = await SDK.u()
    if JSON.stringify(pre) != JSON.stringify(r)
      set(r)
      save()
  return

< setNameWay = (id, name, li)=>
  change = 0
  for i from USER_SIGNIN
    if i[0] == id
      if name
        if i[1] != name
          change = 1
          i[1] = name
      if li
        for [way,val] from li
          if way == i[2]
            if val!=i[3]
              i[3] = val
              change = 1
      break
  if change
    _toAllMe()
  return

< userSet = (li, args...)=>
  r = Array.isArray(li)
  if r
    li = li.concat args
    uid = li[0]

    for [id],pos in USER_EXIT
      if uid == id
        USER_EXIT.splice(pos,1)
        USER_SIGNIN.unshift(li)
        _toAllMe()
        return r

    for [id],pos in USER_SIGNIN
      if uid == id
        if pos != 0
          USER_SIGNIN.splice pos, 1
          USER_SIGNIN.unshift li
          _toAllMe()
        return r
    USER_SIGNIN.unshift li
    _toAllMe()
  return r

< exit = ()=>
  {id} = await User()
  if id
    return exitUid(id)
  return

< enter = (id)=>
  for i,pos in USER_SIGNIN
    if i[0] == id
      if pos == 0
        return
      USER_SIGNIN.splice pos,1
      USER_SIGNIN.unshift i
      _toAllMe()
      await SDK.u.enter id
      return
  return

< rm = (id)=>
  for i,pos in USER_EXIT
    if i[0] == id
      await SDK.u.rm id
      USER_EXIT.splice pos,1
      _toAllMe()
      return
  return

< exitUid = (id)=>
  for i,pos in USER_SIGNIN
    if i[0] == id
      await SDK.u.exit id
      USER_EXIT.push i
      USER_SIGNIN.splice pos,1
      _toAllMe()
      return
  return

_User = =>
  if INIT
    await INIT
  _User = => USER
  USER

< default User = =>
  _User()

