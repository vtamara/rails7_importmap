# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.js"
pin "@hotwired/stimulus", to: "stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "trix"
pin "@rails/actiontext", to: "actiontext.js"

pin 'md5', to: 'https://cdn.skypack.dev/md5'

pin 'vue', to: 'https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.esm.browser.js'
pin_all_from 'app/javascript/componentes', under: 'componentes'
pin 'd3', to: 'https://esm.sh/d3?bundle'
pin "react", to: "https://ga.jspm.io/npm:react@17.0.2/index.js"
pin "object-assign", to: "https://ga.jspm.io/npm:object-assign@4.1.1/index.js"
pin "react-dom", to: "https://ga.jspm.io/npm:react-dom@17.0.2/index.js"
pin "scheduler", to: "https://ga.jspm.io/npm:scheduler@0.20.2/index.js"
