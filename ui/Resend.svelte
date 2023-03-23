<script lang="coffee">
< send

+ resended

_resend = =>
  setTimeout(
    =>
      resended = 0
      return
    1e4
  )
  return

resend = =>
  await send()
  resended = 1
  _resend()
  return

onMount _resend
</script>

<template lang="pug">
+if resended
  i >verificationMailResended
    | {' '}✓
  +elif resended == 0
    a(@click=resend)
      | >notRecv >resend
</template>

