window.getsupported = (path) ->
  op = 'Operating'
  txt = path.split('.')
  if txt[txt.length - 1].indexOf(op) >= 0
    sup = path.replace(op, 'Supported')
    arr = $('li:contains(' + sup + ')').children('.param-value').text().split(',')
    autocom '.acop', arr

window.searchparam = ->
  $.extend $.expr[':'], 'containsIN': (elem, i, match, array) ->
    (elem.textContent or elem.innerText or '').toLowerCase().indexOf((match[3] or '').toLowerCase()) >= 0
  $(this).keyup ->
    txt = $('.search').val()
    if txt == ''
      $('.param-path').parent().show()
    else
      $('.param-path').parent().hide()
      $('.param-path:containsIN("' + txt + '")').parent().show()