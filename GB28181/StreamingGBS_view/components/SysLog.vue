<template>
  <div :style="boxHeight">
    <div class="box box-primary">
      <div class="box-header">
        <h4 class="text-primary text-center">日志列表</h4>
      </div>
      <div class="box-body box-search">
        <form class="form-inline" autocomplete="off" spellcheck="false">
          <span class="hidden-xs">&nbsp;&nbsp;</span>
          <div class="form-group form-group-sm date-from-control">
            <label>开始时间</label>
            <el-date-picker class="form-control date-input" v-model.trim="startTime" type="datetime" @change="getPageData" placeholder="开始时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
          </div>
          <span class="hidden-xs">&nbsp;&nbsp;</span>
          <div class="form-group form-group-sm date-from-control">
            <label>结束时间</label>
            <el-date-picker class="form-control date-input" v-model.trim="endTime" type="datetime" @change="getPageData" placeholder="结束时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
          </div>
        </form>
        <br>
        <el-table class="my-table" height="100%" :data="pageList" stripe @sort-change="sortChange" v-loading="loading" element-loading-text="加载中...">
          <el-table-column prop="loginName" label="用户" width="80" show-overflow-tooltip></el-table-column>
          <el-table-column prop="operationContent" label="用途" width="150" show-overflow-tooltip></el-table-column>
          <el-table-column prop="url" label="地址" width="350" show-overflow-tooltip></el-table-column>
          <el-table-column prop="method" label="请求方式" width="80" show-overflow-tooltip></el-table-column>
          <el-table-column prop="parameter" label="请求参数" min-width="150" show-overflow-tooltip></el-table-column>
          <el-table-column prop="result" label="返回结果" min-width="200" show-overflow-tooltip></el-table-column>
          <el-table-column prop="startTime" label="操作时间" :formatter="formatTime" width="160" show-overflow-tooltip></el-table-column>
        </el-table>
      </div>
      <div class="box-footer">
        <el-pagination layout="total,prev,pager,next" :pager-count="pageBtnNum" class="pull-right" :total="total" :page-size.sync="pageSize" :current-page.sync="currentPage" @current-change="getPageData"></el-pagination>
      </div>
    </div>
  </div>
</template>

<script>
import _ from "lodash";
export default {
  data() {
    return {
      boxHeight: "height: 100%;",
      total: 0,
      pageSize: 20,
      currentPage: 1,
      sort: "time",
      order: "desc",
      loading: false,
      pageList: [],
      startTime: "",
      endTime: "",
    };
  },
  mounted() {
    // this.startTime = this.formatTime(new Date().getTime(),"yyyy-MM-dd")+" 00:00:00";
    // this.endTime = this.formatTime(new Date().getTime(),"yyyy-MM-dd")+" 23:59:59";
    this.getPageData();
  },
  methods: {
    formatTime(row){//时间格式过滤器
      let date = row.startTime, fmt="yyyy-MM-dd HH:mm:ss";
      if(!date){
        return "";
      }
      if(typeof date == "string"&&date.indexOf("-")==-1&&date.indexOf("/")==-1&&date.indexOf(".")==-1&&date.indexOf(":")==-1&&date.indexOf(" ")==-1){
        date = parseInt(date);
      }
      date = new Date(date);
      // 返回处理后的值
      if (/(y+)/.test(fmt)) {
        fmt = fmt.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length))
      }
      let o = {
        'M+': date.getMonth() + 1,
        'd+': date.getDate(),
        'h+': date.getHours(),
        'H+': date.getHours(),
        'm+': date.getMinutes(),
        's+': date.getSeconds()
      }
      for (let k in o) {
        if (new RegExp(`(${k})`).test(fmt)) {
          let str = o[k] + ''
          fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? str : ('00' + str).substr(str.length))
        }
      }
      return fmt
    },
    getPageData() {
      this.loading = true;
      $.get(this.$store.state.baseUrl + "/user/log/findPage", {
        page: this.currentPage,
        limit: this.pageSize,
        startTime: this.startTime,
        endTime: this.endTime
      }).then(ret => {
        this.total = ret.count;
        this.pageList = ret.data;
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
      this.getPageData();
    }
  },
  beforeRouteUpdate(to, from, next) {
    next();
  }
};
</script>

<style>
.date-from-control .date-input{
  border: 0;
}
.date-from-control .date-input .el-input__inner{
  margin: -5px 0 0 -10px;
  height: 30px;
}
.date-from-control .el-input__icon{
  line-height: 30px;
}
</style>