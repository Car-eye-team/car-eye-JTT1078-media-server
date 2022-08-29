<template>
    <FormDlg title="添加机构" @hide="onHide" @show="onShow" @submit="onSubmit" ref="dlg" :disabled="errors.any()">
        <div :class="{'form-group':true,'has-error': errors.has('parentname')}">
            <label for="input-parentname" class="col-sm-4 control-label">父级机构
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" readonly="readonly" id="input-parentname" name="parentname" v-model.trim="form.parentname" data-vv-as="父级机构">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('deptname')}">
            <label for="input-deptname" class="col-sm-4 control-label">机构名称
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-deptname" name="deptname" v-model.trim="form.deptname" data-vv-as="机构名称" v-validate="'required'" @keydown.enter="$el.querySelector('#input-deptname').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('gb_id')}">
            <label for="input-code" class="col-sm-4 control-label">机构编码
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-code" name="gb_id" v-model.trim="form.gb_id" placeholder="" data-vv-as="机构编码" v-validate="'required'" @keydown.enter="$el.querySelector('#input-code').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('depClass')}">
            <label for="input-depClass" class="col-sm-4 control-label">机构类别
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <select class="form-control" id="input-depClass" name="depClass" v-model.trim="form.depClass" data-vv-as="机构类别">
                    <option value="0">部门</option>
                    <option value="1">单位</option>
                    <option value="2">其它</option>
                </select>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('contract')}">
            <label for="input-contract" class="col-sm-4 control-label">联系人
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-contract" name="contract" v-model.trim="form.contract" placeholder="" data-vv-as="联系人" @keydown.enter="$el.querySelector('#input-contract').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('tel')}">
            <label for="input-tel" class="col-sm-4 control-label">联系电话
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-tel" name="tel" v-model.trim="form.tel" placeholder="" data-vv-as="联系电话" @keydown.enter="$el.querySelector('#input-tel').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('address')}">
            <label for="input-address" class="col-sm-4 control-label">地址
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-address" name="address" v-model.trim="form.address" placeholder="" data-vv-as="地址" @keydown.enter="$el.querySelector('#input-address').focus()">
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
                parentid: '',
                deptname: '',
                gb_id: '',
                depClass: '',
                contract: '',
                tel: '',
                address: '',
                parentname: ''
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
            $.post(this.$store.state.baseUrl + '/dept/add', this.form).then(data => {
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
