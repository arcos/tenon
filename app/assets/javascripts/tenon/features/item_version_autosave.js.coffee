class Tenon.features.ItemVersionAutosave
  constructor: ->
    @$form = $('form[data-autosave="true"]')
    setInterval(@autosave, 15000) if @$form.length

  autosave: =>
    jqxhr = $.ajax
      url: @$form.data('version-create-path')
      data: @_formData()
      method: 'POST'
    jqxhr.done(@_updateAutosave)

  _updateAutosave: (data) =>
    $('.last-autosave')
      .text("Last draft autosave on #{data.created_at}")
      .fadeIn()

  _formData:  =>
    itemFormData = URI("?" + @$form.serialize()).query(true)
    versionData =
      item_version:
        item_type: @$form.data('item-type')
        item_id: @$form.data('item-id')
        save_type: 'autosave'
        title: 'Auto-Save'
    delete(itemFormData._method)
    $.extend(itemFormData, versionData)