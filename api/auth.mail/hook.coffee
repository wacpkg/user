#!/usr/bin/env coffee

> ../u/uidAccount > WAY_ACCOUNT
  ../auth/way > MAIL
  _/Redis:R

WAY_ACCOUNT.set(
  MAIL
  (id_li)=>
    Promise.all id_li.map (id)=>
      R.uidMail(id)
)
