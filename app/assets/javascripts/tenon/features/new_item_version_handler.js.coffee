class Tenon.features.NewItemVersionHandler
  constructor: (@$link, @$el, @$template) ->
    @$itemForm = @$link.closest('form')
    @$versionForm = @$template.find('form')
    @$versionForm.on('submit', @submitItemVersion)

  submitItemVersion: (e) =>
    e.preventDefault()
    jqxhr = $.ajax
      url: @$versionForm.attr('action')
      data: @_formData()
      method: 'POST'
    jqxhr.done(@$template.modal('hide'))
    jqxhr.fail(@_failure())

  _formData: =>
    itemFormData = URI("?" + @$itemForm.serialize()).query(true)
    versionFormData = URI("?" + @$versionForm.serialize()).query(true)
    delete(itemFormData._method)
    $.extend(itemFormData, versionFormData)

  _failure: =>
    msg = "Failed to save draft."
    @$versionForm.prepend(msg)