#!/usr/bin/env coffee

> !/_/SDK.js
  !/_/byTag.js > byTag0
  ./Sign.auth.js > auth

< =>
  box = auth()
  byTag0(box,'u-auth').account = await SDK.u.last()
  box
