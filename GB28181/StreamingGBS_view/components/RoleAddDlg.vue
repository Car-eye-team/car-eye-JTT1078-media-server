<template>
    <FormDlg title="添加角色" @hide="onHide" @show="onShow" @submit="onSubmit" ref="dlg" :disabled="errors.any()">
        <div :class="{'form-group':true,'has-error': errors.has('usergroupname')}">
            <label for="input-usergroupname" class="col-sm-4 control-label">角色名称
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-usergroupname" name="usergroupname" v-model.trim="form.usergroupname" data-vv-as="角色名称" v-validate="'required'" @keydown.enter="$el.querySelector('#input-usergroupname').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('usergroupdesc')}">
            <label for="input-usergroupdesc" class="col-sm-4 control-label">角色描述
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-usergroupdesc" name="usergroupdesc" v-model.trim="form.usergroupdesc" placeholder="角色描述" data-vv-as="角色描述" @keydown.enter="$el.querySelector('#input-usergroupdesc').focus()">
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
                usergroupname: '',
                usergroupdesc: '',
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
            $.post(this.$store.state.baseUrl + '/userGroup/add', this.form).then(data => {
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
