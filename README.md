# CarEye-media-server

# 什么是CarEye-media-server


CarEye-media-server 是CarEye团队开发的一套高性能视频服务器。主要分成GT1078视频服务器和GB28181视频服务器两大块
他们与车辆管理平台，安防监控平台，上级平台，各种客户端构成了以视频为核心的网络应用框架。


# GT/T1078 流媒体服务器介绍

其主要的优势：
1. 满足JT1078 下级和上级视频流传输协议
2. 支持多种音视频格式，主要有H264，H265， AAC, g711A,g726，PCMA
3. 支持语音对讲，支持回放和直播同时推流
5. 提供丰富的拉流接口，包含HTTP(1.1，2.0)-FLV,HLS,RTMP,WS-FLV
6. 提供丰富的API给平台调用
7. 提供对windows和linux全平台支持。部署方便，大量应用于车载行业。

## 车辆管理平台体验
www.liveoss.com
账号：admin    
密码：123456

# GB28181 流媒体服务器介绍
## 服务器功能

1. 提供标准的http接口访问，相关文档参考：http://120.76.235.109:4025/doc/index.html
2. 遵照GB28181协议实现   
3. 提供丰富的流媒体协议格式转码服务，实现RTSP,WS-FLV,RTMP,HLS等多种协议转化。
4. 提供ws-flv，http-flv，RTMP，HLS等各种输出格式   
6. 支持平台录像
7. 支持服务器级联

## GB28181平台体验
www.liveoss.com:10088   
账号：admin    
密码：123456 

GB28181平台SDK相关资源请参考 https://gitee.com/careye_open_source_platform_group/car-eye-streaming-gbs-view


#  架构展示
## 服务器与设备客户端关系

![](https://gitee.com/careye_open_source_platform_group/car-eye-jtt1078-media-server/raw/master/框架.png)  

## 多服务器和平台交互
CarEye 媒体服务器与平台，上级平台，客户端相互交互图

![](https://gitee.com/careye_open_source_platform_group/car-eye-media-server/raw/master/交互图.png)


CarEye-media-server 是一个授权项目，需要授权才能在实际产品中使用。


# 联系我们

car-eye 开源官方网址：www.car-eye.cn    
car-eye 车辆管理平台网址：www.liveoss.com  
car-eye GB28181管理平台网址 ：www.streaming-vip.com:10088     
car-eye 技术官方邮箱: support@car-eye.cn  
car-eye 车辆管理平台技术交流QQ群: 590411159   
car-eye 视频服务和管理平台QQ群：713522732   
![](https://gitee.com/careye_open_source_platform_group/car-eye-jtt1078-media-server/raw/master/QQ/QQ.jpg)     
CopyRight©  car-eye 开源团队 2018-2020
