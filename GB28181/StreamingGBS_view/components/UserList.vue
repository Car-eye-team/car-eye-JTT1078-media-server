<template>
  <div :style="boxHeight">
    <div class="box box-primary">
      <div class="box-header">
        <h4 class="text-primary text-center">用户列表</h4>
      </div>
      <div class="box-body box-search">
        <form class="form-inline" autocomplete="off" spellcheck="false">
          <div class="form-group form-group-sm">
            <span class="hidden-xs">&nbsp;&nbsp;</span>
            <label>搜索</label>
            <input type="text" class="form-control" placeholder="关键字" v-model.trim="q" @change="getUserList" @keydown.enter.prevent ref="q">
          </div>
          <span class="hidden-xs">&nbsp;&nbsp;</span>
          <div class="form-group form-group-sm">
            <label>状态</label>
            <select class="form-control" v-model.trim="online" @change="getUserList">
              <option value="">全部</option>
              <option value="1">激活</option>
              <option value="0">停用</option>
            </select>
          </div>
          <div class="form-group form-group-sm pull-right">
            <div class="input-group input-group-sm" v-if="hasAnyRole(buttons, userInfo, '756079874053111808')">
              <button type="button" class="btn btn-sm btn-primary" @click.prevent="$refs['userAddDlg'].show()">
                <i class="fa fa-plus"></i> 添加用户
              </button>
            </div>
          </div>
        </form>
        <br>
        <el-table class="my-table" height="100%" :data="datas" stripe :default-sort="{prop: 'userid', order: 'desc'}" @sort-change="sortChange">
          <el-table-column prop="loginname" label="登录名" min-width="140" :formatter="formatName" show-overflow-tooltip>
            <template slot-scope="props">
              <span>{{props.row.loginname}}</span>
            </template>
          </el-table-column>
          <el-table-column prop="username" label="用户姓名" min-width="140" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="deptname" label="组织机构" min-width="200" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="online" label="状态" min-width="100">
            <template slot-scope="props">
              <span class="text-success" v-if="props.row.status === 1">激活</span>
              <span class="text-gray" v-else>停用</span>
            </template>
          </el-table-column>
          <el-table-column prop="usergroupname" label="所属角色" min-width="140" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="validtime" label="有效期" min-width="120" sortable="custom" :formatter="formatDay" show-overflow-tooltip></el-table-column>
          <el-table-column prop="logintime" label="最后登录时间" min-width="160" sortable="custom" :formatter="formatDate" show-overflow-tooltip></el-table-column>
          <el-table-column prop="createDate" label="创建时间" min-width="160" sortable="custom" :formatter="formatDate" show-overflow-tooltip></el-table-column>
          <el-table-column label="操作" min-width="120" fixed="right">
            <template slot-scope="props">
                <div class="btn-group btn-group-xs">
                    <button type="button" class="btn btn-warning" @click.prevent="editUser(props.row)" v-if="hasAnyRole(buttons, userInfo, '756079941996642304')">
                      <i class="fa fa-edit"></i> 编辑
                    </button>
                    <button type="button" class="btn btn-danger" @click.prevent="removeUser(props.row)" v-if="hasAnyRole(buttons, userInfo, '756080004277862400')">
                      <i class="fa fa-remove"></i> 删除
                    </button>
                </div>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div class="box-footer">
        <el-pagination layout="total,prev,pager,next" :pager-count="5" class="pull-right" :total="total" :page-size.sync="pageSize" :current-page.sync="currentPage" @current-change="getUserList"></el-pagination>
      </div>
    </div>
    
    <UserAddDlg ref="userAddDlg" @submit="getUserList()"></UserAddDlg>
    <UserEditDlg ref="userEditDlg" @submit="getUserList()"></UserEditDlg>
  </div>
</template>

<script>
import _ from "lodash";
import url from "url";
import UserAddDlg from "components/UserAddDlg";
import UserEditDlg from "components/UserEditDlg";
import { mapState } from "vuex"
export default {
  props: {},
  data() {
    return {
      boxHeight: "height: 100%;",
      q: "",
      online: '',
      total: 0,
      pageSize: 10,
      currentPage: 1,
      sort: "userid",
      order: "desc",
      datas: [],
      loading: false
    };
  },
  components: {
    UserEditDlg, UserAddDlg
  },
  computed: {
    ...mapState(["userInfo", "buttons"])
  },
  mounted() {
    this.getUserList();
  },
  methods: {
    getUserList() {
      this.loading = true;
      $.get(this.$store.state.baseUrl + "/user/list", {
        q: this.q,
        online: this.online,
        page: this.currentPage,
        limit: this.pageSize,
        sort: this.sort,
        order: this.order
      }).then(ret => {
        this.total = ret.count;
        this.datas = ret.data;
        if(this.isMobile()&&ret.data.length>0){
          this.boxHeight = "height:calc(100% + "+ (ret.data.length*30+50) +"px);"
        }
      }).always(() => {
        this.loading = false;
      });
    },
    sortChange(data) {
      this.sort = data.prop;
      this.order = data.order == "ascending" ? "asc" : "desc";
      this.getUserList();
    },
    removeUser(row) {
      this.$confirm(`确认删除 ${row.username|| row.loginname}`, "提示").then(() => {
        $.post(this.$store.state.baseUrl + "/user/delete", {
          userid: row.userid
        }).always(() => {
          this.getUserList();
        });
      }).catch(() => {});
    },
    editUser(row) {
      this.$refs["userEditDlg"].show({
        userid: row.userid,
        loginname: row.loginname,
        username: row.username,
        deptid: row.deptid,
        usergroupid: row.usergroupid,
        userNumber: row.userNumber,
        validtimeStr: this.formatDay(null,row,row.validtime),
        usersex: row.usersex + '',
        mobile: row.mobile,
        telephone: row.telephone,
        email: row.email,
        status: row.status + '',
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
      return "-";
    },
    formatDay(row, col, cell) {
      if (cell){
        var date = new Date(cell) //时间戳为10位需*1000，时间戳为13位的话不需乘1000
        var Y = date.getFullYear() + '-'
        var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-'
        var D = (date.getDate() < 10 ? '0'+date.getDate() : date.getDate())
        return Y+M+D
      } 
      return "-";
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

