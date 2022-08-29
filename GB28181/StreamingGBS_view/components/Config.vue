<template>
<div class="container-fluid no-padding">
  <section class="content">
    <div class="nav-tabs-custom no-padding">
      <ul class="nav nav-tabs">
        <li class="active"><a href="#base-config" data-toggle="tab">系统参数配置</a></li>
      </ul>
      <div class="tab-content" style="height: calc(100% - 44px);">
        <div class="tab-pane  active" id="base-config">
          <form role="form" class="form-horizontal" autocomplete="off" @submit.prevent="onSubmit">
            <div :class="['form-group' , {'has-error': errors.has('closeDelay')}]">
              <label for="sip-closeDelay" class="col-sm-4 control-label">视频关闭延迟(秒)&nbsp;&nbsp;</label>
              <div class="col-sm-7">
                <input type="text" id="sip-closeDelay" class="form-control" name="closeDelay" data-vv-as="视频关闭延迟" v-validate="'numeric'" v-model.trim="closeDelay">
                <span class="help-block">{{errors.first('closeDelay')}}</span>
              </div>
            </div>
            <div :class="{'form-group': true, 'has-error': errors.has('sessionTimeout')}">
              <label for="input-sessionTimeout" class="col-sm-4 control-label">登录超时(分钟)&nbsp;<span class="text-red">*</span></label>
              <div class="col-sm-7">
                <input type="text" id="sip-sessionTimeout" class="form-control" name="sessionTimeout" data-vv-as="登录超时(分钟)" v-validate="'required|numeric|between:0,999'" v-model.trim="sessionTimeout">
                <span class="help-block">{{errors.first('sessionTimeout')}}</span>
              </div>
            </div>
            <div :class="{'form-group': true, 'has-error': errors.has('videoServerUrl')}">
              <label for="input-videoServerUrl" class="col-sm-4 control-label">视频服务器地址&nbsp;<span class="text-red">*</span></label>
              <div class="col-sm-7">
                <input type="text" id="sip-videoServerUrl" class="form-control" name="videoServerUrl" data-vv-as="视频服务器地址" v-validate="'required'" v-model.trim="videoServerUrl">
                <span class="help-block">{{errors.first('videoServerUrl')}}</span>
              </div>
            </div>
            <div class="form-group mybtn">
              <button type="submit" class="btn btn-primary" :disabled="isBasicNoChange || errors.any() || isBusy">保&nbsp;&nbsp;存</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </section>
</div>
</template>

<script>
import $ from 'jquery'

export default {
  data() {
    return {
      isBusy: false,
      closeDelay: null,
      sessionTimeout: null,
      videoServerUrl: null
    }
  },
  computed: {
    isBasicNoChange() {
      const remoteKeys = Object.keys(this.remoteBasicData || {})
      const localKeys = Object.keys(this.basicCommitObject)
      if (remoteKeys.length !== localKeys.length) {
        return false
      }
      for (let i = 0; i < localKeys.length; i++) {
        if (this.basicCommitObject[localKeys[i]] != this.remoteBasicData[localKeys[i]]) {
          return false
        }
      }
      return true
    },
    basicCommitObject() {
      return {
        closeDelay: this.closeDelay,
        sessionTimeout: this.sessionTimeout,
        videoServerUrl: this.videoServerUrl
      }
    }
  },
  methods: {
    async onSubmit() {
      if (this.isBusy) {
        return
      }
      if (!await this.$validator.validateAll()) {
        const e = this.errors.items[0]
        this.$message.error({
          message: e.msg,
          center: true
        })
        $(`[name=${e.field}]`).focus()
        return
      }
      this.isBusy = true
      try {
        const res = await $.post(this.$store.state.baseUrl + '/sysParamSet/save', this.basicCommitObject)
        if (res && res.data) {
          this.$message.success({
            message: '配置成功',
            center: true
          })
          this.$parent.getSomeParams()
          this.getBaseConfig()
          return
        }
        this.$message.error({
          message: '配置失败',
          center: true
        })
      } catch (e) {
        this.$message.error({
          message: '配置失败',
          center: true
        })
      } finally {
        this.isBusy = false
      }
    },
    async getBaseConfig() {
      try {
        const res = (await $.get(this.$store.state.baseUrl + '/sysParamSet/getParamInfo')).data
        this.closeDelay = res.closeDelay,
        this.sessionTimeout = res.sessionTimeout,
        this.videoServerUrl = res.videoServerUrl,
        this.remoteBasicData = JSON.parse(JSON.stringify(this.basicCommitObject))
      } catch (e) {
        this.remoteBasicData = null
        this.$message.error({
          message: '获取配置信息失败',
          center: true
        })
      }
    }
  },
  mounted() {
    this.getBaseConfig()
  },
  beforeDestroy() {
    delete this.remoteBasicData
  }
};
</script>

<style lang="less" scoped>
  .container-fluid{
    width: 100%;
    height: 100%;
    .content{
      width: 100%;
      height: 100%;
      padding: 0;
      .nav-tabs-custom{
        width: 100%;
        height: 100%;
        margin: 0;
        .tab-pane{
          height: 100%;
          overflow-x: hidden;
          overflow-y: auto;
        }
        .mybtn{
          text-align: center;
        }
      }
    }
  }
  .fa.cfg-black-list, .fa.cfg-white-list {
    font-size: 14px;
    line-height: 19px;
    display: inline-block;
    color: #606266;
  }
</style>
