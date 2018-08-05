//
//  IMCommManager.m
//  iMei
//
//  Created by Chengfei Liang on 2018/8/5.
//  Copyright © 2018年 Chengfei Liang. All rights reserved.
//

#import "IMeiCommManager.h"
#import "IMeiBaseRequest.h"

@interface IMeiCommManager ()

@property (nonatomic, strong) NSOperationQueue *oprQueue;

@end


@implementation IMeiCommManager

#pragma mark - 生命周期方法
static IMeiCommManager *instance;
+ (id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[IMeiCommManager alloc] init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        _oprQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

#pragma mark - 自定义接口方法

@end
