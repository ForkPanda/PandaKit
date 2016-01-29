//
//  NSObject+PandaKit.h
//  PandaKitDemo
//
//  Created by Ricky on 16/1/28.
//  Copyright © 2016年 panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PandaKit)

#pragma mark - property
// 属性列表
@property (nonatomic, readonly, strong) NSArray* pd_attributeList;

#pragma mark - conversion
- (NSInteger)pd_asInteger; // NSNumber, NSNull, NSString, NSString, NSDate
- (float)pd_asFloat; // NSNumber, NSNull, NSString, NSString, NSDate
- (BOOL)pd_asBool; // NSNumber, NSNull, NSString, NSString, NSDate

- (NSNumber*)pd_asNSNumber; // NSNumber, NSNull, NSString, NSString, NSDate
- (NSString*)pd_asNSString; // NSString, NSNull, NSData
- (NSDate*)pd_asNSDate; // NSDate, NSString,
- (NSData*)pd_asNSData; // NSData, NSString
- (NSArray*)pd_asNSArray; // NSArray, NSObject

#pragma mark - copy
- (id)pd_deepCopy1; // 基于NSKeyArchive

@end
