//
// Created by lingqingwan on 9/18/15.
// Copyright (c) 2015 lingiqngwan. All rights reserved.
//

#import "TXHttpClient.h"
#import <AFNetworking.h>
#import "XMDef.h"

@implementation TXHttpClient {
    NSOperationQueue *_operationQueue;
    NSString *_version;
    NSArray *_gateWayModules;
    AFHTTPSessionManager *_manager;
}

- (TXHttpClient *)init {
    if (self = [super init]) {
        _operationQueue = [[NSOperationQueue alloc] init];
//        _gateWayModules = @[TX_MODULE_LEARNGARDEN,TX_MODULE_BRANDGROW];
    }
    return self;
}
- (void)setupHttpProtocolClass:(NSString *)className
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    if (className && [className length]) {
        configuration.protocolClasses = @[NSClassFromString(className)];
    }
    _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    AFHTTPRequestSerializer *request = [AFHTTPRequestSerializer serializer];
//    [request setValue:@"text/plain;charset=UTF-8" forKey:@"Content-Type"];
    [request setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    _manager.requestSerializer = request;
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _manager.completionQueue = dispatch_get_main_queue();
}
- (void)setupWithVersion:(NSString *)version {
    _version = version;
}


+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)handleResponse:(NSURLResponse *)response
                  data:(NSData *)data
                 error:(NSError *)error
                   url:(NSString *)url
           onCompleted:(void (^)(NSError *error, XMBASEResponse *response))onCompleted {
    NSError *innerError;
    XMBASEResponse *txResponse;

    //处理请求错误
    if (error) {
        switch (error.code) {
            case NSURLErrorTimedOut: {
                innerError = TX_ERROR_MAKE_WITH_URL(TX_STATUS_TIMEOUT, TX_STATUS_TIMEOUT_DESC, url);
                break;
            }
            case NSURLErrorCannotConnectToHost: {
                innerError = TX_ERROR_MAKE_WITH_URL(error.code, @"无法连接到服务器", url);
                break;
            }
            default: {
                innerError = TX_ERROR_MAKE_WITH_URL(error.code, @"服务请求错误", url);
            }
        }
        goto completed;
    }

    //处理http code
    NSInteger httpStatusCode = [(NSHTTPURLResponse *) response statusCode];
    switch (httpStatusCode) {
        case 200: {
            //Do nothing
            break;
        }
        case 403: {
            innerError = TX_ERROR_MAKE_WITH_URL(TX_STATUS_UNAUTHORIZED, TX_STATUS_UNAUTHORIZED_DESC, url);
            goto completed;
        }
        default: {
            innerError = TX_ERROR_MAKE_WITH_URL(httpStatusCode + 1000000, @"服务器错误", url);
            goto completed;
        }
    }

    //将http body内容解析成pb对象
    @try {
        
        txResponse = [XMBASEResponse parseFromData:data error:&innerError];
    }
    @catch (NSException *e) {
        innerError = TX_ERROR_MAKE_WITH_URL(TX_STATUS_PB_PARSE_ERROR, e.name, url);
        goto completed;
    }

    //处理协议code状态
//    switch (txpbResponse.status) {
//        case TX_STATUS_OK: {
//            break;
//        };
//        case TX_STATUS_UNAUTHORIZED: {
//            innerError = TX_ERROR_MAKE_WITH_URL(TX_STATUS_UNAUTHORIZED, txpbResponse.statusTxt, url);
//            goto completed;
//        }
//        default: {
//            innerError = TX_ERROR_MAKE_WITH_URL(txpbResponse.status, txpbResponse.statusTxt, url);
//            goto completed;
//        }
//    }

    completed:
    {
        onCompleted(innerError, txResponse);
    }
}

- (void)sendRequest:(NSString *)url
              token:(NSString *)token
           bodyData:(NSData *)bodyData
        onCompleted:(void (^)(NSError *error, XMBASEResponse *response))onCompleted {
    [self sendRequest:url token:token bodyData:bodyData requestModuleStr:@"" onCompleted:onCompleted];
}


- (void)sendRequest:(NSString *)url
              token:(NSString *)token
           bodyData:(NSData *)bodyData
         requestModuleStr:(NSString *)requestModuleStr
        onCompleted:(void (^)(NSError *error, XMBASEResponse *response))onCompleted
{
    
    XMBASERequest *txpbRequest = [XMBASERequest message];
    txpbRequest.URL = url;
    txpbRequest.body = bodyData;
    txpbRequest.version = @"1.2.0";
    txpbRequest.osName = @"iOS";
    txpbRequest.osVersion = @"10.10.1";
    NSString *requestUrl = [NSString stringWithFormat:@"http://127.0.0.1/%@", url];

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:requestUrl]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:txpbRequest.data];
    [urlRequest setTimeoutInterval:20];
    NSString* encodeResult = [txpbRequest.data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    [urlRequest setValue:encodeResult forHTTPHeaderField:@"httpBody"];
    
#ifdef TX_SYNC_HTTP_REQUEST
    NSURLResponse *syncResponse;
    NSError *syncError;
    NSData *syncData;
    syncData = [NSURLConnection sendSynchronousRequest:urlRequest
                                     returningResponse:&syncResponse
                                                 error:&syncError];
    [self handleResponse:syncResponse data:syncData error:syncError url:url onCompleted:onCompleted];
#else
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [_manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf handleResponse:response data:(NSData *)responseObject error:error url:url onCompleted:onCompleted];
        }
    }];
    [task resume];
#endif
}


@end
