
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
  .data(arcos,  d => `${d.fuente.id}-${d.destino.id}`)
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
  .attr('transform', d => `translate(${d.x}, ${d.y})`);

vertices.append('circle')
.attr('r', 10)
.style('fill', 'blue');

