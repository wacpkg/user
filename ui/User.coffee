> !/_/DB.js > R W
  !/_/SDK.js
  wtax/liSet.js
  # !/_/vote.js > reply


+ USER

U = 'u'

< USER_SIGNIN = []
< USER_EXIT = []

ON_ME = new Set()
ON_LI = new Set()

< onLi = (func)=>
  ON_LI.add func
  if USER != undefined
    func USER_SIGNIN,USER_EXIT
  =>
    ON_LI.delete func
    return

< onMe = (func)=>
  ON_ME.add func
  if USER != undefined
    func USER
  =>
    ON_ME.delete func
    return

_setMe = =>
  me = USER_SIGNIN[0]
  if USER
    if me?.id == USER.id
      return
  if me
    [id,name] = me
    USER = {id,name}
  else
    USER = {}
  for f from ON_ME
    f(USER)
  return


_setMeLi = =>
  _setMe()
  for func from ON_LI
    func USER_SIGNIN,USER_EXIT
  return

_signinExit = ([signin,exit])=>
  liSet USER_SIGNIN,signin
  liSet USER_EXIT,exit
  _setMeLi()
  return

save = =>
  W.conf.put {
    id:U
    v:[
      USER_SIGNIN
      USER_EXIT
    ]
  }

_change = =>
  _setMeLi()
  await save()
  return

< enter = (id)=>
  for i,pos in USER_SIGNIN
    if i[0] == id
      if pos == 0
        return
      await SDK.u.enter id
      USER_SIGNIN.splice pos,1
      USER_SIGNIN.unshift i
      _setMeLi()
      return
  return

< exitUid = (id)=>
  for i,pos in USER_SIGNIN
    if i[0] == id
      await SDK.u.exit id
      USER_EXIT.push i
      USER_SIGNIN.splice pos,1
      _change()
      return
  return

_User = =>
  r = (await R.conf.get U)?.v

  no_exist = not r
  if no_exist
    r = await SDK.u()

  _signinExit r

  if no_exist
    save()

  _User = =>
    USER

  USER

_User()

< default User = =>
  _User()

< userSet = (li, args...)=>
  r = Array.isArray(li)
  if r
    li = li.concat args
    uid = li[0]

    for [id],pos in USER_EXIT
      if uid == id
        USER_EXIT.splice(pos,1)
        USER_SIGNIN.unshift(li)
        _change()
        return r

    for [id],pos in USER_SIGNIN
      if uid == id
        if pos != 0
          USER_SIGNIN.splice pos, 1
          USER_SIGNIN.unshift li
          _change()
        return r
    USER_SIGNIN.unshift li
    _change()
  return r


_setChange = (signin, exit)=>
  _signinExit [signin,exit]
  _change()
  return

< exitAll = =>
  await SDK.u.exitAll()
  _setChange [],USER_SIGNIN.concat USER_EXIT
  return

< rmAll = =>
  await SDK.u.rmAll()
  _setChange [],[]
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
    _change()
  return


< exit = ()=>
  {id} = await _User()
  if id
    return exitUid(id)
  return

< rm = (id)=>
  for i,pos in USER_EXIT
    if i[0] == id
      await SDK.u.rm id
      USER_EXIT.splice pos,1
      _change()
      return
  return
