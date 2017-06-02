//
//  systemManger.m
//  xmProto
//
//  Created by ucse on 2017/5/31.
//  Copyright © 2017年 孙明月. All rights reserved.
//

#import "SystemManger.h"
#import "TXLogManager.h"

@implementation SystemManger
static id _instance = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        _logManager = [[TXLogManager alloc] init];
    }
    return self;
}

@end
