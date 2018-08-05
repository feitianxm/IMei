//
//  IMeiUuidUtils.h
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/22.
//  Copyright © 2016年 i美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMeiUuidUtils : NSObject

/*! @brief 以类方法获取设备uuid信息，并返回
 *
 * @return 返回设备uuid信息。
 */
+(NSString *)getUUID;

@end
