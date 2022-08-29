var recSeq=0,rec,talkSimCode,talkChannel,talkDeviceId,audioClient,recTimestamp=0;
var ws_talk_server_url = "";

function str2bytes(str){
	var ch, st, re = [];
	for (var i = 0; i < str.length; i++ ) {
		ch = str.charCodeAt(i);
		st = [];
		do {
			st.push( ch & 0xFF );
			ch = ch >> 8;
		}
		while ( ch );
		re = re.concat(st.reverse());
	}
	return re;
}

function bcd2byte(asc) {
	var bcd;
	if ((asc >= 48) && (asc <= 57))
		bcd = (asc - 48);
	else if ((asc >= 65) && (asc <= 70))
		bcd = (asc - 65 + 10);
	else if ((asc >= 97) && (asc <= 102))
		bcd = (asc - 97 + 10);
	else
		bcd = (asc - 48);
	return bcd;
}

function bcd2bytes(ascii, len) {
	var bcd = [];
	var j = 0;
	for (var i = 0; i < len / 2; i++) {
		bcd.push(bcd2byte(ascii[j++]));
		bcd[i] = (((j >= len) ? 0x00 : bcd2byte(ascii[j++])) + (bcd[i] << 4));
	}
	return bcd;
}

function sendVoiceMessage(simCode,channel,data,flag,time){
	var dataLength = data.length;
	var buffer = new ArrayBuffer(59 + dataLength * 2);
	var view = new DataView(buffer);

	var offset = 0;
	// 帧头标识，以大端字节序写入值为0x30 0x31 0x63 0x64的32位整数
	view.setUint32(offset, 808543076, false);
	offset += 4;

	//00010010
	view.setUint8(offset, 129, false);
	offset += 1;

	//var m = 128;//是否完整帧标识，10000000
	//var pt = 22;//负载类型，10110
	view.setUint8(offset, 150, false);
	offset += 1;

	//包序号
	view.setUint16(offset, recSeq++, false);
	offset += 2;

	//sim卡号，todo
	//var simCode = "013600000000";

	for(var j=0;j<simCode.length;j++){
		view.setUint8(offset, simCode[j], false);
		offset += 1;
	}

	//逻辑通道号
	for(var j=0;j<channel.length;j++){
		view.setUint8(offset, channel[j], false);
		offset += 1;
	}
	//数据类型，00110000 + 分包标识
	view.setUint8(offset, flag+48, false);
	offset += 1;

	//时间戳
	view.setBigUint64(offset, BigInt(time), false);
	offset += 8;

	//数据长度
	view.setUint16(offset, dataLength * 2, false);
	offset += 2;

	for(var j=0;j<dataLength;j++){
		view.setInt16(offset, data[j], true);//小尾端
		offset += 2;
	}
	audioClient.send(buffer);
}

function recopen(socket){
	recclose();
	rec=Recorder({
		onProcess:function(buffers,level,duration,sampleRate){
			//$("#video_talker_voice").css("width",level+"%");
			var simCode= talkSimCode;
			var channel=talkChannel;

			recTimestamp +=duration;
			//这里封装1078协议
			sendVoiceMessage(simCode,channel,buffers,0,recTimestamp);
		}
	});
	rec.open(function(){
		//开启录音
        recstart();
        stop_talk_flag = false;
		//doStartTalk();
	},function(e,isUserNotAllow){
		alert((isUserNotAllow?"用户不允许录音，":"")+"打开失败："+e);
		return false;
	});

	window.waitDialogClick=function(){
		alert("打开麦克风失败：权限请求被忽略，<span style='color:#f00'>用户主动点击的弹窗</span>");
	};

	return true;
};

function recclose(){
	if(rec){
		rec.close(function(){
			reclog("已关闭");
		});
	}else{
		reclog("未打开录音",1);
	};
};

function recstart(call){
	call||(call=function(msg){
		msg&&reclog(msg,1);
	});
	if(rec){
		window.realTimeSendTryReset&&realTimeSendTryReset();

		rec.start();
		var set=rec.set;

		reclog("录制中："+set.type+" "+set.sampleRate+"hz "+set.bitRate+"kbps");
		call();
	}else{
		call("未打开录音");
	};
};

function recpause(){
	if(rec){
		rec.pause();
		reclog("已暂停");
	};
};

function recresume(){
	if(rec){
		rec.resume();
		reclog("继续录音中...");
	};
};

function recstop(call){
	recstopFn(call,true,function(){
		setTimeout(function(){
			window.realTimeSendTryStop&&realTimeSendTryStop(rec.set);
		});
	});
};

function recstopFn(call,isClick,endCall,rec){
	call||(call=function(msg){
		msg&&reclog(msg,1);
	});
	rec=rec||window.rec;
	if(rec){
		if(isClick){
			reclog("正在编码"+rec.set.type+"...");
		};
		var t1=Date.now();
		rec.stop(function(blob,time){

		},function(s){
			endCall(s);
			call("失败："+s);
		});
	}else{
		call("未打开录音");
	};
};

function reclog(s,e){
	console.info(s);
};

function onclickStartTalk(deviceId,channelId,socket){
	audioClient =  socket;
	if(talkDeviceId){
		alert("当前语音对讲已开启，语音对讲只支持一对一通话！");
		return false;
	}
//	if(window.isSecureContext===false){
//		alert("当前网页不是安全环境（HTTPS），将无法获取录音权限，<a href='https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia#Privacy_and_security'>MDN Privacy and security</a>",1);
//		return false;
//	}
	talkDeviceId = deviceId;
	talkChannel = channelId;
	talkSimCode = deviceId;
	//开启语音对讲
	return recopen(socket);
}

var stop_talk_flag = false;
function onclickStopTalk(){
//	if (null != audioClient) {
//		audioClient.close();
//	}
	recclose();
	recSeq=0;
	recTimestamp=0;
	talkSimCode=null;
	talkChannel=null;
	talkDeviceId=null;
	audioClient=null;
	stop_talk_flag = true;
}

function voiceSocketOpen() {
	recstart();
	stop_talk_flag = false;
}

function voiceSocketClose() {
	if(!stop_talk_flag){
		//alert("连接语音对讲服务器失败，请联系系统管理员！");
		recclose();
		recSeq=0;
		recTimestamp=0;
		talkSimCode=null;
		talkChannel=null;
		talkDeviceId=null;
		audioClient=null;
	}
}

function voiceSocketError() {
	alert("连接语音对讲服务器失败，请联系系统管理员！");
	talkChannel=null;
	talkDeviceId=null;
}

function doStartTalk(socket){
	audioClient = new WSClient({
		host: ws_talk_server_url,
		onopen: function() {
			//发送对讲指令->指令成功->开始对讲
			//        ->指令失败->关闭websocket
			//console.log("*******onopen");
			//发送指令
			recstart();
			stop_talk_flag = false;
		},
		onclose: function() {
			if(!stop_talk_flag){
				alert("连接语音对讲服务器失败，请联系系统管理员！");
				recclose();
				//stopVideo(talkDeviceId,talkChannel);
				recSeq=0;
				recTimestamp=0;
				talkSimCode=null;
				talkChannel=null;
				talkDeviceId=null;
				audioClient=null;
				//endLoading();
			}
		},
		onmessage: function(arraybuffer) {
			//接收数据
		},
		onerror: function(){
			alert("连接语音对讲服务器失败，请联系系统管理员！");
			talkChannel=null;
			talkDeviceId=null;
			//endLoading();
		}
	});
	audioClient.initialize();
}

function startTalk(deviceId,channelId,dataType){
	if(ws_talk_server_url==""){
		showErrorMessage("无可用语音对讲服务器，请联系系统管理员配置！");
		return false;
	}
	//这里发送指令开启语音对讲，todo
	return true;
}
