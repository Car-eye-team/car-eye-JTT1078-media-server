import Vue from 'vue'
import store from "./store";
import router from './router'
function randomStr(n) { // 生成n位长度的字符串
  var str = "abcdefghijklmnopqrstuvwxyz0123456789"; // 可以作为常量放到random外面
  var result = "";
  for(let i = 0; i < n; i++) {
    result += str[parseInt(Math.random() * str.length)];
  }
  return result;
}
Vue.prototype.randomStr = randomStr;
new Vue({
  el: '#app',
  store,
  router,
  template: `
  <transition>
    <router-view></router-view>
  </transition>
  `
})