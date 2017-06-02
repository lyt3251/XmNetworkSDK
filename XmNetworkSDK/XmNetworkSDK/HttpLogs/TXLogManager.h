//
//  TXLogManager.h
//  TXChatParent
//
//  Created by lyt on 16/5/26.
//  Copyright © 2016年 lyt. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const TXConsoleSupportShakeToShowKey;

@interface TXLogManager : NSObject

/**
 *  网络请求的log信息
 */
@property (nonatomic,strong) NSArray<NSString *> *urlRequestLogs;
/**
 *  是否支持摇一摇显示Console界面,默认为YES
 */
@property (nonatomic) BOOL enableShakeToShowConsole;
/**
 *  是否正在展示Console界面
 */
@property (nonatomic) BOOL isShowingConsole;

/**
 *  log信息
 *
 *  @param message 要log的文本内容
 */
- (void)logMessage:(NSString *)message;

/**
 *  根据请求的url来获取pb的类名
 *
 *  @param path 类似/class_attendance的子路径
 *
 *  @return Class名称
 */
- (NSString *)requestClassNameForURLPath:(NSString *)path;

@end
