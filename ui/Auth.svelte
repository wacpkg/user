<template lang="pug">
include /_/p_input.pug
form(@&form @submit|preventDefault)
  +p_input("{tip}")#account(
    &account
    autocomplete="{ up ? 'off' : 'username' }"
    required
  )
  +p_input("{i18nPassword}")#password(
    &password
    minlength="6"
    required
    type="password"
  )
  p
    +if isAgree
      button(@click=signup class:a=!up type="submit")
        | >signUp
      button(@click=signin class:a=up type="submit")
        | >signIn
      +else
        b >needUserAgreement
  footer
    p
      input#uAuthAgree(checked&isAgree type="checkbox")
      label(for="uAuthAgree") >agree
      a(@click=agree) >userAgreement
    a(@click=resetPassword) >resetPassword
</template>

<script lang="coffee">
> !/wtax/On.js
  !/_/errRender.js
  !/_/Focus.js
  !/_/AutoFocus.js
  ./i18n/code.js > PASSWORD SET_PASSWORD CLICK_SIGN_IN ACCOUNT_EXIST ACCOUNT_MAIL_HOST_BAN ERR_ACCOUNT_OR_PASSWORD ACCOUNT_INVALID
  !/_/byTag.js:@ > byTagBind byTag0
  ./setPassword.js
  ./WAY.js:@ > accountWay
  ./Auth.agree.js > agree

< next = =>
< account = ''

+ form, errAccount, errPassword, inputLi, focus

+ password = tip = ''

:$
  tip = (
    WAY.map ([k,func])=>
      I18N[k]
  ).join ' / '

:$
  i18nPassword = I18N[if up then SET_PASSWORD else PASSWORD]

< up = ! account

rmErr = (e)=>
  e.preventDefault()
  for i from form.getElementsByTagName('b')
    i.remove()
  up = !up
  return

signup = (e)=>
  if !up
    rmErr(e)
    i = inputLi()[0]
    i.focus()
    i.select()
  return


signin = (e)=>
  if up
    rmErr(e)
    [i0,i1] = inputLi()
    if not i0.value
      i0.value = account
      i1.value = ''
    focus()
  return

submit = =>
  account = account.trim()
  errAccount = account
  errPassword = password
  way = await accountWay(account,0)
  if way
    r = await errRender(
      way(up, password[..63])
      (err)=>
        if err.account == ACCOUNT_EXIST
          err.account = (b)=>
            b.innerText = I18N[ACCOUNT_EXIST]
            a = document.createElement 'a'
            a.innerText = I18N[CLICK_SIGN_IN]

            On a,{
              click:signin
            }
            b.appendChild a
            return
        return
    )

    if Number.isNaN r
      focus()
      return
    next()
    return
  throw account:ACCOUNT_INVALID
  inputFocus 0
  return

inputFocus = (n)=>
  i = inputLi()[n]
  i.focus()
  i.select()
  return

isAgree = true

onMount =>
  await tick()
  inputLi = byTagBind form, 'input'
  focus = Focus form
  for i from inputLi()
    On(
      i
      keydown:(e)=>
        if 13 == e.keyCode
          e.preventDefault()
          for b from byTag form,'button'
            if not b.classList.contains 'a'
              b.click()
              break
        return
    )
  return AutoFocus form

resetPassword = =>
  setPassword(
    tip
    account
    password
    (e)=>
      account = e.account
      password = e.password
      return
  )
  return

</script>

