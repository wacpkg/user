#!/usr/bin/env coffee

> ../cron/week/mailban > load

< default main = =>
  await load()
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  console.log await main()
  process.exit()

