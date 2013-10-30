btns = $('.course__btn')
infos = $('.course__info')

closeAllInfos = () ->
  infos.forEach (elem, index) ->
    elem.setAttribute('data-state', 'hidden')

btns.on 'click', (e) ->
  id = @.getAttribute('id')
  info = $(".course__info[data-id=\"#{id}\"]")
  isVisible = if info.getAttribute('data-state') is 'visible' then true else false

  if isVisible
    info.setAttribute('data-state', 'hidden')
  else
    closeAllInfos()
    info.setAttribute('data-state', 'visible')
