//
//  IMeiDataPathService.m
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/22.
//  Copyright © 2016年 i美. All rights reserved.
//

#import "IMeiDataPathService.h"

NSString *const GLOBAL_CACHES_FILE_NAME = @"temp/caches";           //全局临时缓存文件
NSString *const GLOBAL_CONFIG_FILE_NAME = @"globalConfig.plist";    //全局配置文件
NSString *const USER_CONFIG_FILE_NAME   = @"userConfig.plist";      //用户配置文件
NSString *const DB_SQLITE_FILE_NAME     = @"dbFile.sqlite3";        //数据库文件
NSString *const WIFI_MOBILECONFIG_FILE_NAME     = @"wifi.mobileconfig";        //wifi属性描述
NSString *const WIFI_CONFIG_FILE_NAME   = @"wifi.plist";            //wifi的ssid配置文件
NSString *const SYSTEM_APP_LIST_NAME    = @"systemApp.plist";       //系统默认安装的app列表配置文件

@implementation IMeiDataPathService

#pragma mark - 设备Document,Caches文件主路径
//Document文件路径
+ (NSString *)documentPathForAllUsers
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

//Caches文件路径
+ (NSString *)pathForAllUserCaches
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

//带用户id的Document文件路径
+ (NSString *)pathForUserId:(NSString *)userId
{
    if (!userId || [userId isEqualToString:@""]) {
        userId = @"0";
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:userId];
}

#pragma mark - 获取用户相关文件路径
//获取全局用户Document文件路径
+ (NSString *)pathForAllConfigFile:(NSString*)fileName
{
    return [[self documentPathForAllUsers] stringByAppendingPathComponent:fileName];
}

//获取指定用户Document文件路径
+ (NSString *)pathForConfigFileOfUser:(NSString *)userId
{
    return [[self pathForUserId:userId] stringByAppendingPathComponent:USER_CONFIG_FILE_NAME];
}

//获取全局用户Caches文件路径
+ (NSString *)pathForCachesFile
{
    return [[self pathForAllUserCaches] stringByAppendingPathComponent:GLOBAL_CACHES_FILE_NAME];
}

//全局数据库DB文件路径
+ (NSString *)pathForDataBaseFile
{
    return [[self documentPathForAllUsers] stringByAppendingPathComponent:DB_SQLITE_FILE_NAME];
}


@end
