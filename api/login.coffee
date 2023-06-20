#!/usr/bin/env coffee
> @w5/lib > u64Bin binU64
  _/Redis > R R_CLIENT_USER
  _/Http/Err.js > ERR_LOGIN

< (func)=>
  ->
    key = u64Bin @I
    uid = await R_CLIENT_USER.zmax(key) 0
    if uid
      @uid = binU64 uid
      return await func.apply @,arguments
    throw ERR_LOGIN

