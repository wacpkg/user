> @w5/ru > u64Bin
  _/Redis > R R_CLIENT_USER

< (func)=>
  (args...)->
    key = u64Bin @I
    id = u64Bin +args[0]
    r = await R_CLIENT_USER.zscore key, id
    if r
      if r > 0
        return await func.apply @,[id,...args[1..]]
    return
