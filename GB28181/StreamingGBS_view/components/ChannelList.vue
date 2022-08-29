<template>
    <div :style="boxHeight">
        <div class="box box-primary">
          <div class="box-header">
            <button type="button" style="position:absolute;left:10px;top:10px;" class="btn btn-sm btn-primary" @click.prevent="$router.go(-1)">
              <i class="fa fa-chevron-left"></i> 返回
            </button>
            <h4 class="text-primary text-center">通道列表({{devicecode||devicename}})</h4>
          </div>
          <div class="box-body box-search">
            <form class="form-inline" autocomplete="off" spellcheck="false">
              <div class="form-group form-group-sm">
                <label>搜索</label>
                <input type="text" class="form-control" placeholder="关键字" v-model.trim="q" @change="getChannels" @keydown.enter.prevent ref="q">
              </div>
              <span class="hidden-xs">&nbsp;&nbsp;</span>
              <div class="form-group form-group-sm">
                <label>在线状态</label>
                <select class="form-control" v-model.trim="online" @change="getChannels">
                  <option value="">全部</option>
                  <option value="1">在线</option>
                  <option value="0">离线</option>
                </select>
              </div>
              <span class="hidden-xs">&nbsp;&nbsp;</span>
              <div class="form-group form-group-sm">
                <label>通道类型</label>
                <select class="form-control" v-model.trim="type" @change="getChannels">
                  <option value="">全部</option>
                  <option value="0">视频通道</option>
                  <option value="1">语音输出通道</option>
                  <option value="2">报警通道</option>
                  <option value="3">语音输入通道</option>
                  <option value="4">其他</option>
                </select>
              </div>
              <div class="form-group form-group-sm pull-right">
                <div class="input-group input-group-sm" v-if="hasAnyRole(buttons, userInfo, '756091030016753664')">
                  <button type="button" class="btn btn-sm btn-primary" @click.prevent="addChannel()">
                    <i class="fa fa-plus"></i> 添加通道
                  </button>
                </div>
              </div>
            </form>
            <br>
            <el-table :data="channels" class="my-table" height="100%" stripe :default-sort="{prop: 'id', order: 'desc'}" @sort-change="sortChange" v-loading="loading" element-loading-text="加载中...">
              <el-table-column prop="gb_id" label="通道编码" min-width="140" show-overflow-tooltip sortable="custom"></el-table-column>
              <el-table-column prop="channelname" label="通道名称" min-width="140" show-overflow-tooltip></el-table-column>
              <el-table-column prop="status" label="在线状态" min-width="100">
                <template slot-scope="props">
                  <span class="text-success" v-if="props.row.status === 1">在线</span>
                  <span class="text-gray" v-else>离线</span>
                </template>
              </el-table-column>
              <el-table-column prop="type" label="通道类型" min-width="100">
                <template slot-scope="props">
                  <span v-if="props.row.type===0">视频通道</span>
                  <span v-if="props.row.type === 1">语音输出通道</span>
                  <span v-if="props.row.type === 2">报警通道</span>
                  <span v-if="props.row.type === 3">语音输入通道</span>
                  <span v-if="props.row.type === 4">其他</span>
                  <span v-if="props.row.type === null">未设置</span>
                </template>
              </el-table-column>
              <el-table-column prop="ptzEnable" label="是否支持云台" min-width="120">
                <template slot-scope="props">
                  <span class="text-success" v-if="props.row.ptzEnable === 1">支持</span>
                  <span class="text-gray" v-else>不支持</span>
                </template>
              </el-table-column>
              <el-table-column prop="talkEnbale" label="是否支持对讲" min-width="120">
                <template slot-scope="props">
                  <span class="text-success" v-if="props.row.talkEnbale === 1">支持</span>
                  <span class="text-gray" v-else>不支持</span>
                </template>
              </el-table-column>
              <el-table-column label="操作" min-width="110" fixed="right" class-name="opt-group">
                <template slot-scope="props">
                    <div class="btn-group btn-group-xs">
                        <button type="button" class="btn btn-warning" @click.prevent="editChannel(props.row)" v-if="hasAnyRole(buttons, userInfo, '756091457781235712')">
                          <i class="fa fa-edit"></i> 编辑
                        </button>
                        <button type="button" class="btn btn-danger" @click.prevent="removeChannel(props.row)" v-if="hasAnyRole(buttons, userInfo, '756091557672779776')">
                          <i class="fa fa-remove"></i> 删除
                        </button>
                    </div>
                </template>
              </el-table-column>
            </el-table>
          </div>
          <div class="box-footer">
            <el-pagination layout="total,prev,pager,next" :pager-count="5" class="pull-right" :total="total" :page-size.sync="pageSize" :current-page.sync="currentPage" @current-change="getChannels"></el-pagination>
          </div>
        </div>

        <ChannelAddDlg ref="channelAddDlg" @submit="getChannels"></ChannelAddDlg>
        <ChannelEditDlg ref="channelEditDlg" @submit="getChannels"></ChannelEditDlg>
    </div>
</template>

<script>
import _ from "lodash";
import { mapState } from "vuex";
import ChannelAddDlg from 'components/ChannelAddDlg.vue'
import ChannelEditDlg from 'components/ChannelEditDlg.vue'
export default {
  props: {
    deviceid: {
      type: String,
      default: ""
    }
  },
  data() {
    return {
      boxHeight: "height: 100%;",
      q: "",
      online: "",
      type: "",
      total: 0,
      pageSize: 10,
      currentPage: 1,
      sort: "id",
      order: "desc",
      loading: false,
      channels: [],
      recorder: null,
      devicename: '',
      devicecode: ''
    };
  },
  computed: {
    ...mapState(['userInfo', 'buttons']),
  },
  components: {
    ChannelAddDlg,ChannelEditDlg
  },
  mounted() {
    this.getDeviceInfo();
    this.getChannels();
  },
  methods: {
    keyDown(e) {
      if(e.keyCode == 27) {
        this.$el.querySelector('.fa-chevron-left').click();
      }
    },
    isMobile() {
      return videojs.browser.IS_IOS || videojs.browser.IS_ANDROID;
    },
    getChannels() {
      $.get(this.$store.state.baseUrl + "/deviceChannelInfo/list", {
        deviceid: this.deviceid,
        q: this.q,
        page: this.currentPage,
        limit: this.pageSize,
        type: this.type,
        online: this.online,
        sort: this.sort,
        order: this.order
      })
      .then(ret => {
        this.total = ret.count;
        this.channels = ret.data;
        if(this.isMobile()&&ret.data.length>0){
          this.boxHeight = "height:calc(100% + "+ (ret.data.length*30+50) +"px);"
        }
      })
      .always(() => {
      });
    },
    sortChange(data) {
      this.sort = data.prop;
      this.order = data.order == "ascending" ? "asc" : "desc";
      this.getChannels();
    },
    formatName(row, col, cell) {
      if (cell) return cell;
      return "-";
    },
    getDeviceInfo(){
      $.get(this.$store.state.baseUrl + "/deviceInfo/details", {
        id: this.deviceid
      })
      .then(ret => {
        this.devicename = ret.data.devicename;
        this.devicecode = ret.data.gb_id;
      })
      .always(() => {
      });
    },
    removeChannel(row) {
      this.$confirm(`确认删除 ${row.channelname || row.gb_id}`, "提示").then(() => {
        $.post(this.$store.state.baseUrl + "/deviceChannelInfo/delete", {
          id: row.id
        }).always(() => {
          this.getChannels();
        });
      }).catch(() => {});
    },
    editChannel(row) {
      this.$refs["channelEditDlg"].show({
        id: row.id,
        deviceid: row.deviceid,
        gb_id: row.gb_id,
        channelname: row.channelname,
        ptzEnable: row.ptzEnable,
        talkEnbale: row.talkEnbale,
        type: row.type
      });
    },
    addChannel(){
      this.$refs["channelAddDlg"].show({
        deviceid: this.deviceid,
      });
    }
  },
  beforeRouteUpdate(to, from, next) {
    next();
  }
};
</script>

<style lang="less">
.opt-group .cell {
  overflow: visible;
}
</style>



