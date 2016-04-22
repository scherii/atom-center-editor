{CompositeDisposable} = require 'atom'

module.exports =

  config:
    scopes:
      description: 'Comma seperated, no spaces. Find the scope for each language in its package.'
      type: 'string'
      default: 'text.html,text.html.php,source.sass,source.js'

  activate: (state) ->
    @disposables = new CompositeDisposable
    Run = require './run'
    Run.start()

    @disposables.add atom.config.onDidChange 'centerEditor.scopes', ->
      # Reset, start() will run again when pane is switched (e.g. away from settings)
      Run.stop()

    @disposables.add atom.config.onDidChange 'editor.fontSize', ->
      Run.start()

    @disposables.add atom.config.onDidChange 'editor.preferredLineLength', ->
      Run.start()

    @disposables.add atom.workspace.onDidChangeActivePaneItem =>
      Run.start()
      # Listen to grammar changes
      editor = atom.workspace.getActiveTextEditor()
      if editor isnt undefined
        @disposables.add editor.onDidChangeGrammar ->
          # Reset first
          atom.views.getView(editor).setAttribute('style', '')
          atom.views.getView(editor).setAttribute('data-center-editor', false)
          # Then decide if the new grammar needs to be in center editor mode
          Run.start()

  deactivate: (state) ->
    Run = require './run'
    Run.stop()
    @disposables.dispose()
