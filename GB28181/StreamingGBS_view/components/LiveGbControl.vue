<template>
    <FormDlg title="设备控制" @hide="onHide" @show="onShow" @submit="onSubmit" ref="dlg" :disabled="errors.any()">
        <div :class="{'form-group':true,'has-error': errors.has('depClass')}">
            <div class="col-sm-7">
                <el-radio-group v-model="form.cmd" v-validate="'required'">
                    <el-radio label="0">远程启动</el-radio>
                    <el-radio label="1">录像</el-radio>
                    <el-radio label="2">取消录像</el-radio>
                    <el-radio label="3">布防</el-radio>
                    <el-radio label="4">取消布防</el-radio>
                    <el-radio label="5">报警复位</el-radio>
                </el-radio-group>
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
            form: this.defForm()
        }
    },
    components: {
        FormDlg
    },
    methods: {
        defForm() {
            return {
                //deviceId: '',
                gb_id: '',
                d_gb_id: '',
                cmd: '',
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
            $.post(this.$store.state.baseUrl + '/deviceControl', this.form).then(data => {
                if(data == 'ok'){
                    this.$message({
                        message: '指令发送成功',
                        type: 'success',
                    });
                    this.$refs['dlg'].hide();
                    this.$emit("submit");
                }else{
                    this.$message({
                        message: data,
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

<style scoped>
    .el-radio{
        width: 160px;
        margin-left: 30px;
    }
    .col-sm-7{
        width: 100%;
    }
</style>
