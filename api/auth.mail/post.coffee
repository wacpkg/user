`export * as set from './post/set.js'`

> ~/ERR.js > ACCOUNT_EXIST ERR_ACCOUNT_OR_PASSWORD ERR_CODE
  ~/auth/way.js > MAIL
  ~/captcha/index.js:captcha
  ~/u/USER_LOG.js > NAME
  ~/u/canEdit.js
  ./hook.js:
  ./lib.js > mailValid sendMail
  ~/Sql/signup.js:_signup
  ~/Sql/uidByMailId.js
  @w5/lib > passwordHash:_passwordHash u64Bin
  @w5/time > Second
  @w5/u8 > u8merge u8eq
  @w5/wcut
  _/Core/sk > skVerify
  _/Http/Err > ERR
  @w5/pg/PG > EXE
  _/Redis > R R_USER_NAME R_CLIENT_USER R_AUTH_WAY R_AUTH_LAST R_UID_MAIL

SIGNUP = 'signup'
RESET_PASSWORD = 'resetPassword'

MAIL_BIN = u64Bin MAIL

_captcha = (self, isNew)=>
  if isNew
    await captcha self
  else
    null
    # 登录失败超过3次就每次都要输入验证码
  return

passwordHash = (ctime,password)=>
  _passwordHash u64Bin(ctime), password

< has = (account)->
  account = account.trim().toLocaleLowerCase()
  if not account
    return 0
  mail_id = await R.mailId account
  console.log {mail_id}
  if not mail_id
    return 0
  if await uidByMailId(mail_id) then 1 else 0

signin = (I, user_id)=>
  key = u64Bin I
  uid = u64Bin user_id
  R_CLIENT_USER.ztouch(key) uid
  [
    user_id
    await R.hget R_USER_NAME, uid
  ]

_mail_account_password = (account, password)->
  r = await mailValid account

  if Number.isInteger r
    ERR account: r

  [account, ban] = r

  password = password[..63]

  result = [
    account
    password
  ]

  mail_id = await R.mailId account
  if mail_id
    r = await uidByMailId(mail_id)
    if r
      # [user_id, hash, ctime]
      result = result.concat r

  if ban and (not user_id)
    ERR account: ban

  result


_setPassword = (action, account, password, code)->
  account = account.trim().toLocaleLowerCase()

  password = password[..63]

  if skVerify(
    code
    action
    @origin
    account
    password
  )
    ctime = Second()
    mail_id = await R.mailIdNew account
    {I} = @
    hash = await passwordHash ctime,password
    user_id = await _signup(
      I,mail_id,ctime,hash
    )
    uid_bin = u64Bin user_id
    key = u64Bin I
    await R_CLIENT_USER.ztouch(key) uid_bin
    return [
      user_id
      uid_bin
      ctime
      mail_id
    ]
  ERR code: ERR_CODE
  return


#< phone = (isNew, area, phone, password)=>
#  await _captcha @,isNew
#  0

< (isNew, account, password)->
  await _captcha @,isNew

  [
    account, password, user_id, hash, ctime
  ] = await _mail_account_password.call @, account, password

  if isNew
    if user_id
      ERR account:ACCOUNT_EXIST
    sendMail.call @, SIGNUP, account, password
    return

  if user_id
    if u8eq(
      hash
      await passwordHash ctime,password
    )
      return signin @I,user_id
  ERR password: ERR_ACCOUNT_OR_PASSWORD
  return

< resetPassword = (account, password, code)->
  if code
    [user_id, uid_bin, ctime] = await _setPassword.call(
      @, RESET_PASSWORD, account, password, code
    )
    return [
      user_id
      await R.hget R_USER_NAME, uid_bin
    ]

  await captcha @
  [
    account, password, user_id
  ] = await _mail_account_password.call @, account, password

  action = if user_id then RESET_PASSWORD else SIGNUP
  sendMail.call @, action, account, password

  if user_id
    # 重置密码
    return false
  return 0

< signup = (account, password, code, name)->
  [user_id, uid_bin, ctime, mail_id] = await _setPassword.call(
    @, SIGNUP, account, password, code
  )
  name = wcut name.trim(),24

  await Promise.all [
    R.hset R_USER_NAME,uid_bin, name
    R_AUTH_WAY.sadd uid_bin, MAIL_BIN
    R.hset R_AUTH_LAST, uid_bin, MAIL_BIN
    R.hset R_UID_MAIL, uid_bin, mail_id
  ]
  EXE"INSERT INTO u.log (action,client_id,uid,val,ctime) VALUES (#{NAME},#{@I},#{user_id},#{name},#{ctime})"
  return [user_id,name]



