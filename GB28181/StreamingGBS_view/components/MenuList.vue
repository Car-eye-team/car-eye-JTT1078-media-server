<template>
  <div :style="boxHeight">
    <div class="box box-primary">
      <div class="box-header">
        <h4 class="text-primary text-center">菜单列表</h4>
      </div>
      <div class="box-body box-search">
        <form class="form-inline" autocomplete="off" spellcheck="false">
          <div class="form-group form-group-sm">
            <label>搜索</label>
            <input type="text" class="form-control" placeholder="关键字" v-model.trim="q" @change="getMenuList" @keydown.enter.prevent ref="q">
          </div>
          <span class="hidden-xs">&nbsp;&nbsp;</span>
          <div class="form-group form-group-sm">
            <label>菜单类型</label>
            <select class="form-control" v-model.trim="type" @change="getMenuList">
              <option value="">全部</option>
              <option value="0">菜单</option>
              <option value="1">按钮</option>
            </select>
          </div>
          <span class="hidden-xs">&nbsp;&nbsp;</span>
          <div class="form-group form-group-sm">
            <label>是否显示</label>
            <select class="form-control" v-model.trim="online" @change="getMenuList">
              <option value="">全部</option>
              <option value="1">显示</option>
              <option value="0">隐藏</option>
            </select>
          </div>
          <div class="form-group form-group-sm pull-right">
            <div class="input-group input-group-sm" v-if="hasAnyRole(buttons, userInfo, '755845973078573056')">
              <button type="button" class="btn btn-sm btn-primary" @click.prevent="$refs['menuAddDlg'].show()">
                <i class="fa fa-plus"></i> 添加菜单
              </button>
            </div>
          </div>
        </form>
        <br>
        <el-table class="my-table" height="100%" :data="datas" stripe :default-sort="{prop: 'menuid', order: 'desc'}" @sort-change="sortChange">
          <el-table-column prop="menuname" label="菜单名称" min-width="140" :formatter="formatName" sortable="custom" show-overflow-tooltip>
            <template slot-scope="props">
              <span>{{props.row.menuname}}</span>
            </template>
          </el-table-column>
          <el-table-column prop="parentmenuname" label="父级菜单名称" min-width="140" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="menulevel" label="菜单级别" min-width="100" sortable="custom">
            <template slot-scope="props">
              <span class="text-primary" v-if="props.row.menulevel === 1">一级</span>
              <span class="text-primary" v-else-if="props.row.menulevel === 2">二级</span>
              <span class="text-primary" v-else-if="props.row.menulevel === 3">三级</span>
              <span class="text-primary" v-else>-</span>
            </template>
          </el-table-column>
          <el-table-column prop="menutype" label="菜单类型" min-width="100" sortable="custom">
            <template slot-scope="props">
              <span class="text-primary" v-if="props.row.menutype === 1">按钮</span>
              <span class="text-primary" v-else>菜单</span>
            </template>
          </el-table-column>
          <el-table-column prop="displaytype" label="是否显示" min-width="100" sortable="custom">
            <template slot-scope="props">
              <span class="text-success" v-if="props.row.displaytype === 1">显示</span>
              <span class="text-gray" v-else>隐藏</span>
            </template>
          </el-table-column>
          <el-table-column prop="menuaddr" label="菜单地址" min-width="140" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="createDate" label="创建时间" min-width="160" sortable="custom" :formatter="formatDate" show-overflow-tooltip></el-table-column>
          <el-table-column prop="menuid" label="菜单ID" min-width="140" :formatter="formatName" sortable="custom" show-overflow-tooltip></el-table-column>
          <el-table-column label="操作" min-width="120" fixed="right">
            <template slot-scope="props">
                <div class="btn-group btn-group-xs">
                    <button type="button" class="btn btn-warning" @click.prevent="editMenu(props.row)" v-if="hasAnyRole(buttons, userInfo, '755846052728406016')">
                      <i class="fa fa-edit"></i> 编辑
                    </button>
                    <button type="button" class="btn btn-danger" @click.prevent="removeMenu(props.row)" v-if="hasAnyRole(buttons, userInfo, '755846117727535104')">
                      <i class="fa fa-remove"></i> 删除
                    </button>
                </div>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div class="box-footer">
        <el-pagination layout="total,prev,pager,next" :pager-count="5" class="pull-right" :total="total" :page-size.sync="pageSize" :current-page.sync="currentPage" @current-change="getMenuList"></el-pagination>
      </div>
    </div>
    
    <MenuAddDlg ref="menuAddDlg" @submit="getMenuList"></MenuAddDlg>
    <MenuEditDlg ref="menuEditDlg" @submit="getMenuList"></MenuEditDlg>
  </div>
</template>

<script>
import _ from "lodash";
import url from "url";
import MenuEditDlg from 'components/MenuEditDlg.vue'
import MenuAddDlg from 'components/MenuAddDlg.vue'
import { mapState } from "vuex"
export default {
  props: {},
  data() {
    return {
      boxHeight: "height: 100%;",
      q: "",
      type: "",
      online: "",
      total: 0,
      pageSize: 10,
      currentPage: 1,
      sort: "menuid",
      order: "desc",
      datas: [],
      loading: false
    };
  },
  components: {
    MenuEditDlg,MenuAddDlg
  },
  computed: {
    ...mapState(["userInfo", "buttons"])
  },
  mounted() {
    this.getMenuList();
  },
  methods: {
    getMenuList() {
      this.loading = true;
      $.get(this.$store.state.baseUrl + "/menu/list", {
        q: this.q,
        type: this.type,
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
      this.getMenuList();
    },
    removeMenu(row) {
      this.$confirm(`确认删除 ${row.menuname}`, "提示").then(() => {
        $.post(this.$store.state.baseUrl + "/menu/delete", {
          menuid: row.menuid
        }).always(() => {
          this.getMenuList();
        });
      }).catch(() => {});
    },
    editMenu(row) {
      this.$refs["menuEditDlg"].show({
        menuid: row.menuid,
        parentmenuid: row.parentmenuid,
        menuname: row.menuname,
        menuaddr: row.menuaddr,
        displaytype: row.displaytype,
        menusort: row.menusort,
        menulevel: row.menulevel,
        menutype: row.menutype,
        imgurl: row.imgurl,
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

