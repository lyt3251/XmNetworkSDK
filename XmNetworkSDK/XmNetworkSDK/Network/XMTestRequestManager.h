//
//  XMTestRequestManager.h
//  XmNetworkSDK
//
//  Created by ucse on 2017/6/1.
//  Copyright © 2017年 xm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMTestRequestManager : NSObject
-(void)test_request:(NSString *)requestId index:(SInt32)index url:(NSString *)url onCompleted:(void (^)(NSError *error, NSArray *list))onCompleted;

@end
