SELECT_LIMIT = 200 # for more than 200 pages move to form

_ = require 'underscore'
View = require '../core-view'
Paging = require './paging'

# FIXME - check this import
template = require '../templates/pagination'

module.exports = class Pagination extends View

  initialize: ->
    _.extend @, Paging
    @listenTo @model, 'change:start change:count', @render

  render: ->
    {start, size, count} = @model.toJSON()
    max = @getMaxPage()
    data =
      gotoStart: if start is 0 then 'active' else ''
      goFiveBack: if start < (5 * size) then 'active' else ''
      goOneBack: if start < size then 'active' else ''
      gotoEnd: if start >= (count - size) then 'active' else ''
      goFiveForward: if start >= (count - 6 * size) then 'active' else ''
      goOneForward: if start >= (count - size) then 'active' else ''
      max: max
      size: size
      selected: (i) -> start is i * size
      useSelect: (max <= SELECT_LIMIT)

    @$el.html template data
    @$('li').tooltip placement: 'top'

  events:
    'submit .im-page-form': 'pageFormSubmit'
    'click .im-pagination-button': 'pageButtonClick'
    'click .im-current-page a': 'clickCurrentPage'
    'change .im-page-form select': 'goToChosenPage'

  goToChosenPage: (e) ->
    raw = $(e.target).val()
    start = if typeof raw is 'string' then parseInt($(e.target).val(), 10) else raw
    @goTo start


  clickCurrentPage: (e) ->
    size = @model.get 'size'
    total = @model.get 'count'
    return if size >= total
    $(e.target).hide()
    @$('form').show().find('select').trigger('mousedown')

  pageButtonClick: (e) ->
    $elem = $(e.target)
    unless $elem.parent().is('.active') # Here active means "where we are"
      switch $elem.data("goto")
        when "start"        then @goTo 0
        when "prev"         then @goBack 1
        when "fast-rewind"  then @goBack 5
        when "next"         then @goForward 1
        when "fast-forward" then @goForward 5
        when "end"          then @goToPage @getMaxPage()

  pageFormSubmit: (e) ->
      e.stopPropagation()
      e.preventDefault()
      pageForm = @$('.im-page-form')
      centre = @$('.im-current-page')
      inp = pageForm.find('input')
      if inp.size()
          destination = inp.val().replace(/\s*/g, "")
        if destination.match /^\d+$/
              newSelectorVal = Math.min @getMaxPage(), Math.max(parseInt(destination) - 1, 0)
              @table.goToPage newSelectorVal
              centre.find('a').show()
              pageForm.hide()
        else
              pageForm.find('.control-group').addClass 'error'
              inp.val ''
              inp.attr placeholder: "1 .. #{ @getMaxPage() + 1 }"