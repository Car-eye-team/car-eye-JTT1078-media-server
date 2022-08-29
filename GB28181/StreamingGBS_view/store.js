import Vue from "vue";
import Vuex from "vuex";
Vue.use(Vuex);
const store = new Vuex.Store({
  state: {
    baseUrl: '/api',
    serverInfo: {
      LogoText: 'StreamingGBS',
      LogoMiniText: 'GBS',
      versionText: 'V0.0.8-202103231400',
      CopyrightText: ''
    },
    userInfo: null,
    deptOptions: [],
    menus: [],
    buttons: [],
    keepTime: 1.5*60
  },
  mutations: {
    updateUserInfo(state, userInfo) {
      state.userInfo = userInfo;
    },
    updateDeptOptions(state, deptOptions) {
      state.deptOptions = deptOptions;
    },
    setKeepTime(state, value) {
      state.keepTime = value;
    }
  },
  actions: {
    getUserInfo({commit, state}) {
      return new Promise((resolve, reject) => {
        if(!!state.userInfo){
          resolve(state.userInfo);
        }else{
          $.get(state.baseUrl + "/user/getUserInfo").then(ret => {
            if (!ret.data || ret.data == null) {
              window.location.href = `/login.html`;
            }
            state.menus = ret.data.menus;
            state.buttons = ret.data.buttons;
            var userInfo = ret.data.userInfo;
            commit('updateUserInfo', userInfo);
            resolve(userInfo);
          }).fail(() => {
            window.location.href = `/login.html`;
            resolve(null);
          });
        }
      })
    },
    logout({commit, state}) {
      return new Promise((resolve, reject) => {
        $.get(state.baseUrl + "/logout").then(ret => {
          commit('updateUserInfo', null);
          resolve(null);
        }).fail(() => {
          resolve(null);
        })
      })
    },
    getDeptOptions({commit, state}) {
      return new Promise((resolve, reject) => {
        if(state.deptOptions.length>0){
          resolve(state.deptOptions);
        }else{
          $.get(state.baseUrl + "/dept/getSelectTreeDeptList").then(ret => {
            var deptOptions = new Array;
            deptOptions.push(ret.data);
            commit('updateDeptOptions', deptOptions);
            resolve(deptOptions);
          }).fail(() => {
            resolve(null);
          });
        }
      })
    },
    keepLogin({commit, state}) {//保持登录状态
      return new Promise((resolve, reject) => {
        $.get(state.baseUrl + "/keep").then((ret) => {
          resolve(ret);
        });
      })
    },
    setKeepTime(context,value){
      context.commit('setKeepTime',value);
    }
  }
});
export default store;