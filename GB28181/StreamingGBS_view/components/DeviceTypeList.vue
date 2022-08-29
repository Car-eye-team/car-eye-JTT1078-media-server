<template>
  <div :style="boxHeight">
    <div class="box box-primary">
      <div class="box-header">
        <h4 class="text-primary text-center">设备类型列表</h4>
      </div>
      <div class="box-body box-search">
        <form class="form-inline" autocomplete="off" spellcheck="false">
          <div class="form-group form-group-sm">
            <label>搜索</label>
            <input type="text" class="form-control" placeholder="关键字" v-model.trim="q" @change="getDeviceTypeList" @keydown.enter.prevent ref="q">
          </div>
          <div class="form-group form-group-sm pull-right">
            <div class="input-group input-group-sm" v-if="hasAnyRole(buttons, userInfo, '792074049139376128')">
              <button type="button" class="btn btn-sm btn-primary" @click.prevent="$refs['roleAddDlg'].show()">
                <i class="fa fa-plus"></i> 添加设备类型
              </button>
            </div>
          </div>
        </form>
        <br>
        <el-table class="my-table" height="100%" :data="datas" stripe :default-sort="{prop: 'id', order: 'desc'}" @sort-change="sortChange">
          <el-table-column prop="typename" label="设备类型名称" min-width="140" :formatter="formatName" show-overflow-tooltip>
            <template slot-scope="props">
              <span>{{props.row.typename}}</span>
            </template>
          </el-table-column>
          <el-table-column prop="protocol" label="协议类型" min-width="120" sortable="custom" show-overflow-tooltip>
            <template slot-scope="props">
              <span class="text-primary" v-if="props.row.protocol === 0">GB28181-2011</span>
              <span class="text-primary" v-else-if="props.row.protocol === 1">GB28181-2016</span>
              <span class="text-primary" v-else-if="props.row.protocol === 2">ONVIF</span>
              <span class="text-primary" v-else-if="props.row.protocol === 4">其它</span>
              <span class="text-primary" v-else>-</span>
            </template>
          </el-table-column>
          <el-table-column prop="company" label="所属厂家" min-width="100" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="videoFormat" label="视频格式" min-width="100" sortable="custom">
            <template slot-scope="props">
              <span class="text-primary" v-if="props.row.videoFormat === 0">H264</span>
              <span class="text-primary" v-else-if="props.row.videoFormat === 1">H265</span>
              <span class="text-primary" v-else>-</span>
            </template>
          </el-table-column>
          <el-table-column prop="videoFps" label="视频帧率" min-width="100" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="videoResolution" label="视频分辨率" min-width="100" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="audioFormat" label="音频格式" min-width="100" sortable="custom">
            <template slot-scope="props">
              <span class="text-primary" v-if="props.row.audioFormat === 0">aac</span>
              <span class="text-primary" v-else-if="props.row.audioFormat === 1">G711a</span>
              <span class="text-primary" v-else-if="props.row.audioFormat === 2">G711U</span>
              <span class="text-primary" v-else-if="props.row.audioFormat === 3">G726-16bit</span>
              <span class="text-primary" v-else-if="props.row.audioFormat === 4">G726-24bit</span>
              <span class="text-primary" v-else-if="props.row.audioFormat === 5">G726-32bit</span>
              <span class="text-primary" v-else-if="props.row.audioFormat === 6">G726-40bit</span>
              <span class="text-primary" v-else-if="props.row.audioFormat === 7">G722</span>
              <span class="text-primary" v-else-if="props.row.audioFormat === 8">g729</span>
              <span class="text-primary" v-else-if="props.row.audioFormat === 9">PCMA</span>
              <span class="text-primary" v-else-if="props.row.audioFormat === 10">其它</span>
              <span class="text-primary" v-else>-</span>
            </template>
          </el-table-column>
          <el-table-column prop="audioChannels" label="音频通道" min-width="100" sortable="custom">
            <template slot-scope="props">
              <span class="text-primary" v-if="props.row.audioChannels === 0">单通道</span>
              <span class="text-primary" v-else-if="props.row.audioChannels === 1">立体声</span>
              <span class="text-primary" v-else>-</span>
            </template>
          </el-table-column>
          <el-table-column prop="audioFreq" label="音频采样频率" min-width="110" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="audioFormatBits" label="音频帧采样位数" min-width="120" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="heartbeatTime" label="心跳时间" min-width="120" :formatter="formatName" show-overflow-tooltip></el-table-column>
          <el-table-column prop="heartbeatTimeOutCount" label="心跳超时次数" min-width="120" :formatter="formatName" show-overflow-tooltip></el-table-column>

          <el-table-column prop="createDate" label="创建时间" min-width="160" sortable="custom" :formatter="formatDate" show-overflow-tooltip></el-table-column>
          <el-table-column label="操作" min-width="160" fixed="right">
            <template slot-scope="props">
                <div class="btn-group btn-group-xs">
                    <button type="button" class="btn btn-warning" @click.prevent="editDeviceType(props.row)" v-if="hasAnyRole(buttons, userInfo, '792074242438070272')">
                      <i class="fa fa-edit"></i> 编辑
                    </button>
                    <button type="button" class="btn btn-danger" @click.prevent="removeDeviceType(props.row)" v-if="hasAnyRole(buttons, userInfo, '792074331927740416')">
                      <i class="fa fa-remove"></i> 删除
                    </button>
                </div>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div class="box-footer">
        <el-pagination layout="total,prev,pager,next" :pager-count="5" class="pull-right" :total="total" :page-size.sync="pageSize" :current-page.sync="currentPage" @current-change="getDeviceTypeList"></el-pagination>
      </div>
    </div>
    
    <DeviceTypeAddDlg ref="roleAddDlg" @submit="getDeviceTypeList"></DeviceTypeAddDlg>
    <DeviceTypeEditDlg ref="roleEditDlg" @submit="getDeviceTypeList"></DeviceTypeEditDlg>
  </div>
</template>

<script>
import _ from "lodash";
import url from "url";
import DeviceTypeEditDlg from 'components/DeviceTypeEditDlg.vue'
import DeviceTypeAddDlg from 'components/DeviceTypeAddDlg.vue'
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
      sort: "id",
      order: "desc",
      datas: [],
      loading: false,
    };
  },
  components: {
    DeviceTypeEditDlg,DeviceTypeAddDlg
  },
  computed: {
    ...mapState(["userInfo", "buttons"])
  },
  mounted() {
    this.getDeviceTypeList();
  },
  methods: {
    getDeviceTypeList() {
      this.loading = true;
      $.get(this.$store.state.baseUrl + "/deviceType/list", {
        q: this.q,
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
      this.getDeviceTypeList();
    },
    removeDeviceType(row) {
      this.$confirm(`确认删除 ${row.typename}`, "提示").then(() => {
        $.post(this.$store.state.baseUrl + "/deviceType/delete", {
          id: row.id
        }).always(() => {
          this.getDeviceTypeList();
        });
      }).catch(() => {});
    },
    editDeviceType(row) {
      this.$refs["roleEditDlg"].show({
        id: row.id,
        protocol: row.protocol,
        typename: row.typename,
        company: row.company,
        videoFormat: row.videoFormat,
        videoFps: row.videoFps,
        videoResolution: row.videoResolution,
        audioFormat: row.audioFormat,
        audioChannels: row.audioChannels,
        audioFreq: row.audioFreq,
        audioFormatBits: row.audioFormatBits,
        heartbeatTime: row.heartbeatTime,
        heartbeatTimeOutCount: row.heartbeatTimeOutCount,
      });
    },
    setAuthority(row){
      this.$refs["setAuthority"].show({
        id: row.id,
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

