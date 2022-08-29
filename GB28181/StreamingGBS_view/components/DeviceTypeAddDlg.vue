<template>
    <FormDlg title="添加设备类型" @hide="onHide" @show="onShow" @submit="onSubmit" ref="dlg" :disabled="errors.any()">
        <div :class="{'form-group':true,'has-error': errors.has('typename')}">
            <label for="input-typename" class="col-sm-4 control-label">设备类型名称
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-typename" name="typename" v-model.trim="form.typename" data-vv-as="设备类型名称" v-validate="'required'" @keydown.enter="$el.querySelector('#input-typename').focus()">
            </div>
        </div>
        <div :class="{'form-group': true, 'has-error': errors.has('protocol')}">
            <label for="input-protocol" class="col-sm-4 control-label">协议类型
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <select class="form-control" id="input-protocol" name="protocol" v-model.trim="form.protocol" data-vv-as="协议类型"  v-validate="'required'">
                    <option value="0">GB28181-2011</option>
                    <option value="1">GB28181-2016</option>
                    <option value="2">ONVIF</option>
                    <option value="4">其它</option>
                </select>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('company')}">
            <label for="input-company" class="col-sm-4 control-label">所属厂家
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-company" name="company" v-model.trim="form.company" data-vv-as="所属厂家" @keydown.enter="$el.querySelector('#input-company').focus()">
            </div>
        </div>
        <div :class="{'form-group': true, 'has-error': errors.has('videoFormat')}">
            <label for="input-videoFormat" class="col-sm-4 control-label">视频格式
            </label>
            <div class="col-sm-7">
                <select class="form-control" id="input-videoFormat" name="videoFormat" v-model.trim="form.videoFormat" data-vv-as="视频格式"  v-validate="">
                    <option value="0">H264</option>
                    <option value="1">H265</option>
                </select>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('videoFps')}">
            <label for="input-videoFps" class="col-sm-4 control-label">视频帧率
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-videoFps" name="videoFps" v-model.trim="form.videoFps" data-vv-as="视频帧率" @keydown.enter="$el.querySelector('#input-videoFps').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('videoResolution')}">
            <label for="input-videoResolution" class="col-sm-4 control-label">视频分辨率
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-videoResolution" name="videoResolution" v-model.trim="form.videoResolution" data-vv-as="视频分辨率" @keydown.enter="$el.querySelector('#input-videoResolution').focus()">
            </div>
        </div>
        <div :class="{'form-group': true, 'has-error': errors.has('audioFormat')}">
            <label for="input-audioFormat" class="col-sm-4 control-label">音频格式
            </label>
            <div class="col-sm-7">
                <select class="form-control" id="input-audioFormat" name="audioFormat" v-model.trim="form.audioFormat" data-vv-as="音频格式"  v-validate="">
                    <option value="0">aac</option>
                    <option value="1">G711a</option>
                    <option value="2">G711U</option>
                    <option value="3">G726-16bit</option>
                    <option value="4">G726-24bit</option>
                    <option value="5">G726-32bit</option>
                    <option value="6">G726-40bit</option>
                    <option value="7">G722</option>
                    <option value="8">g729</option>
                    <option value="9">PCMA</option>
                    <option value="10">其它</option>
                </select>
            </div>
        </div>
        <div :class="{'form-group': true, 'has-error': errors.has('audioChannels')}">
            <label for="input-audioChannels" class="col-sm-4 control-label">音频通道
            </label>
            <div class="col-sm-7">
                <select class="form-control" id="input-audioChannels" name="audioChannels" v-model.trim="form.audioChannels" data-vv-as="音频通道"  v-validate="">
                    <option value="0">单通道</option>
                    <option value="1">立体声</option>
                </select>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('audioFreq')}">
            <label for="input-audioFreq" class="col-sm-4 control-label">音频采样频率
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-audioFreq" name="audioFreq" v-model.trim="form.audioFreq" data-vv-as="音频采样频率" @keydown.enter="$el.querySelector('#input-audioFreq').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('audioFormatBits')}">
            <label for="input-audioFormatBits" class="col-sm-4 control-label">音频帧采样位数
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-audioFormatBits" name="audioFormatBits" v-model.trim="form.audioFormatBits" data-vv-as="音频帧采样位数" @keydown.enter="$el.querySelector('#input-audioFormatBits').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('heartbeatTime')}">
            <label for="input-heartbeatTime" class="col-sm-4 control-label">心跳时间(秒)
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-heartbeatTime" name="heartbeatTime" v-model.trim="form.heartbeatTime" data-vv-as="心跳时间(秒)" @keydown.enter="$el.querySelector('#input-heartbeatTime').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('heartbeatTimeOutCount')}">
            <label for="input-heartbeatTimeOutCount" class="col-sm-4 control-label">心跳超时次数
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-heartbeatTimeOutCount" name="heartbeatTimeOutCount" v-model.trim="form.heartbeatTimeOutCount" data-vv-as="心跳超时次数" @keydown.enter="$el.querySelector('#input-heartbeatTimeOutCount').focus()">
            </div>
        </div>
    </FormDlg>
</template>

<script>
import FormDlg from 'components/FormDlg.vue'
import $ from 'jquery'

export default {
    data() {
        return {
            form: this.defForm(),
        }
    },
    components: {
        FormDlg
    },
    methods: {
        defForm() {
            return {
                typename: '',
                protocol: '',
                company: '',
                videoFormat: '',
                videoFps: '',
                videoResolution: '',
                audioFormat: '',
                audioChannels: '',
                audioFreq: '',
                audioFormatBits: '',
                heartbeatTime: 120,
                heartbeatTimeOutCount: 1,
            }
        },
        onHide() {
            this.form = this.defForm();
            this.$emit("hide");
        },
        onShow() {
            this.errors.clear();
            this.$emit("show");
        },
        async onSubmit() {
            var ok = await this.$validator.validateAll();
            if(!ok) {
                var e = this.errors.items[0];
                this.$message({
                    type: 'error',
                    message: e.msg
                })
                $(`[name=${e.field}]`).focus();
                return;
            }
            $.post(this.$store.state.baseUrl + '/deviceType/add', this.form).then(data => {
                if(data.code >= 0){
                    this.$refs['dlg'].hide();
                    this.$emit("submit");
                }else{
                    this.$message({
                        message: data.msg,
                        type: 'warning',
                    });
                    return;
                }
            })
        },
        async show(data) {
            this.errors.clear();
            if(data) {
                Object.assign(this.form, data);
            }
            this.$nextTick(() => {
                this.$refs['dlg'].show();
            })
        }
    }
}
</script>
