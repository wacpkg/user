#!/usr/bin/env coffee

> !/_/SDK.js
  !/_/byTag.js > byTag0
  ./Sign.auth.js > auth

< =>
  byTag0(auth(),'u-auth').account = await SDK.u.last()
