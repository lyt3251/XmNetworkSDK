//
//  XmNetworkSDKTests.m
//  XmNetworkSDKTests
//
//  Created by ucse on 2017/6/1.
//  Copyright © 2017年 xm. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TXHttpClient.h"

@interface XmNetworkSDKTests : XCTestCase
@end

@implementation XmNetworkSDKTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [[TXHttpClient sharedInstance] setupHttpProtocolClass:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTestExpectation *testException = [self expectationWithDescription:@"testError"];
    
    [[TXHttpClient sharedInstance] sendRequest:@"a.php" token:nil bodyData:nil onCompleted:^(NSError *error, XMBASEResponse *response) {
        NSLog(@"error:%@", error);
        [testException fulfill];
    }];
    
    //延迟两秒执行
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        XCTFail(@"time out:%@",error);
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
