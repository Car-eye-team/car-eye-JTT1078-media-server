<template>
  <div class="the-box" :class="{'showLYT':!isMobile()}" id="thebox">
    <div class="col-lg-3 col-md-3 depttree" id="depttree">
      <div class="tree-box" id="tab-tree-wrapper">
        <el-tree ref="devTree" class="flow-tree outbox" id="dev-tree" node-key="key" :props="treeProps" :load="treeLoad"
          style="overflow:auto;margin:auto;" :filter-node-method="treeFilter" lazy :default-expanded-keys="defaultExpandedKeys"
          @node-click="treeNodeClick" @node-contextmenu="treeNodeRightClick">
            <span class="custom-tree-node" slot-scope="{node, data}">
              <span>
                <i :class="['fa', {'fa-sitemap':typeof data.parentid != 'undefined'&&typeof data.channelname == 'undefined',
                  'fa-server': data.device && typeof data.channelname == 'undefined',
                  'fa-camera channeloffline':typeof data.channelname != 'undefined' && data.status === 0 && !data.type,
                  'fa-camera channelonline':typeof data.channelname != 'undefined' && data.status === 1 && !data.type,
                  'fa-volume-off channeloffline':typeof data.channelname != 'undefined' && data.status === 0 && data.type===1,
                  'fa-volume-off channelonline':typeof data.channelname != 'undefined' && data.status === 1 && data.type===1,
                  'fa-exclamation-triangle channeloffline':typeof data.channelname != 'undefined' && data.status === 0 && data.type===2,
                  'fa-exclamation-triangle channelonline':typeof data.channelname != 'undefined' && data.status === 1 && data.type===2,
                  'fa-microphone channeloffline':typeof data.channelname != 'undefined' && data.status === 0 && data.type===3,
                  'fa-microphone channelonline':typeof data.channelname != 'undefined' && data.status === 1 && data.type===3}]"></i>
                <span class="ellipsis" :title="node.label">{{node.label}}</span>
              </span>
            </span>
        </el-tree>
      </div>
      <div class="select">
        <div class="_label">是否录像</div>
        <el-select class="_value" id="input-record" name="record" size="small" v-model.trim="record" placeholder="1" v-validate="'required'">
          <el-option class="options marleft" v-for="(item, index) in recordListLive" :key="index" :value="item.value" :label="item.label"></el-option>
        </el-select>
      </div>
      <div class="ctr-block" v-if="!isMobile()">
        <LiveYuntai ref="liveYuntai" id="liveyuntai" :params="yuntaiCtrData"></LiveYuntai>
      </div>
      <VueContextMenu class="right-menu" :target="contextMenuTarget" :show="contextMenuVisible" @update:show="(show) => contextMenuVisible = show">
        <a href="javascript:;" @click="playAll" v-show="popup==1" style="color: #000000;">
          <i class="fa fa-caret-square-o-right"></i>预览全部
        </a>
        <a href="javascript:;" @click="refresh()" v-show="popup==1" style="color: #000000;">
          <i class="fa fa-refresh"></i>刷新状态
        </a>
        <a href="javascript:;" @click="refresh()" v-show="popup==3" style="color: #000000;">
          <i class="fa fa-refresh"></i>刷新状态
        </a>
        <a href="javascript:;" @click="playOne()" style="color: #000000;" v-show="popup==2">
          <i class="fa fa-camera"></i> 通道预览
        </a>
        <a href="javascript:;" @click="voiceintercom" style="color: #000000;" v-show="popup==2">
          <i class="fa fa-microphone"></i> 开启对讲
        </a>
        <a href="javascript:;" @click="gbControl" style="color: #000000;" v-show="popup==2">
          <i class="fa fa-hand-o-right"></i> 设备控制
        </a>
      </VueContextMenu>
    </div>
    <div class="col-lg-9 col-md-9 screenbox" id="playDiv">
      <div class="tool">
        <ul>
          <li class="btnmenuli" v-for="list in playerBtnGroup" :key="list.num" @click.prevent="setPlayerLength(list.num)" :style="{'display':isMobile()?'block':'none'}">
            <img class="btnmenulist" :src="list.img" :style="{'display':list.num==1&isMobile()||list.num==4&isMobile()?'block':'none'}"/>
          </li>
          <li class="btnmenuli" v-for="list in playerBtnGroup" :key="list.num" @click.prevent="setPlayerLength(list.num)" :style="{'display':!isMobile()?'block':'none'}">
            <img class="btnmenulist" :src="list.img"/>
            <div class="btnmenuli-tip">分{{list.num}}屏</div>
          </li>
          <li class="btnmenuli" @click="isshowstop" v-if="isMobile()">
            <img class="btnmenulist" src="../assets/images/closebtn.png"/>
            <VueContextMenu class="right-menu" :show="showstop">
              <a href="javascript:;" @click="stopAll" style="color: #000000;">
                关闭所有视频
              </a>
            </VueContextMenu>
          </li>
          <li class="btnmenuli" @click="stopAll" v-else>
            <img class="btnmenulist" src="../assets/images/closebtn.png"/>
            <div class="text">关闭</div>
            <div class="btnmenuli-tip tostop">关闭所有视频</div>
          </li>
        </ul>
      </div>
      <div class="view-list" id="list-box">
        <div class="video-show" id="car-eye-player">
        </div>
      </div>
    </div>
    
    <VoiceInterCom ref="voiceInterCom" id="voiceintercom"></VoiceInterCom>
    <LiveGbControl ref="liveGbControl" id="liveGbControl"></LiveGbControl>
  </div>
</template>
<script>
    import $ from "jquery";
    import "assets/css/classic.css";
    import "assets/css/style.css";
    import {
      mapActions
    } from "vuex"
    import {component as VueContextMenu} from '@xunlei/vue-context-menu'
    import LiveYuntai from 'components/LiveYuntai.vue'
    import LiveGbControl from 'components/LiveGbControl.vue'
    import VoiceInterCom from 'components/VoiceInterCom.vue'
    import con1 from "../assets/images/1.png";
    import con2 from "../assets/images/2.png";
    import con4 from "../assets/images/4.png";
    import con9 from "../assets/images/9.png";
    import con16 from "../assets/images/16.png";
    import con25 from "../assets/images/25.png";
    import con36 from "../assets/images/36.png";
    import con64 from "../assets/images/64.png";
    import logo from "../assets/images/logo.png";
    import fastClick from 'fastclick';

    fastClick.attach(document.body);
    export default {
      components: {VueContextMenu, LiveYuntai, VoiceInterCom, LiveGbControl},
      data() {
        return {
          playerLength: this.isMobile() ? 1 : 4,
          lastnum: 0,
          protocol: "",
          nodedeviceid: null,
          nodechannelcode: null,
          nodechannelid: null,
          nodechannelstatus: null,
          nodeprotocol: null,
          nodechannelname: null,
          vedioType: 0,
          popup: 0,
          contextMenuTarget: null,
          contextMenuVisible: false,
          contextMenuNodeData: null,
          treeClickCount: 0,
          d_gb_id: '',
          channelcount: 0,
          showstop: false,
          terminals: new Array(),//用于存放播放中的设备信息[{deviceid,id,boxId,d_gb_id,gb_id,channelname,status,index,streamid,sinkid}...]
          logoimg: logo,
          defaultExpandedKeys: [],
          record: 0,
          recordListLive: [{value: 1,label: '是'},{value: 0,label: '否'}],
          treeProps: {
            label: (data, node) => {
              var label = "";
              if (node.level === 1) {
                // 第一层lable为src_name字
                node.deptid = data.deptid;
                node.deptname = data.deptname;
                label = data.deptname;
                label += ` [${Number(data.subCount) + Number(data.subDeviceCount)}]`;
              } else {
                if (typeof data.devicename != "undefined") {
                  node.id = data.id;
                  node.devicename = data.devicename;
                  node.channelcount = data.channels;
                  node.status = data.status;
                  label = data.deptname;
                  if (data.channels > 0) {
                    label += ` [${data.channels}]`;
                  }
                } else if (typeof data.channelname != "undefined") {
                  node.d_gb_id = data.d_gb_id;
                  node.gb_id = data.gb_id;
                  node.channelname = data.channelname;
                  node.deviceId = data.deviceid;
                  node.status = data.status;
                  label = data.deptname;
                } else {
                  node.deptid = data.deptid;
                  node.deptname = data.deptname;
                  label = data.deptname;
                  if (Number(data.subCount) + Number(data.subDeviceCount) > 0) {
                    label += ` [${data.subCount + data.subDeviceCount}]`;
                  }
                }
              }
              return label;
            },
            isLeaf: (data, node) => {
              if (typeof data.channelname != "undefined") {
                return true;
              } else {
                if (typeof data.devicename != "undefined") {
                  return data.channels == 0;
                } else {
                  return (Number(data.subCount) + Number(data.subDeviceCount)) == 0;
                }
              }
            },
            disabled: (data, node) => {
              return false;
            }
          },
          keepSiv: null,
          currentStopIndex: null,
          currentChoiceScreen: "",//当前选中的窗口
          yuntaiCtrData: {
            deviceId: "",
            d_gb_id: "",
            channelId: ""
          }
        };
      },
      computed: {
        playerBtnGroup() {
          var list = [{
            num: 1,
            img: con1
          }, {
            num: 2,
            img: con2
          }, {
            num: 4,
            img: con4
          }, {
            num: 9,
            img: con9
          }, {
            num: 16,
            img: con16
          }, {
            num: 25,
            img: con25
          }, {
            num: 36,
            img: con36
          }, {
            num: 64,
            img: con64
          }];
          return list;
        }
      },
      mounted() {
        if (this.isMobile()) {//屏幕跟树的位置互换
          this.$el.querySelector("#depttree").before(this.$el.querySelector("#playDiv"));
          $("#thebox").addClass("ismobile");
        }
        this.contextMenuTarget = document.querySelector('#tab-tree-wrapper');
        $("#car-eye-player").html("");
        for (let i = 0; i < 64; i++) {
          $("#car-eye-player").append("<div class='col-smxx-8 listerclick' id='player" + i + "' style='display:none;'></div>");
          this.playerrestart("", "player" + i, i);
          $("#player" + i).find("div.pe-logo").remove();
        }
        this.setPlayerLength(this.playerLength);
        this.initPlayerEvent();
      },
      methods: {
        ...mapActions([
          "keepLogin"
        ]),
        playerrestart(fileurl, playerid, val, isrestart) {//初始化播放器
          var container = document.getElementById(playerid);
          var ui = careyeplay.ui(val);
          if(!isrestart){
            this.terminals.push({
              index: val,
              boxId: playerid
            });
          }
          ui.setup(container, {
            autoplay: false,
            // level: 'error',    // debug, log, warn, error
            file: fileurl,
            lowlatency: true,//false为服务器的点播功能
            bufferLength: 0,//0.5,       // sec.
            maxBufferLength: 1.5,    // sec.
            maxRetries: 0,
            mode: "live", //live
            module: 'FLV',
            objectfit: "fill",
            retrying: 200,
            loader: {
              name: 'auto',
              mode: 'cors',        // cors, no-cors, same-origin
              credentials: 'omit', // omit, include, same-origin
            },
            service: {
              script: 'js/sw.js',
              scope: 'js/',
              enable: false,
            },
            plugins: [
              {
                kind: 'Logo',
                visibility: false
              },{
                kind: 'Poster',
                file: this.logoimg,
                objectfit: 'contain', // fill, contain, cover, none, scale-down
                visibility: true
              },{
                kind: 'Display',
                layout: '',
                ondouBleclick: 'fullscreen',
                visibility: true
              },{
                kind: 'Controlbar',
                layout: '||[Slider:timebar=Preview]|[Button:play=播放][Button:pause=暂停][Button:stop=停止][Button:reload=重新加载][Button:capture=拍照][Button:video=录像][Button:mute=静音][Button:unmute=取消静音][Slider:volumebar=80][Button:fullscreen=全屏][Button:exitfullscreen=退出全屏]',
                autohide: false,
                visibility: true,
              },{
                kind: 'ContextMenu',
                visibility: false,
                items: [{
                  mode: '',
                  icon: 'image/github.png',
                  text: 'studease',
                  shortcut: '',
                  handler: function () {}
                }]
              }
            ]
          });
          ui.removeEventListener('error');
          ui.addEventListener('error', console.error);
          let that = this;
          ui.removeEventListener('screenshot');
          ui.addEventListener('screenshot', function(e){
            let arr = e.data.image.split(',');
            let ret = arr[0].match(/^data:(image\/(.+));base64$/);
            if (ret === null) {
              console.error('The string did not match the expected pattern.');
              return;
            }
            let link = document.createElement('a');
            link.href = e.data.image;
            link.download = that.terminals[e.api].channelname+'.' + ret[2];
            link.click();
          });
          ui.removeEventListener('ended');
          ui.addEventListener('ended',function(res) {
            console.log(res)
            that.currentStopIndex = res.api;
          });
          
          ui.removeEventListener('statsupdate');
          let lastTimestampType = "";//当播放器状态改变时，时间戳要重新计算。主要用在waiting和seeking处
          let timestampSend = 0;//计算toReSendApiTime的时间戳
          let toReSendApiTime = 10;//播放器waiting状态n秒后重新发送播放请求
          let reloadingMax = 50;//播放器连续拉流次数，超过后不再重复请求接口拉流了
          let refreshT = 2;//refreshT秒刷一次播放速度
          let timestamp = 0;//计算refreshT的时间戳
          let totalBytesReceived = 0;//总字节数
          ui.addEventListener("statsupdate", function(stats){
            let time = new Date().getTime();
            if(!!stats.target.state()){
              if(!timestampSend){//设置上一个时间戳，会结合当前时间戳进行计算
                timestampSend = time;
              }
              if(lastTimestampType!=stats.target.state()&&stats.target.state()=="playing"){
                // console.log("播放器恢复了播放了-----------",val);
                lastTimestampType = stats.target.state();
                // that.removeWaitingImg(val);
              }
              if(stats.target.state()=="waiting"||stats.target.state()=="seeking"){
                if(!lastTimestampType){//记录上一次的播放器状态
                  lastTimestampType = stats.target.state();
                }
                if(lastTimestampType==stats.target.state()){//停在waiting或者seeking状态了
                  if((time-timestampSend)>toReSendApiTime*1000&&reloadingMax>=0){//播放器waiting状态n秒后重新发送播放请求
                    if(reloadingMax==0){
                      //doing stop
                      that.stopPlayApi(val);
                    }else{
                      // console.log("播放器reload+++++++++++++++++++",val);
                      // that.setWaitingImg(val);
                      // ui.reload();
                      timestampSend = time;
                      reloadingMax--;
                    }
                  }
                }else{
                  lastTimestampType = stats.target.state();
                  timestampSend = time;
                }
              }else if(stats.target.state()!="error"&&stats.target.state()!="ended"){
                timestampSend = time;
                reloadingMax = 50;
              }
            }
            // console.log("接收的总字节数==",stats.data.stats);
            if(!!stats.data.stats&&stats.data.stats.BytesReceivedPerSecond){
              $("#player" + val).find("#speed"+val).text((stats.data.stats.BytesReceivedPerSecond/1024).toFixed(2)+"K/S");
            }else if(!!stats.data.stats.BytesReceived){
              // console.log("接收的总字节数==",stats.data.stats.BytesReceived);
              if((time-timestamp)>refreshT*1000){//refreshT秒刷一次速度
                let speed = (stats.data.stats.BytesReceived-totalBytesReceived)/(time-timestamp);
                totalBytesReceived = stats.data.stats.BytesReceived;
                timestamp = time;
                if(speed>0){
                  $("#player" + val).find("#speed"+val).text(speed.toFixed(2)+"K/S");
                }
              }
            }
          });
        },
        setPlayerLength(playerNum) {//布局分屏
          if (this.isMobile()) {
            if (playerNum > 4) {
              this.$message({
                type: 'error',
                message: "手机端最多支持四个同时播放！"
              })
              return;
            }
          }
          if (playerNum == this.lastnum) {
            return;
          }
          for (var i = 0; i < playerNum; i++) {
            $("#player" + i).removeAttr("style");
            if (playerNum == 1) {
              $("#player" + i).attr("class", "col-sm-12 col-xs-12 col-md-12 col-lg-12 listerclick");
              $("#player" + i).css("height", "100%");
            } else if (playerNum == 2) {
              $("#player" + i).attr("class", "col-sm-6 col-xs-6 col-md-6 col-lg-6 listerclick");
              $("#player" + i).css("height", "100%");
            } else if (playerNum == 4) {
              $("#player" + i).attr("class", "col-sm-6 col-xs-6 col-md-6 col-lg-6 listerclick");
              $("#player" + i).css("height", "50%");
            } else if (playerNum == 9) {
              $("#player" + i).attr("class", "col-sm-4 col-xs-4 col-md-4 col-lg-4 listerclick");
              $("#player" + i).css("height", "33.33333%");
            } else if (playerNum == 16) {
              $("#player" + i).attr("class", "col-sm-3 col-xs-3 col-md-3 col-lg-3 listerclick");
              $("#player" + i).css("height", "25%");
            } else if (playerNum == 25) {
              $("#player" + i).attr("class", "col-smxx-5 listerclick");
              $("#player" + i).css("height", "20%");
            } else if (playerNum == 36) {
              $("#player" + i).attr("class", "col-sm-2 col-xs-2 col-md-2 col-lg-2 listerclick");
              $("#player" + i).css("height", "16.666667%");
            } else if (playerNum == 64) {
              $("#player" + i).attr("class", "col-smxx-8 listerclick");
              $("#player" + i).css("height", "12.5%");
            }
          }
          for (let i = playerNum; i < 64; i++) {
            $("#player" + i).css("display", "none");
          }
          this.lastnum = playerNum;
          this.playerLength = playerNum;
        },
        initPlayerEvent(){
          let that = this;
          $("#car-eye-player .pe-controlbar").find(".pe-button.stop").click(function(e){
            e.stopPropagation();    //  阻止事件冒泡
            that.stopPlayApi(that.currentStopIndex);
          });
          $("#car-eye-player .pe-controlbar").find(".pe-button.video").click(function(e){
            e.stopPropagation();  //  阻止事件冒泡
            let boxId = e.target.parentNode.parentNode.parentNode.parentNode.parentNode.id;
            let screenIdx = that.terminals.findIndex(_=>_.boxId==boxId);
            if(screenIdx>-1&&e&&e.target&&e.target.classList){
              if(e.target.className.indexOf("ing")>-1&&that.terminals[screenIdx].sinkid){
                e.target.classList.remove("ing");
                $(e.target.childNodes[0]).text("录像");
                let params_ = {
                  sinkid: that.terminals[screenIdx].sinkid,
                  dGbId: that.terminals[screenIdx].d_gb_id,
                  gbId: that.terminals[screenIdx].gb_id
                };
                $.post(that.$store.state.baseUrl + '/stop/video', params_).then(ret => {
                    if(!ret.code){
                      that.terminals[screenIdx].sinkid = "";
                      if(ret.data){
                        let filename = ret.data.split("/");
                        filename = filename[filename.length-1].split(".")[0];
                        that.downloadF({url:"https://"+ret.data,filename:filename});
                      }
                    }else{
                      that.$message({
                        message: data.msg,
                        type: 'warning',
                      });
                    }
                });
              }else if(e.target.className.indexOf("ing")==-1&&that.terminals[screenIdx].streamid){
                e.target.classList.add("ing");
                $(e.target.childNodes[0]).text("停止录像");
                $.post(that.$store.state.baseUrl + '/start/video', {streamid: that.terminals[screenIdx].streamid}).then(ret => {
                    if(!ret.code){
                      that.terminals[screenIdx].sinkid = ret.data;
                    }else{
                      that.$message({
                        message: data.msg,
                        type: 'warning',
                      });
                    }
                });
              }
            }  
          });
          $("#car-eye-player .listerclick").click(function(e){
            e.stopPropagation();    //  阻止事件冒泡
            if(e.currentTarget.parentNode.children.length>0){
              for (let i = 0; i < e.currentTarget.parentNode.children.length; i++) {
                if(e.currentTarget.parentNode.children[i].id===e.currentTarget.id){
                  if(e.currentTarget.parentNode.children[i].className.indexOf("choice")==-1){
                    e.currentTarget.parentNode.children[i].className += " choice";
                  }
                }else if(e.currentTarget.parentNode.children[i].className.indexOf("choice")>-1){
                  e.currentTarget.parentNode.children[i].className = e.currentTarget.parentNode.children[i].className.replace("choice","");
                }
              }
            }
            that.clickScreen(parseInt(e.currentTarget.id.split("player")[1]));
          });
        },
        setWaitingImg(val){//设置等待中的图片
          if(!document.getElementById("img_"+val)){
            var api = careyeplay(val);
            var video = api.element();
            var scale = 1;
            var canvas = document.createElement("canvas");
            canvas.width = video.videoWidth * scale;
            canvas.height = video.videoHeight * scale;
            canvas.getContext('2d').drawImage(video, 0, 0, canvas.width, canvas.height);
            var img = document.createElement("img");
            img.crossOrigin = 'anonymous';
            img.src = canvas.toDataURL("image/png");
            img.id="img_"+val;
            img.className="waitingImg";
            let theId = "player"+val;
            img.onload = function(){
              let list = document.getElementById(theId).childNodes;
              for (let i = 0; i < list.length; i++) {
                if(list[i].className.indexOf("pe-ui-classic")>-1){
                  list[i].appendChild(img);
                  break;
                }
              }
            }
          }
        },
        removeWaitingImg(val){//移除等待中的图片
          setTimeout(function(){
            let img = document.getElementById("img_"+val);
            if(!!img)img.remove();
          },500);
        },
        downloadF({url,filename}){
          /**
          * 下载文件 - 带进度监控
          * @param url: 文件请求路径
          * @param filename: 保存的文件名
          **/
          // console.log(url,filename);
          var xhr = new XMLHttpRequest();
          xhr.open("get", url, true);
          xhr.responseType = "blob";
          xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded; charset=UTF-8");
          xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
              if(xhr.status === 200){
                if (typeof window.chrome !== 'undefined') {
                  // Chrome version
                  var link = document.createElement('a');
                  link.href = window.URL.createObjectURL(xhr.response);
                  link.download = filename;
                  link.click();
                } else if (typeof window.navigator.msSaveBlob !== 'undefined') {
                  // IE version
                  var blob = new Blob([xhr.response], { type: 'application/force-download' });
                  window.navigator.msSaveBlob(blob, filename);
                } else {
                  // Firefox version
                  var file = new File([xhr.response], filename, { type: 'application/force-download' });
                  window.open(URL.createObjectURL(file));
                }
              }
            }
          };
          // FormData
          //var formData = new FormData();
          var paramsStr = '';
          if(paramsStr) paramsStr = paramsStr.substring(1);
          xhr.send(paramsStr);
        },
        isshowstop() {//关闭所有视频按钮的显示隐藏
          if (this.showstop) {
            this.showstop = false;
          } else {
            this.showstop = true;
          }
        },
        isHttps(){
            const ishttps = 'https:' == document.location.protocol ? true : false;
            var isUrl = 'https';
            if(ishttps) {
               return true;
            } else {
              return false;
            }

        },
        playAll() {//预览该车辆下的全部摄像头
          var self = this;
          $.get(self.$store.state.baseUrl + "/deviceChannelInfo/list", {//获取该车辆下的全部摄像头
            deviceid: self.nodedeviceid,
            q: "",
            online: "",
            sort: "id",
            order: "asc"
          }).then(ret => {
            var channellist = [];
            let maxI = self.playerLength;
            for (let i = 0; i < ret.data.length; i++) {//过滤掉非视频通道   0：代表视频通道  1：代表语音输出通道 2 代表报警通道 3：语音输入通道  4：其他
              if(!ret.data[i].type){
                channellist.push(ret.data[i]);
                let screenIdx = self.terminals.findIndex(_=>_.gb_id===ret.data[i].gb_id &&_.d_gb_id===ret.data[i].d_gb_id);
                if(screenIdx==-1){//代表这个通道不在播放中
                  let _i = self.terminals.findIndex(_=>!_.gb_id);//获取最靠前的未使用窗口
                  maxI = _i;
                  if(_i==-1){
                    break;
                  }
                  let temp = {
                    deviceid: ret.data[i].deviceid,
                    id: ret.data[i].id,
                    gb_id: ret.data[i].gb_id,
                    d_gb_id: ret.data[i].d_gb_id,
                    channelname: ret.data[i].channelname,
                    status: ret.data[i].status
                  };
                  Object.assign(self.terminals[_i],temp);
                }
              }
            }
            if(maxI==-1){//已经达到了最大数量
              self.$message({
                type: 'error',
                message: "播放已达到最大数量！"
              })
              return;
            }
            if(maxI>=self.playerLength){//代表目前展示的窗口数不够用，需要多加窗口
              if (maxI <= 1) {
                self.setPlayerLength(2);
              } else if (maxI <= 2) {
                self.setPlayerLength(4);
              } else if (maxI <= 4 && !self.isMobile()) {
                self.setPlayerLength(9);
              } else if (maxI <= 9 && !self.isMobile()) {
                self.setPlayerLength(16);
              } else if (maxI <= 16 && !self.isMobile()) {
                self.setPlayerLength(25);
              } else if (maxI <= 25 && !self.isMobile()) {
                self.setPlayerLength(36);
              } else if (maxI <= 36 && !self.isMobile()) {
                self.setPlayerLength(64);
              }
            }
            for (var z = 0; z < channellist.length; z++) {
              let screenIdx = self.terminals.findIndex(_=>_.gb_id===channellist[z].gb_id && _.d_gb_id===channellist[z].d_gb_id);
              if (self.isMobile()&&screenIdx >= 4) {
                this.$message({
                  type: 'error',
                  message: "手机端最多支持四个同时播放！"
                })
                return;
              }
              $.ajax({
                url: self.$store.state.baseUrl + "/play",
                data: {
                  d_gb_id: channellist[z].d_gb_id,
                  gb_id: channellist[z].gb_id,
                  vedioType: 0,
                  record: self.record
                },
                type: "get",
                async: false,
                contentType: 'application/json;charset=utf-8',
                success: function (data) {
                  if(self.currentChoiceScreen===screenIdx){
                    self.clickScreen(screenIdx);
                  }
                  var online =data.data.online;
                  if(online ==1){
                      var url;
                      if(self.isHttps()){
                        url = data.data.WebSockets;
                      }else{
                        url = data.data.WebSocket;
                      }
                      self.terminals[screenIdx].streamid = data.data.StreamID;
                      let ui2 = careyeplay.ui(self.terminals[screenIdx].index);
                      ui2.stop();
                      setTimeout(function(){
                        ui2.play(url);
                      },1000);
                      $("#player" + self.terminals[screenIdx].index).find("div#souga").remove();
                      let souga = "<div id='souga' class='play-title-my'>" + self.terminals[screenIdx].channelname + "<span class='thespeed' id='speed"+self.terminals[screenIdx].index+"'></span></div>";
                      $("#player" + self.terminals[screenIdx].index).find("div.pe-controlbar").append(souga);
                      if(!self.keepSiv){//保持登录
                        let keepIn = self.$store.state.keepTime;
                        self.keepSiv = setInterval(function(){
                          keepIn--;
                          if(keepIn<=0){
                            self.keepLogin().then(res=>{keepIn = self.$store.state.keepTime;});
                          }
                        },1000);
                      }
                  }
                }
              });
            }
          })
        },
        downs(opt) {
          var self = this;
          fetch(opt.url)
            .then((res) => res.blob())
            .then((blob) => {
              download(
                blob,
                self.nodechannelname,
                "jpg"
              );
            });
        },
        playOne() {//播放
          let self = this;
          let screenIdx = self.terminals.findIndex(_=>!_.gb_id);//找到未使用的窗口
          if(screenIdx==-1){//已经达到了最大数量
            self.$message({
              type: 'error',
              message: "播放已达到最大数量！"
            })
            return;
          }
          if(screenIdx>=self.playerLength){//代表目前展示的窗口数不够用，需要多加窗口
            if (screenIdx <= 1) {
              self.setPlayerLength(2);
            } else if (screenIdx <= 2) {
              self.setPlayerLength(4);
            } else if (screenIdx <= 4 && !self.isMobile()) {
              self.setPlayerLength(9);
            } else if (screenIdx <= 9 && !self.isMobile()) {
              self.setPlayerLength(16);
            } else if (screenIdx <= 16 && !self.isMobile()) {
              self.setPlayerLength(25);
            } else if (screenIdx <= 25 && !self.isMobile()) {
              self.setPlayerLength(36);
            } else if (screenIdx <= 36 && !self.isMobile()) {
              self.setPlayerLength(64);
            }
          }
          if (self.isMobile()&&screenIdx >= 4) {
            self.$message({
              type: 'error',
              message: "手机端最多支持四个同时播放！"
            })
            return;
          }
          let _i = self.terminals.findIndex(_=>_.gb_id===self.nodechannelcode&&_.d_gb_id===self.d_gb_id);
          if(_i==-1){//新的
            let temp = {
              deviceid: self.nodedeviceid,
              id: self.nodechannelid,
              gb_id: self.nodechannelcode,
              d_gb_id: self.d_gb_id,
              channelname: self.nodechannelname,
              status: self.nodechannelstatus
            };
            Object.assign(self.terminals[screenIdx],temp);
          }else{//已经在播放中
            screenIdx = _i;
          }
          $.get(self.$store.state.baseUrl + "/play", {
            d_gb_id: self.d_gb_id,
            gb_id: self.nodechannelcode,
            vedioType: self.vedioType,
            record: self.record
          }).then(ret => {
            if(self.currentChoiceScreen===screenIdx){
              self.clickScreen(screenIdx);
            }
            var online =ret.data.online;
            if(online==1){
              var url;
              if(self.isHttps()){
                url = ret.data.WebSockets;
              }else{
                url = ret.data.WebSocket;
              }
              self.contextMenuVisible = false;
              self.terminals[screenIdx].streamid = ret.data.StreamID;
              let ui2 = careyeplay.ui(self.terminals[screenIdx].index);
              ui2.stop();
              setTimeout(function(){
                ui2.play(url);
              },1000);
              $("#player" + self.terminals[screenIdx].index).find("div#souga").remove();
              let souga = "<div id='souga' class='play-title-my'>" + self.terminals[screenIdx].channelname + "<span class='thespeed' id='speed"+self.terminals[screenIdx].index+"'></span></div>";
              $("#player" + self.terminals[screenIdx].index).find("div.pe-controlbar").append(souga);
              if(!self.keepSiv){//保持登录
                let keepIn = self.$store.state.keepTime;
                self.keepSiv = setInterval(function(){
                  keepIn--;
                  if(keepIn<=0){
                    self.keepLogin().then(res=>{keepIn = self.$store.state.keepTime;});
                  }
                },1000);
              }
            }
          })
        },
        stopPlayApi(index){//调用停止播放接口
          let that = this;
          $("#player" + that.terminals[index].index).find("div#souga").remove();
          that.removeWaitingImg(index);
          // $.get(that.$store.state.baseUrl + "/playControl", {//目前停止播放接口有问题
          //   d_gb_id: that.terminals[index].d_gb_id,
          //   gb_id: that.terminals[index].gb_id,
          //   command: 0
          // }).then(ret => {});
          let temp = {
            index: index,
            boxId: that.terminals[index].boxId
          };
          that.terminals[index] = temp;
          that.yuntaiCtrData = {};
          let ui = careyeplay.ui(temp.index);
          ui.destroy();
          that.playerrestart("",temp.boxId,temp.index,true);
          $("#" + temp.boxId).find("div.pe-logo").remove();
          that.initPlayerEvent();
        },
        stopAll() {//停止全部
          var self = this;
          if(!!self.keepSiv){
            clearInterval(self.keepSiv);
            self.keepSiv = null;
          }
          for (let i = 0; i < self.terminals.length; i++) {
            if(!!self.terminals[i].gb_id){
              careyeplay.ui(self.terminals[i].index).stop();
              self.stopPlayApi(self.terminals[i].index);
            }
          }
        },
        refresh(){//右键刷新
          let that = this;
          let node = that.$refs.devTree.getNode(that.contextMenuNodeData.key); // 通过节点id找到对应树节点对象
          node.loaded = false;
          node.expand(); // 主动调用展开节点方法，重新查询该节点下的所有子节点
        },
        treeNodeClick(data, node, c) {//点击树的节点
          if (this.isMobile()) {
            if (typeof data.channelname != "undefined") {
              this.nodedeviceid = node.deviceId;
              this.d_gb_id = node.d_gb_id;
              this.nodechannelcode = node.gb_id;
              this.nodechannelname = node.channelname;
              this.nodechannelid = node.id;
              this.nodechannelstatus = node.status;
              this.playOne();
            }
          } else {
            this.treeClickCount++;
            //单次点击次数超过2次不作处理,直接返回,也可以拓展成多击事件
            //计时器,计算300毫秒为单位,可自行修改
            this.timer = window.setTimeout(() => {
              if (this.treeClickCount > 1) {
                //把次数归零
                this.treeClickCount = 0;
                if (typeof data.channelname != "undefined") {
                  this.nodedeviceid = node.deviceId;
                  this.d_gb_id = node.d_gb_id;
                  this.nodechannelcode = node.gb_id;
                  this.nodechannelname = node.channelname;
                  this.nodechannelid = node.id;
                  this.nodechannelstatus = node.status;
                  this.playOne();
                }
              } else {
                this.treeClickCount = 0;
              }
            }, 300);
          }
        },
        treeNodeRightClick(event, data, node, c) {//树右键菜单
          this.contextMenuNodeData = node;
          if (typeof data.channelname != "undefined") {//右键通道
            this.nodedeviceid = node.deviceId;
            this.nodechannelcode = node.gb_id;
            this.d_gb_id = node.d_gb_id;
            this.nodechannelname = node.channelname;
            this.nodechannelid = node.id;
            this.nodechannelstatus = node.status;
            this.popup = 2;
            var new_event = new MouseEvent(event.type, event);
            this.contextMenuTarget.dispatchEvent(new_event);
          } else if (typeof data.devicename != "undefined") {//右键设备
            this.nodedeviceid = node.id;
            this.channelcount = node.channelcount;
            this.popup = 1;
            if (node.channelcount == 0) {
              return;
            }
            var new_event = new MouseEvent(event.type, event);
            this.contextMenuTarget.dispatchEvent(new_event);
          } else {//右键机构
            this.popup = 3;
            var new_event = new MouseEvent(event.type, event);
            this.contextMenuTarget.dispatchEvent(new_event);
          }
        },
        clickScreen(index){
          this.currentChoiceScreen = index;
          this.yuntaiCtrData = {
            deviceId: this.terminals[index].deviceid,
            d_gb_id: this.terminals[index].d_gb_id,
            channelId: this.terminals[index].gb_id
          };
        },
        gbControl() {
          var self = this;
          self.$refs["liveGbControl"].show({
            d_gb_id: self.d_gb_id,
            gb_id: self.nodechannelcode
          });
        },
        voiceintercom() {
          var self = this;
          self.$refs["voiceInterCom"].show({
            d_gb_id: self.d_gb_id,
            deviceId: self.nodedeviceid,
            channelId: self.nodechannelcode,
          });
        },
        treeLoad(data, resolve) {
          var self = this;
          var parentid = "";
          if (typeof data.devicename == "undefined") {
            parentid = data.deptid || "-1";
            var deptlist = [];
            if (typeof data.channelname == "undefined") {
              $.ajax({
                url: self.$store.state.baseUrl + "/dept/getChildDeptList", // 请求路径
                data: {
                  parentid: parentid,
                }, // 参数
                type: "get", // 请求类型
                async: false,
                contentType: 'application/json;charset=utf-8',
                error: function (request, textStatus, errorThrown) { // 设置表单提交出错
                },
                success: function (ret) {
                  deptlist = ret.data;
                  if (parentid == "-1") {
                    self.defaultExpandedKeys = deptlist.length?[deptlist[0].deptid]:[]
                    resolve((deptlist || []).map(v => {
                      return Object.assign(v, {
                        key: v.deptid,
                      })
                    }));
                  }
                }
              });
              if (parentid != "-1") {
                $.ajax({
                  url: self.$store.state.baseUrl + "/deviceInfo/list", // 请求路径
                  data: {
                    deptid: parentid,
                    sort: "id",
                    order: "asc",
                  }, // 参数
                  type: "get", // 请求类型
                  async: false,
                  contentType: 'application/json;charset=utf-8',
                  error: function (request, textStatus, errorThrown) { // 设置表单提交出错
                  },
                  success: function (rett) {
                    var devicelist = rett.data;
                    // alert(JSON.stringify(rett.data));
                    if (devicelist != null) {
                      for (var i = 0; i < devicelist.length; i++) {
                        devicelist[i].parentid = devicelist[i].deptid;
                        devicelist[i].deptname = devicelist[i].devicename;
                        devicelist[i].deptid = Math.round(Math.random() * 999)
                          + Math.round(Math.random() * 999);
                      }
                      if (deptlist != null) {
                        deptlist = deptlist.concat(devicelist);
                        resolve((deptlist || []).map(v => {
                          return Object.assign(v, {
                            key: v.deptid,
                          })
                        }));
                      } else {
                        resolve((devicelist || []).map(v => {
                          return Object.assign(v, {
                            key: v.deptid,
                          })
                        }));
                      }
                    } else {
                      resolve((deptlist || []).map(v => {
                        return Object.assign(v, {
                          key: v.deptid,
                        })
                      }));
                    }
                  }
                });
              }
            }
          } else {
            parentid = data.id;
            $.ajax({
              url: self.$store.state.baseUrl + "/deviceChannelInfo/list", // 请求路径
              data: {
                deviceid: parentid,
                sort: "id",
                order: "asc",
              }, // 参数
              type: "get", // 请求类型
              async: false,
              contentType: 'application/json;charset=utf-8',
              error: function (request, textStatus, errorThrown) { // 设置表单提交出错
              },
              success: function (ret) {
                let list = [];
                for (let i = 0; i < ret.data.length; i++) {
                  if(!ret.data[i].type){//过滤掉非视频通道----0：代表视频通道  1：代表语音输出通道 2 代表报警通道 3：语音输入通道  4：其他
                    ret.data[i].parentid = ret.data[i].deviceid;
                    ret.data[i].deptname = ret.data[i].channelname;
                    ret.data[i].deptid = Math.round(Math.random() * 999) + Math.round(Math.random() * 999);
                    list.push(ret.data[i]);
                  }
                }
                resolve(list.map(v => {
                  return Object.assign(v, {
                    key: v.deptid,
                  })
                }));
              }
            });
          }
          window.setTimeout(() => {
            $("#dev-tree").find("div.el-tree-node__children").removeClass("el-tree-node__children");
          }, 300);
        },
        treeFilter(value, data) {
          if (!value) return true;
          return data.deptid.indexOf(value) !== -1 || data.deptname.indexOf(value) !== -1;
        },
        treeNodeRefresh(key) {
          let node = this.$refs['devTree'].getNode(key);
          if (!node) return;
          node.loaded = false;
          node.expand();
        },
        getQueryString(name, defVal = "") {
          var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
          var r = window.location.search.substr(1).match(reg);
          if (r != null) {
            return unescape(r[2]);
          }
          return defVal;
        }
      },
      beforeRouteEnter(to, from, next) {
        next(vm => {
          vm.protocol = vm.getQueryString("protocol", "");
        });
      },
      beforeDestroy(){
        if(!!this.keepSiv){
          clearInterval(this.keepSiv);
          this.keepSiv = null;
        }
      }
    };
</script>
<style>
    .listerclick{
      border: 3px solid #fff;
      padding: 0 !important;
    }
    .listerclick.choice{
      border-color: #3cb0e6;
    }
    .flow-tree {
        overflow: auto;
    }
    .channeloffline {
        color: grey;
    }

    .channelonline {
        color: green;
    }

    ul {
        padding-left: 0;
        margin-left: 0;
    }

    .btnmenuli {
        float: left;
        list-style: none;
        padding-left: 0;
        padding-right: 1%;
        cursor: pointer;
        position: relative;
    }
    .btnmenuli .text{
      font-size: 12px;
      color:#ff3434;
      display: inline-block;
      vertical-align: middle;
    }
    .btnmenuli-tip{
      position: absolute;
      top: -23px;
      left: -60%;
      display: none;
      color: #1e9fff;
      border: 1px solid #1e9fff;
      border-radius: 4px;
      padding: 0 6px;
      white-space: nowrap;
      background-color: #fff;
      z-index: 9;
    }
    .btnmenuli:hover .btnmenuli-tip{
      display: block;
    }
    .btnmenuli-tip.tostop{
      left: -150%;
    }

    .btnmenulist {
        width: 16px;
        height: 18px;
    }

    .col-smxx-5 {
        width: 19.9999992%;
        float: left;
        padding-right: 3px;
        padding-left: 0;
        padding-top: 3px;
    }

    .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-6 {
        padding-right: 3px;
        padding-left: 0;
        padding-top: 3px;
    }

    .col-smxx-8 {
        width: 12.4444442%;
        float: left;
        padding-right: 3px;
        padding-left: 0;
        padding-top: 3px;
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
        box-shadow: 0 0.5em 1em 0 rgba(0, 0, 0, .1);
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

    .outbox {
        overflow-y: auto;
    }

    .marleft {
        margin-left: 2%;
    }
</style>

<style lang="less" scoped>
  @import url(~assets/css/style.css);
  @import url(~assets/css/classic.css);
  @import url(~assets/css/prettify.css);
  .the-box{
    height: 100%;
    width:100%;
    background-color:#fff;
    border-radius: 3px;
    padding: 10px;
    box-sizing: border-box;
    >div{
      padding: 0;
      height: 100%;
      &:first-child{
        padding-right: 10px;
      }
    }
    .depttree{
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
      .tree-box{
        border: 1px solid rgb(216, 216, 216);
        min-height: 200px;
        flex-grow: 1;
        >div{
          height: 100%;
        }
      }
      .select{
        flex-grow: 0;
        margin: 0;
        padding: 20px 0;
        font-size: 14px;
        color: black;
        display: flex;
        align-items: center;
        ._label{
          white-space: nowrap;
          margin-right: 10px;
        }
      }
      .ctr-block{
        width: 100%;
        height: auto;
        flex-grow: 0;
      }
    }
    .screenbox{
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
      .tool{
        padding-left: 0;
        padding-bottom: 5px;
        flex-grow: 0;
        height: 25px;
        width: 100%;
        text-align: left;
      }
      .view-list{
        flex-grow: 1;
        overflow: hidden;
        .video-show{
          height: 100%;
          width: 100%;
        }
      }
    }
    &.ismobile{
      height: 100% !important;
      min-height: 700px;
      .screenbox{
        height: 60%;
        padding: 0 0 10px 0;
      }
      .depttree{
        height: 40%;
        .tree-box{
          min-height: unset;
        }
      }
    }
  }
  @media screen and(max-width: 992px){
    .the-box {
      min-height: 900px;
      .depttree{
        height: 30%;
      }
      .screenbox{
        height: 70%;
      }
      &.showLYT{
        .depttree{
          height: 45%;
        }
        .screenbox{
          height: 55%;
        }
      }
    }
  }
</style>
