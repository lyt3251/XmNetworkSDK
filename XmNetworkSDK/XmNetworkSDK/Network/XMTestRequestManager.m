//
//  XMTestRequestManager.m
//  XmNetworkSDK
//
//  Created by ucse on 2017/6/1.
//  Copyright © 2017年 xm. All rights reserved.
//

#import "XMTestRequestManager.h"
#import "Xm.pbobjc.h"
#import "Message.pbobjc.h"
#import "TXHttpClient.h"
#import "XMDef.h"

@implementation XMTestRequestManager
//
-(void)test_request:(NSString *)requestId index:(SInt32)index url:(NSString *)url onCompleted:(void (^)(NSError *error, NSArray *list))onCompleted
{

    XMTestRequest *request = [XMTestRequest message];
    request.requestid = requestId;
    request.index = index;
    request.URL = url;
    
    [[TXHttpClient sharedInstance] sendRequest:@"/d.php"
                                         token:@""
                                      bodyData:request.data
                                   onCompleted:^(NSError *error, XMBASEResponse *response) {
                                       NSError *innerError = nil;
                                       XMTestResponse *innerResponse;
                                       
                                       TX_GO_TO_COMPLETED_IF_ERROR(error);
                                       TX_PARSE_PB_OBJECT(XMTestResponse, innerResponse);
                                       
                                   completed:
                                       {
                                           TX_POST_NOTIFICATION_IF_ERROR(innerError);
                                           TX_RUN_ON_MAIN(
                                                          if(onCompleted)
                                                          {
                                                              onCompleted(innerError, innerResponse.listArray);
                                                          }
                                                          );
                                       }
                                   }];
    
}

-(void)test_Contidionrequest:(NSString *)contryId cityId:(NSString *)cityId onCompleted:(void (^)(NSError *error, NSArray *list))onCompleted
{
    
    XMTestContidionRequest *request = [XMTestContidionRequest message];
    request.countryId = contryId;
    request.cityId = cityId;
    
    [[TXHttpClient sharedInstance] sendRequest:@"/d.php"
                                         token:@""
                                      bodyData:request.data
                                   onCompleted:^(NSError *error, XMBASEResponse *response) {
                                       NSError *innerError = nil;
                                       XMTestResponse *innerResponse;
                                       
                                       TX_GO_TO_COMPLETED_IF_ERROR(error);
                                       TX_PARSE_PB_OBJECT(XMTestResponse, innerResponse);
                                       
                                   completed:
                                       {
                                           TX_POST_NOTIFICATION_IF_ERROR(innerError);
                                           TX_RUN_ON_MAIN(
                                                          if(onCompleted)
                                                          {
                                                              onCompleted(innerError, innerResponse.listArray);
                                                          }
                                                          );
                                       }
                                   }];
    
}


@end
