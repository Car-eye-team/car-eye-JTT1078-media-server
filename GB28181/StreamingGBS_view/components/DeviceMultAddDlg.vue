<template>
    <FormDlg title="批量添加设备" @hide="onHide" @show="onShow" @submit="onSubmit" ref="dlg" :disabled="errors.any()">
        <div :class="{'form-group':true,'has-error': errors.has('deptId')}">
            <label for="mult-deptId" class="col-sm-4 control-label">组织机构
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <SelectTree width="100%" class="form-control" id="mult-deptId" name="deptId" data-vv-as="组织机构" v-validate="'required'" v-model.trim="form.deptId" :options="this.$store.state.deptOptions" :props="{parent:'parentid',value:'deptid',label:'deptname',children:'children'}"></SelectTree>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('minDeviceNo')}">
            <label for="mult-minDeviceNo" class="col-sm-4 control-label">设备最小开始值编码
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="mult-minDeviceNo" name="minDeviceNo" v-model.trim="form.minDeviceNo" placeholder="设备最小开始值编码" data-vv-as="设备最小开始值编码" v-validate="'required'" @keydown.enter="$el.querySelector('#mult-minDeviceNo').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('minDeviceChannelNo')}">
            <label for="mult-minDeviceChannelNo" class="col-sm-4 control-label">通道最小开始值编码
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="mult-minDeviceChannelNo" name="minDeviceChannelNo" v-model.trim="form.minDeviceChannelNo" placeholder="通道最小开始值编码" data-vv-as="通道最小开始值编码" v-validate="'required'" @keydown.enter="$el.querySelector('#mult-minDeviceChannelNo').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('generateNumber')}">
            <label for="mult-generateNumber" class="col-sm-4 control-label">生成条数
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="mult-generateNumber" name="generateNumber" v-model.trim="form.generateNumber" placeholder="生成条数" data-vv-as="生成条数" v-validate="'required'" @keydown.enter="$el.querySelector('#mult-generateNumber').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('devicetypeid')}">
            <label for="mult-devicetypeid" class="col-sm-4 control-label">设备类型
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <el-select style="width:100%;" class="form-control" size="medium" id="mult-devicetypeid" name="devicetypeid" data-vv-as="设备类型" v-model.trim="form.devicetypeid" placeholder="请选择" v-validate="'required'">
                    <el-option v-for="item in deviceTypes" :key="item.id" :label="item.name" :value="item.id">
                    </el-option>
                </el-select>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('password')}">
            <label for="mult-password" class="col-sm-4 control-label">接入密码
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="mult-password" name="password" v-model.trim="form.password" placeholder="接入密码" data-vv-as="接入密码" @keydown.enter="$el.querySelector('#mult-password').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('ip')}">
            <label for="mult-ip" class="col-sm-4 control-label">IP地址
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="mult-ip" name="ip" v-model.trim="form.ip" placeholder="IP地址" data-vv-as="IP地址" @keydown.enter="$el.querySelector('#mult-ip').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('port')}">
            <label for="mult-port" class="col-sm-4 control-label">端口
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="mult-port" name="port" v-model.trim="form.port" placeholder="端口" data-vv-as="端口" @keydown.enter="$el.querySelector('#mult-port').focus()">
            </div>
        </div>
    </FormDlg>
</template>
<style lang="less" scoped>
.two-input{
  display: flex;
  align-items: center;
  .form-control{
    width: 45%;
    margin: 0 5px;
    &:last-child{
      margin-right: 0;
    }
  }
}
</style>
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
                deptId: '',
                deviceChannelPrefix: '',
                devicetypeid: '',
                ip: '',
                port: '',
                password: '',
                generateNumber: ''
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
            $.post(this.$store.state.baseUrl + '/deviceInfo/batchGenerate', this.form).then(data => {
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
