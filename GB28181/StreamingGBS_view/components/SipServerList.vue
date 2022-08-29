<template>
  <div :style="boxHeight">
    <div class="box box-primary">
      <div class="box-header">
        <h4 class="text-primary text-center">上级平台级联列表</h4>
      </div>
      <div class="box-body box-search">
        <form class="form-inline" autocomplete="off" spellcheck="false">
          <div class="form-group form-group-sm">
            <span class="hidden-xs">&nbsp;&nbsp;</span>
            <label>搜索</label>
            <input type="text" class="form-control" placeholder="关键字" v-model.trim="q" @change="getSipServerList" @keydown.enter.prevent ref="q">
          </div>
          <span class="hidden-xs">&nbsp;&nbsp;</span>
          <div class="form-group form-group-sm">
            <label>是否启用</label>
            <select class="form-control" v-model.trim="online" @change="getSipServerList">
              <option value="">全部</option>
              <option value="1">启用</option>
              <option value="0">未启用</option>
            </select>
          </div>
          <div class="form-group form-group-sm pull-right">
            <div class="input-group input-group-sm" v-if="hasAnyRole(buttons, userInfo, '758061738758373376')">
              <button type="button" class="btn btn-sm btn-primary" @click.prevent="$refs['sipServerAddDlg'].show()">
                <i class="fa fa-plus"></i> 添加上级平台
              </button>
            </div>
          </div>
        </form>
        <br>
        <el-table class="my-table" height="100%" :data="datas" stripe :default-sort="{prop: 'id', order: 'desc'}" @sort-change="sortChange">
          <el-table-column prop="name" label="名称" min-width="140" :formatter="formatName" show-overflow-tooltip>
            <template slot-scope="props">
              <span>{{props.row.name}}</span>
            </template>
          </el-table-column>
          <el-table-column prop="code" label="国标编码" min-width="140" :formatter="formatName" sortable="custom" show-overflow-tooltip></el-table-column>
          <el-table-column prop="active" label="是否启用" min-width="100" sortable="custom">
            <template slot-scope="props">
              <span class="text-success" v-if="props.row.active === 1">启用</span>
              <span class="text-gray" v-else>未启用</span>
            </template>
          </el-table-column>
          <el-table-column prop="domain" label="SIP服务域名" min-width="140" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="ip" label="SIP服务IP" min-width="140" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="port" label="SIP服务端口" min-width="140" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="registerPeroid" label="注册周期(秒)" min-width="140" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="heartPeroid" label="心跳周期(秒)" min-width="140" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="gourpSize" label="目录分组大小" min-width="140" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="transProtocol" label="传输协议" min-width="120">
            <template slot-scope="props">
              <span class="text-primary" v-if="props.row.transProtocol === 1">TCP</span>
              <span class="text-primary" v-else>UDP</span>
            </template>
          </el-table-column>
          <el-table-column prop="codeSet" label="字符集" min-width="120">
            <template slot-scope="props">
              <span class="text-primary" v-if="props.row.codeSet === 1">UTF-8</span>
              <span class="text-primary" v-else>GB2312</span>
            </template>
          </el-table-column>
          <el-table-column prop="rtcp" label="是否启用RTCP" min-width="140" sortable="custom">
            <template slot-scope="props">
              <span class="text-success" v-if="props.row.rtcp === 1">启用</span>
              <span class="text-gray" v-else>未启用</span>
            </template>
          </el-table-column>
          <el-table-column prop="createDate" label="创建时间" min-width="160" sortable="custom" :formatter="formatDate" show-overflow-tooltip></el-table-column>
          <el-table-column label="操作" min-width="120" fixed="right">
            <template slot-scope="props">
                <div class="btn-group btn-group-xs">
                    <button type="button" class="btn btn-warning" @click.prevent="editSipServer(props.row)" v-if="hasAnyRole(buttons, userInfo, '758061804067880960')">
                      <i class="fa fa-edit"></i> 编辑
                    </button>
                    <button type="button" class="btn btn-danger" @click.prevent="removeSipServer(props.row)" v-if="!props.row.online && hasAnyRole(buttons, userInfo, '758062008217239552')">
                      <i class="fa fa-remove"></i> 删除
                    </button>
                </div>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div class="box-footer">
        <el-pagination layout="total,prev,pager,next" :pager-count="5" class="pull-right" :total="total" :page-size.sync="pageSize" :current-page.sync="currentPage" @current-change="getSipServerList"></el-pagination>
      </div>
    </div>
    
    <SipServerAddDlg ref="sipServerAddDlg" @submit="getSipServerList"></SipServerAddDlg>
    <SipServerEditDlg ref="sipServerEditDlg" @submit="getSipServerList"></SipServerEditDlg>
  </div>
</template>

<script>
import _ from "lodash";
import url from "url";
import SipServerEditDlg from 'components/SipServerEditDlg.vue'
import SipServerAddDlg from 'components/SipServerAddDlg.vue'
import { mapState } from "vuex"
export default {
  props: {},
  data() {
    return {
      boxHeight: "height: 100%;",
      q: "",
      online: "",
      total: 0,
      pageSize: 10,
      currentPage: 1,
      sort: "id",
      order: "desc",
      datas: [],
      loading: false
    };
  },
  components: {
    SipServerEditDlg,SipServerAddDlg
  },
  computed: {
    ...mapState(["userInfo", "buttons"])
  },
  mounted() {
    this.getSipServerList();
  },
  methods: {
    isMobile() {
      return videojs.browser.IS_IOS || videojs.browser.IS_ANDROID;
    },
    getSipServerList() {
      this.loading = true;
      $.get(this.$store.state.baseUrl + "/sipServer/list", {
        q: this.q,
        page: this.currentPage,
        limit: this.pageSize,
        online: this.online,
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
      this.getSipServerList();
    },
    removeSipServer(row) {
      this.$confirm(`确认删除 ${row.name || row.code}`, "提示").then(() => {
        $.post(this.$store.state.baseUrl + "/sipServer/delete", {
          id: row.id
        }).always(() => {
          this.getSipServerList();
        });
      }).catch(() => {});
    },
    editSipServer(row) {
      this.$refs["sipServerEditDlg"].show({
        id: row.id,
        name: row.name,
        code: row.code,
        domain: row.domain,
        ip: row.ip,
        port: row.port,
        user: row.user,
        password: row.password,
        registerPeroid: row.registerPeroid,
        heartPeroid: row.heartPeroid,
        gourpSize: row.gourpSize,
        transProtocol: row.transProtocol + '',
        codeSet: row.codeSet + '',
        active: row.active + '',
        rtcp: row.rtcp + ''
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

