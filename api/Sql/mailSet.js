// NOT EDIT : use sh/gen/sql_func.coffee gen

import {UNSAFE} from '_/Pg'

export default (mail_id,uid)=>{
  return UNSAFE(
    'SELECT auth_mail.mail_set($1,$2)',
    mail_id,uid
  )
}