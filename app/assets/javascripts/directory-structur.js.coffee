$(document).on 'page:change', ->
  pathname = '#device-params ul li'

  setIcons = (lev, nlev) ->
    arrowandtab = ''
    arrow = '<span class="arrow">&#9205;</span>'
    treeend = '&#9561;'
    tree = '&#9567;'
    space = '&emsp;'
    i = 2
    while i <= lev
      arrowandtab = arrowandtab + space
      i++
    if lev == 1
      arrowandtab = '<span class="arrow">&#9207;</span>'
    else
      if lev > nlev or !nlev
        arrowandtab = arrowandtab + treeend
      else
        arrowandtab = arrowandtab + tree
        if lev < nlev
          arrowandtab = arrowandtab + arrow
    arrowandtab

  $(pathname + ' .param-path').each ->
    txt = $(this).text()
    txtwithoutvalue = txt.split(' ', 1)
    path = txtwithoutvalue[0].split('.')
    $(this).parent().attr
      'data-weight': path.length
      'data-hidden': 0

  $(pathname).each ->
    level = $(this).data('weight')
    nlevel = $(this).next().data('weight')
    $(this).children('.param-path').before setIcons(level, nlevel)
    if level > 2
      $(this).hide().data 'hidden', 1

  $(pathname + ' .param-path').click ->
    pli = $(this).parent()
    level = pli.data('weight')
    ndata = pli.next().data()
    nhidden = ndata.hidden
    nlevel = ndata.weight
    lilevel = 'li[data-weight=\'' + level + '\']'
    if level < nlevel and nhidden == 0
      pli.children('.arrow').html '&#9205;'
      pli.nextUntil(lilevel).hide().data('hidden', 1).children('.arrow').html '&#9205;'
    else
      pli.children('.arrow').html '&#9207;'
      pli.nextUntil(lilevel).filter('li[data-weight=\'' + nlevel + '\']').show().data 'hidden', 0

  $('.search').focusin ->
    $(pathname).each ->
      $(this).show().data 'hidden', 0
      
  $('.search').focusout ->
    if !$('.search').val()
      $(pathname).each ->
        level = $(this).data('weight')
        if level > 2
          $(this).hide().data 'hidden', 1