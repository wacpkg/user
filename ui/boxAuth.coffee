#!/usr/bin/env coffee

> !/_/SDK.js
  !/_/byTag.js > byTag0
  ./Sign.auth.js > auth
  ./User.js > last

< =>
  byTag0(auth(),'u-auth').account = last()?[3] or ''
