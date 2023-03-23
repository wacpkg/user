<template lang="pug">
include /_/p_input.pug
form(@&form @submit|preventDefault)
  h4 >enterCode
  p >checkSpam
  input(disabled type="text" value:account)
  +if slot
    | {@html slot(I18N)}
  +p_input(">verificationCode")#code(
    &code
    @&verificationCode
    autocomplete="off"
    required
  )
  u-resend(:send)
  button(type="submit") {I18N[btn]}
</template>

<script lang="coffee">
> ./i18n/code.js > ERR_CODE RESEND
  !/_/AutoFocus.js
  !/_/SDK.js
  !/_/errRender.js
  wtax/On.js

< account, next, send, btn, slot

+ form, verificationCode

code = ""

submit = =>
  await errRender(
    next.call(form,code)
    (err)=>
      if err.code == ERR_CODE
        err.code = (b)=>
          b.innerText = I18N[ERR_CODE] + ', '
          a = document.createElement 'a'
          a.innerText = I18N[RESEND]
          On a,{
            click:=>
              await send()
              verificationCode.value = ''
              verificationCode.focus()
              b.remove()
              return
          }
          b.appendChild a
          return
      return
  )
  return

onMount =>
  return AutoFocus(form)
</script>
