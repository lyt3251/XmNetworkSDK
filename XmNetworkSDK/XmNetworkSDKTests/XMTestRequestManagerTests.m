//
//  XMTestRequestManagerTests.m
//  XmNetworkSDK
//
//  Created by ucse on 2017/6/1.
//  Copyright © 2017年 xm. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMTestRequestManager.h"
#import "TXHttpClient.h"

@interface XMTestRequestManagerTests : XCTestCase
@property(nonatomic, strong)XMTestRequestManager *requestManger;
@end

@implementation XMTestRequestManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.requestManger = [[XMTestRequestManager alloc] init];
    [[TXHttpClient sharedInstance] setupHttpProtocolClass:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.requestManger = nil;
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTestExpectation *testException = [self expectationWithDescription:@"testError"];
    [self.requestManger test_request:@"d.php" index:22 url:@"http://www.baidu.com" onCompleted:^(NSError *error, NSArray *list) {
        [testException fulfill];
        NSLog(@"error:%@, list:%@", error, list);
    }];
    
    //延迟执行
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        NSLog(@"error:%@", error);
    }];
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
