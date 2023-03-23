> !/_/Box.js > tagBox
  !/_/byTag.js > byTag0

< =>
  [box,tag] = tagBox('u-sign')
  tag.next = =>
    box.close()
    return
  #byTag0(tag,'button').click = =>
  #  box.close()
  #  return
  tag
