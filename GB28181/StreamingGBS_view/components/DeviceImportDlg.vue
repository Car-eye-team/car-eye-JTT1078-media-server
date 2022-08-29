<template>
    <FormDlg title="导入设备" @hide="onHide" @show="onShow" @submit="onSubmit" ref="dlg" :disabled="errors.any()">
        <div class="form-group">
            <label for="input-devicecode" class="col-sm-4 control-label">模板下载
                
            </label>
            <div class="col-sm-7">
                <el-button type="primary" size="small" @click="toDownload"><i class="fa fa-download"></i> 下载导入模板</el-button>
            </div>
        </div>
        <div class="form-group">
            <label for="input-devicename" class="col-sm-4 control-label">上传文件
                
            </label>
            <div class="col-sm-7">
                <el-upload
                class="upload-demo"
                :action="action"
                :data="data"
                :accept="accept"
                :on-preview="handlePreview"
                :on-remove="handleRemove"
                :before-remove="beforeRemove"
                :on-success="handleSuccess"
                :limit="1"
                :on-exceed="handleExceed"
                :file-list="fileList">
                <el-button size="small" type="primary"><i class="fa fa-upload"></i> 点击上传</el-button>
                <div slot="tip" class="el-upload__tip">只能上传xls/xlsx格式文件</div>
                </el-upload>
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
            fileList: [],
            action: this.$store.state.baseUrl + '/upload/vueUploadFilesB64',
            data:{type:1},
            accept: '.xls,.xlsx',
            template: '/templates/设备导入.xlsx'
        }
    },
    components: {
        FormDlg
    },
    methods: {
        defForm() {
            return {
                fileName: ''
            }
        },
        onHide() {
            this.form = this.defForm();
            this.fileList = [];
            this.$emit("hide");
        },
        onShow() {
            this.errors.clear();
            this.$emit("show");
        },
        async onSubmit() {
            if(this.form.fileName == '') {
                this.$message({
                    type: 'error',
                    message: '请先上传文件'
                })
                return;
            }
            $.post(this.$store.state.baseUrl + '/gbInfo/import', this.form).then(data => {
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
        },
        handleRemove(file, fileList) {
            this.form.fileName = '';
        },
        handlePreview(file) {
            console.log(file);
        },
        handleExceed(files, fileList) {
            this.$message.warning(`当前限制选择 1 个文件，请先删除已上传的文件`);
        },
        beforeRemove(file, fileList) {
            return this.$confirm(`确定移除 ${ file.name }？`);
        },
        handleSuccess(response, file, fileList){
            if(response.code >= 0){
                this.form.fileName = response.data.returnPath;
            }else{
                this.$message({
                    message: response.msg,
                    type: 'warning',
                });
                return;
            }
        },
        toDownload(){
            var url2 = this.template;
            window.open(url2);
        }
    }
}
</script>
