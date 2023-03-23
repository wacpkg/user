<template lang="pug">
+if user
  a {user.name}
</template>

<script lang="coffee">
> ./User.js > onMe
  !/_/SDK.js

+ user

onMe (u)=>
  user = u
  return
</script>
