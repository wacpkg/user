> !/_/Box.js
  !/_/byTag.js > byTag0
  !/_/On.js

tag = 'u-captcha'

+ BOX

_elem = =>
  byTag0 BOX, tag

< =>
  if BOX
    _elem().refresh()
    return

  + resolve

  BOX = Box "<#{tag}></#{tag}>"

  On BOX, {
    close:=>
      BOX = undefined
      if resolve
        resolve NaN
      return
  }

  new Promise (_resolve, reject) =>
    resolve = _resolve
    _elem().next = (args...)=>
      resolve JSON.stringify args
      resolve = undefined
      BOX.close()
      return
    return
