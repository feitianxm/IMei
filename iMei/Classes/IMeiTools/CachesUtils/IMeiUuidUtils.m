//
//  IMeiUuidUtils.m
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/22.
//  Copyright © 2016年 i美. All rights reserved.
//

#import "IMeiUuidUtils.h"
#import "IMeiKeyChainUtils.h"

@implementation IMeiUuidUtils

+(NSString *)getUUID
{
    NSString * strUUID = (NSString *) [IMeiKeyChainUtils load:LGS_KeyChain_UUID_Key];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
         [IMeiKeyChainUtils save:LGS_KeyChain_UUID_Key data:strUUID];
        
    }
    //IMLOG(@"IMeiUuidUtils strUUID=>%@", strUUID);
    return strUUID;
}

@end
