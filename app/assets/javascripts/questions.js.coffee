# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

SITE.questions =
  index: () ->
    converter = new Markdown.Converter()
    $('.content').each (key, value) ->
      content = $(value)
      content.html(converter.makeHtml(content.html()))
      MathJax.Hub.Queue(["Typeset",MathJax.Hub])
  new: () ->
    this.form()
  create: () ->
    this.form()
  edit: () ->
    this.form()
  update: () ->
    this.form()
  import_edit: () ->
    converter = new Markdown.Converter()
    rows = $('.question-row')
    rows.each (key, value) ->
      content = $(value).find('.content')
      preview = $(value).find('.preview')
      updatePreview = () ->
        preview.html(converter.makeHtml(content.val()))
        MathJax.Hub.Queue(["Typeset",MathJax.Hub])
      updatePreview()
      content.bind('keyup', updatePreview)
  import_save: () ->
    this.import_edit()
  form: () ->
    content = $('#question_content')
    preview = $('#question_preview')
    converter = new Markdown.Converter()
    updatePreview = () ->
      preview.html(converter.makeHtml(content.val()))
      MathJax.Hub.Queue(["Typeset",MathJax.Hub])
    updatePreview()
    content.bind('keyup', updatePreview)