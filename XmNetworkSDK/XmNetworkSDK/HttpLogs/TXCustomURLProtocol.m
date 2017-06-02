//
//  TXCustomURLProtocol.m
//  TXChat
//
//  Created by lyt on 15/7/19.
//  Copyright (c) 2015年 lyt. All rights reserved.
//

#import "TXCustomURLProtocol.h"
#import "SystemManger.h"
#import "Xm.pbobjc.h"
#import "TXLogManager.h"
#import "Message.pbobjc.h"
#import <GPBMessage.h>

static NSString *const kURLProtocolHandledKey = @"urlProtocolHandledKey";
static NSString *const kHostPath_HttpInvoke = @"http_invoke";
static NSString *const kHostPath_AppGateway = @"app_gateway";

@interface TXCustomURLProtocol()
<NSURLSessionDelegate,
NSURLSessionDataDelegate,
NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *task;
@end


@implementation TXCustomURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    NSString *urlString = [[request URL] absoluteString];
    //判断是否包含http_invoke，如果包含则是土星服务器，替换请求
    if (([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame) )
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:kURLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        return YES;
    }
    return NO;
}
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}
//修改请求Host
- (NSMutableURLRequest*)redirectHostInRequset:(NSMutableURLRequest*)request
{
    if ([request.URL host].length == 0) {
        return request;
    }
    
    return request;
}
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}
- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    mutableReqeust = [self redirectHostInRequset:mutableReqeust];
    //标示改request已经处理过了，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:kURLProtocolHandledKey inRequest:mutableReqeust];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    self.task = [session dataTaskWithRequest:mutableReqeust];
    [self.task resume];
    /*记录网络请求的信息*/
    TXLogManager *logManager = [SystemManger sharedManager].logManager;
    if (!logManager) {
        return;
    }
    NSMutableString *logString = [NSMutableString string];
    //添加url
    if (mutableReqeust.URL.absoluteString && [mutableReqeust.URL.absoluteString length]) {
        [logString appendString:@"请求URL:"];
        [logString appendString:mutableReqeust.URL.absoluteString];
    }
    //添加具体的url路径
//    NSData *body = mutableReqeust.HTTPBody;
    NSString *httpBody = [mutableReqeust valueForHTTPHeaderField:@"httpBody"];
    XMBASERequest *txpbRequest;
    @try {
        NSError *error;
        NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:httpBody options:0];
        
        txpbRequest = [XMBASERequest parseFromData:decodeData error:&error];
        NSString *path = txpbRequest.URL;
         [logString appendString:path];
        [logString appendString:@"\n"];
        NSMutableString *bodyString = [NSMutableString string];
        //添加url
        [bodyString appendFormat:@"path:%@\n",path];
        NSString *className = [mutableReqeust valueForHTTPHeaderField:@"className"];
        //添加body
        if (txpbRequest.body != nil && className.length > 0) {
            //获取具体的请求内容
            if (className) {
                NSData *data = txpbRequest.body;
                Class cls = NSClassFromString(className);
                if ([cls isSubclassOfClass:[GPBMessage class]])
                {
                    id requestInfo = [cls parseFromData:data error:nil];
                    [bodyString appendFormat:@"body:{%@}\n",requestInfo];
                }
            }
        }
        //添加token
        [bodyString appendFormat:@"token:%@\n",txpbRequest.token];
        //添加version
        [bodyString appendFormat:@"version:%@\n",txpbRequest.version];
        //添加osName
        [bodyString appendFormat:@"osName:%@\n",txpbRequest.osName];
        //添加osVersion
        [bodyString appendFormat:@"osVersion:%@\n",txpbRequest.osVersion];
        //添加进log字符串
        [logString appendFormat:@"请求信息:\n%@",bodyString];
    } @catch (NSException *exception) {
        [logString appendString:@"\n"];
    }
    //添加区别的分割线
    [logString appendString:@"--------"];
    [logManager logMessage:logString];

}
- (void)stopLoading
{
    [self.task cancel];
}
#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        dispatch_async(dispatch_get_main_queue(), ^{
            //须在主线程回调credential
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            //须在主线程回调credential
            completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
        });
    }
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    }else{
        [self.client URLProtocolDidFinishLoading:self];
    }
}
@end
