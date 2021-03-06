class Tenon.features.AssetCropping
  constructor: ->
    $(document).on('click', '.asset-crop', @_loadCrop)
    $(document).on('click', '.asset-cropping .close', @_cancelCrop)
    $(document).on('ajax:success', '.asset-cropping form[data-remote]', @_saveCrop)
    $(document).keyup (ev) =>
      @_cancelCrop(ev) if ev.keyCode is 27
    $(document).on('click', '.save', @_showSpinner)

  _showSpinner: (e) ->
    $('.spinner').fadeIn()

  _loadCrop: (e) =>
    e.preventDefault()
    @$link = $(e.currentTarget)
    url = Routes.tenon_crop_asset_path(@$link.data('asset-id'))
    $.get(url, {format: 'html'}, @_startCrop, 'html')

  _cancelCrop: (e) ->
    e.preventDefault()
    $('.asset-cropping').remove()

  _startCrop: (data) =>
    $(data).appendTo('body')
    $cropbox = $('#cropbox')

    $("#cropbox").Jcrop
      onChange: @_updateCrop
      onSelect: @_updateCrop
      boxWidth: $(window).width() * 0.8
      boxHeight: $(window).height() * 0.75

  _saveCrop: (e, data) =>
    if @$link.data('post-crop-handler')
      @_sendToHandler(data)
    else
      $('.asset-cropping').remove()

  _sendToHandler: (data) =>
    parts = @$link.data('post-crop-handler').split('.')
    method = window
    $(parts).each (i, part) -> method = method[part]
    new method(@$link, data)

  _updateCrop: (coords) ->
    ratio = $('#cropbox').data('width') / $('#cropbox').width()
    $('#asset_crop_x').val(coords.x)
    $('#asset_crop_y').val(coords.y)
    $('#asset_crop_w').val(coords.w)
    $('#asset_crop_h').val(coords.h)