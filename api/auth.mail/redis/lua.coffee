> ./key > R_MAIL_HOST R_MAIL R_UID_MAIL

< (R, redis)=>
  R.fboolR.hasHost()
  host_mail = [R_MAIL_HOST, R_MAIL]
  R.fstrR.idMail(...host_mail)
  R.fnum.mailId(...host_mail)
  R.fnum.mailIdNew(...host_mail)
  R.fstrR.uidMail(R_UID_MAIL, ...host_mail)
  return
