
import React from "react"
import ReactDom from "react-dom"

const e = React.createElement

class Hola extends React.Component {
  render() {
    return e('div', null, `Hola ${this.props.aQue}`);
  }
}

ReactDom.render(
  e(Hola, { aQue: 'Mundo' }, null),
  document.getElementById('react')
)

