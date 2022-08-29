/*
 Navicat Premium Data Transfer

 Source Server         : 121.37.198.249-华为
 Source Server Type    : MySQL
 Source Server Version : 50640
 Source Host           : 121.37.198.249:3307
 Source Schema         : streaming_gbs

 Target Server Type    : MySQL
 Target Server Version : 50640
 File Encoding         : 65001

 Date: 29/05/2021 11:04:56
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for device_alarm
-- ----------------------------
DROP TABLE IF EXISTS `device_alarm`;
CREATE TABLE `device_alarm`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `GB_ID` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '国标编码',
  `alarmmethod` int(11) DEFAULT 0 COMMENT '报警方法',
  `time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '报警时间',
  `lon` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '经度',
  `lat` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '纬度',
  `alarmtype` int(11) DEFAULT 0 COMMENT '报警类型',
  `level` int(11) DEFAULT 0 COMMENT '报警等级',
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '报警描述',
  `D_GB_ID` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '设备编码',
  `deptid` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '' COMMENT '部门id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_time`(`time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 728661 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备报警表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for device_channel_info
-- ----------------------------
DROP TABLE IF EXISTS `device_channel_info`;
CREATE TABLE `device_channel_info`  (
  `id` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `deviceid` bigint(20) NOT NULL COMMENT '设备ID',
  `gb_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '通道编码',
  `channelname` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '通道名称',
  `ptz_enable` int(1) NOT NULL DEFAULT 0 COMMENT '是否支持云台（0不支持  1支持）',
  `talk_enbale` int(1) NOT NULL DEFAULT 0 COMMENT '是否支持对讲（0不支持  1支持）',
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '通道在线状态（0不在线  1在线 2故障 3报警）',
  `bk1` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '备用',
  `type` int(11) NOT NULL DEFAULT 0 COMMENT '0：代表视频通道  1：代表语音输出通道 2 代表报警通道 3：语音输出通到  4：其他',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_channelcode`(`gb_id`, `deviceid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '设备通道信息' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of device_channel_info
-- ----------------------------
INSERT INTO `device_channel_info` VALUES ('766717736943484928', 766717310491820032, '34020000001310000098', '通道1', 0, 0, 0, NULL, 0);
INSERT INTO `device_channel_info` VALUES ('768169122650521603', 768169122650521602, '34020000001310000011', 'NVR 通道1', 0, 0, 0, NULL, 0);
INSERT INTO `device_channel_info` VALUES ('790640039410401280', 768169122650521602, '34020000001310000012', '通道2', 0, 0, 0, NULL, 0);
INSERT INTO `device_channel_info` VALUES ('798517295512158208', 798517153966981120, '34020000001310000002', '通道1', 1, 1, 0, NULL, 0);
INSERT INTO `device_channel_info` VALUES ('815227814168100864', 815227217679351808, '34020000001310000003', '摄像头1', 1, 1, 0, NULL, 0);
INSERT INTO `device_channel_info` VALUES ('825005583391391744', 822894843280883712, '34020000001310000009', '测试', 0, 0, 0, NULL, 0);
INSERT INTO `device_channel_info` VALUES ('825008976558161920', 814941938947063808, '34020000001310000100', '测试', 0, 0, 0, NULL, 0);
INSERT INTO `device_channel_info` VALUES ('826414363110932480', 766717310491820032, '34020000001310000099', '测试', 0, 0, 0, NULL, 0);
INSERT INTO `device_channel_info` VALUES ('827204979222773760', 822894843280883712, '34020000001310000099', '测试', 0, 0, 0, NULL, 0);
INSERT INTO `device_channel_info` VALUES ('827222692733255680', 814941938947063808, '34020000001310000002', '海康支持云台', 1, 1, 1, NULL, 0);
INSERT INTO `device_channel_info` VALUES ('834090355166150656', 819237107255083008, '34020000001310000005', 'ch1', 0, 0, 0, NULL, 0);
INSERT INTO `device_channel_info` VALUES ('834090452306231296', 834090260613955584, '34020000001310000004', 'ch1', 0, 0, 0, NULL, 0);
INSERT INTO `device_channel_info` VALUES ('837364045391724544', 837363662409826304, '34020000001310000020', 'CH1', 0, 0, 1, NULL, 0);
INSERT INTO `device_channel_info` VALUES ('837381291421859840', 837381196299239424, '34020000001310000021', '宏瑞2', 0, 0, 0, NULL, 0);
INSERT INTO `device_channel_info` VALUES ('846454651850194944', 846454570023518208, '34020000001310000001', 'CH1', 0, 0, 1, NULL, 0);

-- ----------------------------
-- Table structure for device_info
-- ----------------------------
DROP TABLE IF EXISTS `device_info`;
CREATE TABLE `device_info`  (
  `id` bigint(20) NOT NULL,
  `deptid` bigint(20) NOT NULL COMMENT '组织机构',
  `gb_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备编码',
  `devicetypeid` bigint(20) DEFAULT NULL COMMENT '设备类型(外键设备类型表ID）',
  `devicename` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '设备名',
  `ip` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'IP地址',
  `port` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '端口',
  `password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '接入密码',
  `install_time` datetime(0) DEFAULT NULL COMMENT '安装时间',
  `location` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '安装位置',
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `bk1` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备用',
  `bk2` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备用',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '创建人',
  `modify_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后一次修改时间',
  `modify_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '修改记录用户',
  `status` int(11) DEFAULT 0 COMMENT '在线状态（0不在线  1在线 2 故障 3 报警）',
  `alarmstatus` int(1) NOT NULL DEFAULT 0 COMMENT '报警状态(0没报警 1报警)',
  `lon` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '经度',
  `lat` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '维度',
  `on_time` datetime(0) DEFAULT NULL COMMENT '最近上线时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_devicecode`(`gb_id`) USING BTREE,
  INDEX `idx_deptid`(`deptid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备信息表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of device_info
-- ----------------------------
INSERT INTO `device_info` VALUES (766717310491820032, 766715999801180160, '34020000001320000098', 0, '摄像头', '127.0.0.1', '8043', '123456', '2020-10-08 00:00:00', '广东省深圳市宝安区西乡坪洲地铁站A出口1号摄像头', NULL, NULL, NULL, '2020-10-16 17:40:52', 'admin', '2021-03-24 14:06:40', 'admin', 0, 0, NULL, NULL, NULL);
INSERT INTO `device_info` VALUES (768169122650521602, 768169122650521601, '34020000001110000010', 0, '学院楼1一层', '192.168.22.3', '6800', '', NULL, '', NULL, NULL, NULL, '2020-10-20 17:49:55', '超级管理员', '2021-03-18 18:12:12', 'admin', 0, 0, NULL, NULL, NULL);
INSERT INTO `device_info` VALUES (814941938947063808, 814939334695321600, '34020000001320000099', 1, 'IPC', '192.168.3.90', '3000', '12345678', '2021-03-01 00:00:00', '沙河口', NULL, NULL, NULL, '2021-02-26 19:28:19', 'admin', '2021-04-06 15:12:50', 'admin', 1, 0, NULL, NULL, NULL);
INSERT INTO `device_info` VALUES (815227217679351808, 766715999801180160, '34020000001320000003', 1, '海康IPC', '192.168.0.223', '5060', '123456', '2021-02-09 00:00:00', '', NULL, NULL, NULL, '2021-02-27 14:21:54', 'admin', '2021-03-24 11:16:01', 'admin', 0, 0, NULL, NULL, NULL);
INSERT INTO `device_info` VALUES (819237107255083008, 766715999801180160, '34020000001320000005', 1, '测试', '', '', '', NULL, '', NULL, NULL, NULL, '2021-03-10 15:55:47', 'admin', '2021-03-18 18:12:30', 'admin', 0, 0, NULL, NULL, NULL);
INSERT INTO `device_info` VALUES (834090260613955584, 766715999801180160, '34020000001320000004', 1, '测试', '', '', '', NULL, '', NULL, NULL, NULL, '2021-04-20 15:36:54', 'admin', '2021-04-20 15:36:54', 'admin', 0, 0, NULL, NULL, NULL);
INSERT INTO `device_info` VALUES (837363662409826304, 766715999801180160, '34020000001320000020', 1, '长沙', '', '', '', NULL, '', NULL, NULL, NULL, '2021-04-29 16:24:14', 'admin', '2021-04-29 16:25:10', 'admin', 1, 0, NULL, NULL, NULL);
INSERT INTO `device_info` VALUES (837381196299239424, 766715999801180160, '34020000001320000021', 1, '宏瑞2', '', '', '', NULL, '', NULL, NULL, NULL, '2021-04-29 17:33:54', 'admin', '2021-04-29 17:33:54', 'admin', 0, 0, NULL, NULL, NULL);
INSERT INTO `device_info` VALUES (846454570023518208, 814939334695321600, '34020000001320000001', 1, '大华摄像头', '', '', '', NULL, '', NULL, NULL, NULL, '2021-05-24 18:28:15', 'admin', '2021-05-24 18:28:15', 'admin', 1, 0, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for gb_info
-- ----------------------------
DROP TABLE IF EXISTS `gb_info`;
CREATE TABLE `gb_info`  (
  `id` bigint(20) NOT NULL COMMENT '与机构、设备、通道表ID对应（为了方便）',
  `gb_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '国标编码',
  `type` int(1) NOT NULL COMMENT '类型（0机构 1设备 2通道）',
  `parent_id` bigint(20) NOT NULL COMMENT '机构ID、设备ID、通道ID',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_gb_id`(`gb_id`) USING BTREE,
  INDEX `idx_type`(`type`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '国标编码统一表（主表）' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of gb_info
-- ----------------------------
INSERT INTO `gb_info` VALUES (1, '1', 0, -1, NULL);
INSERT INTO `gb_info` VALUES (766712371250069504, '34020000001110000001', 0, 1, '测试机构1');
INSERT INTO `gb_info` VALUES (766714011013218304, '34020000001110000002', 0, 1, '测试机构2');
INSERT INTO `gb_info` VALUES (766715999801180160, '34020000001110000004', 0, 766712371250069504, '测试机构4');
INSERT INTO `gb_info` VALUES (766717310491820032, '34020000001320000098', 2, 766715999801180160, '摄像头');
INSERT INTO `gb_info` VALUES (766717736943484928, '34020000001310000098', 1, 766717310491820032, '通道1');
INSERT INTO `gb_info` VALUES (767692880390258688, '34020000001110000003', 0, 1, '测试机构3');
INSERT INTO `gb_info` VALUES (768169122650521600, '44000103562160011000', 0, 1, '广东省第三强制隔离戒毒所');
INSERT INTO `gb_info` VALUES (768169122650521601, '44000103562160011100', 0, 768169122650521600, '学院楼1');
INSERT INTO `gb_info` VALUES (768169122650521602, '34020000001110000010', 1, 768169122650521601, '学院楼1一层');
INSERT INTO `gb_info` VALUES (768169122650521603, '34020000001310000011', 2, 768169122650521602, 'NVR 通道1');
INSERT INTO `gb_info` VALUES (790640039410401280, '34020000001310000012', 2, 768169122650521602, '通道2');
INSERT INTO `gb_info` VALUES (798517153966981120, '34020000001320000002', 1, 766715999801180160, '海康1');
INSERT INTO `gb_info` VALUES (798517295512158208, '34020000001310000002', 2, 798517153966981120, '通道1');
INSERT INTO `gb_info` VALUES (814938943505170432, '34020000002000000002', 0, 1, '大连测试');
INSERT INTO `gb_info` VALUES (814939334695321600, '3402', 0, 814938943505170432, '交通');
INSERT INTO `gb_info` VALUES (814941938947063808, '34020000001320000099', 1, 814939334695321600, '西部通道入口');
INSERT INTO `gb_info` VALUES (814942274088730624, '34020000001310000099', 2, 814941938947063808, '入口');
INSERT INTO `gb_info` VALUES (815227217679351808, '34020000001320000003', 1, 766715999801180160, '海康IPC');
INSERT INTO `gb_info` VALUES (815227814168100864, '34020000001310000003', 2, 815227217679351808, '摄像头1');
INSERT INTO `gb_info` VALUES (819237107255083008, '34020000001320000005', 1, 766715999801180160, '测试');
INSERT INTO `gb_info` VALUES (822894843280883712, '34020000001320000009', 1, 766715999801180160, '执法仪');
INSERT INTO `gb_info` VALUES (822895038563483648, '34020000001310000009', 2, 822894843280883712, '执法仪');
INSERT INTO `gb_info` VALUES (823857554571526144, '34020000001110000033', 0, 767692880390258688, '测试机构');
INSERT INTO `gb_info` VALUES (823919987143081984, '34020000001110000066', 0, 814939334695321600, '测试');

-- ----------------------------
-- Table structure for photo_file
-- ----------------------------
DROP TABLE IF EXISTS `photo_file`;
CREATE TABLE `photo_file`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `GB_ID` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '国标编码',
  `dir` varchar(256) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '录制路径',
  `name` varchar(256) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '文件名',
  `ip` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '服务器ip地址',
  `port` int(11) NOT NULL DEFAULT 0 COMMENT '端口',
  `seq` int(11) DEFAULT -1,
  `result` int(11) DEFAULT -1,
  `isdelete` int(11) DEFAULT 0,
  `D_GB_ID` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '设备编码',
  `deptid` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '' COMMENT '部门id',
  `create_time` datetime(0) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '视频录制记录' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of photo_file
-- ----------------------------
INSERT INTO `photo_file` VALUES (1, '34020000001310000002', '/34020000001320000099/34020000001310000002/1342343028.jpg', '', '120.76.235.109', 9000, 332, 0, 0, '', '814939334695321600', '2021-05-27 14:46:27');
INSERT INTO `photo_file` VALUES (2, '34020000001310000002', '/34020000001320000099/34020000001310000002/1731261844.jpg', '', '120.76.235.109', 9000, 334, 0, 0, '', '814939334695321600', '2021-05-27 14:47:54');
INSERT INTO `photo_file` VALUES (3, '34020000001310000002', '/34020000001320000099/34020000001310000002/365633232.jpg', '', '120.76.235.109', 9000, 336, 0, 0, '', '814939334695321600', '2021-05-27 14:48:08');
INSERT INTO `photo_file` VALUES (4, '34020000001310000002', '/34020000001320000099/34020000001310000002/102049476.jpg', '', '120.76.235.109', 9000, 337, 0, 0, '', '814939334695321600', '2021-05-27 14:48:18');
INSERT INTO `photo_file` VALUES (5, '34020000001310000002', '/34020000001320000099/34020000001310000002/639077984.jpg', '', '120.76.235.109', 9000, 362, 0, 0, '', '814939334695321600', '2021-05-27 15:09:55');
INSERT INTO `photo_file` VALUES (6, '34020000001310000002', '/34020000001320000099/34020000001310000002/928513092.jpg', '', '120.76.235.109', 9000, 364, 0, 0, '', '814939334695321600', '2021-05-27 15:10:04');
INSERT INTO `photo_file` VALUES (7, '34020000001310000002', '/34020000001320000099/34020000001310000002/717557912.jpg', '', '120.76.235.109', 9000, 393, 0, 0, '', '814939334695321600', '2021-05-27 15:15:20');
INSERT INTO `photo_file` VALUES (8, '34020000001310000001', '/34020000001320000001/34020000001310000001/1034516212.jpg', '', '120.76.235.109', 9000, 409, 0, 0, '', '814939334695321600', '2021-05-27 15:24:17');
INSERT INTO `photo_file` VALUES (9, '34020000001310000001', '/34020000001320000001/34020000001310000001/210863852.jpg', '', '120.76.235.109', 9000, 410, 0, 0, '', '814939334695321600', '2021-05-27 15:25:28');
INSERT INTO `photo_file` VALUES (10, '34020000001310000002', '/34020000001320000099/34020000001310000002/475756948.jpg', '', '120.76.235.109', 9000, 1183, 0, 0, '', '814939334695321600', '2021-05-28 16:09:01');

-- ----------------------------
-- Table structure for record_file
-- ----------------------------
DROP TABLE IF EXISTS `record_file`;
CREATE TABLE `record_file`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `GB_ID` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '国标编码',
  `dir` varchar(256) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '录制路径',
  `name` varchar(256) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '文件名',
  `ip` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '服务器ip地址',
  `port` int(11) NOT NULL DEFAULT 0 COMMENT '端口',
  `protocol` int(11) NOT NULL DEFAULT 0 COMMENT '下载通信协议',
  `type` int(11) DEFAULT -1 COMMENT '0直播1录像计划2回放3回放下载',
  `starttime` datetime(0) DEFAULT NULL COMMENT '视频开始时间',
  `endtime` datetime(0) DEFAULT NULL COMMENT '视频结束时间',
  `localstarttime` datetime(0) DEFAULT NULL COMMENT '录制开始时间',
  `localendtime` datetime(0) DEFAULT NULL COMMENT '录制结束时间',
  `usr` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '用户名',
  `passwd` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '密码',
  `size` int(11) NOT NULL DEFAULT 0 COMMENT '录制文件大小',
  `seq` int(11) DEFAULT -1,
  `result` int(11) DEFAULT -1,
  `isdelete` int(11) DEFAULT 0,
  `D_GB_ID` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '设备编码',
  `deptid` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '' COMMENT '部门id',
  `create_time` datetime(0) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '视频录制记录' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for record_plan
-- ----------------------------
DROP TABLE IF EXISTS `record_plan`;
CREATE TABLE `record_plan`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gb_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '通道国标编码',
  `content` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT '内容',
  `create_time` datetime(0) DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) DEFAULT NULL COMMENT '更新时间',
  `d_gb_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '设备编码',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `gbid_dgbid`(`gb_id`, `d_gb_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '录像计划' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of record_plan
-- ----------------------------
INSERT INTO `record_plan` VALUES (2, '34020000001310000003', '[{\"day\":2,\"times\":[{\"stime\":0,\"etime\":1}]}]', '2021-03-25 12:15:12', '2021-03-26 09:34:05', '34020000001320000003');
INSERT INTO `record_plan` VALUES (3, '34020000001310000009', '[{\"day\":2,\"times\":[{\"stime\":0,\"etime\":1}]}]', '2021-03-25 12:15:13', '2021-03-26 09:34:05', '34020000001320000005');
INSERT INTO `record_plan` VALUES (4, '34020000001310000011', '[{\"day\":2,\"times\":[{\"stime\":0,\"etime\":1}]}]', '2021-03-25 12:15:13', '2021-03-26 09:34:05', '34020000001110000010');
INSERT INTO `record_plan` VALUES (5, '34020000001310000012', '[{\"day\":2,\"times\":[{\"stime\":0,\"etime\":1}]}]', '2021-03-25 12:15:13', '2021-03-26 09:34:05', '34020000001110000010');
INSERT INTO `record_plan` VALUES (6, '34020000001310000098', '[{\"day\":2,\"times\":[{\"stime\":0,\"etime\":1}]}]', '2021-03-25 12:15:12', '2021-03-25 12:15:35', '34020000001320000098');
INSERT INTO `record_plan` VALUES (7, '34020000001310000099', '[{\"day\":2,\"times\":[{\"stime\":0,\"etime\":1}]}]', '2021-03-25 12:15:13', '2021-03-26 09:34:05', '34020000001320000099');
INSERT INTO `record_plan` VALUES (8, '34020000001310000009', '[{\"day\":3,\"times\":[{\"stime\":1,\"etime\":2}]}]', '2021-03-26 09:44:34', '2021-03-26 09:44:34', '34020000001320000009');
INSERT INTO `record_plan` VALUES (9, '34020000001310000198', '[{\"day\":2,\"times\":[{\"stime\":11,\"etime\":12},{\"stime\":13,\"etime\":14},{\"stime\":16,\"etime\":17}]},{\"day\":3,\"times\":[{\"stime\":19,\"etime\":20}]}]', '2021-03-31 15:08:34', '2021-03-31 15:08:34', '34020000001320000098');

-- ----------------------------
-- Table structure for setting_sip_server_info
-- ----------------------------
DROP TABLE IF EXISTS `setting_sip_server_info`;
CREATE TABLE `setting_sip_server_info`  (
  `id` bigint(20) NOT NULL,
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '级联服务器名',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '国标编码',
  `domain` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '国标服务器域',
  `ip` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '国标服务器ip',
  `port` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '端口',
  `user` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '用户名',
  `password` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '密码',
  `register_peroid` int(11) DEFAULT NULL COMMENT '注册周期(秒)',
  `heart_peroid` int(11) DEFAULT NULL COMMENT '心跳周期(秒)',
  `gourp_size` int(11) DEFAULT NULL COMMENT '目录分组大小',
  `trans_protocol` int(11) DEFAULT NULL COMMENT '传输协议(0：UDP 1：tcp)',
  `code_set` int(11) DEFAULT NULL COMMENT '字符集(0：GB2312 1：UTF-8)',
  `active` int(11) NOT NULL DEFAULT 0 COMMENT '是否启用(0：未启用 1：启用)',
  `rtcp` int(11) NOT NULL DEFAULT 0 COMMENT '是否启用RTCP(0：未启用 1：启动)',
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `bk1` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备用',
  `bk2` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备用',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '创建人',
  `modify_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后一次修改时间',
  `modify_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '修改记录用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = 'SIP上级服务器信息表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of setting_sip_server_info
-- ----------------------------
INSERT INTO `setting_sip_server_info` VALUES (758284768466042880, '测试', '34020000001880000000', '34020000', '120.76.235.109', '5060', 'admin', '12345678', 300, 60, 1, 0, 0, 1, 1, NULL, NULL, NULL, '2020-09-23 11:12:56', 'admin', '2020-09-23 11:12:56', 'admin');

-- ----------------------------
-- Table structure for setting_video_server_info
-- ----------------------------
DROP TABLE IF EXISTS `setting_video_server_info`;
CREATE TABLE `setting_video_server_info`  (
  `id` bigint(20) NOT NULL,
  `server_ip` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '视频服务器IP',
  `server_local_ip` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '视频服务器内网IP',
  `server_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '视频服务器名称(可选，用于标识)',
  `rtmp_port` smallint(6) UNSIGNED DEFAULT NULL COMMENT 'RTMP播放端口',
  `http_port` smallint(6) UNSIGNED DEFAULT NULL COMMENT 'HTTP播放端口',
  `state_check_ip` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '状态检测IP',
  `state_check_port` smallint(6) UNSIGNED DEFAULT NULL COMMENT '状态检测端口',
  `voice_talk_ip` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '语音对讲IP',
  `voice_talk_port` smallint(6) UNSIGNED DEFAULT NULL COMMENT '语音对讲端口',
  `record` bit(1) DEFAULT b'0' COMMENT '是否开启录像',
  `record_file_dir` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '录像文件存放目录',
  `file_server_ip` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '文件服务器IP',
  `file_server_port` smallint(6) UNSIGNED DEFAULT NULL COMMENT '文件服务器端口',
  `max_bandwidth` int(11) UNSIGNED DEFAULT 100 COMMENT '最大带宽',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) DEFAULT NULL COMMENT '更新时间',
  `enabled` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否启用',
  `bak_1` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `bak_2` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `bak_3` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `bak_4` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `bak_5` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `https_port` smallint(6) DEFAULT NULL COMMENT 'https端口',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '参数设置表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of setting_video_server_info
-- ----------------------------
INSERT INTO `setting_video_server_info` VALUES (823852580991008768, 'www.car-eye.cn', '10.25.136.154', '测试服务器', 10077, 4025, '120.76.235.109', 10085, 'www.car-eye.cn', 9216, b'1', 'E:\\CarDep', '', NULL, 500, '2021-03-23 09:36:02', '2021-05-24 18:25:56', b'1', NULL, NULL, NULL, NULL, NULL, 12);
INSERT INTO `setting_video_server_info` VALUES (823918549805432832, '192.168.0.112', NULL, 'xxxx', 9998, 9999, '127.0.0.13', 8888, NULL, NULL, b'0', NULL, NULL, 666, 100, '2021-03-23 13:58:10', '2021-04-15 10:57:26', b'0', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `setting_video_server_info` VALUES (826999710492524544, '36.33.33.22', NULL, 'yyyy', 7777, 6666, '36.33.33.22', 9999, NULL, NULL, b'1', 'D:/test', NULL, NULL, 800, '2021-04-01 02:01:36', '2021-04-01 04:41:26', b'0', NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for settings_device_type
-- ----------------------------
DROP TABLE IF EXISTS `settings_device_type`;
CREATE TABLE `settings_device_type`  (
  `id` bigint(20) NOT NULL,
  `protocol` int(2) NOT NULL COMMENT '协议类型(0: GB28181-2011 1:GB28181-2016 2：ONVIF 3：预留 4：其他）',
  `typename` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备类型名称',
  `company` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '所属厂家',
  `video_format` int(2) DEFAULT NULL COMMENT '视频格式(0：H264  1：H265)',
  `video_fps` int(11) DEFAULT NULL COMMENT '视频帧率',
  `video_resolution` int(11) DEFAULT NULL COMMENT '视频分辨率',
  `audio_format` int(2) DEFAULT NULL COMMENT '音频格式（0:aac 1：G711a 2：G711U 3：G726-16bit 4：G726-24bit 5：G726-32bit 6：G726-40bit 7：G722 8：g729 9：PCMA 10：其他）',
  `audio_channels` int(2) DEFAULT NULL COMMENT '音频通道（0：单通道 1：立体声）',
  `audio_freq` int(11) DEFAULT NULL COMMENT '音频采样频率',
  `audio_format_bits` int(11) DEFAULT NULL COMMENT '音频帧采样位数',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备注',
  `bk1` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备用',
  `bk2` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备用',
  `bk3` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备用',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '创建人',
  `modify_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后一次修改时间',
  `modify_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '修改记录用户',
  `heartbeat_time` int(11) DEFAULT 60 COMMENT '心跳时间秒',
  `heartbeat_time_out_count` int(11) DEFAULT 1 COMMENT '超时次数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备类型表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of settings_device_type
-- ----------------------------
INSERT INTO `settings_device_type` VALUES (0, 0, 'GB28181-2011协议设备', '海康', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-09-10 16:59:34', 'admin', '2020-09-10 14:44:23', 'admin', 59, 2);
INSERT INTO `settings_device_type` VALUES (1, 1, 'GB28181-2016协议设备', '海康', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-09-10 17:03:10', 'admin', '2020-09-10 14:02:28', 'admin', 120, 1);
INSERT INTO `settings_device_type` VALUES (2, 2, 'ONVIF协议设备', '海康', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-09-10 22:17:52', 'admin', '2020-09-10 23:07:20', 'admin', 120, 1);
INSERT INTO `settings_device_type` VALUES (796443284242300928, 1, '设备类型1', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-01-06 18:21:16', 'admin', '2021-01-06 18:21:16', 'admin', 119, 2);

-- ----------------------------
-- Table structure for sys_auth_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_auth_dept`;
CREATE TABLE `sys_auth_dept`  (
  `deptid` bigint(20) NOT NULL,
  `gb_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '机构编码',
  `deptname` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '机构名称',
  `parentid` bigint(20) NOT NULL COMMENT '父级ID，-1表示顶级部门',
  `contract` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '联系人',
  `tel` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '电话',
  `address` varchar(512) CHARACTER SET gbk COLLATE gbk_chinese_ci DEFAULT NULL COMMENT '地址',
  `max_car_num` int(11) NOT NULL DEFAULT 0 COMMENT '挂载最大设备数量（0无限制）',
  `dep_class` int(11) DEFAULT NULL COMMENT '机构类别（0部门 1单位 2其他）',
  `op_userid` bigint(20) DEFAULT NULL COMMENT '操作人ID',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备注',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '创建用户',
  `modify_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `modify_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '修改用户',
  `deptidnew` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '编号',
  PRIMARY KEY (`deptid`) USING BTREE,
  INDEX `idx_parentid`(`parentid`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '公司机构表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_auth_dept
-- ----------------------------
INSERT INTO `sys_auth_dept` VALUES (1, '1', 'GB28181管理平台', -1, '', '', '', 0, 1, 1, '', '2017-12-03 23:10:12', 'admin', '2020-07-10 16:24:58', 'admin', '001');
INSERT INTO `sys_auth_dept` VALUES (766712371250069504, '34020000001110000001', 'NVR设备', 1, '', '', '', 0, 1, NULL, NULL, '2020-10-16 17:21:14', 'admin', '2020-10-16 17:21:14', 'admin', '001002');
INSERT INTO `sys_auth_dept` VALUES (768169122650521601, '44000103562160011100', '学院楼1', 768169122650521600, NULL, NULL, NULL, 0, NULL, 1, NULL, '2020-10-20 17:49:55', '超级管理员', '2020-10-20 17:49:55', 'admin', '001004001');
INSERT INTO `sys_auth_dept` VALUES (766715999801180160, '34020000001110000004', '视频测试', 766712371250069504, '', '', '', 0, 0, NULL, NULL, '2020-10-16 17:35:39', 'admin', '2020-10-16 17:35:39', 'admin', '001002001');
INSERT INTO `sys_auth_dept` VALUES (768169122650521600, '44000103562160011000', '广东省第三强制隔离戒毒所', 1, NULL, NULL, NULL, 0, NULL, 1, NULL, '2020-10-20 17:49:55', '超级管理员', '2020-10-20 17:49:55', 'admin', '001004');
INSERT INTO `sys_auth_dept` VALUES (814938943505170432, '34020000002000000002', '测试样机专用', 1, '', '', '', 0, 0, NULL, NULL, '2021-02-26 19:16:24', 'admin', '2021-02-26 19:16:24', 'admin', '001005');
INSERT INTO `sys_auth_dept` VALUES (814939334695321600, '3402', '测试机器', 814938943505170432, '', '', '', 0, 0, NULL, NULL, '2021-02-26 19:17:58', 'admin', '2021-02-26 19:17:58', 'admin', '001005001');
INSERT INTO `sys_auth_dept` VALUES (823919987143081984, '34020000001110000066', '海康IPC', 814939334695321600, '', '', '', 0, NULL, 1, NULL, '2021-03-23 14:03:52', '超级管理员', '2021-03-23 14:03:52', 'admin', '001005001001');

-- ----------------------------
-- Table structure for sys_auth_login_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_auth_login_log`;
CREATE TABLE `sys_auth_login_log`  (
  `id` bigint(20) NOT NULL,
  `deptid` bigint(20) NOT NULL,
  `userid` bigint(20) NOT NULL,
  `logindate` datetime(0) NOT NULL,
  `loginip` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `loginflag` int(1) NOT NULL DEFAULT 1 COMMENT '是否成功,1成功,2失败',
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `status` int(11) NOT NULL COMMENT '状态1登录 2退出',
  `work_time` int(11) DEFAULT NULL COMMENT '工作时长（秒）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户登陆日志表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_auth_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_auth_menu`;
CREATE TABLE `sys_auth_menu`  (
  `menuid` bigint(22) NOT NULL DEFAULT 0 COMMENT '菜单编号',
  `parentmenuid` bigint(20) NOT NULL DEFAULT -1 COMMENT '父级ID	父菜单ID,-1表示顶级菜单',
  `menuname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '菜单名称',
  `menuaddr` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '地址	功能访问路径',
  `displaytype` int(2) NOT NULL DEFAULT 1 COMMENT '是否显示	(0不显示 1显示)',
  `menusort` int(10) NOT NULL DEFAULT 0 COMMENT '排序号',
  `menulevel` int(2) NOT NULL COMMENT '菜单级别(1一级， 2 二级）',
  `menutype` int(2) NOT NULL COMMENT '菜单类型	(0-菜单  1-按钮)',
  `imgurl` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '图片地址（font-awesome）',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '创建人',
  `modify_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后一次修改时间',
  `modify_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '修改记录用户',
  PRIMARY KEY (`menuid`) USING BTREE,
  INDEX `menuid`(`menuid`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_auth_menu
-- ----------------------------
INSERT INTO `sys_auth_menu` VALUES (755723339380686848, -1, '系统管理', '', 1, 9, 1, 0, 'cog', '2020-09-16 09:34:52', 'admin', '2020-09-16 09:34:52', 'admin');
INSERT INTO `sys_auth_menu` VALUES (755723590598524928, 755723339380686848, '机构管理', '/deptTree', 1, 1, 2, 0, 'sitemap', '2020-09-16 09:35:51', 'admin', '2020-09-16 09:35:51', 'admin');
INSERT INTO `sys_auth_menu` VALUES (755728879464873984, 755723339380686848, '角色管理', '/role', 1, 2, 2, 0, 'user-plus', '2020-09-16 09:56:52', 'admin', '2020-09-16 09:56:52', 'admin');
INSERT INTO `sys_auth_menu` VALUES (755729076756545536, 755723339380686848, '用户管理', '/user', 1, 3, 2, 0, 'user-o', '2020-09-16 09:57:39', 'admin', '2020-09-16 09:57:39', 'admin');
INSERT INTO `sys_auth_menu` VALUES (755729194348052480, 755723339380686848, '菜单管理', '/menu', 1, 4, 2, 0, 'list', '2020-09-16 09:58:07', 'admin', '2020-09-16 09:58:07', 'admin');
INSERT INTO `sys_auth_menu` VALUES (755842837718892544, -1, '服务器管理', '-', 1, 1, 1, 0, 'cog', '2020-09-16 17:29:42', 'admin', '2020-09-16 17:29:42', 'admin');
INSERT INTO `sys_auth_menu` VALUES (755843116090654720, -1, '设备管理', '/devices', 1, 2, 1, 0, 'camera', '2020-09-16 17:30:48', 'admin', '2020-09-16 17:30:48', 'admin');
INSERT INTO `sys_auth_menu` VALUES (755843295707529216, -1, '视频监控', '/live', 1, 3, 1, 0, 'video-camera', '2020-09-16 17:31:31', 'admin', '2020-09-16 17:31:31', 'admin');
INSERT INTO `sys_auth_menu` VALUES (755843518601232384, 755723339380686848, '参数配置', '/config', 1, 8, 2, 0, 'cogs', '2020-09-16 17:32:24', 'admin', '2020-09-16 17:32:24', 'admin');
INSERT INTO `sys_auth_menu` VALUES (755845973078573056, 755729194348052480, '菜单管理_添加', '', 1, 1, 3, 1, '', '2020-09-16 17:42:09', 'admin', '2020-09-16 17:42:09', 'admin');
INSERT INTO `sys_auth_menu` VALUES (755846052728406016, 755729194348052480, '菜单管理_编辑', '', 1, 2, 3, 1, '', '2020-09-16 17:42:28', 'admin', '2020-09-16 17:42:28', 'admin');
INSERT INTO `sys_auth_menu` VALUES (755846117727535104, 755729194348052480, '菜单管理_删除', '', 1, 3, 3, 1, '', '2020-09-16 17:42:44', 'admin', '2020-09-16 17:42:44', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756079874053111808, 755729076756545536, '用户管理_添加', '', 1, 1, 3, 1, '', '2020-09-17 09:11:29', 'admin', '2020-09-17 09:11:29', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756079941996642304, 755729076756545536, '用户管理_编辑', '', 1, 2, 3, 1, '', '2020-09-17 09:11:46', 'admin', '2020-09-17 09:11:46', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756080004277862400, 755729076756545536, '用户管理_删除', '', 1, 3, 3, 1, '', '2020-09-17 09:12:00', 'admin', '2020-09-17 09:12:00', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756081462758998016, 755728879464873984, '角色管理_添加', '', 1, 1, 3, 1, '', '2020-09-17 09:17:48', 'admin', '2020-09-17 09:17:48', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756081554404540416, 755728879464873984, '角色管理_编辑', '', 1, 2, 3, 1, '', '2020-09-17 09:18:10', 'admin', '2020-09-17 09:18:10', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756081633836269568, 755728879464873984, '角色管理_删除', '', 1, 3, 3, 1, '', '2020-09-17 09:18:29', 'admin', '2020-09-17 09:18:29', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756082012099575808, 755728879464873984, '角色管理_分配权限', '', 1, 4, 3, 1, '', '2020-09-17 09:19:59', 'admin', '2020-09-17 09:19:59', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756082824884387840, 755723590598524928, '机构管理_添加', '', 1, 1, 3, 1, '', '2020-09-17 09:23:13', 'admin', '2020-09-17 09:23:13', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756082890063872000, 755723590598524928, '机构管理_编辑', '', 1, 2, 3, 1, '', '2020-09-17 09:23:28', 'admin', '2020-09-17 09:23:28', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756082958280032256, 755723590598524928, '机构管理_删除', '', 1, 3, 3, 1, '', '2020-09-17 09:23:45', 'admin', '2020-09-17 09:23:45', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756090393669533696, 755843116090654720, '设备管理_添加', '', 1, 1, 2, 1, '', '2020-09-17 09:53:17', 'admin', '2020-09-17 09:53:17', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756090541694910464, 755843116090654720, '设备管理_编辑', '', 1, 2, 2, 1, '', '2020-09-17 09:53:53', 'admin', '2020-09-17 09:53:53', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756090618203209728, 755843116090654720, '设备管理_删除', '', 1, 3, 2, 1, '', '2020-09-17 09:54:11', 'admin', '2020-09-17 09:54:11', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756090917986893824, 755843116090654720, '设备管理_查看通道', '', 1, 4, 2, 1, '', '2020-09-17 09:55:22', 'admin', '2020-09-17 09:55:22', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756091030016753664, 755843116090654720, '设备管理_通道添加', '', 1, 5, 2, 1, '', '2020-09-17 09:55:49', 'admin', '2020-09-17 09:55:49', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756091457781235712, 755843116090654720, '设备管理_通道编辑', '', 1, 0, 2, 1, '', '2020-09-17 09:57:31', 'admin', '2020-09-17 09:57:31', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756091557672779776, 755843116090654720, '设备管理_通道删除', '', 1, 0, 2, 1, '', '2020-09-17 09:57:55', 'admin', '2020-09-17 09:57:55', 'admin');
INSERT INTO `sys_auth_menu` VALUES (756536478963728384, -1, '历史视频', '/historical', 1, 4, 1, 0, 'camera-retro', '2020-09-18 15:25:52', 'admin', '2020-09-18 15:25:52', 'admin');
INSERT INTO `sys_auth_menu` VALUES (758060053117927424, -1, '国标级联', '/sipServer', 1, 5, 1, 0, 'cloud-upload', '2020-09-22 20:20:00', 'admin', '2020-09-22 20:20:00', 'admin');
INSERT INTO `sys_auth_menu` VALUES (758061738758373376, 758060053117927424, '国标级联_添加', '', 1, 1, 2, 1, '', '2020-09-22 20:26:42', 'admin', '2020-09-22 20:26:42', 'admin');
INSERT INTO `sys_auth_menu` VALUES (758061804067880960, 758060053117927424, '国标级联_编辑', '', 1, 2, 2, 1, '', '2020-09-22 20:26:58', 'admin', '2020-09-22 20:26:58', 'admin');
INSERT INTO `sys_auth_menu` VALUES (758062008217239552, 758060053117927424, '国标级联_删除', '', 1, 3, 2, 1, '', '2020-09-22 20:27:46', 'admin', '2020-09-22 20:27:46', 'admin');
INSERT INTO `sys_auth_menu` VALUES (765967229702504448, 758060053117927424, '国标级联_查询', '', 1, 0, 2, 1, '', '2020-10-14 16:00:18', 'admin', '2020-10-14 16:00:18', 'admin');
INSERT INTO `sys_auth_menu` VALUES (765967447684677632, 755843116090654720, '设备管理_查询', '', 1, 0, 2, 1, '', '2020-10-14 16:01:10', 'admin', '2020-10-14 16:01:10', 'admin');
INSERT INTO `sys_auth_menu` VALUES (765967554614263808, 755723590598524928, '机构管理_查询', '', 1, 0, 3, 1, '', '2020-10-14 16:01:35', 'admin', '2020-10-14 16:01:35', 'admin');
INSERT INTO `sys_auth_menu` VALUES (765967628744392704, 755728879464873984, '角色管理_查询', '', 1, 0, 3, 1, '', '2020-10-14 16:01:53', 'admin', '2020-10-14 16:01:53', 'admin');
INSERT INTO `sys_auth_menu` VALUES (765967691453431808, 755729076756545536, '用户管理_查询', '', 1, 0, 3, 1, '', '2020-10-14 16:02:08', 'admin', '2020-10-14 16:02:08', 'admin');
INSERT INTO `sys_auth_menu` VALUES (765967753176809472, 755729194348052480, '菜单管理_查询', '', 1, 0, 3, 1, '', '2020-10-14 16:02:23', 'admin', '2020-10-14 16:02:23', 'admin');
INSERT INTO `sys_auth_menu` VALUES (765968442389037056, -1, '报警管理', '', 1, 6, 1, 0, 'bell', '2020-10-14 16:05:07', 'admin', '2020-10-14 16:05:07', 'admin');
INSERT INTO `sys_auth_menu` VALUES (765968567568039936, 765968442389037056, '报警查询', '/alarms', 1, 1, 2, 0, 'bell-o', '2020-10-14 16:05:37', 'admin', '2020-10-14 16:05:37', 'admin');
INSERT INTO `sys_auth_menu` VALUES (765968905243066368, 765968567568039936, '报警查询_查询', '', 1, 0, 3, 1, '', '2020-10-14 16:06:57', 'admin', '2020-10-14 16:06:57', 'admin');
INSERT INTO `sys_auth_menu` VALUES (765968992186793984, 765968567568039936, '报警查询_删除', '', 1, 1, 3, 1, '', '2020-10-14 16:07:18', 'admin', '2020-10-14 16:07:18', 'admin');
INSERT INTO `sys_auth_menu` VALUES (765969072327360512, 765968567568039936, '报警查询_全部删除', '', 1, 2, 3, 1, '', '2020-10-14 16:07:37', 'admin', '2020-10-14 16:07:37', 'admin');
INSERT INTO `sys_auth_menu` VALUES (792073739763318784, 755723339380686848, '设备类型管理', '/deviceType', 1, 5, 2, 0, 'deaf', '2020-12-25 16:58:23', 'admin', '2020-12-25 16:58:23', 'admin');
INSERT INTO `sys_auth_menu` VALUES (792074049139376128, 792073739763318784, '设备类型管理_添加', '', 1, 1, 3, 1, '', '2020-12-25 16:59:36', 'admin', '2020-12-25 16:59:36', 'admin');
INSERT INTO `sys_auth_menu` VALUES (792074242438070272, 792073739763318784, '设备类型管理_编辑', '', 1, 2, 3, 1, '', '2020-12-25 17:00:22', 'admin', '2020-12-25 17:00:22', 'admin');
INSERT INTO `sys_auth_menu` VALUES (792074331927740416, 792073739763318784, '设备类型管理_删除', '', 1, 3, 3, 1, '', '2020-12-25 17:00:44', 'admin', '2020-12-25 17:00:44', 'admin');
INSERT INTO `sys_auth_menu` VALUES (813423103618187264, 755723339380686848, '录像计划', '/VideoSetting', 1, 6, 2, 0, 'file-video-o', '2021-02-22 14:53:00', 'admin', '2021-02-22 14:53:00', 'admin');
INSERT INTO `sys_auth_menu` VALUES (813463394333097984, 813423103618187264, '录像计划_添加', '', 1, 1, 3, 1, '', '2021-02-22 17:33:06', 'admin', '2021-02-22 17:33:06', 'admin');
INSERT INTO `sys_auth_menu` VALUES (813463482111492096, 813423103618187264, '录像计划_编辑', '', 1, 1, 3, 1, '', '2021-02-22 17:33:27', 'admin', '2021-02-22 17:33:27', 'admin');
INSERT INTO `sys_auth_menu` VALUES (813463600520888320, 813423103618187264, '录像计划_删除', '', 1, 3, 3, 1, '', '2021-02-22 17:33:55', 'admin', '2021-02-22 17:33:55', 'admin');
INSERT INTO `sys_auth_menu` VALUES (822873958868189184, 755842837718892544, '服务器配置', '/server/config', 1, 0, 2, 0, 'cogs', '2021-03-20 16:47:20', 'admin', '2021-03-20 16:47:20', 'admin');
INSERT INTO `sys_auth_menu` VALUES (822874304822771712, 755842837718892544, '服务器状态', '/server/status', 1, 1, 2, 0, 'dashboard', '2021-03-20 16:48:42', 'admin', '2021-03-20 16:48:42', 'admin');

-- ----------------------------
-- Table structure for sys_auth_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_auth_user`;
CREATE TABLE `sys_auth_user`  (
  `userid` bigint(20) NOT NULL COMMENT '用户id主键',
  `deptid` bigint(20) NOT NULL COMMENT '组织机构	外键（机构ID）',
  `loginname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'loginname',
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登录密码',
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '姓名',
  `usersex` int(1) DEFAULT 1 COMMENT '性别（0 女 1 男）',
  `mobile` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '手机号',
  `telephone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '固定电话',
  `email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `user_number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '用户编码（用于授权）',
  `validtime` datetime(0) DEFAULT NULL COMMENT '有效期',
  `status` int(1) NOT NULL DEFAULT 1 COMMENT '状态（停用/激活状态）1 激活 0 停用 默认为：1',
  `usergroupid` bigint(20) DEFAULT NULL COMMENT '用户组id（角色ID）',
  `logintime` datetime(0) DEFAULT NULL COMMENT '登陆时间',
  `exittime` datetime(0) DEFAULT NULL COMMENT '注销时间',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备注',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '创建用户',
  `modify_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `modify_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '修改用户',
  PRIMARY KEY (`userid`) USING BTREE,
  UNIQUE INDEX `loginname`(`loginname`) USING BTREE,
  INDEX `userid`(`userid`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_auth_user
-- ----------------------------
INSERT INTO `sys_auth_user` VALUES (1, 1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', '超级管理员', 1, '15173296030', '', '', '', '2099-01-01 00:00:00', 1, 1, '2021-05-29 10:00:40', '2021-05-28 19:05:12', '', '2017-09-18 19:19:47', 'admin', '2019-05-15 22:54:36', 'admin');
INSERT INTO `sys_auth_user` VALUES (755381130739449856, 2, 'ceshi', 'E10ADC3949BA59ABBE56E057F20F883E', '测试', 1, '15100090001', '073150001001', '549188022@qq.com', '232323', '2020-09-30 00:00:00', 1, 755351183601827840, '2020-09-30 10:27:40', '2020-09-30 10:22:03', NULL, '2020-09-15 10:55:01', 'admin', '2020-09-15 10:55:01', 'admin');
INSERT INTO `sys_auth_user` VALUES (823943877969969152, 766712371250069504, 'test', 'E10ADC3949BA59ABBE56E057F20F883E', 'test', 1, '', '', '', '', NULL, 1, 1, '2021-05-25 23:15:58', '2021-05-26 00:07:15', NULL, '2021-03-23 15:38:48', 'admin', '2021-03-23 15:38:48', 'admin');

-- ----------------------------
-- Table structure for sys_auth_user_group
-- ----------------------------
DROP TABLE IF EXISTS `sys_auth_user_group`;
CREATE TABLE `sys_auth_user_group`  (
  `usergroupid` bigint(20) NOT NULL COMMENT '用户组ID',
  `usergroupname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户组名称',
  `usergroupdesc` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '用户组描述',
  `op_userid` bigint(20) DEFAULT NULL COMMENT '操作人ID',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '创建用户',
  `modify_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `modify_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '修改用户',
  PRIMARY KEY (`usergroupid`) USING BTREE,
  INDEX `USERGROUPID`(`usergroupid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of sys_auth_user_group
-- ----------------------------
INSERT INTO `sys_auth_user_group` VALUES (1, '管理员角色', '管理员角色', 0, '2020-09-10 15:31:58', 'admin', '2020-09-10 18:17:16', 'admin');
INSERT INTO `sys_auth_user_group` VALUES (755138606238138368, '宏宇管理员', '描述', NULL, '2020-09-14 18:51:14', 'admin', '2020-09-14 18:51:14', 'admin');
INSERT INTO `sys_auth_user_group` VALUES (755351183601827840, '测试角色', '测试', NULL, '2020-09-15 08:56:01', 'admin', '2020-09-15 08:56:01', 'admin');
INSERT INTO `sys_auth_user_group` VALUES (846889932835389440, 'wpc', '1', NULL, '2021-05-25 23:18:14', 'admin', '2021-05-25 23:18:14', 'admin');

-- ----------------------------
-- Table structure for sys_auth_user_group_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_auth_user_group_menu`;
CREATE TABLE `sys_auth_user_group_menu`  (
  `id` bigint(20) NOT NULL,
  `usergroupid` bigint(20) NOT NULL COMMENT '用户组id',
  `menuid` bigint(20) NOT NULL COMMENT '菜单id',
  `is_half` int(1) NOT NULL DEFAULT 0 COMMENT '是否为半选中（0全选中 1半选中）',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '创建用户',
  `modify_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `modify_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'admin' COMMENT '修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_usergroupid_menuid`(`usergroupid`, `menuid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色菜单表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of sys_auth_user_group_menu
-- ----------------------------
INSERT INTO `sys_auth_user_group_menu` VALUES (756835863702405120, 755351183601827840, 755842837718892544, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835863752736768, 755351183601827840, 755843116090654720, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835863798874112, 755351183601827840, 756091457781235712, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835863840817152, 755351183601827840, 756091557672779776, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835863882760192, 755351183601827840, 756090393669533696, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835863924703232, 755351183601827840, 756090541694910464, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835863966646272, 755351183601827840, 756090618203209728, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864008589312, 755351183601827840, 756090917986893824, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864058920960, 755351183601827840, 756091030016753664, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864100864000, 755351183601827840, 756082824884387840, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864142807040, 755351183601827840, 756082890063872000, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864184750080, 755351183601827840, 756081462758998016, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864226693120, 755351183601827840, 756081554404540416, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864268636160, 755351183601827840, 756081633836269568, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864314773504, 755351183601827840, 756079874053111808, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864356716544, 755351183601827840, 756079941996642304, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864398659584, 755351183601827840, 755845973078573056, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864440602624, 755351183601827840, 755846052728406016, 0, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864478351360, 755351183601827840, 755723339380686848, 1, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864520294400, 755351183601827840, 755723590598524928, 1, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864562237440, 755351183601827840, 755728879464873984, 1, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864604180480, 755351183601827840, 755729076756545536, 1, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (756835864646123520, 755351183601827840, 755729194348052480, 1, '2020-09-19 11:15:31', 'admin', '2020-09-19 11:15:31', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969414293159936, 1, 755842837718892544, 0, '2020-10-14 16:08:59', 'admin', '2020-10-14 16:08:59', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969414830030848, 1, 755843116090654720, 0, '2020-10-14 16:08:59', 'admin', '2020-10-14 16:08:59', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969415144603648, 1, 756091457781235712, 0, '2020-10-14 16:08:59', 'admin', '2020-10-14 16:08:59', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969415471759360, 1, 756091557672779776, 0, '2020-10-14 16:08:59', 'admin', '2020-10-14 16:08:59', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969415769554944, 1, 765967447684677632, 0, '2020-10-14 16:08:59', 'admin', '2020-10-14 16:08:59', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969416075739136, 1, 756090393669533696, 0, '2020-10-14 16:08:59', 'admin', '2020-10-14 16:08:59', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969416394506240, 1, 756090541694910464, 0, '2020-10-14 16:08:59', 'admin', '2020-10-14 16:08:59', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969416864268288, 1, 756090618203209728, 0, '2020-10-14 16:09:00', 'admin', '2020-10-14 16:09:00', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969417719906304, 1, 756090917986893824, 0, '2020-10-14 16:09:00', 'admin', '2020-10-14 16:09:00', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969418021896192, 1, 756091030016753664, 0, '2020-10-14 16:09:00', 'admin', '2020-10-14 16:09:00', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969418407772160, 1, 755843295707529216, 0, '2020-10-14 16:09:00', 'admin', '2020-10-14 16:09:00', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969418835591168, 1, 756536478963728384, 0, '2020-10-14 16:09:00', 'admin', '2020-10-14 16:09:00', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969419422793728, 1, 758060053117927424, 0, '2020-10-14 16:09:00', 'admin', '2020-10-14 16:09:00', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969419737366528, 1, 765967229702504448, 0, '2020-10-14 16:09:00', 'admin', '2020-10-14 16:09:00', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969420035162112, 1, 758061738758373376, 0, '2020-10-14 16:09:00', 'admin', '2020-10-14 16:09:00', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969420337152000, 1, 758061804067880960, 0, '2020-10-14 16:09:00', 'admin', '2020-10-14 16:09:00', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969420622364672, 1, 758062008217239552, 0, '2020-10-14 16:09:00', 'admin', '2020-10-14 16:09:00', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969420932743168, 1, 765968442389037056, 0, '2020-10-14 16:09:00', 'admin', '2020-10-14 16:09:00', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969421293453312, 1, 765968567568039936, 0, '2020-10-14 16:09:00', 'admin', '2020-10-14 16:09:00', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969421578665984, 1, 765968905243066368, 0, '2020-10-14 16:09:01', 'admin', '2020-10-14 16:09:01', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969421876461568, 1, 765968992186793984, 0, '2020-10-14 16:09:01', 'admin', '2020-10-14 16:09:01', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969422203617280, 1, 765969072327360512, 0, '2020-10-14 16:09:01', 'admin', '2020-10-14 16:09:01', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969422782431232, 1, 755843518601232384, 0, '2020-10-14 16:09:01', 'admin', '2020-10-14 16:09:01', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969423365439488, 1, 755723339380686848, 0, '2020-10-14 16:09:01', 'admin', '2020-10-14 16:09:01', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969423759704064, 1, 755723590598524928, 0, '2020-10-14 16:09:01', 'admin', '2020-10-14 16:09:01', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969424074276864, 1, 765967554614263808, 0, '2020-10-14 16:09:01', 'admin', '2020-10-14 16:09:01', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969424367878144, 1, 756082824884387840, 0, '2020-10-14 16:09:01', 'admin', '2020-10-14 16:09:01', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969424690839552, 1, 756082890063872000, 0, '2020-10-14 16:09:01', 'admin', '2020-10-14 16:09:01', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969425299013632, 1, 756082958280032256, 0, '2020-10-14 16:09:01', 'admin', '2020-10-14 16:09:01', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969425722638336, 1, 755728879464873984, 0, '2020-10-14 16:09:02', 'admin', '2020-10-14 16:09:02', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969426179817472, 1, 765967628744392704, 0, '2020-10-14 16:09:02', 'admin', '2020-10-14 16:09:02', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969426481807360, 1, 756081462758998016, 0, '2020-10-14 16:09:02', 'admin', '2020-10-14 16:09:02', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969427127730176, 1, 756081554404540416, 0, '2020-10-14 16:09:02', 'admin', '2020-10-14 16:09:02', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969427421331456, 1, 756081633836269568, 0, '2020-10-14 16:09:02', 'admin', '2020-10-14 16:09:02', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969427731709952, 1, 756082012099575808, 0, '2020-10-14 16:09:02', 'admin', '2020-10-14 16:09:02', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969428088225792, 1, 755729076756545536, 0, '2020-10-14 16:09:02', 'admin', '2020-10-14 16:09:02', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969428708982784, 1, 765967691453431808, 0, '2020-10-14 16:09:02', 'admin', '2020-10-14 16:09:02', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969429103247360, 1, 756079874053111808, 0, '2020-10-14 16:09:02', 'admin', '2020-10-14 16:09:02', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969429489123328, 1, 756079941996642304, 0, '2020-10-14 16:09:02', 'admin', '2020-10-14 16:09:02', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969429862416384, 1, 756080004277862400, 0, '2020-10-14 16:09:03', 'admin', '2020-10-14 16:09:03', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969430202155008, 1, 755729194348052480, 0, '2020-10-14 16:09:03', 'admin', '2020-10-14 16:09:03', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969430575448064, 1, 765967753176809472, 0, '2020-10-14 16:09:03', 'admin', '2020-10-14 16:09:03', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969430990684160, 1, 755845973078573056, 0, '2020-10-14 16:09:03', 'admin', '2020-10-14 16:09:03', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969431397531648, 1, 755846052728406016, 0, '2020-10-14 16:09:03', 'admin', '2020-10-14 16:09:03', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (765969431707910144, 1, 755846117727535104, 0, '2020-10-14 16:09:03', 'admin', '2020-10-14 16:09:03', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975113973760, 846889932835389440, 755842837718892544, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975126556672, 846889932835389440, 822873958868189184, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975130750976, 846889932835389440, 822874304822771712, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975139139584, 846889932835389440, 755843116090654720, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975147528192, 846889932835389440, 756091457781235712, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975151722496, 846889932835389440, 756091557672779776, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975160111104, 846889932835389440, 765967447684677632, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975172694016, 846889932835389440, 756090393669533696, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975290134528, 846889932835389440, 756090541694910464, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975294328832, 846889932835389440, 756090618203209728, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975319494656, 846889932835389440, 756090917986893824, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975336271872, 846889932835389440, 756091030016753664, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975344660480, 846889932835389440, 755843295707529216, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975353049088, 846889932835389440, 756536478963728384, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975357243392, 846889932835389440, 758060053117927424, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975365632000, 846889932835389440, 765967229702504448, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975369826304, 846889932835389440, 758061738758373376, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975378214912, 846889932835389440, 758061804067880960, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975382409216, 846889932835389440, 758062008217239552, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975390797824, 846889932835389440, 765968442389037056, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975399186432, 846889932835389440, 765968567568039936, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975407575040, 846889932835389440, 765968905243066368, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975411769344, 846889932835389440, 765968992186793984, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975420157952, 846889932835389440, 765969072327360512, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975424352256, 846889932835389440, 755723339380686848, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975432740864, 846889932835389440, 755723590598524928, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975436935168, 846889932835389440, 765967554614263808, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975445323776, 846889932835389440, 756082824884387840, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975453712384, 846889932835389440, 756082890063872000, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975457906688, 846889932835389440, 756082958280032256, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975466295296, 846889932835389440, 755728879464873984, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975478878208, 846889932835389440, 765967628744392704, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975487266816, 846889932835389440, 756081462758998016, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975491461120, 846889932835389440, 756081554404540416, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975499849728, 846889932835389440, 756081633836269568, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975504044032, 846889932835389440, 756082012099575808, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975512432640, 846889932835389440, 755729076756545536, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975516626944, 846889932835389440, 765967691453431808, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975525015552, 846889932835389440, 756079874053111808, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975529209856, 846889932835389440, 756079941996642304, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975537598464, 846889932835389440, 756080004277862400, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975545987072, 846889932835389440, 755729194348052480, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975550181376, 846889932835389440, 765967753176809472, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975558569984, 846889932835389440, 755845973078573056, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975566958592, 846889932835389440, 755846052728406016, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975571152896, 846889932835389440, 755846117727535104, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975579541504, 846889932835389440, 792073739763318784, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975587930112, 846889932835389440, 792074049139376128, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975592124416, 846889932835389440, 792074242438070272, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975600513024, 846889932835389440, 792074331927740416, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975608901632, 846889932835389440, 813423103618187264, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975621484544, 846889932835389440, 813463394333097984, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975629873152, 846889932835389440, 813463482111492096, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975634067456, 846889932835389440, 813463600520888320, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');
INSERT INTO `sys_auth_user_group_menu` VALUES (846889975642456064, 846889932835389440, 755843518601232384, 0, '2021-05-25 23:18:24', 'admin', '2021-05-25 23:18:24', 'admin');

-- ----------------------------
-- Table structure for sys_auth_user_operate
-- ----------------------------
DROP TABLE IF EXISTS `sys_auth_user_operate`;
CREATE TABLE `sys_auth_user_operate`  (
  `log_id` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `operateobj` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '操作归类，归属功能（例如：机构管理）',
  `operatetype` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '操作类型（例如：添加 编辑 删除 导出 批量导入）',
  `operateid` bigint(20) DEFAULT NULL COMMENT '用户操作对象的ID（例如：deviceid）',
  `context` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `oratetime` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统操作日志表' ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sys_param_set
-- ----------------------------
DROP TABLE IF EXISTS `sys_param_set`;
CREATE TABLE `sys_param_set`  (
  `id` bigint(20) NOT NULL,
  `close_delay` int(11) DEFAULT NULL COMMENT '视频关闭延迟',
  `clear_video_period` int(11) DEFAULT 0 COMMENT '定期清理间隔(天)',
  `session_timeout` int(11) DEFAULT 3 COMMENT '超时时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '参数设置表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of sys_param_set
-- ----------------------------
INSERT INTO `sys_param_set` VALUES (1, 60, 2, 30);

-- ----------------------------
-- Function structure for getChildLst
-- ----------------------------
DROP FUNCTION IF EXISTS `getChildLst`;
delimiter ;;
CREATE DEFINER=`root`@`%` FUNCTION `getChildLst`(rootId bigint) RETURNS varchar(20000) CHARSET utf8
BEGIN
	 RETURN (SELECT group_concat(deptid) FROM sys_auth_dept where deptidnew like CONCAT((select deptidnew from sys_auth_dept where deptid = rootId),'%'));
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
