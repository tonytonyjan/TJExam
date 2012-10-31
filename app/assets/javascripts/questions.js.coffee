# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ () ->
  content = $('#question_content')
  preview = $('#question_preview')

  updatePreview = () ->
    ary = content.val().match(/\$[^\$]*\$/g)
    preview.text ary?.join() ? ""
    MathJax.Hub.Queue(["Typeset",MathJax.Hub])
  updatePreview()
  content.bind('keyup', updatePreview)