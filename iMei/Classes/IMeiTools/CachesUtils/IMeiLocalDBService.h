//
//  IMeiLocalDBUtils.h
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/23.
//  Copyright © 2016年 i美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface IMeiLocalDBService : NSObject
{
    sqlite3     *dataBase;
    BOOL        isDBOpen;
}

/*! @brief 以单例模块创建LSLocalDBService实例对象，并返回
 *
 * @return 返回LSLocalDBService实例对象。
 */
+ (id)shareLocalDBService;


/*! @brief 释放LSLocalDBService实例对象
 *
 */
+ (void)releaseLocalDBService;

@end
