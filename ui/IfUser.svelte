<template lang="pug">
div(@&div style="visibility: hidden")
  +if user
    +if user.id
      slot
      +else
        slot(name="else")
</template>

<script lang="coffee">
> ./User.js > onMe
  !/_/byTag.js

+ user,div

fire = =>
  e = document.createEvent('UIEvents')
  e.initUIEvent('visibilitychange')
  document.dispatchEvent e
  return

onMe (u)=>
  div.style.visibility=''
  user = u
  fire()
  return
</script>
