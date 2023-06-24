> wtax/On.js
  wtax/assign.js
  !/_/SDK.js
  wtax/web/tld.js
  wtax/sleep.js
  wtax/liSet.js
  !/_/DB.js > R W

+ USER, TAB_ID, _setUser, unbindBeforeunload

< CHANNEL = new BroadcastChannel 'wac.tax:'+tld
< USER_SIGNIN = []
< USER_EXIT = []

NEW_REPLY = []
LEADER = 0
MSG_NEW = 1

_ms = =>
  parseInt +new Date

sameHost = do =>
  dot_host = '.'+tld
  (origin)=>
    {hostname} = new URL(origin)
    (hostname == tld) or hostname.endsWith(dot_host)

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

reply = (tab_id)=>
  CHANNEL.postMessage [
    MSG_NEW
    tab_id
    TAB_ID
    USER_SIGNIN
    USER_EXIT
  ]
  return

initPost = =>
  TAB_ID = _ms()
  CHANNEL.postMessage [
    MSG_NEW
    TAB_ID
  ]
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

On CHANNEL,{
  message:(e)=>
    {data,origin} = e
    if not sameHost origin
      return

    {length} = data

    switch data[0]
      when MSG_NEW
        tab_id = data[1]

        if length == 2
          if INIT
            return

          if LEADER
            reply tab_id
          else
            data.push _ms()
            NEW_REPLY.push data
            timeout = 10
            await sleep timeout
            if NEW_REPLY.length
              li = NEW_REPLY.filter(
                (i)=>
                  time = i[2]
                  timeout = (new Date - time) >= timeout
                  if timeout
                    reply(i[1])
                  !timeout
              )
              if li.length != NEW_REPLY.length
                NEW_REPLY = li
                if not LEADER
                  LEADER = 1
                  #document.title = 'leader'
                  unbindBeforeunload = On window,{
                    beforeunload:=>
                      # 重新选举避免延时(没有leader的时候，延时甚至可能会高达1秒)
                      initPost()
                      return
                  }
        else
          user_li = data[3..]
          _setUser ...user_li

          if tab_id == 0
            return

          src_id = data[2]
          if src_id == TAB_ID
            initPost()

          for i,pos in NEW_REPLY
            if i[1] == tab_id
              NEW_REPLY.splice(pos,1)
              return

          if LEADER
            if src_id <= TAB_ID
              #document.title = 'member'
              unbindBeforeunload()
              unbindBeforeunload = undefined
              LEADER = 0
    return
}

U = 'u'

do =>
  initPost()
  await sleep 300
  if INIT
    r = await SDK.u()
    W.conf.put {
      id:U
      v:JSON.stringify(r)
    }
    # 必须拆分成为2行写，不然可能会导致_setUser还是INIT
    if _setUser ...r
      reply(0)
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

