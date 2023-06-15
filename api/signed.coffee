#!/usr/bin/env coffee
> @w5/lib > u64Bin
  _/Redis > R R_CLIENT_USER

< (func)=>
  ->
    key = u64Bin @I
    uid = await R_CLIENT_USER.zmax(key) 0
    if uid
      @uid = uid
      return await func.apply @,arguments
    return

