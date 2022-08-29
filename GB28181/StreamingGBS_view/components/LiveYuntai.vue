<template>
    <div class="ctr-box">
        <div class="ctr1">
            <div class="row">
                <div class="col-lg-offset-2 col-lg-3 col-xs-4 col-md-4 divmd" @mousedown="setYdControl(1)" @mouseup="setYdUpControl(1)"
                        @mouseenter="sventerorleave(1,1)" @mouseleave="sventerorleave(1,2)">
                    <img class="ytbtnmenu" src="../assets/ytimages/zs-01.png" v-show="zsflag" title="左上"/>
                    <img class="ytbtnmenu" src="../assets/ytimages/zs-02.png" v-show="!zsflag" title="左上"/>
                </div>
                <div class="col-lg-3 col-xs-4 col-md-4 divmd" @mousedown="setYdControl(2)" @mouseup="setYdUpControl(2)"
                        @mouseenter="sventerorleave(2,1)" @mouseleave="sventerorleave(2,2)">
                    <img class="ytbtnmenu" src="../assets/ytimages/s-01.png" v-show="sflag" title="上"/>
                    <img class="ytbtnmenu" src="../assets/ytimages/s-02.png" v-show="!sflag" title="上"/>
                </div>
                <div class="col-lg-offset-1 col-lg-3 col-xs-4 col-md-4 divmd" @mousedown="setYdControl(3)" @mouseup="setYdUpControl(3)"
                        @mouseenter="sventerorleave(3,1)" @mouseleave="sventerorleave(3,2)">
                    <img class="ytbtnmenu" src="../assets/ytimages/ys-01.png" v-show="ysflag" title="右上"/>
                    <img class="ytbtnmenu" src="../assets/ytimages/ys-02.png" v-show="!ysflag" title="右上"/>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-offset-2 col-lg-3 col-xs-4 col-md-4 divmd" @mousedown="setYdControl(4)" @mouseup="setYdUpControl(4)"
                        @mouseenter="sventerorleave(4,1)" @mouseleave="sventerorleave(4,2)">
                    <img class="ytbtnmenu" src="../assets/ytimages/z-01.png" v-show="zflag" title="左"/>
                    <img class="ytbtnmenu" src="../assets/ytimages/z-02.png" v-show="!zflag" title="左"/>
                </div>
                <div class="col-lg-3 col-xs-4 col-md-4 divmd">
                </div>
                <div class="col-lg-offset-1 col-lg-3 col-xs-4 col-md-4 divmd" @mousedown="setYdControl(6)" @mouseup="setYdUpControl(6)"
                        @mouseenter="sventerorleave(6,1)" @mouseleave="sventerorleave(6,2)">
                    <img class="ytbtnmenu" src="../assets/ytimages/y-01.png" v-show="yflag" title="右"/>
                    <img class="ytbtnmenu" src="../assets/ytimages/y-02.png" v-show="!yflag" title="右"/>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-offset-2 col-lg-3 col-xs-4 col-md-4 divmd" @mousedown="setYdControl(7)" @mouseup="setYdUpControl(7)"
                        @mouseenter="sventerorleave(7,1)" @mouseleave="sventerorleave(7,2)">
                    <img class="ytbtnmenu" src="../assets/ytimages/zx-01.png" v-show="zxflag" title="左下"/>
                    <img class="ytbtnmenu" src="../assets/ytimages/zx-02.png" v-show="!zxflag" title="左下"/>
                </div>
                <div class="col-lg-3 col-xs-4 col-md-4 divmd" @mousedown="setYdControl(8)" @mouseup="setYdUpControl(8)"
                        @mouseenter="sventerorleave(8,1)" @mouseleave="sventerorleave(8,2)">
                    <img class="ytbtnmenu" src="../assets/ytimages/x-01.png" v-show="xflag" title="下"/>
                    <img class="ytbtnmenu" src="../assets/ytimages/x-02.png" v-show="!xflag" title="下"/>
                </div>
                <div class="col-lg-offset-1 col-lg-3 col-xs-4 col-md-4 divmd" @mousedown="setYdControl(9)" @mouseup="setYdUpControl(9)"
                        @mouseenter="sventerorleave(9,1)" @mouseleave="sventerorleave(9,2)">
                    <img class="ytbtnmenu" src="../assets/ytimages/yx-01.png" v-show="yxflag" title="右下"/>
                    <img class="ytbtnmenu" src="../assets/ytimages/yx-02.png" v-show="!yxflag" title="右下"/>
                </div>
            </div>
            <div class="row">
                <el-slider class="myslider" v-model="speed" :min="1" :max="255" :format-tooltip="formatydTooltip" label="移动速度" @change="changeydsp"></el-slider>
            </div>
        </div>
        <div class="ctr2">
            <div class="row">
                <div class="ctr2-left">
                    <div @click="setYdControl(10)"  @mouseenter="sventerorleave(10,1)" @mouseleave="sventerorleave(10,2)">
                        <img src="../assets/ytimages/f-01.png" v-show="fjflag" title="焦距变小"/>
                        <img src="../assets/ytimages/f-02.png" v-show="!fjflag" title="焦距变小"/>
                    </div>
                    <div @click="setYdControl(12)"  @mouseenter="sventerorleave(12,1)" @mouseleave="sventerorleave(12,2)">
                        <img src="../assets/ytimages/o-01.png" v-show="ojflag" title="光圈缩小"/>
                        <img src="../assets/ytimages/o-02.png" v-show="!ojflag" title="光圈缩小"/>
                    </div>
                    <div @click="setYdControl(14)" @mouseenter="sventerorleave(14,1)" @mouseleave="sventerorleave(14,2)">
                        <img src="../assets/ytimages/k-01.png" v-show="kjflag" title="焦点前调"/>
                        <img src="../assets/ytimages/k-02.png" v-show="!kjflag" title="焦点前调"/>
                    </div>
                </div>
                <div class="ctr2-right">
                    <div @click="setYdControl(11)" @mouseenter="sventerorleave(11,1)" @mouseleave="sventerorleave(11,2)">
                        <img src="../assets/ytimages/f+01.png" v-show="fjjflag" title="焦距变大"/>
                        <img src="../assets/ytimages/f+02.png" v-show="!fjjflag" title="焦距变大"/>
                    </div>
                    <div @click="setYdControl(13)" @mouseenter="sventerorleave(13,1)" @mouseleave="sventerorleave(13,2)">
                        <img src="../assets/ytimages/o+01.png" v-show="ojjflag" title="光圈变大"/>
                        <img src="../assets/ytimages/o+02.png" v-show="!ojjflag" title="光圈变大"/>
                    </div>
                    <div @click="setYdControl(15)" @mouseenter="sventerorleave(15,1)" @mouseleave="sventerorleave(15,2)">
                        <img src="../assets/ytimages/k+01.png" v-show="kjjflag" title="焦点后调"/>
                        <img src="../assets/ytimages/k+02.png" v-show="!kjjflag" title="焦点后调"/>
                    </div>
                </div>
            </div>
            <div class="row">
                <el-slider class="myslider" v-model="bjspeed" :min="1" :max="15" :format-tooltip="formatbjTooltip" label="变焦速度" @change="showalter"></el-slider>
            </div>
        </div>
    </div>
</template>

<script>
    import $ from 'jquery'
    export default {
        props: {
            params: {
                type: Object,
                default: () => ({
                    deviceId: "",
                    d_gb_id: "",
                    channelId: ""
                }),
            }
        },
        data() {
            return {
                form: this.defForm(),
                zsflag: false,
                sflag: false,
                ysflag: false,
                zflag: false,
                sxflag: false,
                yflag: false,
                yxflag: false,
                xflag: false,
                zxflag: false,
                fjflag: false,
                fjjflag: false,
                ojflag: false,
                ojjflag: false,
                kjflag: false,
                kjjflag: false,
                dflag: false,
                ykflag: false,
                upflag: true,
                downflag: false,
                //valuesp: 128,
                speed: 128,
                //valuebjsp: 0,
                bjspeed: 7,
                deviceId: '',
                channelId: '',
            }
        },
        watch: {
            params: {
                handler: function() {
                    this.channelId = this.params.channelId;
                    this.deviceId = this.params.deviceId;
                    this.d_gb_id = this.params.d_gb_id;
                },
                deep: true
            }
        },
        mounted() {
            this.channelId = this.params.channelId;
            this.deviceId = this.params.deviceId;
            this.d_gb_id = this.params.d_gb_id;
            $("#liveyuntai").find("div.modal-footer").remove();
        },
        methods: {
            defForm() {
                return {
                    deviceId: '',
                    channelId: '',
                    d_gb_id: '',
                }
            },
            setYdControl(val) {//按钮点击
                if(!this.params.d_gb_id){
                    this.$message.warning("请先选中正在播放的视频窗口！");
                    return;
                }
                var self = this;
                var vertical = 0;
                var zoom = 0;
                var horizontal = 0;
                var aperture = 0;
                var focus = 0;
                if (val == 1) {//左上
                    vertical = 1;
                    horizontal = 1;
                    if (self.isMobile()) {
                        self.zsflag = false;
                    }
                } else if (val == 2) {//上
                    vertical = 1;
                    if (self.isMobile()) {
                        self.sflag = false;
                    }
                } else if (val == 3) {//右上
                    horizontal = 2;
                    vertical = 1;
                    if (self.isMobile()) {
                        self.ysflag = false;
                    }
                } else if (val == 4) {//左
                    horizontal = 1;
                    if (self.isMobile()) {
                        self.zflag = false;
                    }
                } else if (val == 6) {//右
                    horizontal = 2;
                    if (self.isMobile()) {
                        self.yflag = false;
                    }
                } else if (val == 7) {//左下
                    horizontal = 1;
                    vertical = 2;
                    if (self.isMobile()) {
                        self.zxflag = false;
                    }
                } else if (val == 8) {//下
                    vertical = 2;
                    if (self.isMobile()) {
                        self.xflag = false;
                    }
                } else if (val == 9) {//右下
                    horizontal = 2;
                    vertical = 2;
                    if (self.isMobile()) {
                        self.yxflag = false;
                    }
                } else if (val == 10) {
                    zoom = 2;
                    if (self.isMobile()) {
                        self.fjflag = false;
                    }
                } else if (val == 11) {
                    zoom = 1;
                    if (self.isMobile()) {
                        self.fjjflag = false;
                    }
                } else if (val == 12) {
                    aperture = 2;
                    if (self.isMobile()) {
                        self.ojflag = false;
                    }
                } else if (val == 13) {
                    aperture = 1;
                    if (self.isMobile()) {
                        self.ojjflag = false;
                    }
                } else if (val == 14) {
                    focus = 2;
                    if (self.isMobile()) {
                        self.kjflag = false;
                    }
                } else if (val == 15) {
                    focus = 1;
                    if (self.isMobile()) {
                        self.kjjflag = false;
                    }
                }
                $.get(self.$store.state.baseUrl + "/yuntab", {
                    d_gb_id: self.d_gb_id,
                    gb_id: self.channelId,
                    vertical: vertical,
                    zoom: zoom,
                    focus: focus,
                    aperture: aperture,
                    horizontal: horizontal,
                    zoom_level: self.bjspeed,
                    horizontal_level: self.speed,
                    vertica_level: self.speed
                }).then(ret => {
                }).always(() => {
                });
            },
            setYdUpControl(val) {//按钮点击
                if(!this.params.d_gb_id){
                    return;
                }
                var self = this;
                var vertical = 0;
                var zoom = 0;
                var horizontal = 0;
                var aperture = 0;
                var focus = 0;
                $.get(self.$store.state.baseUrl + "/yuntab", {
                    d_gb_id: self.d_gb_id,
                    gb_id: self.channelId,
                    vertical: vertical,
                    zoom: zoom,
                    focus: focus,
                    aperture: aperture,
                    horizontal: horizontal,
                    zoom_level: self.bjspeed,
                    horizontal_level: self.speed,
                    vertica_level: self.speed
                })
                .then(ret => {
                })
                .always(() => {
                });
            },
            sventerorleave(val, type) {//按钮点击
                var self = this;
                if (val == 1) {
                    if (type == 1) {
                        self.zsflag = true;
                    } else {
                        self.zsflag = false;
                    }

                } else if (val == 2) {
                    if (type == 1) {
                        self.sflag = true;
                    } else {
                        self.sflag = false;
                    }

                } else if (val == 3) {
                    if (type == 1) {
                        self.ysflag = true;
                    } else {
                        self.ysflag = false;
                    }

                } else if (val == 4) {
                    if (type == 1) {
                        self.zflag = true;
                    } else {
                        self.zflag = false;
                    }

                } else if (val == 5) {
                    if (type == 1) {
                        self.sxflag = true;
                    } else {
                        self.sxflag = false;
                    }

                } else if (val == 6) {
                    if (type == 1) {
                        self.yflag = true;
                    } else {
                        self.yflag = false;
                    }

                } else if (val == 7) {
                    if (type == 1) {
                        self.zxflag = true;
                    } else {
                        self.zxflag = false;
                    }

                } else if (val == 8) {
                    if (type == 1) {
                        self.xflag = true;
                    } else {
                        self.xflag = false;
                    }

                } else if (val == 9) {
                    if (type == 1) {
                        self.yxflag = true;
                    } else {
                        self.yxflag = false;
                    }

                } else if (val == 10) {
                    if (type == 1) {
                        self.fjflag = true;
                    } else {
                        self.fjflag = false;
                    }

                } else if (val == 11) {
                    if (type == 1) {
                        self.fjjflag = true;
                    } else {
                        self.fjjflag = false;
                    }

                } else if (val == 12) {
                    if (type == 1) {
                        self.ojflag = true;
                    } else {
                        self.ojflag = false;
                    }

                } else if (val == 13) {
                    if (type == 1) {
                        self.ojjflag = true;
                    } else {
                        self.ojjflag = false;
                    }

                } else if (val == 14) {
                    if (type == 1) {
                        self.kjflag = true;
                    } else {
                        self.kjflag = false;
                    }

                } else if (val == 15) {
                    if (type == 1) {
                        self.kjjflag = true;
                    } else {
                        self.kjjflag = false;
                    }

                } else if (val == 16) {
                    if (type == 1) {
                        self.dflag = true;
                    } else {
                        self.dflag = false;
                    }

                } else if (val == 17) {
                    if (type == 1) {
                        self.ykflag = true;
                    } else {
                        self.ykflag = false;
                    }

                }
            },
            formatydTooltip(val){
                return "移动速度为"+val;
            },
            changeydsp(val) {//移动速度变化
                this.speed = val;
                if(!this.params.d_gb_id){
                    this.$message.warning("请先选中正在播放的视频窗口！");
                    return;
                }
                this.setYdControl(0);
            },
            formatbjTooltip(val){
                return "变焦速度为"+val;
            },
            showalter(val){
                if(!this.params.d_gb_id){
                    this.$message.warning("请先选中正在播放的视频窗口！");
                    return;
                }
            }
        }
    }
</script>
<style lang="less" scoped>
    .ctr-box{
        position: relative;
        .fa-times-circle{
            position: absolute;
            top: -17px;
            right: -2px;
            font-size: 20px;
            color: #6c7489;
        }
    }
    .ytbtnmenu {
        width: 100%;
        height: 30px;
    }
    .divmd {
        margin: 0;
        padding: 0;
        width: 35px;
        height: 30px;
        position: relative;
        overflow: hidden;
    }
    .ctr-box>div{
        display: block;
    }
    .ctr1{
        width: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: flex-start;
    }
    .ctr1 .row{
        margin-left: 0;
        margin-right: 0;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .ctr2{
        width: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: flex-start;
    }
    .ctr2 .row{
        margin-left: 0;
        margin-right: 0;
        width: 165px;
        margin: auto;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    .ctr2-left>div,.ctr2-right>div{
        display: block;
        margin-bottom: 4px;
    }
    .ctr2-left>div:last-child,.ctr2-right>div:last-child{
        margin-bottom: 0;
    }
    .myslider{
        width: 105px;
    }
    .divmd img{
        width: 35px;
        height: 30px;
        cursor: pointer;
    }
    .ctr2 img{
        width: 39px;
        height: 27px;
        cursor: pointer;
    }
    @media screen and(min-width: 1200px){
        .ctr-box>div{
            display: inline-block;
            vertical-align: top;
        }
        .ctr1,.ctr2{
            width: 49%;
        }
        .ctr2 .row{
            width: auto;
        }
    }
    @media screen and(max-width: 992px){
        .ctr-box>div{
            display: inline-block;
            vertical-align: top;
        }
        .ctr1,.ctr2{
            width: 49%;
        }
        .ctr2 .row{
            width: auto;
        }
    }
</style>
