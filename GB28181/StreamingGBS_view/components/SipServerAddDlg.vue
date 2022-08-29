<template>
    <FormDlg title="添加上级平台" @hide="onHide" @show="onShow" @submit="onSubmit" ref="dlg" :disabled="errors.any()" size="modal-lgg">
        <div class="col-sm-6">
            <div :class="{'form-group':true,'has-error': errors.has('name')}">
                <label for="input-name" class="col-sm-4 control-label">名称
                    <span class="text-red">*</span>
                </label>
                <div class="col-sm-7">
                    <input type="text" class="form-control" id="input-name" name="name" v-model.trim="form.name" data-vv-as="名称" v-validate="'required'" @keydown.enter="$el.querySelector('#input-name').focus()">
                </div>
            </div>
            <div :class="{'form-group':true,'has-error': errors.has('code')}">
                <label for="input-code" class="col-sm-4 control-label">国标编码
                    <span class="text-red">*</span>
                </label>
                <div class="col-sm-7">
                    <input type="text" class="form-control" id="input-code" name="code" v-model.trim="form.code" data-vv-as="国标编码" v-validate="'required'" @keydown.enter="$el.querySelector('#input-code').focus()">
                </div>
            </div>
            <div :class="{'form-group':true,'has-error': errors.has('domain')}">
                <label for="input-domain" class="col-sm-4 control-label">服务器域名
                    <span class="text-red">*</span>
                </label>
                <div class="col-sm-7">
                    <input type="text" class="form-control" id="input-domain" name="domain" v-model.trim="form.domain" data-vv-as="服务器域名" @keydown.enter="$el.querySelector('#input-domain').focus()">
                </div>
            </div>
            <div :class="{'form-group':true,'has-error': errors.has('ip')}">
                <label for="input-ip" class="col-sm-4 control-label">服务器IP
                    <span class="text-red">*</span>
                </label>
                <div class="col-sm-7">
                    <input type="text" class="form-control" id="input-ip" name="ip" v-model.trim="form.ip" data-vv-as="服务器IP" @keydown.enter="$el.querySelector('#input-ip').focus()">
                </div>
            </div>
            <div :class="{'form-group':true,'has-error': errors.has('port')}">
                <label for="input-port" class="col-sm-4 control-label">服务器端口
                    <span class="text-red">*</span>
                </label>
                <div class="col-sm-7">
                    <input type="text" class="form-control" id="input-port" name="port" v-model.trim="form.port" data-vv-as="服务器端口" @keydown.enter="$el.querySelector('#input-port').focus()">
                </div>
            </div>
            <div :class="{'form-group':true,'has-error': errors.has('user')}">
                <label for="input-user" class="col-sm-4 control-label">用户名
                    <span class="text-red">*</span>
                </label>
                <div class="col-sm-7">
                    <input type="text" class="form-control" id="input-user" name="user" v-model.trim="form.user" data-vv-as="用户名" @keydown.enter="$el.querySelector('#input-user').focus()">
                </div>
            </div>
            <div :class="{'form-group':true,'has-error': errors.has('password')}">
                <label for="input-password" class="col-sm-4 control-label">密码
                </label>
                <div class="col-sm-7">
                    <input type="text" class="form-control" id="input-password" name="password" v-model.trim="form.password" placeholder="密码" data-vv-as="密码" @keydown.enter="$el.querySelector('#input-password').focus()">
                </div>
            </div>
        </div>

        <div class="col-sm-6">
            <div :class="{'form-group':true,'has-error': errors.has('registerPeroid')}">
                <label for="input-registerPeroid" class="col-sm-4 control-label">注册周期(秒)
                </label>
                <div class="col-sm-7">
                    <input type="number" class="form-control" id="input-registerPeroid" name="registerPeroid" v-model.trim="form.registerPeroid" placeholder="注册周期(秒)" data-vv-as="注册周期(秒)" @keydown.enter="$el.querySelector('#input-registerPeroid').focus()">
                </div>
            </div>
            <div :class="{'form-group':true,'has-error': errors.has('heartPeroid')}">
                <label for="input-heartPeroid" class="col-sm-4 control-label">心跳周期(秒)
                </label>
                <div class="col-sm-7">
                    <input type="number" class="form-control" id="input-heartPeroid" name="heartPeroid" v-model.trim="form.heartPeroid" placeholder="心跳周期(秒)" data-vv-as="心跳周期(秒)" @keydown.enter="$el.querySelector('#input-heartPeroid').focus()">
                </div>
            </div>
            <div :class="{'form-group':true,'has-error': errors.has('gourpSize')}">
                <label for="input-gourpSize" class="col-sm-4 control-label">目录分组大小
                </label>
                <div class="col-sm-7">
                    <input type="number" class="form-control" id="input-gourpSize" name="gourpSize" v-model.trim="form.gourpSize" placeholder="目录分组大小" data-vv-as="目录分组大小" @keydown.enter="$el.querySelector('#input-gourpSize').focus()">
                </div>
            </div>
            <div :class="{'form-group': true, 'has-error': errors.has('transProtocol')}">
                <label for="input-transProtocol" class="col-sm-4 control-label">传输协议
                    <span class="text-red">*</span>
                </label>
                <div class="col-sm-7">
                    <select class="form-control" id="input-transProtocol" name="transProtocol" v-model.trim="form.transProtocol" data-vv-as="传输协议">
                        <option value="0">UDP</option>
                        <option value="1">TCP</option>
                    </select>
                </div>
            </div>
            <div :class="{'form-group': true, 'has-error': errors.has('codeSet')}">
                <label for="input-codeSet" class="col-sm-4 control-label">字符集
                    <span class="text-red">*</span>
                </label>
                <div class="col-sm-7">
                    <select class="form-control" id="input-codeSet" name="codeSet" v-model.trim="form.codeSet" data-vv-as="字符集">
                        <option value="0">GB2312</option>
                        <option value="1">UTF-8</option>
                    </select>
                </div>
            </div>
            <div :class="{'form-group': true, 'has-error': errors.has('active')}">
                <label for="input-active" class="col-sm-4 control-label">是否启用
                    <span class="text-red">*</span>
                </label>
                <div class="col-sm-7">
                    <select class="form-control" id="input-active" name="active" v-model.trim="form.active" data-vv-as="是否启用">
                        <option value="1">启用</option>
                        <option value="0">未启用</option>
                    </select>
                </div>
            </div>
            <div :class="{'form-group': true, 'has-error': errors.has('rtcp')}">
                <label for="input-rtcp" class="col-sm-4 control-label">是否启用RTCP
                    <span class="text-red">*</span>
                </label>
                <div class="col-sm-7">
                    <select class="form-control" id="input-rtcp" name="rtcp" v-model.trim="form.rtcp" data-vv-as="是否启用RTCP">
                        <option value="1">启用</option>
                        <option value="0">未启用</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="clearfix"></div>
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
                name: '',
                code: '',
                domain: '',
                ip: '',
                port: '',
                user: '',
                password: '',
                registerPeroid: '300',
                heartPeroid: '60',
                gourpSize: '1',
                transProtocol: '0',
                codeSet: '0',
                active: '0',
                rtcp: '0',
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
            $.post(this.$store.state.baseUrl + '/sipServer/add', this.form).then(data => {
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

<style lang="less" scoped>
.model-lg {
    width: 80% !important;
}
</style>