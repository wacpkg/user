#!/usr/bin/env coffee

> !/_/Alert.js
  !/_/Box.js > tagBox
  !/_/SDK.js
  !/_/byTag.js
  !/wtax/On.js
  !/wtax/assign.js
  !/wtax/wcut.js
  !/user/i18n/onMount.js > I18N
  ./captcha.js
  ../i18n/code.js > MAIL CREATE_ACCOUNT NAME RESET_PASSWORD USED SET_DONE
  ../User.js > userSet

{mail} = SDK.auth
{signup,resetPassword,set} = mail

mail = captcha mail
setMail = captcha set.mail

_box = (account, password, send, option)=>
  [box,b] = tagBox 'u-auth-mail-code'

  assign b,{
    account
    send
  }
  assign b, option
  return box

_user = (r, account)=>
  userSet r, MAIL, account

_signup = (account,password,send)=>
  box = _box(
    account,password,send
    btn: CREATE_ACCOUNT
    slot: (I18N)=>
      """<u><input maxlength="28" placeholder=" " type="text" id="uName" autocomplete="off" required><label for="uName">#{I18N[NAME]}</label></u>"""
    next:(code) ->
      input = byTag(@,'input')[1]
      input.value = name = wcut input.value.trim(),28
      r = await signup(account, password, code, name)
      if _user r, account
        box.close()
        return
      r
  )
  return

< [
  MAIL
  (account)=>
    if not /^\S+@\S+$/.test(account)
      return

    [
      # 注册
      (up, password)=>
        send = =>
          mail up, account, password

        r = await send()

        # 验证码窗口被主动关闭
        if not Number.isNaN r
          if _user r, account
            return
          _signup(
            account
            password
            send
          )
        return r

      # 重置密码
      (password)=>
        reset = captcha resetPassword
        send = => reset(account, password)
        r = await send()
        # 返回的值可能是已登录
        if _user r, account
          return false

        switch r
          when 0
            _signup(account,password,send)
          when false
            box = _box(
              account,password,send
              {
                btn:RESET_PASSWORD
                next:(code) ->
                  r = await resetPassword(account, password, code)
                  if _user r, account
                    box.close()
                    Alert(
                      =>
                        I18N[SET_DONE]
                    )
                    return
                  r
              }
            )
        return

      # 修改邮箱
      (UID,old,now)=>
        send = => setMail UID,now
        r = await send()
        if Number.isNaN r
          return false
        if r
          return (i18n)=>
            now + ' : ' + i18n[r]
        [box,tag] = tagBox('u-set-mail')
        new Promise (resolve, reject)=>
          x = =>
            box.close()
            return
          On box,{
            close:=>
              resolve(false)
              return
          }
          assign tag,{
            UID
            old
            now
            send
            ok: (r)=>
              resolve r
              x()
              return
          }
          return
    ]
]

