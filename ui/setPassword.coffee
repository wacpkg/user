> !/_/Box.js > tagBox

< (tip, account, password, next)=>
  [box,e] = tagBox 'u-reset-password'
  e.tip = tip
  e.account = account
  e.password = password
  e.next = =>
    next?(e)
    box.close()
    return
  return
