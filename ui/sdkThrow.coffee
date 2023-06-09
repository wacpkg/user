> ./captcha.js
  ./boxAuth.js
< (response, next, url, req_option)=>
  {status} = response
  switch status
    when 401
      boxAuth()
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

