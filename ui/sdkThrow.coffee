> ./captcha.js
  ./Sign.auth.js > auth
  !/_/byTag.js > byTag0
  !/_/SDK.js

< (response, next, url, req_option)=>
  {status} = response
  switch status
    when 401
      byTag0(auth(),'u-auth').account = await SDK.u.last()
    when 412
      c = await captcha()
      # 验证码窗口被关闭
      if Number.isNaN c
        return c
      else
        req_option.headers['Content-Type'] = c
        next url, req_option
        return
  # 返回 response 代表不处理
  return response

