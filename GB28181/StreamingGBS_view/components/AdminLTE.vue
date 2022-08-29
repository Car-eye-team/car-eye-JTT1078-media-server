<template>
  <div class="wrapper">
    <NaviBar :logoText="serverInfo.LogoText" :logoMiniText="serverInfo.LogoMiniText" :versionText="versionText" @modify-password="$refs['modify-password-dlg'].show()"></NaviBar>
    <Sider :menus="menus"></Sider>
    <ModifyPasswordDlg ref="modify-password-dlg"></ModifyPasswordDlg>
    <div class="content-wrapper">
      <section class="content">
        <router-view @play="play"></router-view>
      </section>
    </div>
    <back-to-top text="返回顶部" class="hidden-xs"></back-to-top>
    <resize-observer @notify="handleResize"/>
  </div>
</template>

<script>
import "font-awesome/css/font-awesome.css"
import "bootstrap/dist/css/bootstrap.css"
import "admin-lte/dist/css/AdminLTE.css"
import "admin-lte/dist/css/skins/_all-skins.css"
import "assets/styles/custom.less"
import 'vue-resize/dist/vue-resize.css'

import "bootstrap/dist/js/bootstrap.js"
import "admin-lte/dist/js/adminlte.js"


import { mapState, mapActions } from "vuex"
import Vue from 'vue'
import moment from 'moment'
import Sider from 'components/Sider.vue'
import NaviBar from 'components/NaviBar.vue'
import ModifyPasswordDlg from 'components/ModifyPasswordDlg.vue'

import ElementUI from "element-ui"
import 'assets/styles/element-custom.scss'
Vue.use(ElementUI);

import VueClipboards from 'vue-clipboards';
Vue.use(VueClipboards);

import fullscreen from 'vue-fullscreen'
Vue.use(fullscreen);

import BackToTop from 'vue-backtotop'
Vue.use(BackToTop);

import VueResize from 'vue-resize'
Vue.use(VueResize);

import VeeValidate, { Validator } from "vee-validate";
Vue.use(VeeValidate, {
  fieldsBagName: 'veeFields'
});
import zh_CN from "vee-validate/dist/locale/zh_CN";
Validator.localize("zh_CN", zh_CN);
Vue.use(VeeValidate, {
  locale: "zh_CN",
  // delay: 500,
  dictionary: {
    zh_CN: {
      messages: {
        required: field => `${field} 不能为空`,
        confirmed: (field, targetField) => `${field} 和 ${targetField} 不匹配`,
        regex: field => `${field} 不符合要求格式`
      }
    }
  }
});
Vue.prototype.$updateQueryString = (uri, key, value) => {
    var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
    var separator = uri.indexOf('?') !== -1 ? "&" : "?";
    if (uri.match(re)) {
        return uri.replace(re, '$1' + key + "=" + value + '$2');
    } else {
        return uri + separator + key + "=" + value;
    }
}
Vue.prototype.$iframe = (link, w, h) => {
    var _link = Vue.prototype.$updateQueryString(link, "aspect", `${w}x${h}`)
    return `<iframe src="${_link}" width="${w}" height="${h}" allowfullscreen allow="autoplay; fullscreen"></iframe>`
}
Vue.prototype.isMobile = () => {
  return videojs.browser.IS_IOS || videojs.browser.IS_ANDROID;
}
Vue.prototype.isIE = () => {
  return !!videojs.browser.IE_VERSION;
}
Vue.prototype.flvSupported = () => {
  return videojs.browser.IE_VERSION || (flvjs.getFeatureList() && flvjs.getFeatureList().mseLiveFlvPlayback);
}
Vue.prototype.canTalk = () => {
  return location.protocol.indexOf("https") == 0 || location.hostname === 'localhost' || location.hostname === '127.0.0.1';
}
Vue.prototype.hasAnyRole = (buttons, userInfo, buttonid) => {
    if (!userInfo) {
        return true;
    }
    var checked = false;
    for(var idx in buttons) {
        if (buttons[idx] == buttonid) {
            checked = true;
            break;
        }
    }
    return checked;
}
Vue.prototype.isDemoUser = (serverInfo, userInfo) => {
  if (serverInfo && userInfo && serverInfo.IsDemo && userInfo.Name == serverInfo.DemoUser) return true;
  return false;
}
Vue.prototype.pageBtnNum = Vue.prototype.isMobile()?3:5;//分页栏显示的数量
Vue.prototype.formatTime = (date, fmt)=>{//时间格式过滤器
  if(!date){
    return "";
  }
	date = new Date(date);
	// 返回处理后的值
	if (/(y+)/.test(fmt)) {
		fmt = fmt.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length))
	}
	let o = {
		'M+': date.getMonth() + 1,
		'd+': date.getDate(),
		'h+': date.getHours(),
		'H+': date.getHours(),
		'm+': date.getMinutes(),
		's+': date.getSeconds()
	}
	for (let k in o) {
		if (new RegExp(`(${k})`).test(fmt)) {
			let str = o[k] + ''
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? str : ('00' + str).substr(str.length))
		}
	}
	return fmt
}
import $ from "jquery"
import "@penggy/jquery.nicescroll"

import 'assets/css/base.css'

$.ajaxSetup({ 
  cache: false,
  complete: function(xhr,status) {
    if(status=="success"&&xhr.status==200&&xhr.responseJSON){
      switch(xhr.responseJSON.code){
        case(2000):
          window.location.href = `/login.html`;
          break;
      }
    }
  }
});
export default {
  data() {
    return {
      nice: null,
    }
  },
  watch: {
    serverInfo(val) {
      if (val) {
       document.title = val.LogoText || "StreamingGBS";
      }
    }
  },
  mounted() {
    this.getDeptOptions();
    this.$nextTick(() => {
      $("body").layout("fix");
      this.fixHover();
      this.handleResize();
    });
    $("body").addClass(localStorage["sidebar-collapse"]);
    //验证浏览器无操作
    this.validNoOperation();
    this.getSomeParams();
  },
  components: {
    NaviBar, Sider, ModifyPasswordDlg
  },
  computed: {
    ...mapState([
      "menus",
      "userInfo",
      "serverInfo",
    ]),
    versionText(){
      var text = "";
      if(this.serverInfo){
        text = this.serverInfo.Server || ""
      }
      var matchs = text.match(/streamingGBS\/(.+?)\s/i);
      if(matchs) {
        return matchs[1];
      }
      return ""
    }
  },
  methods: {
    ...mapActions([
      "getDeptOptions","keepLogin","setKeepTime"
    ]),
    getSomeParams(){
      let self = this;
      $.get(self.$store.state.baseUrl + "/keep", {}).then(ret => {
        if(ret.code==0){
          let keep = self.$store.state.keepTime;
          if(ret.data){
            if(ret.data.timeout){
              ret.data.timeout = ret.data.timeout-60; 
              self.setKeepTime(ret.data.timeout);
              keep = ret.data.timeout;
            }
          }
          let keepTime = keep*1000+new Date().getTime();
          window.addEventListener("click", function(){
            if(new Date().getTime()>=keepTime){
              self.keepLogin().then(res=>{
                keepTime = keep*1000+new Date().getTime();
              });
            }
          });
        }
      })
    },
    fixHover() {
        if(videojs.browser.IS_IOS||videojs.browser.IS_ANDROID) {
            for(var sheetI = document.styleSheets.length - 1; sheetI >= 0; sheetI--) {
                var sheet = document.styleSheets[sheetI];
                if(sheet.cssRules) {
                    for(var ruleI = sheet.cssRules.length - 1; ruleI >= 0; ruleI--) {
                        var rule = sheet.cssRules[ruleI];
                        if(rule.selectorText) {
                            rule.selectorText = rule.selectorText.replace(":hover", ":active");
                            rule.selectorText = rule.selectorText.replace(":focus", ":active");
                        }
                    }
                }
            }
        }
    },
    handleResize() {
      $(".content-wrapper").css("height",$(".content-wrapper").css("min-height"));
    },
    play(video){
    },
    thisYear() {
      return moment().format('YYYY');
    },
    validNoOperation(){
      var showTime = 60 * 3;
			var time = showTime;
			$(document).on('click', function() {
				time = showTime;
			});
			var interCount = setInterval(function() {
				time--;
				if(time == 0) {
					clearInterval(interCount);
					window.location.href = "/#/logout";
				}
      }, 10000)
    }
  },
  beforeRouteUpdate(to, from, next) {
    $('.modal').modal('hide') // closes all active pop ups.
    next();
  }
}
</script>

<style lang="less" scoped>
.wrapper{
  height: 100%;
  overflow: hidden;
}
.content-wrapper{
  height: 100%;
  overflow: hidden;
  -webkit-overflow-scrolling: touch;
}
.content-wrapper .content{
  box-sizing: border-box;
  height: 100%;
  overflow: auto;

}





.content-wrapper, .right-side, .main-footer {
  transition: none;
}
</style>

<style lang="less">
.vue-back-to-top {
  background-color: transparent;
  left: 30px;
  bottom: 10px;
}
.sidebar-collapse .vue-back-to-top {
  display: none;
}
.sidebar-collapse .main-sidebar .sidebar .el-menu-item span,
 .sidebar-collapse .main-sidebar .sidebar .el-submenu span {
  display: none;
}
.sidebar-collapse .main-sidebar .sidebar .el-submenu .el-submenu__icon-arrow{
  right: 2px;
}
.sidebar-collapse .main-sidebar .sidebar .el-submenu .el-menu-item{
  padding-left: 30px !important;
}
</style>


