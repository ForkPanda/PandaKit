//
//  NSObject+PandaKit.m
//  PandaKitDemo
//
//  Created by Ricky on 16/1/28.
//  Copyright © 2016年 panda. All rights reserved.
//

#import "NSObject+PandaKit.h"
#import <objc/runtime.h>

@interface NSObject (XYPrivate)
+ (NSDateFormatter*)__pd_dateFormatterTemp;
@end

@implementation NSObject (PandaKit)

@dynamic pd_attributeList;

#pragma mark -
+ (NSDateFormatter*)__uxy_dateFormatterTemp
{
    NSMutableDictionary* threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter* dateFormatter = threadDictionary[@"uxy_dateFormatterTemp"];
    if (!dateFormatter) {
        @synchronized(self)
        {
            if (!dateFormatter) {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                threadDictionary[@"uxy_dateFormatterTemp"] = dateFormatter;
            }
        }
    }

    return dateFormatter;
}

#pragma mark - property
- (NSArray*)pd_attributeList
{
    unsigned int propertyCount = 0;
    objc_property_t* properties = class_copyPropertyList([self class], &propertyCount);
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < propertyCount; i++) {
        const char* name = property_getName(properties[i]);
        NSString* propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        [array addObject:propertyName];
    }
    free(properties);

    return array;
}

#pragma mark - Conversion
- (NSInteger)pd_asInteger
{
    return [[self pd_asNSNumber] integerValue];
}

- (float)pd_asFloat
{
    return [[self pd_asNSNumber] floatValue];
}

- (BOOL)pd_asBool
{
    return [[self pd_asNSNumber] boolValue];
}

- (NSNumber*)pd_asNSNumber
{
    if ([self isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)self;
    }
    else if ([self isKindOfClass:[NSNull class]]) {
        return [NSNumber numberWithInteger:0];
    }
    else if ([self isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithInteger:[(NSString*)self integerValue]];
    }
    else if ([self isKindOfClass:[NSDate class]]) {
        return [NSNumber numberWithDouble:[(NSDate*)self timeIntervalSince1970]];
    }

    return nil;
}

- (NSString*)pd_asNSString
{
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString*)self;
    }
    else if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    else if ([self isKindOfClass:[NSData class]]) {
        NSData* data = (NSData*)self;
        return [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
    }
    else {
        return [NSString stringWithFormat:@"%@", self];
    }
}

- (NSDate*)pd_asNSDate
{
    if ([self isKindOfClass:[NSDate class]]) {
        return (NSDate*)self;
    }
    else if ([self isKindOfClass:[NSString class]]) {
        NSDate* date = nil;

        if (nil == date) {
            NSString* format = @"yyyy-MM-dd HH:mm:ss z";
            NSDateFormatter* formatter = [NSObject __pd_dateFormatterTemp];
            [formatter setDateFormat:format];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

            date = [formatter dateFromString:(NSString*)self];
        }

        if (nil == date) {
            NSString* format = @"yyyy/MM/dd HH:mm:ss z";
            NSDateFormatter* formatter = [NSObject __pd_dateFormatterTemp];
            [formatter setDateFormat:format];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

            date = [formatter dateFromString:(NSString*)self];
        }

        if (nil == date) {
            NSString* format = @"yyyy-MM-dd HH:mm:ss";
            NSDateFormatter* formatter = [NSObject __pd_dateFormatterTemp];
            [formatter setDateFormat:format];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

            date = [formatter dateFromString:(NSString*)self];
        }

        if (nil == date) {
            NSString* format = @"yyyy/MM/dd HH:mm:ss";
            NSDateFormatter* formatter = [NSObject __pd_dateFormatterTemp];
            [formatter setDateFormat:format];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

            date = [formatter dateFromString:(NSString*)self];
        }

        return date;
    }
    else {
        return [NSDate dateWithTimeIntervalSince1970:[self pd_asNSNumber].doubleValue];
    }

    return nil;
}

- (NSData*)pd_asNSData
{
    if ([self isKindOfClass:[NSData class]]) {
        return (NSData*)self;
    }
    else if ([self isKindOfClass:[NSString class]]) {
        return [(NSString*)self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    }

    return nil;
}

- (NSArray*)pd_asNSArray
{
    if ([self isKindOfClass:[NSArray class]]) {
        return (NSArray*)self;
    }
    else {
        return [NSArray arrayWithObject:self];
    }
}

#pragma mark - copy
- (id)pd_deepCopy1
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

@end
