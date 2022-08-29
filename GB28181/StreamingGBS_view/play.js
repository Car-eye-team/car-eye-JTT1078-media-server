import Vue from 'vue'

import store from "./store"

new Vue({
  el: '#app',
  store,
  template: `<Play></Play>`,
  components: {
    Play
  }
})