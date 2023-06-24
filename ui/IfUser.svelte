<template lang="pug">
+if user
  +if user.id
    slot
    +else
      slot(name="else")
</template>

<script lang="coffee">
> ./User.js > onMe
  !/_/byTag.js

+ user

onMe (u)=>
  user = u
  return
</script>
