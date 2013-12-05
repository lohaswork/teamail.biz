jQuery ->
  class App.page.EditorPage
    constructor: (element)->
      this.el = element
      this.init()

    init: ->
      # Initialize editor
      this.el.find(".content-editor").qeditor();
