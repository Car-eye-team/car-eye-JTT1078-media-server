<template>
    <FormDlg title="设置权限" @hide="onHide" @show="onShow" @submit="onSubmit" ref="dlg" :disabled="errors.any()">
        <el-tree class="mytree" :style="treeHeight"
        ref="permissionTree"
        :data="menuTree"
        show-checkbox
        node-key="id"
        @node-expand="treeEvent" 
        @node-collapse="treeEvent" 
        :default-expanded-keys="expandedKeys"
        :default-checked-keys="expandedKeys"
        :props="defaultProps">
        </el-tree>
                
    </FormDlg>
</template>
<style scoped>
 .mytree{
    /* overflow: auto; */
 }
</style>
<script>
import FormDlg from 'components/FormDlg.vue'
import $ from 'jquery'

export default {
    data() {
        return {
            treeHeight: "",
            form: this.defForm(),
            menuTree: [],
            defaultProps: {
             children: 'children',
             label: 'label'
            },
            expandedKeys: [],
        }
    },
    components: {
        FormDlg
    },
    methods: {
        treeEvent(){
            this.$children[0].heightchange();
        },
        defForm() {
            return {
                usergroupid: '',
                selectAllMenuids: [],
                halfMenuids: []
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
        initPreMenuTree(){
            this.form.parentmenuid = '';
            $.get(this.$store.state.baseUrl + "/userGroup/preAuthMenu",{
                    usergroupid: this.form.usergroupid
                }).then(ret => {
                    this.menuTree = ret.data.menuTree;
                    this.expandedKeys = ret.data.expandedKeys;
                }).fail(() => {
                    resolve([]);
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
            this.form.selectAllMenuids = this.$refs.permissionTree.getCheckedKeys().join(',');
            this.form.halfMenuids = this.$refs.permissionTree.getHalfCheckedKeys().join(',');

            $.post(this.$store.state.baseUrl + '/userGroup/setAuthMenu', this.form).then(data => {
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
            this.initPreMenuTree();
            this.$nextTick(() => {
                this.$refs['dlg'].show();
            })
        }
    }
}
</script>
