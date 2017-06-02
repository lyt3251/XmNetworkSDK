//
//  systemManger.h
//  xmProto
//
//  Created by ucse on 2017/5/31.
//  Copyright © 2017年 孙明月. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TXLogManager;
@interface SystemManger : NSObject
+ (instancetype)sharedManager;

@property(nonatomic, strong)TXLogManager *logManager;

@end
