<template>
  <div :style="boxHeight">
    <div class="box box-primary">
      <div class="box-header">
        <h4 class="text-primary text-center">角色列表</h4>
      </div>
      <div class="box-body box-search">
        <form class="form-inline" autocomplete="off" spellcheck="false">
          <div class="form-group form-group-sm">
            <span class="hidden-xs">&nbsp;&nbsp;</span>
            <label>搜索</label>
            <input type="text" class="form-control" placeholder="关键字" v-model.trim="q" @change="getRoleList" @keydown.enter.prevent ref="q">
          </div>
          <div class="form-group form-group-sm pull-right">
            <div class="input-group input-group-sm" v-if="hasAnyRole(buttons, userInfo, '756081462758998016')">
              <button type="button" class="btn btn-sm btn-primary" @click.prevent="$refs['roleAddDlg'].show()">
                <i class="fa fa-plus"></i> 添加角色
              </button>
            </div>
          </div>
        </form>
        <br>
        <el-table class="my-table" height="100%" :data="datas" stripe :default-sort="{prop: 'usergroupid', order: 'desc'}" @sort-change="sortChange">
          <el-table-column prop="usergroupname" label="角色名称" min-width="140" :formatter="formatName" show-overflow-tooltip>
            <template slot-scope="props">
              <span>{{props.row.usergroupname}}</span>
            </template>
          </el-table-column>
          <el-table-column prop="usergroupdesc" label="角色描述" min-width="300" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="createDate" label="创建时间" min-width="160" sortable="custom" :formatter="formatDate" show-overflow-tooltip></el-table-column>
          <el-table-column label="操作" min-width="180" fixed="right">
            <template slot-scope="props">
                <div class="btn-group btn-group-xs">
                    <button class="btn btn-info" @click.prevent="setAuthority(props.row)" v-if="hasAnyRole(buttons, userInfo, '756082012099575808')">
                        分配权限
                    </button>
                    <button type="button" class="btn btn-warning" @click.prevent="editRole(props.row)" v-if="hasAnyRole(buttons, userInfo, '756081554404540416')">
                      <i class="fa fa-edit"></i> 编辑
                    </button>
                    <button type="button" class="btn btn-danger" @click.prevent="removeRole(props.row)" v-if="hasAnyRole(buttons, userInfo, '756081633836269568')">
                      <i class="fa fa-remove"></i> 删除
                    </button>
                </div>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div class="box-footer">
        <el-pagination layout="total,prev,pager,next" :pager-count="5" class="pull-right" :total="total" :page-size.sync="pageSize" :current-page.sync="currentPage" @current-change="getRoleList"></el-pagination>
      </div>
    </div>
    
    <RoleAddDlg ref="roleAddDlg" @submit="getRoleList"></RoleAddDlg>
    <RoleEditDlg ref="roleEditDlg" @submit="getRoleList"></RoleEditDlg>
    <SetAuthority ref="setAuthority"></SetAuthority>
  </div>
</template>

<script>
import _ from "lodash";
import url from "url";
import RoleEditDlg from 'components/RoleEditDlg.vue'
import RoleAddDlg from 'components/RoleAddDlg.vue'
import SetAuthority from 'components/SetAuthority.vue'
import { mapState } from "vuex"
export default {
  props: {},
  data() {
    return {
      boxHeight: "height: 100%;",
      q: "",
      total: 0,
      pageSize: 10,
      currentPage: 1,
      sort: "usergroupid",
      order: "desc",
      datas: [],
      loading: false
    };
  },
  components: {
    RoleEditDlg,RoleAddDlg,SetAuthority
  },
  computed: {
    ...mapState(["userInfo", "buttons"])
  },
  mounted() {
    this.getRoleList();
  },
  methods: {
    getRoleList() {
      this.loading = true;
      $.get(this.$store.state.baseUrl + "/userGroup/list", {
        q: this.q,
        page: this.currentPage,
        limit: this.pageSize,
        sort: this.sort,
        order: this.order
      })
        .then(ret => {
          this.total = ret.count;
          this.datas = ret.data;
        if(this.isMobile()&&ret.data.length>0){
          this.boxHeight = "height:calc(100% + "+ (ret.data.length*30+50) +"px);"
        }
        })
        .always(() => {
          this.loading = false;
        });
    },
    sortChange(data) {
      this.sort = data.prop;
      this.order = data.order == "ascending" ? "asc" : "desc";
      this.getRoleList();
    },
    removeRole(row) {
      this.$confirm(`确认删除 ${row.usergroupname}`, "提示").then(() => {
        $.post(this.$store.state.baseUrl + "/userGroup/delete", {
          usergroupid: row.usergroupid
        }).always(() => {
          this.getRoleList();
        });
      }).catch(() => {});
    },
    editRole(row) {
      this.$refs["roleEditDlg"].show({
        usergroupid: row.usergroupid,
        usergroupname: row.usergroupname,
        usergroupdesc: row.usergroupdesc,
      });
    },
    setAuthority(row){
      this.$refs["setAuthority"].show({
        usergroupid: row.usergroupid,
      });
    },
    formatName(row, col, cell) {
      if (cell) return cell;
      return "-";
    },
    formatDate(row, col, cell) {
      if (cell){
        var date = new Date(cell) //时间戳为10位需*1000，时间戳为13位的话不需乘1000
        var Y = date.getFullYear() + '-'
        var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-'
        var D = (date.getDate() < 10 ? '0'+date.getDate() : date.getDate()) + ' '
        var h = (date.getHours() < 10 ? '0'+date.getHours() : date.getHours()) + ':'
        var m = (date.getMinutes() < 10 ? '0'+date.getMinutes() : date.getMinutes()) + ':'
        var s = (date.getSeconds() < 10 ? '0'+date.getSeconds() : date.getSeconds())
        return Y+M+D+h+m+s
      } 
      return "";
    },
    formatDay(row, col, cell) {
      if (cell){
        var date = new Date(cell) //时间戳为10位需*1000，时间戳为13位的话不需乘1000
        var Y = date.getFullYear() + '-'
        var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-'
        var D = (date.getDate() < 10 ? '0'+date.getDate() : date.getDate())
        return Y+M+D
      } 
      return "";
    },
  },
  beforeRouteLeave(to, from, next) {
    next();
  },
  beforeRouteUpdate(to, from, next) {
    next();
  }
};
</script>

