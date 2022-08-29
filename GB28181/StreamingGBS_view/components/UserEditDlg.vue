<template>
    <FormDlg title="编辑用户" @hide="onHide" @show="onShow" @submit="onSubmit" ref="dlg" :disabled="errors.any()">
        <div :class="{'form-group':true,'has-error': errors.has('loginname')}">
            <label for="input-loginname" class="col-sm-4 control-label">登录名
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-loginname" name="loginname" v-model.trim="form.loginname" data-vv-as="登录名" v-validate="'required'" @keydown.enter="$el.querySelector('#input-loginname').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('username')}">
            <label for="input-username" class="col-sm-4 control-label">用户名称
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-username" name="username" v-model.trim="form.username" data-vv-as="用户名称" v-validate="'required'" @keydown.enter="$el.querySelector('#input-username').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('deptid')}">
            <label for="input-deptid" class="col-sm-4 control-label">组织机构
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <SelectTree width="100%" class="form-control" id="input-deptid" name="deptid" v-model.trim="form.deptid" v-validate="'required'" :options="this.$store.state.deptOptions" :props="{parent:'parentid',value:'deptid',label:'deptname',children:'children'}"></SelectTree>
            </div>
        </div>
        <div :class="{'form-group':true, 'has-error': errors.has('usergroupid')}">
            <label for="input-usergroupid" class="col-sm-4 control-label">所属角色
                <span class="text-red">*</span>
            </label>
            <div class="col-sm-7">
                <el-select style="width:100%;" class="form-control" size="medium" v-model.trim="form.usergroupid" placeholder="请选择" v-validate="'required'">
                    <el-option v-for="item in innerRoles" :key="item.id" :label="item.name" :value="item.id">
                    </el-option>
                </el-select>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('userNumber')}">
            <label for="input-userNumber" class="col-sm-4 control-label">用户编码
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-userNumber" name="userNumber" v-model.trim="form.userNumber" placeholder="用户编码" data-vv-as="用户编码" @keydown.enter="$el.querySelector('#input-userNumber').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('validtimeStr')}">
            <label for="input-validtimeStr" class="col-sm-4 control-label">有效期
            </label>
            <div class="col-sm-7">
                <el-date-picker style="width:100%" class="form-control" id="input-validtimeStr" name="validtimeStr" v-model.trim="form.validtimeStr" data-vv-as="有效期" type="date" placeholder="选择日期" value-format="yyyy-MM-dd"></el-date-picker>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('usersex')}">
            <label for="input-usersex" class="col-sm-4 control-label">性别
            </label>
            <div class="col-sm-7">
                <el-radio name="usersex" v-model.trim="form.usersex" label="1">男</el-radio>
                <el-radio name="usersex" v-model.trim="form.usersex" label="0">女</el-radio>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('mobile')}">
            <label for="input-mobile" class="col-sm-4 control-label">手机号
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-mobile" name="mobile" v-model.trim="form.mobile" placeholder="手机号" data-vv-as="手机号" @keydown.enter="$el.querySelector('#input-mobile').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('telephone')}">
            <label for="input-telephone" class="col-sm-4 control-label">固定电话
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-telephone" name="telephone" v-model.trim="form.telephone" placeholder="固定电话" data-vv-as="固定电话" @keydown.enter="$el.querySelector('#input-telephone').focus()">
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('email')}">
            <label for="input-email" class="col-sm-4 control-label">邮箱
            </label>
            <div class="col-sm-7">
                <input type="text" class="form-control" id="input-email" name="email" v-model.trim="form.email" placeholder="邮箱" data-vv-as="邮箱" @keydown.enter="$el.querySelector('#input-email').focus()">
            </div>
        </div>
        <div :class="{'form-group':true, 'has-error': errors.has('status')}">
            <label for="input-status" class="col-sm-4 control-label">状态
            </label>
            <div class="col-sm-7 checkbox">
                <el-switch name="status" v-model.trim="form.status" active-text="激活" active-value="1" active-color="#13ce66" inactive-text="停用" inactive-value="0" ></el-switch>
            </div>
        </div>
        <div :class="{'form-group':true,'has-error': errors.has('password')}">
            <label for="input-password" class="col-sm-4 control-label">修改密码
            </label>
            <div class="col-sm-7">
                <input type="password" class="form-control" id="input-password" name="password" v-model.trim="form.password" data-vv-as="密码" @keydown.enter="$el.querySelector('#input-password').focus()">
            </div>
        </div>
        
    </FormDlg>
</template>

<script>
import FormDlg from 'components/FormDlg.vue'
import $ from 'jquery'
import SelectTree from 'components/SelectTree.vue'
import crypto from "crypto"

export default {
    data() {
        return {
            form: this.defForm(),
            innerRoles: [],
        }
    },
    components: {
        FormDlg,SelectTree
    },
    methods: {
        defForm() {
            return {
                userid: '',
                deptid: '',
                loginname: '',
                username: '',
                usergroupid: '',
                userNumber: '',
                validtimeStr: '',
                usersex: '',
                telephone: '',
                mobile: '',
                email: '',
                password: '',
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
        md5(text) {
        return crypto
            .createHash("md5")
            .update(text, "utf8")
            .digest("hex")
            .toUpperCase();
        },
        fetchRoleList() {
            return new Promise((resolve, reject) => {
                $.get(this.$store.state.baseUrl + "/userGroup/getSelectRoleList").then(ret => {
                    resolve(ret.data.map(sms => ({
                        id: sms.usergroupid||"",
                        name: sms.usergroupname||"",
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
            if(this.form.password != undefined && this.form.password != null && this.form.password != ''){
                this.form.password = this.md5(this.form.password);
            }

            $.post(this.$store.state.baseUrl + '/user/edit', this.form).then(data => {
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
            console.log(this.form);
            this.innerRoles = await this.fetchRoleList();
            this.$nextTick(() => {
                this.$refs['dlg'].show();
            })
        }
    }
}
</script>
