class Tenon.features.AssetDetachment
  constructor: ->
    $(document).on('click', '.remove-asset', @_removeAsset)

  _removeAsset: (e) =>
    e.preventDefault()
    e.stopPropagation()
    @$assetField = $(e.currentTarget).closest('.asset-field')
    @$assetField.find('.asset-id-field').removeAttr('value')
    @$assetField.find('.thumbnail img').attr('src', '/assets/tenon/thumb-doc.png')
    @$assetField.find('.asset-info').html('No asset selected.')
