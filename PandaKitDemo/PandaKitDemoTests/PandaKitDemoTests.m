//
//  PandaKitDemoTests.m
//  PandaKitDemoTests
//
//  Created by Ricky on 16/1/21.
//  Copyright © 2016年 panda. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface PandaKitDemoTests : XCTestCase

@end

@implementation PandaKitDemoTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSignature
{
    NSArray* nullObjects = @[ @"", @0, @{}, @[] ];

    [nullObjects enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        NSMethodSignature* signature = [obj methodSignatureForSelector:@selector(floatValue)];
        NSLog(@"%@", signature);
    }];
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
