LayerControl = (options) ->
  mapboxgl.util.setOptions(@, options)
  return

LayerControl.prototype = mapboxgl.util.inherit(mapboxgl.Control,

  _map: null

  options:
    layers: {}
    position: 'top-right'

  _createElement: (tagName, className=null, container=null, text=null) ->
    el = document.createElement(tagName)
    if (className)
      el.className = className
    if (container)
      container.appendChild(el)
    if (text)
      t = document.createTextNode(text)
      el.appendChild(t)
    return el

  _createButton: (className, container, fn) ->
    a = @_createElement('button', className, container)
    a.addEventListener('click', -> fn())
    return a

  _hideLayers: (layers) ->
    @map.batch (b) ->
      for l in layers
        b.setLayoutProperty(l, 'visibility', 'none')

  _showLayers: (layers) ->
    @map.batch (b) ->
      for l in layers
        b.setLayoutProperty(l, 'visibility', 'visible')

  _onToggleLayer: (e) ->
    group = @options.groups[e.target.name]
    group.visible = not group.visible
    if group.visible
      @_showLayers(group.layers)
    else
      @_hideLayers(group.layers)

  _updateLayers: (panelEl, style) ->
    i = 0
    for name, group of @options.groups
      elementClassName = 'mapboxgl-ctrl-layers-switch'
      elementId = 'switch-' + i++
      itemEl = @_createElement('li', null, panelEl)
      switchEl = @_createElement('div', elementClassName, itemEl)
      switchEl.innerHTML = '<input id="' + elementId + '" name="' + name + '" type="checkbox" class="' + elementClassName + '-checkbox" checked>
                            <label class="' + elementClassName + '-label" for="' + elementId + '">' + name + '</label>'
      document.getElementById(elementId).addEventListener('change', @_onToggleLayer.bind(@))

  onAdd: (map) ->
    @map = map
    className = 'mapboxgl-ctrl'
    containerEl = @_createElement('div', className + '-group', map.getContainer())
    panelEl = @_createElement('ul', className + '-layers-panel', containerEl)

    map.on('load', =>
      @_updateLayers(panelEl, map.style)
    )

    return containerEl
)

mapboxgl.LayerControl = LayerControl
