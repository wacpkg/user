#!/usr/bin/env coffee

> @w5/req/reqJson
  @w5/write
  @w5/read
  _/Redis > R R_MAIL_BAN_HOST
  path > join
  ./conf > PWD

MAILBAN_JSON = join(PWD,'mailban.json')

PROXY="https://ghproxy.com/https:"

< dump = =>
  url = PROXY+"//raw.githubusercontent.com/7c/fakefilter/main/json/data.json"
  json = await reqJson(url)
  {t,domains} = json
  li = []
  for [host,o] from Object.entries domains
    {lastseen} = o
    if (t - lastseen)/86400 < 365
      li.push host
  write(
    MAILBAN_JSON
    JSON.stringify li
  )
  return

< load = =>
  li = JSON.parse read MAILBAN_JSON
  console.log '\tmail ban host', li.length
  await R.sadd R_MAIL_BAN_HOST, ...li
  return

< default main = =>
  await dump()
  await load()
  return

if process.argv[1] == decodeURI(new URL(import.meta.url).pathname)
  await main()
  process.exit()

