# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

APP.questions =
  index: () ->
    converter = new Markdown.Converter()
    $('.content').each (key, value) ->
      content = $(value)
      content.html(converter.makeHtml(content.html()))
      MathJax.Hub.Queue(["Typeset",MathJax.Hub])
  show: () ->
    converter = new Markdown.Converter()
    content = $('#content')
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
      # solution preview
      solution_content = $(value).find('.question_solution')
      solution_preview = $(value).find('.solution_preview')
      updateSolutionPreview = () ->
        solution_preview.html(converter.makeHtml(solution_content.val()))
        MathJax.Hub.Queue(["Typeset",MathJax.Hub])
      updateSolutionPreview()
      solution_content.bind('keyup', updateSolutionPreview)
    # option preview
    $('.option-row').each (key, value) ->
      updateOptoinPreview = () ->
        value = $(value)
        option_content = value.find('.option-content')
        option_preview = value.find('.option-preview')
        option_preview.html(converter.makeHtml(option_content.val()))
        MathJax.Hub.Queue(["Typeset",MathJax.Hub])
      updateOptoinPreview()
      $(value).find('.option-content').bind('keyup', updateOptoinPreview)
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
    # solution preview
    solution_content = $('#question_solution')
    solution_preview = $('#solution_preview')
    updateSolutionPreview = () ->
      solution_preview.html(converter.makeHtml(solution_content.val()))
      MathJax.Hub.Queue(["Typeset",MathJax.Hub])
    updateSolutionPreview()
    solution_content.bind('keyup', updateSolutionPreview)
    this.options_preview()
    # option preview
    $('.option-row').each (key, value) ->
      updateOptoinPreview = () ->
        value = $(value)
        option_content = value.find('.option-content')
        option_preview = value.find('.option-preview')
        option_preview.html(converter.makeHtml(option_content.val()))
        MathJax.Hub.Queue(["Typeset",MathJax.Hub])
      updateOptoinPreview()
      $(value).find('.option-content').bind('keyup', updateOptoinPreview)
