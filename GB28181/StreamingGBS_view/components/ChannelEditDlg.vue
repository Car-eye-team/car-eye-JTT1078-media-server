<template>
    <FormDlg title="编辑通道" @hide="onHide" @show="onShow" @submit="onSubmit" ref="dlg" :disabled="errors.any()">
        <div :class="{'form-group':true,'has-error': errors.has('gb_id')}">
            <label for="input-channelcode" class="col-sm-4 control-label">通道编码
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-channelcode" name="gb_id" v-model.trim="form.gb_id" data-vv-as="通道编码" v-validate="'required'" @keydown.enter="$el.querySelector('#input-channelcode').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('channelname')}">
            <label for="input-channelname" class="col-sm-4 control-label">通道名称
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-channelname" name="channelname" v-model.trim="form.channelname" data-vv-as="通道名称" v-validate="'required'" @keydown.enter="$el.querySelector('#input-channelname').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('type')}">
            <label for="input-type" class="col-sm-4 control-label">通道类型
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <select class="form-control" id="input-type" name="type" v-model.trim="form.type" data-vv-as="通道类型" v-validate="'required'">
                    <option value="0">视频通道</option>
                    <option value="1">语音输出通道</option>
                    <option value="2">报警通道</option>
                    <option value="3">语音输入通道</option>
                    <option value="4">其他</option>
                </select>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('ptzEnable')}">
            <label for="input-ptzEnable" class="col-sm-4 control-label">是否支持云台
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <select class="form-control" id="input-ptzEnable" name="ptzEnable" v-model.trim="form.ptzEnable" data-vv-as="是否支持云台" v-validate="'required'">
                    <option value="1">支持</option>
                    <option value="0">不支持</option>
                </select>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('talkEnbale')}">
            <label for="input-talkEnbale" class="col-sm-4 control-label">是否支持对讲
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <select class="form-control" id="input-talkEnbale" name="talkEnbale" v-model.trim="form.talkEnbale" data-vv-as="是否支持对讲" v-validate="'required'">
                    <option value="1">支持</option>
                    <option value="0">不支持</option>
                </select>
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
            smsList: [],
        }
    },
    components: {
        FormDlg
    },
    methods: {
        defForm() {
            return {
                id: '',
                deviceid: '',
                gb_id: '',
                channelname: '',
                ptzEnable: '',
                talkEnbale: '',
                type: ''
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
            $.post(this.$store.state.baseUrl + '/deviceChannelInfo/edit', this.form).then(data => {
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
