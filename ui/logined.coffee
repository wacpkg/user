> ./boxAuth.js
  ./User.js

window.logined = =>
  user = await User()
  if user.id
    return user.id
  boxAuth()
  return

export default logined
