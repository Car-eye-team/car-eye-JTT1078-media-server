<template>
    <FormDlg title="编辑设备" @hide="onHide" @show="onShow" @submit="onSubmit" ref="dlg" :disabled="errors.any()">
        <div :class="{'form-group':true,'has-error': errors.has('gb_id')}">
            <label for="input-devicecode" class="col-sm-4 control-label">设备编码
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-devicecode" name="gb_id" v-model.trim="form.gb_id" data-vv-as="设备编码" v-validate="'required'" @keydown.enter="$el.querySelector('#input-devicecode').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('devicename')}">
            <label for="input-devicename" class="col-sm-4 control-label">设备名称
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-devicename" name="devicename" v-model.trim="form.devicename" data-vv-as="设备名称" v-validate="'required'" @keydown.enter="$el.querySelector('#input-devicename').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('deptid')}">
            <label for="input-deptid" class="col-sm-4 control-label">组织机构
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <SelectTree width="100%" class="form-control" id="input-deptid" name="deptid" data-vv-as="组织机构" v-validate="'required'" v-model.trim="form.deptid" :options="this.$store.state.deptOptions" :props="{parent:'parentid',value:'deptid',label:'deptname',children:'children'}"></SelectTree>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('devicetypeid')}">
            <label for="input-devicetypeid" class="col-sm-4 control-label">设备类型
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <el-select style="width:100%;" class="form-control" size="medium" v-model.trim="form.devicetypeid" placeholder="请选择" id="input-devicetypeid" name="devicetypeid" data-vv-as="设备类型" v-validate="'required'">
                    <el-option v-for="item in deviceTypes" :key="item.id" :label="item.name" :value="item.id">
                    </el-option>
                </el-select>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('password')}">
            <label for="input-password" class="col-sm-4 control-label">接入密码
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-password" name="password" v-model.trim="form.password" placeholder="接入密码" data-vv-as="接入密码" @keydown.enter="$el.querySelector('#input-password').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('ip')}">
            <label for="input-ip" class="col-sm-4 control-label">IP地址
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-ip" name="ip" v-model.trim="form.ip" placeholder="IP地址" data-vv-as="IP地址" @keydown.enter="$el.querySelector('#input-ip').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('port')}">
            <label for="input-port" class="col-sm-4 control-label">端口
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-port" name="port" v-model.trim="form.port" placeholder="端口" data-vv-as="端口" @keydown.enter="$el.querySelector('#input-port').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('installTimeStr')}">
            <label for="input-installTimeStr" class="col-sm-4 control-label">安装时间
            </label>
            <div class="col-sm-7">
                <el-date-picker style="width:100%" class="form-control" id="input-installTimeStr" name="installTimeStr" v-model.trim="form.installTimeStr" data-vv-as="安装时间" type="date" placeholder="选择日期" value-format="yyyy-MM-dd"></el-date-picker>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('location')}">
            <label for="input-location" class="col-sm-4 control-label">安装位置
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-location" name="location" v-model.trim="form.location" placeholder="详细地址" data-vv-as="安装位置" @keydown.enter="$el.querySelector('#input-location').focus()">
            </div>
        </div>
        
        
    </FormDlg>
</template>

<script>
import FormDlg from 'components/FormDlg.vue'
import $ from 'jquery'
import SelectTree from 'components/SelectTree.vue'

export default {
    data() {
        return {
            form: this.defForm(),
            deviceTypes: [],
        }
    },
    components: {
        FormDlg,SelectTree
    },
    methods: {
        defForm() {
            return {
                id: '',
                deptid: '',
                gb_id: '',
                devicename: '',
                channels: '',
                devicetypeid: '',
                ip: '',
                port: '',
                password: '',
                installTimeStr: '',
                location: '',
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
        fetchDeviceTypeList() {
            return new Promise((resolve, reject) => {
                $.get(this.$store.state.baseUrl + "/deviceType/getSelectDeviceTypeList").then(ret => {
                    resolve(ret.data.map(sms => ({
                        id: sms.id||"",
                        name: sms.typename||"",
                    })));
                }).fail(() => {
                    resolve([]);
                })
            })
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
            $.post(this.$store.state.baseUrl + '/deviceInfo/edit', this.form).then(data => {
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
            this.deviceTypes = await this.fetchDeviceTypeList();
            this.$nextTick(() => {
                this.$refs['dlg'].show();
            })
        }
    }
}
</script>
