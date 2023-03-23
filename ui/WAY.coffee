> !/wtax/liSet.js

< default WAY = []

< waySet = (args...)=>
  liSet WAY, args
  return

< accountWay = (name,n)=>
  for f from WAY
    r = await f[1](name)
    if r
      return r[n]
  return

