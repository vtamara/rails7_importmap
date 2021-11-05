#!/bin/sh
# Ejemplo de uso de importmap en rails 7.0.0.alpha con base en https://www.youtube.com/watch?v=PtxZvFnL2i0
# Este archivo es también script para el interprete de ordenes en adJ

# 1. Instalación y configuración inicial de publicaciones

rails -v
#Rails 7.0.0.alpha2

rm -rf rails7a2_importmap
rails new rails7a2_importmap
cd rails7a2_importmap

cat >> config/initializers/inflections.rb <<FDA
ActiveSupport::Inflector.inflections do |i|
  i.irregular "publicacion", "publicaciones"
end
FDA

bin/rails g scaffold publicacion titulo:string contenido:text

bin/rails db:migrate

ed app/views/publicaciones/_form.html.erb <<FDA
,s/prohibited this publicacion from being saved:/no permite(n) guardar esta publicación/g
w
q
FDA

ed app/views/publicaciones/_publicacion.html.erb <<FDA
,s/Show this publicacion/Resumen de esta publicación/g
w
q
FDA

ed app/views/publicaciones/edit.html.erb <<FDA
,s/Editing/Edición de/g
,s/Show this publicacion/Resumen de esta publicación/g
,s/Back to publicaciones/Regresar al listado de publicaciones/g
w
q
FDA

ed app/views/publicaciones/index.html.erb <<FDA
,s/New publicacion/Nueva publicación/g
,s/Publicacion/Publicación/g
w
q
FDA

ed app/views/publicaciones/new.html.erb <<FDA
,s/New publicacion/Nueva publicación/g
,s/Back to publicaciones/Regresar al listado de publicaciones/g
w
q
FDA

ed app/views/publicaciones/show.html.erb <<FDA
,s/Edit this publicacion/Editar esta publicación/g
,s/Back to publicaciones/Regresar al listado de publicaciones/g
,s/Destroy this publicacion/Eliminar esta publicación/g
w
q
FDA

ed config/application.rb <<FDA
/end
i
    config.hosts << "rbd.nocheyniebla.org"
.
w
q
FDA

#bin/rails s -p3500 -b 192.168.177.45


# 2. Enriquecer contenido de una publicación


bin/rails action_text:install
bin/rails db:migrate
cat >> config/importmap.rb <<FDA
pin "trix"
pin "@rails/actiontext", to: "actiontext.js"
FDA

ed app/models/publicacion.rb <<FDA
/end
i
  has_rich_text :contenido
.
w
q
FDA

ed app/views/publicaciones/_form.html.erb <<FDA
,s/form.text_area :contenido/form.rich_text_area :contenido/g
w
q
FDA


cat >> app/javascript/application.js <<FDA
import 'trix'
import '@rails/actiontext'
FDA

doas ln -s /usr/local/lib/libglib-2.0.so.4201.5 /usr/local/lib/libglib-2.0.so.0
doas ln -s /usr/local/lib/libgobject-2.0.so.4200.12 /usr/local/lib/libgobject-2.0.so.0
doas pkg_add libvips
doas ln -s /usr/local/lib/libvips.so.0.0 /usr/local/lib/libvips.so.42


#bin/rails s -p3500 -b 192.168.177.45

# 3. Usando un paquete javascript simple: md5

echo "pin 'md5', to: 'https://cdn.skypack.dev/md5'" >> config/importmap.rb

mkdir app/javascript/controllers/utilidades
cat > app/javascript/controllers/utilidades/md5_controller.js <<FDA
import { Controller } from "@hotwired/stimulus"
import md5 from 'md5'

export default class extends Controller {
  convert(event) {
    event.preventDefault()
    event.target.textContent = md5(event.target.textContent)
  }
}
FDA

cat >> app/views/publicaciones/index.html.erb <<FDA

<div data-controller="utilidades--md5">
  <%= link_to "Hash this!", "#", "data-action": "utilidades--md5#convertir" %>
</div>

FDA

#bin/rails s -p3500 -b 192.168.177.45

# 4. Incrustar un componente vue

echo "pin 'vue', to: 'https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.esm.browser.js'" >> config/importmap.rb

mkdir app/javascript/componentes
echo "pin_all_from 'app/javascript/componentes', under: 'componentes'" >> config/importmap.rb

cat > app/javascript/componentes/componente_vue.js <<FDA
import Vue from "vue"

new Vue ({
  el: '#ap-4',
  data: {
    porhacer: [
      { text: 'Aprende Javascript'},
      { text: 'Aprende Vue'},
      { text: 'Crea algo fenomenal'}
    ]
  }
})


new Vue ({
  el: '#ap-5',
  data: {
    mensaje: 'Hola Vue.js!',
  },
  methods: {
    invierteMensaje: function () {
      this.mensaje = this.mensaje.split('').reverse().join('')
    }
  }
})
FDA

echo "import \"componentes/componente_vue\"" >> app/javascript/application.js

cat >> app/views/publicaciones/index.html.erb <<FDA

<div id="ap-4">
  <ol>
    <li v-for="hacer in porhacer">
      {{ hacer.text }}
    </li>
  </ol>
</div>

<div id="ap-5">
  <p>{{ mensaje }}</p>
  <button v-on:click="invertirMensaje">Invertir Mensaje</button>
</div>
FDA

#bin/rails s -p3500 -b 192.168.177.45


# 5. Incrustar un componente d3

echo "pin 'd3', to: 'https://esm.sh/d3?bundle'" >> config/importmap.rb

cat > app/javascript/componentes/componente_d3.js <<FDA

import {select,zoom} from "d3"

const datos = {
  vertices: [
    {id: 1, x: 100, y: 50},
    {id: 2, x: 50, y: 100},
    {id: 3, x: 150, y: 100}
  ],
  arcos: [
    {fuente: 1, destino: 2},
    {fuente: 1, destino: 3}
  ]
};

var svg = select('svg');
var g = svg.append('g')

const manejaAcercamiento = function (e) {
  g.attr('transform', e.transform);
}

const acercamiento = zoom().on('zoom', manejaAcercamiento);

select('svg').call(acercamiento);

const arcos = datos.arcos.map(l=> {
  const fuente = datos.vertices.find(n => n.id === l.fuente);
  const destino = datos.vertices.find(n => n.id === l.destino);
  return {fuente, destino};
})

g.selectAll('line.link')
  .data(arcos,  d => \`\${d.fuente.id}-\${d.destino.id}\`)
  .enter()
  .append('line')
  .classed('link', true)
  .attr('x1', d => d.fuente.x)
  .attr('x2', d => d.destino.x)
  .attr('y1', d => d.fuente.y)
  .attr('y2', d => d.destino.y)
  .style('stroke', 'black');

const vertices = g.selectAll('g.node')
  .data(datos.vertices, d => d.id)
  .enter()
  .append('g')
  .classed('node', true)
  .attr('transform', d => \`translate(\${d.x}, \${d.y})\`);

vertices.append('circle')
.attr('r', 10)
.style('fill', 'blue');

FDA

echo "import \"componentes/componente_d3\"" >> app/javascript/application.js

cat >> app/views/publicaciones/index.html.erb <<FDA

<svg width='300' height='200'></svg>
FDA

#bin/rails s -p3500 -b 192.168.177.45


# 6. Incrustar un componente react sin JSX

bin/importmap pin react react-dom

cat > app/javascript/componentes/componente_react.js <<FDA

import React from "react"
import ReactDom from "react-dom"

const e = React.createElement

class Hola extends React.Component {
  render() {
    return e('div', null, \`Hola \${this.props.aQue}\`);
  }
}

ReactDom.render(
  e(Hola, { aQue: 'Mundo' }, null),
  document.getElementById('react')
)

FDA

bin/rails s -p3500 -b 192.168.177.45

echo "import \"componentes/componente_react\"" >> app/javascript/application.js

cat >> app/views/publicaciones/index.html.erb <<FDA

<div id="react">
</div>
FDA

