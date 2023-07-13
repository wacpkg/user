<template lang="pug">
template(@&Drop)
  ul
    slot(name="ul")
    li >config
    li >switchUser
    li >logout
+if user
  +if user.id
    span(@click=drop) {user.name}
    +else
      slot
</template>

<script lang="coffee">
> ./User.js > onMe exit
  !/_/SDK.js
  !/_/Menu.js
  !/_/bindLi.js
  ./sign.js
  ./conf.js

+ Drop, drop, user

onMount =>
  await tick()
  drop = Menu Drop, bindLi(
    =>
      conf user.id
      return
    =>
      sign()
      return
    exit
  )
  return

onMe (u)=>
  user = u
  return
</script>
