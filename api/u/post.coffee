> @w5/lib > zipU64 binU64 u64Bin
  @w5/wcut
  _/Redis > R R_CLIENT_USER R_USER_NAME
  ./canEdit
  ./uidAccount:@ > uidWay

# 获取最近一个登录用户的账号
< last = ->
  {I} = @
  key = u64Bin I
  li = await R_CLIENT_USER.zrevrangebyscore(key, limit:1)
  if li.length
    r = await uidAccount li
    if r.size
      for i from r.values()
        # TODO 根据 i[0] 判断类型决定是否用微信登录之类的
        return i[1]
  return ''

# 获取已登录/已退出的用户列表
< ->
  {I} = @
  key = u64Bin I
  li = await R_CLIENT_USER.zrevrangebyscoreWithscore(key)
  if not li.length
    return [[],[]]

  + pos

  # 区分已经登录和退出登录的用户
  li = li.map(
    ([id,s], n)=>
      if pos == undefined
        if s == 0
          pos = n
      id
  )

  if pos == undefined
    pos = li.length

  uid_account = await uidAccount li

  r = (
    await R.hmget R_USER_NAME, li
  ).map (name,p)=>
    id = li[p]
    [
      binU64(id)
      name
      ...uid_account.get(id)
    ]
  [
    r[...pos]
    r[pos..]
  ]

< me = ->
  key = u64Bin @I
  uid = await R_CLIENT_USER.zmax(key) 0
  if uid
    name = await R.hget R_USER_NAME,uid
    uid = binU64 uid
    return [uid,name]
  return

< exit = (id)->
  key = u64Bin @I
  await R_CLIENT_USER.zaddXx key,u64Bin(id),0
  return

< exitAll = ->
  key = u64Bin @I
  await R_CLIENT_USER.zero(key)()
  return

< rmAll = ->
  key = u64Bin @I
  await R_CLIENT_USER.del key
  return

< rm = (id)->
  key = u64Bin @I
  id = u64Bin +id
  await R_CLIENT_USER.zrem key, id
  return

< enter = (id)->
  key = u64Bin @I
  id = u64Bin +id
  await R_CLIENT_USER.ztouchXx(key) id
  return

< name = canEdit (id, name)->
  name = name.trim()
  if name
    R.hset R_USER_NAME, id, wcut(name,24)
  return

< conf = canEdit (id)->
  Promise.all [
    R.hget R_USER_NAME, id
    uidWay(id)
  ]


