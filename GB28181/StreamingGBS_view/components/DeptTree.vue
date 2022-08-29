<template>
  <div class="box box-primary">
    <div class="box-header">
      <h4 class="text-primary text-center">机构管理</h4>
      <h6 class="text-success text-center" style="color:#006600;" v-if="isMobile()">长按操作机构</h6>
    </div>
    <div class="box-body" v-if="isMobile()">
      <div class="content" id="tab-tree-wrapper">
        <el-tree ref="devTree" class="depttree" id="dev-tree" node-key="key" v-if="showTree" :props="treeProps" :load="treeLoad" 
          :filter-node-method="treeFilter" lazy @node-click="treeNodeClick" @node-contextmenu="treeNodeRightClick" >
          <span class="custom-tree-node" slot-scope="{node, data}">
            <span :class="{'text-green': data.subCount === 0}">
              <i :class="['fa', {'fa-home' : data.parentid == -1,
                'fa-sitemap' : data.parentid != -1 && data.subCount > 0,
                'fa-group': data.parentid != -1 && data.subCount == 0}]"></i>
              <span class="ellipsis" :title="node.label">{{node.label}}</span>
            </span>
          </span>
        </el-tree>
      </div>
      <VueContextMenu class="right-menu" :target="contextMenuTarget" :show="contextMenuVisible" @update:show="(show) => contextMenuVisible = show">
        <a href="javascript:;" @click="showDeptAddDlg" v-show="contextMenuNodeData" style="color: #6600FF;" v-if="hasAnyRole(buttons, userInfo, '756082824884387840')">
          <i class="fa fa-plus"></i> 添加机构
        </a>
        <a href="javascript:;" @click="showDeptEditDlg" v-show="contextMenuNodeData" style="color: #6600FF;" v-if="hasAnyRole(buttons, userInfo, '756082890063872000')">
          <i class="fa fa-pencil"></i> 编辑机构
        </a>
        <a href="javascript:;" @click="deptRemove" v-show="contextMenuNodeData" style="color: #FF0000;" v-if="hasAnyRole(buttons, userInfo, '756082958280032256')">
          <i class="fa fa-trash"></i> 删除机构
        </a>
      </VueContextMenu>
      <DeptAddDlg ref="deptAddDlg" @submit="treeRefresh"></DeptAddDlg>
      <DeptEditDlg ref="deptEditDlg" @submit="treeRefresh"></DeptEditDlg>
    </div>
    <div class="box-body ispc" v-if="!isMobile()">
      <div class="content tree-block" id="tab-tree-wrapper">
        <el-tree ref="devTree" class="depttree" id="dev-tree" node-key="key" v-if="showTree" :props="treeProps" :load="treeLoad" 
          :filter-node-method="treeFilter" lazy @node-click="treeNodeClick" highlight-current>
          <span class="custom-tree-node" slot-scope="{node, data}">
            <span :class="{'text-green': data.subCount === 0}">
              <i :class="['fa', {'fa-home' : data.parentid == -1,
                'fa-sitemap' : data.parentid != -1 && data.subCount > 0,
                'fa-group': data.parentid != -1 && data.subCount == 0}]"></i>
              <span class="ellipsis" :title="node.label">{{node.label}}</span>
            </span>
          </span>
        </el-tree>
      </div>
      <div class="form-block">
        <form role="form" class="form-box form-horizontal" autocomplete="off" @submit.prevent="onSubmit">
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
          <div class="form-group mybtn text-center" v-if="contextMenuNodeData">
            <button type="button" class="btn btn-primary" @click="toAdd()" v-if="hasAnyRole(buttons, userInfo, '756082824884387840')&&handleType==1"><i class="fa fa-plus"></i> 添加</button>
            <button type="button" class="btn btn-default" @click="toCancel()" v-if="handleType==2">取消</button>
            <button type="submit" class="btn btn-primary" @click.prevent="onSubmit" :disabled="errors.any()" v-if="hasAnyRole(buttons, userInfo, '756082890063872000')"><i class="fa fa-edit"></i>保存</button>
            <button type="button" class="btn btn-danger" @click="deptRemove()" v-if="hasAnyRole(buttons, userInfo, '756082958280032256')&&handleType==1"><i class="fa fa-remove"></i> 删除</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import _ from "lodash";
import url from "url";
import { mapState } from "vuex"
import { component as VueContextMenu } from '@xunlei/vue-context-menu'
import DeptAddDlg from 'components/DeptAddDlg.vue'
import DeptEditDlg from 'components/DeptEditDlg.vue'
export default {
  props: {},
  data() {
    return {
      form: {},
      handleType: 0,//1选中，2添加
      loading: false,
      showTree: true,
      node: null,
      pnode: null,
      ppnode: null,
      contextMenuTarget: null,
      contextMenuVisible: false,
      contextMenuNodeData: null,
      treeProps: {
        label: (data, node) => {
          node.deptid = data.deptid;
          node.deptname = data.deptname;
          var label = data.deptname;
          if(data.subCount > 0) {
            label += ` [${data.subCount}]`;
          }
          return label;
        },
        isLeaf: (data, node) => {
          return data.subCount == 0;
        },
        disabled: (data, node) => {
          return false;
        }
      }
    };
  },
  components: {
    VueContextMenu,DeptAddDlg,DeptEditDlg
  },
  computed: {
    ...mapState(['userInfo', 'buttons'])
  },
  mounted() {
    this.contextMenuTarget = document.querySelector('#tab-tree-wrapper');
  },
  beforeRouteLeave(to, from, next) {
    next();
  },
  beforeRouteUpdate(to, from, next) {
    next();
  },
  methods: {
    defForm() {
      return {
        deptid: '',
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
    toAdd() {
      this.errors.clear();
      this.form = this.defForm();
      this.form.parentid = this.contextMenuNodeData.deptid;
      this.form.parentname = this.contextMenuNodeData.deptname;
      this.handleType = 2;
    },
    toCancel(){
      this.form = {
        deptid: this.contextMenuNodeData.deptid,
        deptname: this.contextMenuNodeData.deptname,
        parentid: this.contextMenuNodeData.parentid,
        parentname: this.pnode.deptname,
        gb_id: this.contextMenuNodeData.gb_id,
        depClass: this.contextMenuNodeData.depClass,
        contract: this.contextMenuNodeData.contract,
        tel: this.contextMenuNodeData.tel,
        address: this.contextMenuNodeData.address
      }
      this.handleType = 1;
    },
    async onSubmit() {
      console.log("onsubmit----")
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
      var url = '/dept/add';
      if(this.handleType==1){
        url = '/dept/edit';
      }
      $.post(this.$store.state.baseUrl + url, this.form).then(data => {
        if(data.code >= 0){
          this.treeRefresh();
        }else{
          this.$message({
            message: data.msg,
            type: 'warning',
          });
          return;
        }
      });
    },



    treeLoad(data, resolve) {
      var parentid = data.deptid||"-1";
      $.get(this.$store.state.baseUrl + "/dept/getChildDeptList", {
        parentid: parentid,
      }).then(ret => {
        resolve((ret.data||[]).map(v => {
          return Object.assign(v, {
            key: v.deptid,
          })
        }));
        if(data.level==0){//让它默认展开第一级
          setTimeout(function(){
            data.childNodes[0].expanded = true;
            data.childNodes[0].loadData();
          },100);
        }
        this.$refs['devTree'].filter();
      })
    },
    treeFilter(value, data) {
       if (!value) return true;
       return data.deptid.indexOf(value) !== -1 || data.deptname.indexOf(value) !== -1;
    },
    treeNodeRefresh(key) {
      let node = this.$refs['devTree'].getNode(key);
      if(!node) return;
      node.loaded = false;
      node.expand();
    },
    treeNodeRightClick(event, data, node, c) {
      this.contextMenuNodeData = data;
      this.pnode = node.parent;
      this.ppnode = this.pnode.parent;
      var new_event = new MouseEvent(event.type, event);
      this.contextMenuTarget.dispatchEvent(new_event);
    },
    treeNodeClick(data, node) {
      if(this.isMobile()){
        this.contextMenuNodeData = null;
      }else{
        this.contextMenuNodeData = data;
        this.form = {
          deptid: this.contextMenuNodeData.deptid,
          deptname: this.contextMenuNodeData.deptname,
          parentid: this.contextMenuNodeData.parentid,
          parentname: node.parent.deptname,
          gb_id: this.contextMenuNodeData.gb_id,
          depClass: this.contextMenuNodeData.depClass,
          contract: this.contextMenuNodeData.contract,
          tel: this.contextMenuNodeData.tel,
          address: this.contextMenuNodeData.address
        }
        this.node = node;
        this.pnode = node.parent;
        this.ppnode = this.pnode.parent;
        this.handleType = 1;
      }
    },
    showDeptEditDlg() {
      this.contextMenuVisible = false;
      this.$refs["deptEditDlg"].show({
        deptid: this.contextMenuNodeData.deptid,
        deptname: this.contextMenuNodeData.deptname,
        parentid: this.contextMenuNodeData.parentid,
        parentname: this.pnode.deptname,
        gb_id: this.contextMenuNodeData.gb_id,
        depClass: this.contextMenuNodeData.depClass,
        contract: this.contextMenuNodeData.contract,
        tel: this.contextMenuNodeData.tel,
        address: this.contextMenuNodeData.address
      });
    },
    showDeptAddDlg() {
      this.contextMenuVisible = false;
      this.$refs["deptAddDlg"].show({
        parentid: this.contextMenuNodeData.deptid,
        parentname: this.contextMenuNodeData.deptname
      });
    },
    deptRemove(){
      this.contextMenuVisible = false;
      if(this.contextMenuNodeData.parentid == -1){
        this.$message({
          message: '顶级机构无法删除',
          type: 'warning',
        });
        return;
      }
      this.$confirm(`即将其下删除所有子机构、设备、通道信息，确认删除 ${this.contextMenuNodeData.deptname}`, "提示").then(() => {
        $.post(this.$store.state.baseUrl + "/dept/delete", {
          deptid: this.contextMenuNodeData.deptid
        }).always(() => {
          this.delTreeRefresh();
        });
      }).catch(() => {});
    },
    treeRefresh() {
      if(this.isMobile()){
        this.contextMenuVisible = false;
        if(this.pnode) {
          this.treeNodeRefresh(this.pnode);
          return;
        }
        this.showTree = false;
        this.$nextTick(() => {
          this.showTree = true;
        });
      }else{
        this.errors.clear();
        if(this.handleType==1&&this.pnode) {
          this.treeNodeRefresh(this.pnode);
          this.form = {
            deptid: this.contextMenuNodeData.deptid,
            deptname: this.contextMenuNodeData.deptname,
            parentid: this.contextMenuNodeData.parentid,
            parentname: this.pnode.deptname,
            gb_id: this.contextMenuNodeData.gb_id,
            depClass: this.contextMenuNodeData.depClass,
            contract: this.contextMenuNodeData.contract,
            tel: this.contextMenuNodeData.tel,
            address: this.contextMenuNodeData.address
          }
          this.handleType = 1;
          return;
        }
        if(this.handleType==2&&this.node) {
          this.treeNodeRefresh(this.node);
          this.form = {
            deptid: this.contextMenuNodeData.deptid,
            deptname: this.contextMenuNodeData.deptname,
            parentid: this.contextMenuNodeData.parentid,
            parentname: this.pnode.deptname,
            gb_id: this.contextMenuNodeData.gb_id,
            depClass: this.contextMenuNodeData.depClass,
            contract: this.contextMenuNodeData.contract,
            tel: this.contextMenuNodeData.tel,
            address: this.contextMenuNodeData.address
          }
          this.handleType = 1;
          return;
        }
        this.showTree = false;
        this.$nextTick(() => {
          this.showTree = true;
        });
      }
    },
    delTreeRefresh() {
      if(!this.isMobile()){
        this.errors.clear();
        this.handleType = 0;
        this.contextMenuNodeData = null;
        this.form = this.defForm();
        this.node = null;
        this.pnode = null;
        this.ppnode = null;
      }
      this.contextMenuVisible = false;
      if(this.ppnode) {
        this.treeNodeRefresh(this.ppnode);
        return;
      }
      this.showTree = false;
      this.$nextTick(() => {
        this.showTree = true;
      })
    },
    getParentData() {
      if(!this.contextMenuNodeData) return null;
      if(!this.$refs["devTree"]) return null;
      var pNode = this.$refs["devTree"].getNode(this.contextMenuNodeData);
      if(!pNode) return null;
      if(!pNode.parent) return null;
      return pNode.parent.data;
    }
  }
};
</script>

<style lang="less" scoped>
.content{
  height: 100%;
  width: 100%;
  padding: 0 0 10px 0;
  margin: 0;
  .depttree{
    height: 100%;
    overflow: auto;
    margin: auto;
    border: 1px solid rgb(216, 216, 216);
  }
}
.box-body.ispc{
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: stretch;
  .tree-block{
    width: 300px;
    height: 100%;
    flex-grow: 0;
    overflow: auto;
  }
  .form-block{
    padding-bottom: 10px;
    flex-grow: 1;
    min-width: 350px;
    height: 100%;
    .form-box{
      width: 100%;
      height: 100%;
      border: 1px solid rgb(216, 216, 216);
      border-left: none;
      box-sizing: border-box;
      padding: 10px;
      overflow: hidden auto;
      .mybtn .btn-default{
        padding: 6px 19px;
      }
    }
  }
}
.right-menu {
  position: fixed;
  background: #fff;
  border: solid 1px rgba(0, 0, 0, .2);
  border-radius: 3px;
  z-index: 999;
  display: none;
}
.right-menu a {
  width: 100px;
  height: 28px;
  line-height: 28px;
  text-align: center;
  display: block;
  color: #1a1a1a;
}
.right-menu a:hover {
  background: #eee;
  color: #fff;
}
.right-menu {
    border: 1px solid #eee;
    box-shadow: 0 0.5em 1em 0 rgba(0,0,0,.1);
    border-radius: 1px;
}
a {
    text-decoration: none;
}
.right-menu a {
    padding: 2px;
}
.right-menu a:hover {
    background: #42b983;
}
</style>


