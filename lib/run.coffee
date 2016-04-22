module.exports =

  start: () ->
    requestAnimationFrame -> # wait for other dom changes
      scopes = atom.config.get('center-editor.scopes').split(',')
      editor = atom.workspace.getActiveTextEditor()

      if editor isnt undefined # e.g. settings-view
        currentScope = editor.getRootScopeDescriptor().scopes[0]
        if currentScope in scopes

          characterWidth = editor.getDefaultCharWidth()
          charactersPerLine = atom.config.get('editor.preferredLineLength', scope: [currentScope])

          atom.config.set('editor.softWrap', true, scopeSelector: currentScope)
          atom.views.getView(editor).style.maxWidth = characterWidth * (charactersPerLine + 4) + 'px'
          atom.views.getView(editor).style.paddingLeft = characterWidth * 2 + 'px'
          atom.views.getView(editor).style.paddingRight = characterWidth * 2 + 'px'
          atom.views.getView(editor).setAttribute('data-center-editor', true)


  stop: () ->
    $ = require 'jquery'
    $('[data-center-editor]').attr('data-center-editor', false)
    $('atom-text-editor:not(.mini)').css 'max-width', ''
