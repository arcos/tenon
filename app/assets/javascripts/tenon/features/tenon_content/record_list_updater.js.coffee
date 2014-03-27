class Tenon.features.RecordListUpdater
  constructor: ->
    $(document).on('click', 'a.record-list-updater', @updateRecordList)
    $(document).on('submit', 'form.record-list-updater', @updateRecordList)
    $(window).on('popstate', @popUpdate)

  updateRecordList: (e) =>
    e.preventDefault()
    $el = $(e.currentTarget)
    @clearQuery = $el.attr('data-clear-record-list-params')
    if $el.prop("tagName").toLowerCase() == 'form'
      @_updateWithQuery($el.serialize(), 'Search')
    else
      @_updateWithQuery(URI($el.attr('href')).query(), $el.textContent)

  _updateWithQuery: (query, title) =>
    query = if @clearQuery then query else @_mergedQuery(query)
    history.pushState({recordListUpdate: true}, title, "?#{query}")
    Tenon.refreshed = false
    Tenon.activeRecordList.refresh(clear: true)

  # Get a combination of the current params and any new params that
  # the link or form is adding.  This allows us to, for example, submit
  # an advanced search form and then change the sort order with a link.
  # Add data-clear-record-list-params to prevent this merge.
  _mergedQuery: (newQuery) =>
    oldQueryObj = URI(location.href).query(true)
    newQueryObj = URI("?" + newQuery).query(true)
    $.param($.extend(oldQueryObj, newQueryObj))

  popUpdate: (e) =>
    # Chrome triggers window.onpopstate on page load, so elsewhere
    # at page load we set Tenon.refreshed to true to indicate that
    # as of yet nothing has been pushed to the history stack.
    #
    # Failing to do this results in a double AJAX load when the
    # page is first loaded in Chrome, and possible other browsers.
    if !Tenon.refreshed && Tenon.activeRecordList
      Tenon.activeRecordList.refresh(clear: true)