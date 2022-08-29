var Recorder = function (stream) {
    var sampleBits = 16; //输出采样数位 8, 16
    var sampleRate = 8000; //输出采样率
    var context = new AudioContext();
    var audioInput = context.createMediaStreamSource(stream);
    var recorder = context.createScriptProcessor(4096, 1, 1);
    var ws;
    var audioData = {
        size: 0, //录音文件长度
        buffer: [], //录音缓存
        inputSampleRate: 48000, //输入采样率
        inputSampleBits: 16, //输入采样数位 8, 16
        outputSampleRate: sampleRate, //输出采样数位
        oututSampleBits: sampleBits, //输出采样率
        clear: function () {
            this.buffer = [];
            this.size = 0;
        },
        input: function (data) {
            this.buffer.push(new Float32Array(data));
            this.size += data.length;
        },
        compress: function () { //合并压缩
            //合并
            var data = new Float32Array(this.size);
            var offset = 0;
            for (var i = 0; i < this.buffer.length; i++) {
                data.set(this.buffer[i], offset);
                offset += this.buffer[i].length;
            }
            //压缩
            var compression = parseInt(this.inputSampleRate / this.outputSampleRate);
            var length = data.length / compression;
            var result = new Float32Array(length);
            var index = 0,
                j = 0;
            while (index < length) {
                result[index] = data[j];
                j += compression;
                index++;
            }
            return result;
        },
        encodePCM: function () { //这里不对采集到的数据进行其他格式处理，如有需要均交给服务器端处理。
            var sampleRate = Math.min(this.inputSampleRate, this.outputSampleRate);
            var sampleBits = Math.min(this.inputSampleBits, this.oututSampleBits);
            var bytes = this.compress();
            var dataLength = bytes.length * (sampleBits / 8);
            var buffer = new ArrayBuffer(dataLength);
            var data = new DataView(buffer);
            var offset = 0;
            for (var i = 0; i < bytes.length; i++, offset += 2) {
                var s = Math.max(-1, Math.min(1, bytes[i]));
                data.setInt16(offset, s < 0 ? s * 0x8000 : s * 0x7FFF, true);
            }
            return new Blob([data]);
        }
    };

    var sendData = function () { //对以获取的数据进行处理(分包)
        var reader = new FileReader();
        reader.onload = e => {
            var outbuffer = e.target.result;
            var arr = new Uint16Array(outbuffer);
            //var arr = new Uint16Array(2);
            var dst = new Int8Array(arr.length);
            pcm16_to_alaw(arr.byteLength,arr,dst);
            ws.send(dst);
        };
        reader.readAsArrayBuffer(audioData.encodePCM());
        audioData.clear();//每次发送完成则清理掉旧数据
    };

    this.start = function (_ws) {
        ws = _ws;
        audioInput.connect(recorder);
        recorder.connect(context.destination);
    }

    this.stop = function () {
        recorder.disconnect();
    }

    this.getBlob = function () {
        return audioData.encodePCM();
    }

    this.clear = function () {
        audioData.clear();
    }

    recorder.onaudioprocess = function (e) {
        var inputBuffer = e.inputBuffer.getChannelData(0);
        audioData.input(inputBuffer);
        sendData();
    }
}
export {Recorder}