> ./boxAuth.js
  ./User.js > Uid

< (func)=>
  ->
    uid = Uid()
    if uid
      return func.call @,uid,...arguments
    boxAuth()
    return
