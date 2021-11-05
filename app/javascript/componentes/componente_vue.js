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
    invertirMensaje: function () {
      this.mensaje = this.mensaje.split('').reverse().join('')
    }
  }
})
