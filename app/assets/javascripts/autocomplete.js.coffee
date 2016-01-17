$(document).on 'page:load', ->
  softwareversions = []
  productclasses = []
  autocomnames = []
  svvalue = 'data[i].InternetGatewayDevice.DeviceInfo.SoftwareVersion._value'
  pcvalue = 'data[i]._deviceId._ProductClass'
  jsonfile = '/devices'

  recpathsearchwritable = (obj) ->
    $.each obj, (key, value) ->
      if $.type(value) == 'object'
        oldobj = obj
        obj = value
        recpathsearchwritable obj
        obj = oldobj
      if key == '_path' and obj._writable == true
        autocomnames.push obj._path
      return
    return

  autocom = (field, source) ->
    $(field).autocomplete source: source
    return

  getvalues = (data) ->
    $.each data, (i) ->
      softwareversions.push eval(svvalue)
      productclasses.push eval(pcvalue)
      return
    return

  parampush = (data) ->
    versionchoose = $('#versionselect').val()
    productclasschoose = $('#productclassselect').val()
    $.each data, (i) ->
      if eval(svvalue) == versionchoose and eval(pcvalue) == productclasschoose
        idforautocomplete = data[i]._id
        $.getJSON jsonfile + '/' + idforautocomplete, (obj) ->
          ke = obj.InternetGatewayDevice
          recpathsearchwritable ke
          autocom '.addac', autocomnames
          return
      return
    return

  $.getJSON jsonfile, getvalues
  autocom '#versionselect', softwareversions
  autocom '#productclassselect', productclasses
  $('#versionbutton').click ->
    versionchoose = $('#versionselect').val()
    productclasschoose = $('#productclassselect').val()
    $.getJSON jsonfile, parampush
    return
  $('.action').click ->
    autocom '.addac', autocomnames
    return
  return