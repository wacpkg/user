#!/usr/bin/env coffee

> _/Redis:R
  @w5/ru > u64Bin

id = 1
console.log await R.mailId('i@wac.tax')
console.log await R.idMail id

id = u64Bin id
console.log await R.uidMail id
