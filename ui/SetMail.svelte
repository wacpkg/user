<template lang="pug">
include /_/p_input.pug
form(@submit|preventDefault)
  h4 >enterCode
  p >checkSpam
  +p_input(">newMail")#nowMail(&now disabled)
  +p_input(">newMail >verificationCode")#now(
    &nowCode
    autocomplete="off"
    required
  )
  +if old
    +p_input(">oldMail")#oldMail(&old disabled)
    +p_input(">oldMail >verificationCode")#old(
      &oldCode
      autocomplete="off"
      required
    )
  u-resend(:send)
  button(type="submit") >modifyMail
</template>

<script lang="coffee">
> !/_/SDK.js

+ oldCode,nowCode

< UID,old,now,ok,send

submit = =>
  await SDK.auth.mail.set(
    UID
    now
    nowCode
    oldCode
  )
  ok()
  return
</script>

