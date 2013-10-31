// Generated by CoffeeScript 1.6.3
var btns, closeAllInfos, infos;

btns = $('.course__btn');

infos = $('.course__info');

closeAllInfos = function() {
  return infos.forEach(function(elem, index) {
    return elem.setAttribute('data-state', 'hidden');
  });
};

btns.on('click', function(e) {
  var id, info, isVisible;
  id = this.getAttribute('id');
  info = $(".course__info[data-id=\"" + id + "\"]");
  isVisible = info.getAttribute('data-state') === 'visible' ? true : false;
  if (isVisible) {
    return info.setAttribute('data-state', 'hidden');
  } else {
    closeAllInfos();
    return info.setAttribute('data-state', 'visible');
  }
});