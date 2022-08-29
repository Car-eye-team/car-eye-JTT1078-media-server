import Vue from 'vue'

import Login from 'components/Login.vue'
import store from "./store";

new Vue({
  el: '#app',
  store,
  template: `<Login></Login>`,
  components: {
    Login
  },
  mounted() {

  }
})