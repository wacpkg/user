> ../captcha.js:_captcha

< (f)=>
  (up, account, args...)=>
    next = =>
      f(up, account, ...args)

    if up then new Promise(
      (resolve,reject)=>
        c =  await _captcha()

        if Number.isNaN c
          resolve c
        else
          f['Content-Type'] = c
          next().then(resolve, reject)
        return
    ) else next()
