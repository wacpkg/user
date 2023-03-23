#!/usr/bin/env coffee

> ../i18n/code.js > PHONE
  !/_/SDK.js
  ./captcha.js

{phone} = SDK.auth

phone = captcha phone

RE_NUM = /^\d+$/

< [
  PHONE
  (account)=>
    [area, ...num]=account.replace(/[+-]/g, ' ').split(' ').filter(
      (i)=>i.length
    )
    num = num.join('')
    for i from [area,num]
      if i and (not RE_NUM.test i)
        return
    if not num
      if not area
        return
      num = area
      area = ''
    [
      (up, password)=>
        phone up, area, num, password
    ]
]
