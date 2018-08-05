//
//  IMeiKeyChainUtils.h
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/22.
//  Copyright © 2016年 i美. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const LGS_KeyChain_Account_Key;        //软件账号Key
extern NSString *const LGS_KeyChain_UUID_Key;           //i美app设备UUID key
extern NSString *const LGS_KeyChain_ServerInfo_Key;     //i美服务器ipPort地址


@interface IMeiKeyChainUtils : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;


@end
