jQuery ->
  class App.page.EditorPage
    constructor: (element)->
      this.el = element
      this.init()

    init: ->
      # Initialize editor
      editorForm = this.el
      editorForm.find(".content-editor").qeditor();
      editorForm.on 'click', ".upload-link", (e,data) ->
        $(editorForm).find(".fileinput-button :file").trigger('click')
        e.preventDefault()

