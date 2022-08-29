<template>
    <FormDlg title="添加菜单" @hide="onHide" @show="onShow" @submit="onSubmit" ref="dlg" :disabled="errors.any()">
        <div :class="{'form-group':true,'has-error': errors.has('menuname')}">
            <label for="input-menuname" class="col-sm-4 control-label">菜单名称
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-menuname" name="menuname" v-model.trim="form.menuname" placeholder="菜单名称" data-vv-as="菜单名称" @keydown.enter="$el.querySelector('#input-menuname').focus()" v-validate="'required'">
            </div>
        </div>
        <div :class="{'form-group': true, 'has-error': errors.has('menulevel')}">
            <label for="input-menulevel" class="col-sm-4 control-label">菜单级别
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <select class="form-control" id="input-menulevel" name="menulevel" v-model.trim="form.menulevel" data-vv-as="菜单级别"  v-validate="'required'" @change="getParentMenuList(form.menulevel)">
                    <option value="1">一级</option>
                    <option value="2">二级</option>
                    <option value="3">三级</option>
                </select>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('parentmenuid')}">
            <label for="input-parentmenuid" class="col-sm-4 control-label">父级菜单
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <SelectTree width="100%" class="form-control" id="input-parentmenuid" name="parentmenuid" v-model.trim="form.parentmenuid" :options="parentMenus" :props="{parent:'parentid',value:'menuid',label:'menuname',children:'children'}" v-validate="'required'"></SelectTree>
            </div>
        </div>
        <div :class="{'form-group': true, 'has-error': errors.has('menutype')}">
            <label for="input-menutype" class="col-sm-4 control-label">菜单类型
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <select class="form-control" id="input-menutype" name="menutype" v-model.trim="form.menutype" data-vv-as="菜单类型"  v-validate="'required'">
                    <option value="0">菜单</option>
                    <option value="1">按钮</option>
                </select>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('menuaddr')}">
            <label for="input-menuaddr" class="col-sm-4 control-label">菜单地址
                
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-menuaddr" name="menuaddr" v-model.trim="form.menuaddr" data-vv-as="菜单地址" @keydown.enter="$el.querySelector('#input-menuaddr').focus()">
            </div>
        </div>
        <div :class="{'form-group': true, 'has-error': errors.has('displaytype')}">
            <label for="input-displaytype" class="col-sm-4 control-label">是否显示
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <select class="form-control" id="input-displaytype" name="displaytype" v-model.trim="form.displaytype" data-vv-as="是否显示"  v-validate="'required'">
                    <option value="1">显示</option>
                    <option value="0">隐藏</option>
                </select>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('menusort')}">
            <label for="input-menusort" class="col-sm-4 control-label">排序号
                
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-menusort" name="menusort" v-model.trim="form.menusort" data-vv-as="排序号" @keydown.enter="$el.querySelector('#input-menusort').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('imgurl')}">
            <label for="input-imgurl" class="col-sm-4 control-label">图标代码
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-imgurl" name="imgurl" v-model.trim="form.imgurl" placeholder="font-awesome图标代码" data-vv-as="图标代码" @keydown.enter="$el.querySelector('#input-imgurl').focus()">
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
            parentMenus: [{menuid:'-1', menuname: '无',parentid: '', children: []}]
        }
    },
    components: {
        FormDlg,SelectTree
    },
    methods: {
        defForm() {
            return {
                menuname: '',
                menulevel: '',
                parentmenuid: '',
                menutype: '',
                menuaddr: '',
                displaytype: '',
                menusort: '',
                imgurl: '',
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
        getParentMenuList(menulevel){
            this.form.parentmenuid = '';
            $.get(this.$store.state.baseUrl + "/menu/getSelectMenuList",{
                    menulevel: menulevel - 1
                }).then(ret => {
                    this.parentMenus = ret.data;
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
            $.post(this.$store.state.baseUrl + '/menu/add', this.form).then(data => {
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
            //设置默认值
            this.form.displaytype = 1;
            this.form.menusort = 0;
            this.form.menulevel = 1;
            this.form.parentmenuid = '-1';

            this.$nextTick(() => {
                this.$refs['dlg'].show();
            })
        }
    }
}
</script>
