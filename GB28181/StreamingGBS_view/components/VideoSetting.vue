<template>
  <div class="box box-primary" :class="{'ismobile':isMobile()}">
    <div class="box-header">
      <h4 class="text-primary text-center">录像计划</h4>
    </div>
    <div class="box-body">
      <div class="tree-block" id="tab-tree-wrapper">
        <el-tree ref="devTree" class="depttree" id="dev-tree" node-key="key" :props="treeProps" :load="treeLoad" show-checkbox
          @check="checkChange" :filter-node-method="treeFilter" lazy highlight-current @node-click="onClickNode">
          <span class="custom-tree-node" slot-scope="{node, data}">
            <span :class="{'text-green': false}">
              <i :class="['fa',{'fa-sitemap':typeof data.subCount!='undefined' && typeof data.channelname == 'undefined',
                'fa-server':data.device && typeof data.channelname == 'undefined',
                'fa-camera':typeof data.channelname != 'undefined'&&!data.type,
                'fa-volume-off':typeof data.channelname != 'undefined'&&data.type===1,
                'fa-exclamation-triangle':typeof data.channelname != 'undefined'&&data.type===2,
                'fa-microphone':typeof data.channelname != 'undefined'&&data.type===3}]"></i>
              <span class="ellipsis" :title="node.label">{{node.label}}</span>
            </span>
          </span>
        </el-tree>
      </div>
      <div class="form-block">
        <div class="times">
          <div class="time-row" v-for="(item,idx) in settingData.content" :key="item.day">
            <div class="time-label">{{item.day|weekZH}}</div>
            <div class="time-value">
              <div class="time-tip" :class="{'choice':timetip.choice}" v-for="(timetip,idx_tip) in item.times" :key="timetip.stime" @click="choiceTime(idx,idx_tip,timetip.choice)">
                <div class="time-tip-hour" :class="{'biger':timetip.stime>9}">{{!isMobile()?timetip.stime:(timetip.stime)%2==0?timetip.stime:""}}</div>
                <div class="line-tip"></div>
              </div>
              <div class="time-tip">
                <div class="time-tip-hour biger">24</div>
                <div class="line-tip"></div>
              </div>
            </div>
          </div>
          <div class="mybtn">
            <button type="submit" class="btn btn-primary" @click="onSubmit()" :disabled="errors.any()" 
              v-if="(hasAnyRole(buttons, userInfo, '813463394333097984')||hasAnyRole(buttons, userInfo, '813463482111492096'))&&settingData.gbId.length"><i class="fa fa-edit"></i>保存</button>
            <button type="submit" class="btn btn-primary" @click="onDel()" :disabled="errors.any()" 
              v-if="hasAnyRole(buttons, userInfo, '813463600520888320')&&settingData.gbId.length"><i class="fa fa-remove"></i>删除</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapState } from "vuex"
export default {
  props: {},
  data() {
    return {
      treeProps: {
        label: (data, node) => {
          var label = data.label;
          if(data.subCount > 0||data.subDeviceCount > 0) {//其下机构或设备数
            label += ` [${(data.subCount||0)+(data.subDeviceCount||0)}]`;
          }else if(data.device&&data.channels>0){
            label += ` [${data.channels}]`;
          }
          return label;
        },
        isLeaf: (data, node) => {//指定节点是否为叶子节点，仅在指定了 lazy 属性的情况下生效
          return !!data.channelname||(data.subCount===0&&data.subDeviceCount===0)||data.channels===0;
        },
        disabled: (data, node) => {
          return false;
        }
      },
      settingData: {gbId:[],content:[]}
    };
  },
  filters: {
    weekZH: function(day) {
      let result = "星期";
      switch (day) {
        case 1:
          result += "一";
          break;
        case 2:
          result += "二";
          break;
        case 3:
          result += "三";
          break;
        case 4:
          result += "四";
          break;
        case 5:
          result += "五";
          break;
        case 6:
          result += "六";
          break;
        case 7:
          result += "日";
          break;
        default:
          break;
      }
      return result;
    }
  },
  computed: {
    ...mapState(['userInfo', 'buttons'])
  },
  mounted() {
    let list = [];
    let test = {///settingData内容样例
      gbId: [{"gb_id":"xxx","type":0}],//id及类型:type（0机构 1设备 2通道）
      content: [{
        day: 1,// 1-7代表周一至周日
        times: [{"stime":0,"etime":2},{"stime":6,"etime":9}]//代表0-2和6-9
      },{
        day: 2,// 1-7代表周一至周日
        times: [{"stime":3,"etime":4},{"stime":6,"etime":7}]//代表3-4和6-7
      }]
    };
    for (let i=0;i<7;i++) {
      let temp = {
        day: i+1,
        times: []
      };
      for (let j=0;j<24;j++) {
        let tip = {
          stime: j,
          etime: j+1,
          choice: false
        };
        temp.times.push(tip);
      }

      list.push(temp);
    }
    this.settingData.content = list;
  },
  methods: {
    getdeptList(params,node, resolve){//获取机构
      $.get(this.$store.state.baseUrl + "/dept/getChildDeptList", params).then(ret => {
        let list = (ret.data||[]).map(v => {
          return Object.assign(v, {
            key: v.gb_id,
            label: v.deptname
          })
        });
        if(node.level===0){//让它默认展开第一级
          resolve(list);
          node.childNodes[0].expanded = true;
          node.childNodes[0].loadData();
        }else if(!!node.data && node.data.subDeviceCount>0){//有设备，去获取设备
          let params = {
            deptid: node.data.deptid,
            sort: "id",
            order: "asc",
          };
          this.getDeviceList(params, node, resolve,list);
        }else{
          resolve(list);
        }
      });
    },
    getDeviceList(params,node, resolve,deptlist){//获取设备
      $.get(this.$store.state.baseUrl + "/deviceInfo/list", params).then(ret => {
        let devicelist = (ret.data||[]).map(v => {
          return Object.assign(v, {
            key: v.gb_id,
            label: v.devicename
          })
        });
        deptlist = deptlist.concat(devicelist);
        resolve(deptlist);
      });
    },
    getChannelList(params,node, resolve){//获取通道
      $.get(this.$store.state.baseUrl + "/deviceChannelInfo/list", params).then(ret => {
        let list = [];
        for (let i = 0; i < ret.data.length; i++) {
          if(!ret.data[i].type){//过滤掉非视频通道----0：代表视频通道  1：代表语音输出通道 2 代表报警通道 3：语音输入通道  4：其他
            list.push(ret.data[i]);
          }
        }
        resolve(list.map(v => {
          return Object.assign(v, {
            key: v.gb_id,
            label: v.channelname
          })
        }));
      });
    },
    treeLoad(node, resolve) {
      if(node.level===0){//获取第一级机构
        let params = {parentid: !!node.data?node.data.deptid:"-1"};
        this.getdeptList(params, node, resolve);
      }else{
        if(!!node.data && typeof node.data.subCount!='undefined'){//获取机构的子机构
          if(node.data.subCount>0){
            let params = {parentid: node.data.deptid};
            this.getdeptList(params, node, resolve);
          }else if(node.data.subDeviceCount>0){
            let params = {
              deptid: node.data.deptid,
              sort: "id",
              order: "asc",
            };
            this.getDeviceList(params, node, resolve,[]);
          }
        }else{
          if(!!node.data && node.data.channels>0){//是设备且有通道，去获取通道
            let params = {
              deviceid: node.data.id,
              sort: "id",
              order: "asc",
            };
            this.getChannelList(params, node, resolve);
          }
        }
      }
    },
    treeFilter(value, data) {
      if (!value) return true;
      return data.key.indexOf(value) !== -1 || data.label.indexOf(value) !== -1;
    },
    checkChange(data, node,) {//当没有加载子级数据而勾选父级时，不会返回子级的数据
      this.settingData.gbId = [];
      node.checkedNodes.forEach(o => {//从上到下一个个下来的
        var a ={gb_id:o.key,type:typeof o.subCount!='undefined'?0:o.device?1:2};
        if(a.type===2)a={d_gb_id:o.d_gb_id,gb_id:o.key,type:typeof o.subCount!='undefined'?0:o.device?1:2};
        this.settingData.gbId.push(a);//目前没有过滤全选下的子节点
      });
      console.log(node,this.settingData.gbId);
    },
    onClickNode(node) {//单击通道节点--加载计划并回显
      if(node.channelname){
        $.get(this.$store.state.baseUrl + "/recordplan/listOne", {
          d_gb_id: node.d_gb_id,
          gbId: node.gb_id
        }).then(ret => {
          this.resetSettingData();
          if(!!ret.data&&!!ret.data.gbId){//有了----编辑回显
            if(!!ret.data.content){
              let backjson = JSON.parse(ret.data.content);
              for (let i = 0; i < backjson.length; i++) {
                let idx = backjson[i].day-1;
                for (let j = 0; j < backjson[i].times.length; j++) {
                  for (let k = backjson[i].times[j].stime; k < backjson[i].times[j].etime; k++) {
                    this.settingData.content[idx].times[k].choice = true;
                  }
                }
              }
            }
          }
        });
      }
    },
    choiceTime(idx,idx_tip,value){//勾选节点-保存的时候以他为准
      console.log(idx,idx_tip,value);
      this.settingData.content[idx].times[idx_tip].choice = !value;
    },
    resetSettingData(){//恢复成默认的空状态
      for (let i = 0; i < this.settingData.content.length; i++) {
        for (let j = 0; j < this.settingData.content[i].times.length; j++) {
          this.settingData.content[i].times[j].choice = false;
        }
      }
    },
    onSubmit() {//保存
      if (!this.userInfo) {
        return true;
      }
      if(!this.settingData.gbId.length){
        this.$message({
          message: "请至少选中一个通道！",
          type: 'warning',
        });
        return;
      }
      let arr = [];
      for (let i = 0; i < this.settingData.content.length; i++) {
        let temp;
        for (let j = 0; j < this.settingData.content[i].times.length; j++) {
          if(this.settingData.content[i].times[j].choice){//选中了
            if(!temp){//第一个时间段
              temp = {
                day:this.settingData.content[i].day,
                times: [{"stime":this.settingData.content[i].times[j].stime,"etime":this.settingData.content[i].times[j].etime}]
              };
            }else{
              if(temp.times[temp.times.length-1].etime==this.settingData.content[i].times[j].stime){//是两个相连的时间段，进行合并
                temp.times[temp.times.length-1].etime = this.settingData.content[i].times[j].etime;
              }else{//不合并
                temp.times.push({"stime":this.settingData.content[i].times[j].stime,"etime":this.settingData.content[i].times[j].etime});
              }
            }
          }
        }
        if(!!temp){
          arr.push(temp);
        }
      }
      if(!arr.length){
        this.$message({
          message: "请至少设置一个时间段！",
          type: 'warning',
        });
      }else{
        let p = {
          gbId: JSON.stringify(this.settingData.gbId),
          content: JSON.stringify(arr)
        }
        console.log({
          gbId: this.settingData.gbId,
          content: arr
        });
        $.post(this.$store.state.baseUrl + '/recordplan/save', p).then(data => {
          if(data.code === 0){
            this.$message({
              message: "保存成功~",
              type: 'success',
            });
          }else{
            this.$message({
              message: data.msg,
              type: 'warning',
            });
          }
        });
      }
    },
    onDel(){//删除
      if (!this.userInfo) {
        return true;
      }
      if(!this.settingData.gbId.length){
        this.$message({
          message: "请至少选中一个通道！",
          type: 'warning',
        });
        return;
      }
      console.log(this.settingData.gbId);
      $.post(this.$store.state.baseUrl + '/recordplan/delete', {gbId: JSON.stringify(this.settingData.gbId)}).then(data => {
        if(data.code === 0){
          this.$message({
            message: "删除成功~",
            type: 'success',
          });
          this.settingData.gbId = [];
          this.resetSettingData();
          this.$refs["devTree"].setCurrentKey(null);
          this.$refs["devTree"].setCheckedNodes([]);
        }else{
          this.$message({
            message: data.msg,
            type: 'warning',
          });
        }
      });
    }
  }
};
</script>

<style lang="less" scoped>
.box{
  .box-body{
    font-size: 14px;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: stretch;
    .tree-block{
      height: 100%;
      width: 300px;
      margin: 0;
      padding-bottom: 10px;
      .depttree{
        height: 100%;
        overflow: auto;
        margin: auto;
        padding: 10px;
        border: 1px solid rgb(216, 216, 216);
      }
    }
    .form-block{
      padding-bottom: 10px;
      flex-grow: 1;
      min-width: 350px;
      height: 100%;
      .times{
        width: 100%;
        height: 100%;
        padding: 10px;
        border: 1px solid rgb(216, 216, 216);
        border-left: none;
        overflow: auto;
        .time-row{
          width: 100%;
          display: flex;
          flex-direction: row;
          justify-content: space-between;
          align-items: center;
          margin-top: 40px;
          .time-label{
            margin: 0 6px;
          }
          .time-value{
            flex-grow: 1;
            display: flex;
            flex-direction: row;
            justify-content: space-between;
            align-items: stretch;
            .time-tip{
              height: 30px;
              flex-grow: 1;
              border: 1px solid rgb(216, 216, 216);
              border-left: none;
              position: relative;
              cursor: pointer;
              &:first-child{
                border-left: 1px solid rgb(216, 216, 216);
              }
              &:last-child{
                border: none;
                width: 0;
                height: 0;
              }
              &.choice{
                background-color: #256fb0;
                border-color: #256fb0;
              }
              .time-tip-hour{
                position: absolute;
                top: -20px;
                top: -23px;
                left: -5px;
                &.biger{
                  left: -8px;
                }
              }
              .line-tip{
                position: absolute;
                height: 5px;
                width: 0;
                left: -1px;
                top: -6px;
                border-left: 1px solid rgb(216, 216, 216);
              }
            }
          }
        }
        .mybtn {
          text-align: center;
          margin-top: 30px;
        }
      }
    }
  }
}
</style>
<style lang="less" scoped>
@media screen and(max-width: 1200px){
  .box {
    .box-body{
      flex-direction: column;
      .tree-block{
        max-height: 30%;
        min-height: 20%;
        height: auto;
        width: 100%;
      }
      .form-block{
        min-height: 70%;
        height: auto;
        width: 100%;
        min-width: unset;
        .times{
          padding: 0 0 10px 10px;
          border: 1px solid #d8d8d8;
          .time-row{
            margin-top: 15px;
            flex-direction: column;
            &:first-child{
              margin-top: 6px;
            }
            .time-label{
              width: 100%;
              margin: 0 0 20px 0;
            }
            .time-value{
              width: 100%;
            }
          }
          .mybtn{
            margin-top: 10px;
          }
        }
      }
    }
  }
}
</style>
<style lang="less" scoped>
.box.ismobile{
  height: 1000px;
  .box-body{
    flex-direction: column;
    .tree-block{
      max-height: 30%;
      min-height: 20%;
      height: auto;
      width: 100%;
    }
    .form-block{
      min-height: 70%;
      height: auto;
      width: 100%;
      min-width: unset;
      .times{
        padding: 0 0 10px 10px;
        border: 1px solid #d8d8d8;
        .time-row{
          margin-top: 15px;
          flex-direction: column;
          &:first-child{
            margin-top: 6px;
          }
          .time-label{
            width: 100%;
            margin: 0 0 20px 0;
          }
          .time-value{
            width: 100%;
          }
        }
        .mybtn{
          margin-top: 10px;
        }
      }
    }
  }
}
</style>

