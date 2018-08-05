//
//  IMeiDataPathService.h
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/22.
//  Copyright © 2016年 i美. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const GLOBAL_CACHES_FILE_NAME;         //全局临时缓存文件
extern NSString *const GLOBAL_CONFIG_FILE_NAME;         //全局配置文件
extern NSString *const USER_CONFIG_FILE_NAME;           //用户配置文件
extern NSString *const DB_SQLITE_FILE_NAME;             //数据库文件
extern NSString *const WIFI_MOBILECONFIG_FILE_NAME;     //wifi属性描述
extern NSString *const WIFI_CONFIG_FILE_NAME;           //wifi的ssid配置文件
extern NSString *const SYSTEM_APP_LIST_NAME;            //系统默认安装的app列表配置文件

@interface IMeiDataPathService : NSObject

//Document文件路径
+ (NSString *)documentPathForAllUsers;

/*! @brief 以类方法获取Document文件路径，并返回
 *
 * @param fileName 文件名。
 * @return 返回Document文件路径。
 */
+ (NSString *)pathForAllConfigFile:(NSString*)fileName;


/*! @brief 以类方法获取Caches临时缓存文件路径，并返回
 *
 * @return 返回Caches临时缓存文件路径。
 */
+ (NSString *)pathForCachesFile;


/*! @brief 以类方法获取带用户id的Document文件路径，并返回
 *
 * @param userId 用户id。
 * @return 返回带用户id的Document文件路径。
 */
+ (NSString *)pathForConfigFileOfUser:(NSString *)userId;


/*! @brief 以类方法获取全局数据库DB文件路，并返回
 *
 * @return 返回全局数据库DB文件路。
 */
+ (NSString *)pathForDataBaseFile;

@end
