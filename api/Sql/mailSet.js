// NOT EDIT : use sh/gen/sql_func.coffee gen

import {UNSAFE} from '@w5/pg/PG'

export default (mail_id,uid)=>{
  return UNSAFE(
    'SELECT auth_mail.mail_set($1,$2)',
    mail_id,uid
  )
}