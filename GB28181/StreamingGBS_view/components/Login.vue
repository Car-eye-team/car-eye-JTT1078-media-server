<template>
    <div class="login-box">
    <div class="row header-space">
    </div>
    <div class="login-container">
        <div id="login-panel" :class="['panel', 'panel-primary', {'visible': showPanel == 'login'}]">
            <div class="panel-heading text-center">
                <h3><b>{{serverInfo.LogoText}} <small v-if="serverInfo.IsDemo" style="color:#fff;"><sup><sup>演示</sup></sup></small></b> - 登录</h3>
            </div>
            <div class="panel-body">
                <br>
                <form autocomplete="off" id="login-form">
                    <div :class="{'form-group':true, 'has-feedback':true,'has-error': errors.has('username')}">
                        <input type="text" class="form-control" :placeholder="usernamePlaceholder" v-validate="'required'" data-vv-as="用户名" name="username" v-model.trim="username" @keydown.enter="$el.querySelector('#login-form [name=password]').focus()">
                        <span class="glyphicon glyphicon-user form-control-feedback text-gray"></span>
                    </div>
                    <div :class="{'form-group':true, 'has-feedback':true,'has-error': errors.has('password')}">
                        <input type="password" class="form-control" :placeholder="passwordPlaceholder" autocomplete="new-password" v-validate="'required'" data-vv-as="密码" name="password" v-model.trim="password" @keydown.enter="$el.querySelector('#login-form [name=checkCode]').focus()">
                        <span class="glyphicon glyphicon-lock form-control-feedback text-gray"></span>
                    </div>
                    <div :class="{'form-group':true, 'has-feedback':true,'has-error': errors.has('checkCode')}">
                        <input type="text" class="form-checkcode" style="width:60%;" :placeholder="checkCodePlaceholder" v-validate="'required'" data-vv-as="验证码" name="checkCode" v-model.trim="checkCode" @keydown.enter="doLogin">
                        <img id="identifyingValue" style="position: absolute;width:40%;height:34px;" @click="changeImg()"><!-- 内部自动发送请求，加载验证码 -->
                    </div>
                    <div class="row">
                        <div class="col-xs-4">
                            <a class="text-primary" role="button" @click="showPanel = 'forgot'">忘记密码?</a>
                        </div>
                        <div class="col-xs-offset-4 col-xs-4">
                            <button id="btn-login" type="button" class="btn btn-primary btn-block btn-flat" @click.prevent="doLogin" :disabled="isLoading">登&nbsp;&nbsp;录</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div id="forgot-panel" :class="['panel', 'panel-danger', {'visible': showPanel == 'forgot'}]">
            <div class="panel-heading">
                <p class="panel-title text-left"><i class="fa fa-key"></i> 提示</p>
            </div>
            <div class="panel-body text-center">
                <small>请联系运营人员重置您的密码。</small>
            </div>

            <div class="panel-footer text-center">
                <a class="text-primary" role="button" @click="showPanel = 'login'">返回登录</a>
            </div>
        </div>

    </div>
    </div>
</template>

<script>
import "font-awesome/css/font-awesome.css";
import "bootstrap/dist/css/bootstrap.css";
import "admin-lte/dist/css/AdminLTE.css";
import "admin-lte/dist/css/skins/_all-skins.css";
import "assets/styles/custom.less";

import "bootstrap/dist/js/bootstrap.js";
import "admin-lte/dist/js/adminlte.js";

import Vue from "vue";
import { mapState } from "vuex";

import VeeValidate, { Validator } from "vee-validate";
import zh_CN from "vee-validate/dist/locale/zh_CN";
Validator.localize("zh_CN", zh_CN);
Vue.use(VeeValidate, {
  locale: "zh_CN",
  delay: 500,
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

import ElementUI from "element-ui";
import "assets/styles/element-custom.scss";
Vue.use(ElementUI);

import crypto from "crypto";
import url from "url";
import $ from "jquery";
$.ajaxSetup({ cache: false });
export default {
  data() {
    return {
      isLoading: false,
      showPanel: "login",
      username: "",
      password: "",
      checkCode: "",
      demoUser: "",
      usernamePlaceholder: "用户名",
      passwordPlaceholder: "密码",
      checkCodePlaceholder: "验证码"
    };
  },
  computed: {
    ...mapState(["serverInfo"])
  },
  async mounted() {
    this.changeImg();
    document.title = this.serverInfo.LogoText;
    this.$el.querySelector("#login-form [name=username]").focus();
  },
  methods: {
    md5(text) {
      return crypto
        .createHash("md5")
        .update(text, "utf8")
        .digest("hex")
        .toUpperCase();
    },
    changeImg(){
      document.getElementById("identifyingValue").src=this.$store.state.baseUrl + "/check?"+Math.random();
    },
    async doLogin() {
      var ok = await this.$validator.validateAll();
      if (!ok) {
        var e = this.errors.items[0];
        this.$message({
          type: "error",
          message: e.msg
        });
        document.querySelector(`[name=${e.field}]`).focus();
        return;
      }
      this.isLoading = true;
      $.post(this.$store.state.baseUrl + "/login", {
        loginname: this.username,
        password: this.md5(this.password),
        checkCode: this.checkCode
      }).then(data => {
        if(data.code >= 0){
          var _url = url.parse(window.location.href, true);
          window.location.href = _url.query.r || "/";
        }else{
          this.$message({
            message: data.msg,
            type: 'warning',
          });
          this.changeImg();
          return;
        }
      }).always(() => {
        this.isLoading = false;
      });
    }
  }
};
</script>

<style lang="less">
@import url(~assets/styles/variables.less);

.light-login {
  background: #dfe0e2 url(~assets/images/pattern.jpg) repeat;
}
.header-space {
  margin: 60px 0;
}

.login-container {
  margin: 0 auto;
  width: 340px;
}

.panel {
  position: fixed;
  visibility: hidden;
  z-index: auto;

  -moz-transform: scale(0, 1) translate(-150px);
  -webkit-transform: scale(0, 1) translate(-150px);
  -o-transform: scale(0, 1) translate(-150px);
  -ms-transform: scale(0, 1) translate(-150px);
  transform: scale(0, 1) translate(-150px);
}

.panel-primary {
  border-color: @base;
}

.panel-primary > .panel-heading {
    color: #fff;
    background-color: @base;
    border-color: @base;
}

.panel.visible {
  visibility: visible;
  position: relative;

  -moz-transform: scale(1, 1) translate(0);
  -webkit-transform: scale(1, 1) translate(0);
  -o-transform: scale(1, 1) translate(0);
  -ms-transform: scale(1, 1) translate(0);
  transform: scale(1, 1) translate(0);

  transition: transform 0.3s ease;
  -moz-transition: -moz-transform 0.3s ease;
  -webkit-transition: -webkit-transform 0.3s ease;
  -o-transition: -o-transform 0.2s ease;
}

</style>

<style lang="less" scoped>
  .form-checkcode{
    height: 34px;
    padding: 6px 12px;
    font-size: 14px;
    line-height: 1.42857143;
    color: #555;
    background-color: #fff;
    background-image: none;
    border: 1px solid #ccc;
  }
</style>

