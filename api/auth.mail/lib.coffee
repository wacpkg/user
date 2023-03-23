> marked > marked
  @w5/split
  _/Mail/smtp
  ~/ERR > ACCOUNT_INVALID ACCOUNT_TOO_LONG ACCOUNT_MAIL_HOST_BAN
  _/Redis > R R_MAIL_BAN_HOST
  _/Core/sk > skCode
  ./I18N

< mailValid = (account)=>
  account = account.trim().toLocaleLowerCase()

  if account.length > 254
    return ACCOUNT_TOO_LONG

  if not /^\S+@\S+$/.test(account)
    return ACCOUNT_INVALID

  [mail,host] = split account,'@'
  # https://stackoverflow.com/questions/386294/what-is-the-maximum-length-of-a-valid-email-address
  if mail.length > 64
    return ACCOUNT_TOO_LONG

  if await R.hasHost(R_MAIL_BAN_HOST)(host)
    ban = ACCOUNT_MAIL_HOST_BAN
  return [
    account
    ban
  ]


< sendMail = (action, account, password)->
  {protocol,origin,lang} = @

  for lang from [lang, 'en']
    try
      {default:md} = await import("./I18N/#{lang}/code.js")
      break

  [
    subject
    mail
  ] = split(md,'\n')

  code = skCode(
    action
    origin
    account
    password
  )

  dict = {
    host:origin
    url:origin
    action:I18N[lang][action]
    code
  }

  subject = subject.render dict
  text = mail.render dict

  dict.code = "${code}"
  dict.url = "[#{origin}](#{protocol}://#{origin})"
  html = marked.parse(mail.render(dict)).replaceAll(
    '<p>','<p style="font-size:16px">'
  ).render({
    code:'<b style="background:#ff0;border:1px dashed #f90;font-weight:bold;padding:8px;font-family:Consolas,Monaco,monospace">'+code+'</b>'
  })

  smtp(
    origin
    account
    subject
    text
    html
  )
  return
