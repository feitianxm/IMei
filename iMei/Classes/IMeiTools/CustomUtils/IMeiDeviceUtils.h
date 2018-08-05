//
//  DeviceUtils.h
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/27.
//  Copyright © 2016年 i美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceUtils : NSObject

/*! @brief 以类方法获取设备UUID信息，并返回
 *
 * @return 返回设备UUID信息。
 */
+ (NSString*)getDeviceUUID;


/*! @brief 获取当前设备Name.
 * @return 返回当前设备Name
 */
+ (NSString*)currentDeviceName;

/*! @brief 获取当前设备Model.
 * @return 返回当前设备Model
 */
+ (NSString*)currentDeviceModel;


/*! @brief 获取当前设备SystemName.
 * @return 返回当前设备SystemName
 */
+ (NSString*)currentDeviceSystemName;

/*! @brief 获取当前设备SystemVersion.
 * @return 返回当前设备SystemVersion
 */
+ (NSString*)currentDeviceSystemVersion;


/*! @brief 获取当前设备TotalMemoryDouble.
 * @return 返回当前设备TotalMemoryDouble
 */
+ (double)currentDeviceTotalMemoryDouble;

/*! @brief 获取当前设备TotalMemory.
 * @return 返回当前设备TotalMemory
 */
+ (NSString*)currentDeviceTotalMemory;

/*! @brief 获取当前设备Resolution.
 * @return 返回当前设备Resolution
 */
+ (NSString*)currentDeviceResolution;

/*! @brief 获取当前设备类型.
 * @return iphone/ipad
 */
+ (BOOL)currentDeviceIsPhone;

/*! @brief 获取当前设备是否越狱.
 * @return 越狱返回YES,不越狱返回NO
 */
+ (BOOL)currentDeviceIsBreak;

/*! @brief 获取当前app uuid.
 * @return 当前app uuid
 */
+ (NSString*)currentAppUUID;

/*! @brief 获取当前app标识.
 * @return 当前app标识:com.xxx.xxx
 */
+ (NSString*)currentAppIdentifier;

/*! @brief 获取当前应用版本号.
 * @return 当前当前应用版本号:1.0.0
 */
+ (NSString*)currentAppVersion;

/*! @brief 获取当前设备Mac地址.
 * @return 当前当前设备Mac地址
 */
+ (NSString *)getMacAddress;

/*! @brief 获取当前设备IP地址.
 * @return 当前当前设备IP地址
 */
+ (NSString *)getIPAddress;

/*! @brief 获取当前设备信息合集json字符串.
 *
 * @param userName 用户名称。
 * @return 当前当前设备信息合集json字符串
 */
+ (NSString*)getDeviceJsonInfoWithUserName:(NSString*)userName;
@end
