<template>
  <div :style="boxHeight">
    <div class="box box-primary">
      <div class="box-header">
        <h4 class="text-primary text-center">设备列表</h4>
      </div>
      <div class="box-body box-search">
        <form class="form-inline" autocomplete="off" spellcheck="false">
          <div class="form-group form-group-sm search-dept">
            <label>组织机构</label>
            <SelectTreeSearch v-model.trim="deptid" :options="this.$store.state.deptOptions" :props="{parent:'parentid',value:'deptid',label:'deptname',children:'children'}"></SelectTreeSearch>
          </div>
          <span class="hidden-xs">&nbsp;&nbsp;</span>
          <div class="form-group form-group-sm">
            <label>搜索</label>
            <input type="text" class="form-control" placeholder="设备编码、名称" v-model.trim="q" @change="getDeviceList" @keydown.enter.prevent ref="q">
          </div>
          <span class="hidden-xs">&nbsp;&nbsp;</span>
          <div class="form-group form-group-sm">
            <label>在线状态</label>
            <select class="form-control" v-model.trim="online" @change="getDeviceList">
              <option value="">全部</option>
              <option value="1">在线</option>
              <option value="0">离线</option>
            </select>
          </div>
          <div class="form-group form-group-sm pull-right">
            <div class="input-group input-group-sm">
              <button type="button" class="btn btn-sm btn-primary" @click.prevent="getDeviceList">
                <i class="fa fa-refresh"></i> 刷新
              </button>
            </div>
            <div class="input-group input-group-sm" v-if="hasAnyRole(buttons, userInfo, '756090393669533696')">
              <button type="button" class="btn btn-sm btn-primary" @click.prevent="$refs['deviceAddDlg'].show()">
                <i class="fa fa-plus"></i> 添加设备
              </button>
            </div>
            <div class="input-group input-group-sm" v-if="hasAnyRole(buttons, userInfo, '756090393669533696')">
              <button type="button" class="btn btn-sm btn-primary" @click.prevent="$refs['deviceMultAddDlg'].show()">
                <i class="fa fa-plus"></i> 批量添加设备
              </button>
            </div>
            <div class="input-group input-group-sm" v-if="hasAnyRole(buttons, userInfo, '756090393669533696')">
              <button type="button" class="btn btn-sm btn-primary" @click.prevent="$refs['deviceImportDlg'].show()">
                <i class="fa fa-cloud-upload"></i> 导入设备
              </button>
            </div>
          </div>
        </form>
        <br>
        <el-table class="my-table" height="100%" :data="devices" stripe :default-sort="{prop: 'id', order: 'desc'}" @sort-change="sortChange">
          <el-table-column prop="gb_id" label="设备编码" min-width="180" :formatter="formatName" sortable="custom" show-overflow-tooltip>
            <template slot-scope="props">
              <span>{{props.row.gb_id}}</span>
            </template>
          </el-table-column>
          <el-table-column prop="devicename" label="设备名称" min-width="140" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="deptname" label="组织机构" min-width="200" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="devicetypename" label="设备类型" min-width="140" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="channels" label="通道数" min-width="100" sortable="custom" show-overflow-tooltip></el-table-column>
          <el-table-column prop="status" label="在线状态" min-width="100" show-overflow-tooltip>
            <template slot-scope="props">
              <span class="text-success" v-if="props.row.status === 1">在线</span>
              <span class="text-gray" v-else>离线</span>
            </template>
          </el-table-column>
          <el-table-column prop="ip" label="IP地址" min-width="120" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="port" label="端口" min-width="80" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="createDate" label="创建时间" min-width="160" sortable="custom" :formatter="formatDate" show-overflow-tooltip></el-table-column>
          <el-table-column label="操作" width="240" fixed="right" align="center">
            <template slot-scope="props">
              <div class="btn-group btn-group-xs">
                <router-link class="btn btn-info" :to="`/devices/channels/${props.row.id}/1`" v-if="hasAnyRole(buttons, userInfo, '756090917986893824')">
                  <i class="fa fa-info"></i> 查看通道
                </router-link>
                <button type="button" class="btn btn-warning" @click.prevent="editDevice(props.row)" v-if="hasAnyRole(buttons, userInfo, '756090541694910464')">
                  <i class="fa fa-edit"></i> 编辑
                </button>
                <button type="button" class="btn btn-success" @click.prevent="refreshDevice(props.row)">
                  <i class="fa fa-refresh"></i> 刷新
                </button>
                <button type="button" class="btn btn-danger" @click.prevent="removeDevice(props.row)" v-if="!props.row.online && hasAnyRole(buttons, userInfo, '756090618203209728')">
                  <i class="fa fa-remove"></i> 删除
                </button>
              </div>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div class="box-footer">
        <el-pagination layout="total,prev,pager,next" :pager-count="5" class="pull-right" :total="total" :page-size.sync="pageSize" :current-page.sync="currentPage" @current-change="getDeviceList"></el-pagination>
      </div>
    </div>
    
    <DeviceAddDlg ref="deviceAddDlg" @submit="getDeviceList"></DeviceAddDlg>
    <DeviceMultAddDlg ref="deviceMultAddDlg" @submit="getDeviceList"></DeviceMultAddDlg>
    <DeviceEditDlg ref="deviceEditDlg" @submit="getDeviceList"></DeviceEditDlg>
    <DeviceImportDlg ref="deviceImportDlg" @submit="getDeviceList"></DeviceImportDlg>
  </div>
</template>

<script>
import _ from "lodash";
import url from "url";
import DeviceEditDlg from 'components/DeviceEditDlg.vue'
import DeviceAddDlg from 'components/DeviceAddDlg.vue'
import DeviceMultAddDlg from 'components/DeviceMultAddDlg.vue'
import SelectTreeSearch from 'components/SelectTreeSearch.vue'
import DeviceImportDlg from 'components/DeviceImportDlg.vue'
import { mapState } from "vuex"
export default {
  props: {},
  data() {
    return {
      boxHeight: "height: 100%;",
      deptid: '',
      deptidAllChild:'1',
      q: "",
      online: "",
      total: 0,
      pageSize: 10,
      currentPage: 1,
      sort: "id",
      order: "desc",
      devices: [],
      loading: false,
    };
  },
  components: {
    DeviceEditDlg,DeviceMultAddDlg,DeviceAddDlg,SelectTreeSearch,DeviceImportDlg
  },
  computed: {
    ...mapState(["userInfo", "buttons"])
  },
  mounted() {
    this.getDeviceList();
  },
  watch: {
    deptid: function(newVal, oldVal) {
      this.getDeviceList();
    },
  },
  methods: {
    getDeviceList() {
      this.loading = true;
      $.get(this.$store.state.baseUrl + "/deviceInfo/list", {
        deptid: this.deptid,
        deptidAllChild:this.deptidAllChild,
        q: this.q,
        page: this.currentPage,
        limit: this.pageSize,
        online: this.online,
        sort: this.sort,
        order: this.order
      }).then(ret => {
        this.total = ret.count;
        this.devices = ret.data;
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
      this.getDeviceList();
    },
    removeDevice(row) {
      this.$confirm(`确认删除 ${row.devicename || row.gb_id}`, "提示").then(() => {
        $.post(this.$store.state.baseUrl + "/deviceInfo/delete", {
          id: row.id
        }).always(() => {
          this.getDeviceList();
        });
      }).catch(() => {});
    },
    refreshDevice(row){
      let self = this;
      $.get(this.$store.state.baseUrl + "/getDeviceChannel/"+row.gb_id).then(() => {
        self.getDeviceList();
      });
    },
    editDevice(row) {
      this.$refs["deviceEditDlg"].show({
        id: row.id,
        deptid: row.deptid,
        gb_id: row.gb_id,
        devicename: row.devicename,
        channels: row.channels,
        devicetypeid: row.devicetypeid,
        ip: row.ip,
        port: row.port,
        password: row.password,
        installTimeStr: this.formatDay(null,row,row.installTime),
        location: row.location
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
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = 0;
    }
    next();
  },
  beforeRouteUpdate(to, from, next) {
    next();
  }
};
</script>

