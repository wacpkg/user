> ./boxAuth.js
  ./User.js

< (func)=>
  ->
    user = await User()
    if user.id
      return func.call @,user.id,...arguments
    boxAuth()
    return
