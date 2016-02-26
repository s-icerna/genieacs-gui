softwareversions = []
productclasses = []
configparamwritablebool = []
configparamwritable = []
objnames = []
objparamwritable = []
svvalue = 'this.InternetGatewayDevice.DeviceInfo.SoftwareVersion._value'
pcvalue = 'this._deviceId._ProductClass'
devicejson = '/devices'
objjson = '/objects'

allpar = (obj) ->
  $.each obj, (key, value) ->
    oobj = undefined
    if $.type(value) == 'object'
      oobj = obj
      obj = value
      allpar obj
      obj = oobj
    if key == '_path'
      if obj._object == true and obj._writable
        objparamwritable.push obj._path
      if obj._type
        if obj._writable
          configparamwritable.push obj._path
        if obj._type == 'xsd:boolean'
          configparamwritablebool.push obj._path

getsv = (data) ->
  $.each data, ->
    softwareversions.push eval(svvalue)
    softwareversions = $.unique(softwareversions)

getpc = (data) ->
  txt = $('#versionselect').val()
  $.each data, (sv) ->
    if eval(svvalue) == txt
      productclasses.push eval(pcvalue)
      productclasses = $.unique(productclasses)

getobjects = (data) ->
  $.each data, ->
    objnames.push @_id

parampush = (data) ->
  versionchoose = $('#versionselect').val()
  productclasschoose = $('#productclassselect').val()
  $.each data, (i) ->
    if eval(svvalue) == versionchoose and eval(pcvalue) == productclasschoose
      id = data[i]._id
      configparamwritable.length = objparamwritable.lenght = configparamwritablebool.lenght = objnames.lenght = 0
      $.getJSON devicejson + '/' + id, (obj) ->
        ke = obj.InternetGatewayDevice
        allpar ke
        autocom '.accon', configparamwritable
        autocom '.acobjparam', objparamwritable
        autocom '.acobj', objnames

      $.getJSON objjson, getobjects
      if $('#notfound').length
        $('#notfound').text('Match found!').css 'color', 'black'
      else
        $('#choose').after '<p id="notfound" style="display:inline;">Match found! Go on with Autocomplete!</p>'
    else
      if $('#notfound').length
        $('#notfound').text 'Again! No Match found!'
      else
        $('#choose').after '<p id="notfound" style="color:red; display:inline;">No match found! Choose another one!</p>'

autocom = (field, source) ->
  $(field).autocomplete(
    source: source
    minLength: 0).focus ->
    $(this).autocomplete 'search'

$(document).on 'page:change', ->
  $.getJSON devicejson, getsv
  autocom '#versionselect', softwareversions
  $('#versionselect').focusout ->
    $.getJSON devicejson, getpc
    autocom '#productclassselect', productclasses

  $('#choose').click ->
    $.getJSON devicejson, parampush

  $('.accon').focusout ->
    if $.inArray($(this).val(), configparamwritablebool) >= 0
      autocom $(this).next(), [
        'true'
        'false'
      ]

  $('.action').click ->
    autocom '.accon', configparamwritable
    autocom '.acobjparam', objparamwritable
    autocom '.acobj', objnames
    $('.accon').focusout ->
      if $.inArray($(this).val(), configparamwritablebool) >= 0
        autocom $(this).next(), [
          'true'
          'false'
        ]
      else
        autocom $(this).next(), []