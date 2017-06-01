//
//  XMDef.h
//  XmNetworkSDK
//
//  Created by ucse on 2017/6/1.
//  Copyright © 2017年 xm. All rights reserved.
//

#ifndef XMDef_h
#define XMDef_h
#import <Foundation/Foundation.h>
//#import <CocoaLumberjack.h>

#define TX_CHAT_SERVER_ENDPOINT                         @"http://127.0.0.1"

#define TX_SETTING_POST_IS_READ                         @"__post_is_read_"

#define TX_CLIENT_NS_ERROR_DOMAIN                       @"com.ucse.ios.sdk"

#define TX_NOTIFICATION_ERROR                           @"ucse.notification.error"
#define TX_NOTIFICATION_COUNTER_REFRESHED               @"ucse.notification.counter.refreshed"
#define TX_NOTIFICATION_COUNTER_FETCHED                 @"ucse.notification.counter.fetched"
#define TX_NOTIFICATION_CURRENT_USER_CHANGED            @"ucse.notification.current.user.changed"
#define TX_NOTIFICATION_QR_CHECK_IN_COUNT_CHANGED       @"ucse.notification.qr_check_in.changed"
#define TX_NOTIFICATION_QR_CHECK_IN_UPLOAD_SUCCEED      @"ucse.notification.qr_check_in.upload.succeed"
#define TX_NOTIFICATION_QR_CHECK_IN_UPLOAD_FAILED       @"ucse.notification.qr_check_in.upload.failed"
#define TX_NOTIFICATION_WEI_DOU_AWARDED                 @"ucse.notification.wei_dou.awarded"
#define TX_NOTIFICATION_WEI_DOU_AWARDED_BY_CHECK_IN     @"ucse.notification.wei_dou.awarded.by.check"
#define TX_NOTIFICATION_NOTICE_HAS_READ                 @"ucse.notification.notice.has.read"
#define TX_NOTIFICATION_CONVERSATIONS_UPDATED           @"ucse.notification.conversations.updated"
#define TX_NOTIFICATION_INBOXNOTICE_CLEAR               @"ucse.notification.inboxNotice.clear"
#define TX_NOTIFICATION_CHECKIN_CLEAR                   @"ucse.notification.checkin.clear"
#define TX_NOTIFICATION_USERPROFILE_UPDATE              @"ucse.notification.userprofile.update"

#define TX_STATUS_OK                                    200
#define TX_STATUS_UNAUTHORIZED                          403
#define TX_STATUS_LOCAL_USER_EXPIRED                    -403
#define TX_STATUS_PB_PARSE_ERROR                        900
#define TX_STATUS_KICK_OFF                              1001
#define TX_STATUS_TIMEOUT                               8000
#define TX_STATUS_UN_KNOW_ERROR                         1000
#define TX_STATUS_DB_INIT_FAILED                        -200
#define TX_STATUS_APPROVE_REQUEST_ERROR                 999 //审批错误 需要退出 刷新界面

#define TX_STATUS_UNAUTHORIZED_DESC                     @"未登录"
#define TX_STATUS_TIMEOUT_DESC                          @"请求超时，请重试"
#define TX_STATUS_LOCAL_USER_EXPIRED_DESC               @"本地登录态已经失效"

#define TIMESTAMP_OF_NOW [[NSDate date] timeIntervalSince1970]*1000

#define TX_ERROR_MAKE(errorCode, errorMessage)                                      \
[NSError errorWithDomain:TX_CLIENT_NS_ERROR_DOMAIN                              \
code:errorCode                                              \
userInfo:@{ @"FILE" : @(__FILE__),                              \
@"LINE" : @(__LINE__),                              \
@"MESSAGE" : errorMessage }]

#define TX_ERROR_MAKE_WITH_URL(errorCode, errorMessage, url)                        \
[NSError errorWithDomain:TX_CLIENT_NS_ERROR_DOMAIN                              \
code:errorCode                                              \
userInfo:@{ @"FILE" : @(__FILE__),                              \
@"LINE" : @(__LINE__),                              \
@"URL"  : url,                                      \
@"MESSAGE" : errorMessage }]

#define TX_COUNTER_PREV_PREFIX                @"prev-"

#define TX_RUN_ON_MAIN(_code)                                   \
if ( [NSThread isMainThread]) {                                 \
_code;                                                      \
}else{                                                          \
dispatch_async(dispatch_get_main_queue(), ^{                \
_code;                                                  \
});                                                         \
}                                                               \


#define TX_PARSE_PB_OBJECT(targetClassName, targetObject)                                                              \
@try {                                                                                                             \
targetObject = [targetClassName parseFromData:response.body];                                                  \
} @catch (NSException *e) {                                                                                        \
innerError = TX_ERROR_MAKE(TX_STATUS_PB_PARSE_ERROR, e.name);                                                  \
goto completed;                                                                                                \
}                                                                                                                  \

#define TX_POST_NOTIFICATION_IF_ERROR(error)                                                                           \
if (error) {                                                                                                       \
dispatch_async(dispatch_get_main_queue(), ^{                                                                   \
[[NSNotificationCenter defaultCenter] postNotificationName:TX_NOTIFICATION_ERROR object:error];            \
});                                                                                                            \
}                                                                                                                  \

#define TX_GO_TO_COMPLETED_IF_ERROR(error)                                                                             \
if (error) {                                                                                                       \
innerError = error;                                                                                            \
goto completed;                                                                                                \
}

//static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

#endif /* XMDef_h */
