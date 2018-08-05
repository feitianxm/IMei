//
//  Constants.h
//  IMei
//
//  Created by i美 on 16/5/19.
//  Copyright (c) 2016 i美. All rights reserved.
//


typedef enum {
    LoginStatus_AutoLogin           = 0,    //需要自动登录
    LoginStatus_Loging              = 1,    //正在登录中
    LoginStatus_LoginSucc           = 2,    //登录成功
    LoginStatus_LoginFail           = 3,    //登录失败
    LoginStatus_Logout              = 4,    //主动登出
    LoginStatus_ClickLogin          = 5,    //主动点击登录
}LoginStatusType;         //登录状态

typedef enum {
    SocketConnection_PingOk         = 1,    //socket ping正常
    SocketConnection_PingFail       = 2,    //socket ping失败
    SocketConnection_ConnOk         = 3,    //socket 连接成功
    SocketConnection_ConnFail       = 4,    //socket 连接断开
    SocketConnection_BadIPPort      = 5,    //socket ipPort不正常
    SocketConnection_ReConnFail     = 6,    //socket 重连失败
    SocketConnection_UnNormal       = 7,    //socket 通信不正常
    SocketConnection_NotNet         = 8,    //socket 无网络
    SocketConnection_Connecting     = 9,    //socket 网络连接中
} SocketConnectionType;     //socket通信状态类型


typedef enum {
    UserPos_Login       = 0,    //登录界面
    UserPos_Lobby       = 1,    //大厅界面
    UserPos_Setting     = 2,    //设置界面
    UserPos_Person      = 3,    //个人资料界面
    UserPos_DeviceMan   = 4,    //设备管理界面
    UserPos_DeviceInfo  = 5,    //设备信息界面
    UserPos_WifiMan     = 6,    //wifi管理界面
    UserPos_WifiSet     = 7,    //wifi设置界面
    UserPos_Shop        = 8,    //商店界面
    UserPos_Violation   = 9,    //违规界面
    UserPos_Message     = 10,   //信息界面
    UserPos_Flow        = 11,   //流量界面
    UserPos_Question    = 12,   //问题界面
    UserPos_Server      = 13,   //服务器设置界面
    UserPos_AppDetail   = 14,   //app详细界面
    
} UserPositionType; //用户所在的位置类型

typedef enum
{
    LobbyModule_CheckIn     = 1,    //准入检查
    LobbyModule_AppShop     = 2,    //应用商店
    LobbyModule_Violation   = 3,    //违规消息
    LobbyModule_Messgae     = 4,    //消息
    LobbyModule_Flow        = 5,    //流量监控
    LobbyModule_Setting     = 6,    //设置
    LobbyModule_SafeScan    = 7,    //安全扫描
} LobbyModuleType;  //大厅功能模块类型

typedef enum {
    IMeiAppOperation_Buy,         //应用安装
    IMeiAppOperation_Delete,      //应用卸载
    IMeiAppOperation_Update,      //应用更新
    IMeiAppOperation_Open,        //应用打开
} IMeiAppOperationType;

typedef enum {
    MDMMobileConfigCheckResult_Default                  = 0,    //默认值
    MDMMobileConfigCheckResult_NotInstalled             = 1,    //未安装
    MDMMobileConfigCheckResult_QueryParametersError     = 2,    //查询参数错误
    MDMMobileConfigCheckResult_Installed                = 3,    //已安装
} MDMMobileConfigCheckResult;       //检测MDM的描述文件安装结果
