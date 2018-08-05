//
//  IMeiCommManager_Request.m
//  iMei
//
//  Created by Chengfei Liang on 2018/8/5.
//  Copyright © 2018年 Chengfei Liang. All rights reserved.
//

#import "IMeiCommManager_Request.h"

@implementation IMeiCommManager(Request)

#pragma mark - IMeiBaseRequestDelegate
//网络请求的成功回调
- (void)iMeiRequest:(IMeiBaseRequest *)iMeiRequest didLoad:(id)result
{
    
}

//网络请求的失败回调
-(void)iMeiRequest:(IMeiBaseRequest *)iMeiRequest didFailWithError:(NSError *)error
{
    
}

@end
