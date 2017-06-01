//
// Created by lingqingwan on 9/18/15.
// Copyright (c) 2015 lingiqngwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.pbobjc.h"

@interface TXHttpClient : NSObject

+ (instancetype)sharedInstance;

- (void)setupHttpProtocolClass:(NSString *)className;
- (void)setupWithVersion:(NSString *)version;

//主域名为http://api.tx2010.com:80/http_invoke的请求
- (void)sendRequest:(NSString *)url
              token:(NSString *)token
           bodyData:(NSData *)bodyData
        onCompleted:(void (^)(NSError *error, XMBASEResponse *response))onCompleted;

///**
// *  发送请求
// *
// *  @param url         接口请求path地址
// *  @param host        主域名地址
// *  @param token       用户当前token
// *  @param bodyData    HTTPBody
// *  @param onCompleted Completion回调
// */
//- (void)sendRequest:(NSString *)url
//               host:(NSString *)host
//              token:(NSString *)token
//           bodyData:(NSData *)bodyData
//        onCompleted:(void (^)(NSError *error, TXPBResponse *response))onCompleted;

/**
 *  分模块请求参数
 *
 *  @param url              pb请求的url
 *  @param token            当前登录token
 *  @param bodyData         请求消息体
 *  @param requestModuleStr 请求模块名
 *  @param onCompleted      请求完成
 */
- (void)sendRequest:(NSString *)url
              token:(NSString *)token
           bodyData:(NSData *)bodyData
   requestModuleStr:(NSString *)requestModuleStr
        onCompleted:(void (^)(NSError *error, XMBASEResponse *response))onCompleted;

@end
