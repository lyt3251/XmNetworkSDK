//
//  TXLogManager.m
//  TXChatParent
//
//  Created by lyt on 16/5/26.
//  Copyright © 2016年 lyt. All rights reserved.
//

#import "TXLogManager.h"
#import <DDLog.h>
#import <DDFileLogger.h>
#import "XMDef.h"

NSString *const TXConsoleSupportShakeToShowKey = @"txConsoleSupportShakeToShowKey";
static NSString *const kLogDocumentDirectory = @"txLogs";
#pragma mark - 根据请求的url来获取pb的类名
static inline NSString *TXPBRequestClassNameForURLPath(NSString *path) {
    if (!path || ![path length]) {
        return nil;
    }
    return nil;
}
//#pragma mark - 根据response的url来获取pb的类名
//static inline NSString *TXPBResponseClassNameForURLPath(NSString *path) {
//    if (!path || ![path length]) {
//        return nil;
//    }
//    return nil;
//}

@interface TXLogManager()

@property (nonatomic,strong) DDFileLogger *fileLogger;
@property (nonatomic,copy) NSString *documentPath;
@end

@implementation TXLogManager

#pragma mark - LifeCycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        //创建目录
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _documentPath = [documentsDirectory stringByAppendingPathComponent:kLogDocumentDirectory];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = NO;
        if (![fileManager fileExistsAtPath:_documentPath isDirectory:&isDir]) {
            [fileManager createDirectoryAtPath:_documentPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        DDLogDebug(@"path:%@", _documentPath);
        //创建FileLogger
        DDLogFileManagerDefault *logFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:_documentPath];
        logFileManager.maximumNumberOfLogFiles = 1; //默认只保存一个文件
        self.fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
        self.fileLogger.maximumFileSize = kDDDefaultLogMaxFileSize;
        self.fileLogger.rollingFrequency = kDDDefaultLogRollingFrequency;
        //设置是否支持震动显示Console
        NSNumber *showKey = [[NSUserDefaults standardUserDefaults] valueForKey:TXConsoleSupportShakeToShowKey];
        if (showKey != nil) {
            _enableShakeToShowConsole = [showKey boolValue];
        }else{
            _enableShakeToShowConsole = YES;
            [[NSUserDefaults standardUserDefaults] setValue:@(_enableShakeToShowConsole) forKey:TXConsoleSupportShakeToShowKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return self;
}
#pragma mark - Log信息
//log信息
- (void)logMessage:(NSString *)message
{
    if (!message || ![message length]) {
        return;
    }
    DDLogMessage *msg = [[DDLogMessage alloc] initWithMessage:message level:DDLogLevelDebug flag:DDLogFlagDebug context:0 file:[NSString stringWithFormat:@"%s",__FILE__] function:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__] line:__LINE__ tag:0 options:(DDLogMessageOptions)0 timestamp:nil];
    [self.fileLogger logMessage:msg];
}
#pragma mark - 根据URL的路径获取TXPB的Class名称
- (NSString *)requestClassNameForURLPath:(NSString *)path
{
    return TXPBRequestClassNameForURLPath(path);
}
#pragma mark - Public methods
- (NSArray *)urlRequestLogs
{
    if (!_documentPath) {
        return nil;
    }
    NSError *error = nil;
    NSArray *pathList = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:_documentPath error:&error];
    if (error) {
        return nil;
    }
    NSMutableArray *paths = [NSMutableArray array];
    for (NSString *name in pathList) {
        if ([name hasSuffix:@".log"]) {
            [paths addObject:name];
        }
    }
    NSArray *sortArray = [paths sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        NSDictionary *fileAttributes1 = [[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",_documentPath,obj1] error:nil];
        NSDictionary *fileAttributes2 = [[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",_documentPath,obj2] error:nil];
        NSDate *date1 = [fileAttributes1 valueForKey:NSFileModificationDate];
        NSDate *date2 = [fileAttributes2 valueForKey:NSFileModificationDate];
        return date1 < date2;
    }];
    NSMutableArray *list = [NSMutableArray array];
    paths = [NSMutableArray arrayWithArray:sortArray];
    if ([paths count] > 0) {
        //只读取最新的一个文件
        NSString *path = paths[0];
        //log文件
        NSURL *fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",_documentPath,path]];
        NSString *content = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
        NSArray *arr = [content componentsSeparatedByString:@"--------"];
        if (arr) {
            [list addObjectsFromArray:arr];
        }
        [list removeObject:@"\n"];
        //倒序返回
        return [[list reverseObjectEnumerator] allObjects];
    }
    return nil;
//    for (NSInteger i = 0; i < [paths count]; i++) {
//        NSString *path = paths[i];
//        //log文件
//        NSURL *fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",_documentPath,path]];
//        NSString *content = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
//        NSArray *arr = [content componentsSeparatedByString:@"--------"];
//        if (arr) {
//            [list addObjectsFromArray:arr];
//        }
//    }
    //倒序返回
//    return [[list reverseObjectEnumerator] allObjects];
}
- (void)setEnableShakeToShowConsole:(BOOL)enableShakeToShowConsole
{
    _enableShakeToShowConsole = enableShakeToShowConsole;
    [[NSUserDefaults standardUserDefaults] setValue:@(_enableShakeToShowConsole) forKey:TXConsoleSupportShakeToShowKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
