//
//  PDKArrayTest.m
//  PandaKitDemo
//
//  Created by Ricky on 16/1/21.
//  Copyright © 2016年 panda. All rights reserved.
//

#import "PandaKit.h"
#import <XCTest/XCTest.h>

@interface PDKArrayTest : XCTestCase

@property (nonatomic, strong) NSArray* arr1;
@property (nonatomic, strong) NSArray* arr2;
@property (nonatomic, strong) NSArray* arr3;

@end

@implementation PDKArrayTest

- (void)setUp
{
    [super setUp];

    self.arr1 = @[];
    self.arr2 = @[ @"first object" ];
    self.arr3 = @[ @"first object", @"second object" ];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testArrayFirstObject
{
    id r1 = self.arr1.firstObject;
    id r2 = self.arr2.firstObject;
    id r3 = self.arr3.firstObject;

    XCTAssert(r1 == nil && [r2 isEqualToString:@"first object"] && [r3 isEqualToString:@"first object"], @"Pass");
}

- (void)testArrayAppendObject
{
    NSMutableArray* muArr = @[].mutableCopy;
    muArr.add(@"x").add(nil).add(@9);
    BOOL result = [muArr isEqualToArray:@[ @"x", @9 ]];
    XCTAssert(result, @"Pass");
    
    [muArr addObject:@"x"];
    [muArr addObject:@9];
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
