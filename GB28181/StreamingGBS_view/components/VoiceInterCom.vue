<template>
    <FormDlg title="对讲" @hide="onHide" @show="onShow" ref="dlg" :disabled="errors.any()">
        <div class="row">
            <div class="col-lg-12 col-xs-12 col-md-12">
                <div class="col-lg-4 col-xs-4 col-md-4">
                    <div class="row">

                    </div>
                </div>
                <div class="col-lg-4 col-xs-4 col-md-4" align="center">
                    <div class="row">
                        <i class="fa fa-microphone-slash fa-6 mksize" aria-hidden="true" v-show="!isdj"></i>
                        <i class="fa fa-microphone fa-6 mksize" aria-hidden="true" v-show="isdj"></i>
                    </div>
                    <div class="row selecttype">
                        <div>广播方式：</div>
                        <el-select size="mini" v-model="broadcastType" placeholder="请选择广播方式">
                            <el-option
                            v-for="item in [{id:0,name:'TCP广播，不带包长'},{id:1,name:'TCP广播，带2字节包长'},{id:2,name:'UDP广播'}]"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id">
                            </el-option>
                        </el-select>
                    </div>
                    <div class="row">
                        <button type="button" class="btn btn-xs btn-success" @click="startDj" v-show="!isdj">开启对讲</button>
                        <button type="button" class="btn btn-xs btn-success" @click="shuntDownDj" v-show="isdj">关闭对讲</button>
                    </div>
                </div>
                <div class="col-lg-5 col-xs-5 col-md-4">
                    <div class="row">

                    </div>
                </div>
            </div>
            <div id="car-eye-playervoice" style="display: none;">
                <div class='row' id='player10089'></div>
            </div>
        </div>
    </FormDlg>
</template>

<script>
    import $ from 'jquery'
    import FormDlg from 'components/FormDlg.vue'
    import {Recorder} from '../assets/config/voiceconfig.js'
    let ui = null;
    export default {
        data() {
            return {
                isdj: false,
                deviceId: '',
                channelId: '',
                d_gb_id: '',
                record: null,//多媒体对象，用来处理音频
                socket: null,
                speekData: {},
                broadcastType: 0
            }
        },
        components: {
            FormDlg
        },
        mounted() {
            $("#voiceintercom").find("div.modal-footer").remove();
            this.initPlayVoice();
        },
        methods: {
            onHide() {
                this.$emit("hide");
            },
            onShow() {
                this.$emit("show");
            },
            async show(data) {
                this.channelId = data.channelId;
                this.deviceId = data.deviceId;
                this.d_gb_id= data.d_gb_id;
                this.isdj = false;
                this.$nextTick(() => {
                    this.$refs['dlg'].show();
                })
            },
            initPlayVoice() {
              ui = careyeplay.ui(10089);
              ui.setup(document.getElementById("player10089"), {
                autoplay: false,
                bufferLength: 0,//1.5,       // sec.
                // level: 'error',    // debug, log, warn, error
                file: "",
                lowlatency: true,//false为服务器的点播功能
                maxBufferLength: 1.5,//3.0,    // sec.
                maxRetries: 1, 
                mode: "live", //live
                module: 'FLV',
                objectfit: "fill",
                retrying: 0,
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
                        visibility: false
                    }
                ]
              });
              ui.removeEventListener('error');
              ui.addEventListener('error', console.error);
            },
            shuntDownDj() {//关闭对讲
                var self = this;
                self.isdj = false;
                if (self.socket) {
                    self.socket.close();
                    self.socket = null;
                    self.record.clear();
                    self.record.stop();
                    ui.stop();
                    $.get(self.$store.state.baseUrl + "/playControl", {
                        gb_id: self.channelId,
                        d_gb_id: self.d_gb_id,
                        command: 0
                    }).then(ret => {});
                    console.log('关闭对讲以及WebSocket');
                }
            },
            startDj() {//开启对讲
                let that = this;
                navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia;
                if (!navigator.getUserMedia) {
                    alert('浏览器不支持音频输入');
                } else {
                    navigator.getUserMedia({
                            audio: true
                        },
                        function (mediaStream) {
                            that.init(new Recorder(mediaStream));
                            console.log('开始对讲');
                            that.startPlayVoice();
                            that.useWebSocket();
                        },
                        function (error) {
                            console.log(error);
                            switch (error.message || error.name) {
                                case 'PERMISSION_DENIED':
                                case 'PermissionDeniedError':
                                    console.info('用户拒绝提供信息。');
                                    break;
                                case 'NOT_SUPPORTED_ERROR':
                                case 'NotSupportedError':
                                    console.info('浏览器不支持硬件设备。');
                                    break;
                                case 'MANDATORY_UNSATISFIED_ERROR':
                                case 'MandatoryUnsatisfiedError':
                                    console.info('无法发现指定的硬件设备。');
                                    break;
                                default:
                                    console.info('无法打开麦克风。异常信息:' + (error.code || error.name));
                                    break;
                            }
                        }
                    )
                }
	        },
            async useWebSocket() {
                let self =this;
                $.get(self.$store.state.baseUrl + "/startSpeak/"+self.d_gb_id).then(ret => {
                    var self = this;
                    if (typeof (WebSocket) == "undefined") {
                        console.log("您的浏览器不支持WebSocket");
                    } else {
                        if(!ret.data)return;
                        self.speekData =  ret.data;
                        //实现化WebSocket对象，指定要连接的服务器地址与端口  建立连接
                        var socketUrl = ret.data.push.ws;
                        if(location.protocol=="https:"){
                            socketUrl = ret.data.push.wss;
                        }
                        console.log("您的浏览器支持WebSocket",socketUrl);
                        if (self.socket != null) {
                            self.socket.close();
                            self.socket = null;
                        }
                        self.socket = new WebSocket(socketUrl);
                        self.socket.binaryType = 'arraybuffer'
                        //打开事件
                        self.socket.onopen = function () {
                            console.log("websocket已打开");
                            self.isdj = true;
                            if (self.socket.readyState == 1) { //ws进入连接状态，则每隔500毫秒发送一包数据
                                self.record.start(self.socket);
                                self.startBroadcast();
                            }

                        };
                        //获得消息事件
                        self.socket.onmessage = function (msg) {
                            var serverMsg = "收到服务端信息：" + msg.data;
                            console.log(serverMsg);
                        };
                        //关闭事件
                        self.socket.onclose = function () {
                            self.isdj = false;
                            self.record.clear();
                            self.record.stop();
                            console.log("websocket已关闭");
                        };
                        //发生了错误事件
                        self.socket.onerror = function () {
                            self.isdj = false;
                            self.record.clear();
                            self.record.stop();
                            console.log("websocket发生了错误");
                        }
                    }
                });
            },
            async init(rec) {
                this.record = rec;
            },
            startBroadcast() {//广播
                var self = this;
                $.ajax({
                    url: self.$store.state.baseUrl + "/broadcast", // 请求路径
                    data: {
                        gbId: self.channelId,
                        dgbId: self.d_gb_id,
                        source: self.speekData.stream,
                        mode: self.broadcastType//0：TCP广播，不带包长；1：TCP广播，带2字节包长；2：UDP广播;
                    }, // 参数
                    method: 'post', // 请求类型
                    // contentType: 'application/json;charset=utf-8',
                    success: function (data) {
                        console.log(data.data)
                    }
                });
            },
            startPlayVoice() {
                var self = this;
                $.ajax({
                    url: self.$store.state.baseUrl + "/play", // 请求路径
                    data: {
                        d_gb_id: self.d_gb_id,
                        gb_id: self.channelId,
                        vedioType: 0,//0音视频
                        record: 0
                    }, // 参数
                    type: "get", // 请求类型
                    async: false,
                    contentType: 'application/json;charset=utf-8',
                    success: function (data) {
                        var online =data.data.online;
                        if(online==1){
                            var url;
                            if(location.protocol=="https:"){
                                url = data.data.WebSockets;
                            }else{
                                url = data.data.WebSocket;
                            }
                            ui.play(url);
                        }
                    }
                });
            }
        }
    }
</script>

<style>
    .djicon {
        width: 30%;
        height: 100%;
    }
    .mksize {
        font-size: 9vh;
    }
    .selecttype{
        display: flex;
        align-items: center;
        width: 270px;
        margin: 20px 0;
    }
</style>