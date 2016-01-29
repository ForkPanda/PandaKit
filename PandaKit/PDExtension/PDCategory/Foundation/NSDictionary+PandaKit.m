//
//  NSDictionary+PandaKit.m
//  PandaKitDemo
//
//  Created by Ricky on 16/1/27.
//  Copyright © 2016年 panda. All rights reserved.
//

#import "NSDictionary+PandaKit.h"

@implementation NSDictionary (PandaKit)

- (id)pd_ObjectForKey:(id<NSCopying>)key;
{
    return key ? self[key] : nil;
}

- (void)pd_each:(void (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        block(key, obj);
    }];
}

- (void)pd_apply:(void (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    [self enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL* stop) {
        block(key, obj);
    }];
}

- (id)pd_match:(BOOL (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    return self[[[self keysOfEntriesPassingTest:^(id key, id obj, BOOL* stop) {
        if (block(key, obj)) {
            *stop = YES;
            return YES;
        }

        return NO;
    }] anyObject]];
}

- (NSDictionary*)pd_select:(BOOL (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    NSArray* keys = [[self keysOfEntriesPassingTest:^(id key, id obj, BOOL* stop) {
        return block(key, obj);
    }] allObjects];

    NSArray* objects = [self objectsForKeys:keys notFoundMarker:[NSNull null]];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

- (NSDictionary*)pd_reject:(BOOL (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);
    return [self pd_select:^BOOL(id key, id obj) {
        return !block(key, obj);
    }];
}

- (NSDictionary*)pd_map:(id (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:self.count];

    [self pd_each:^(id key, id obj) {
        id value = block(key, obj) ?: [NSNull null];
        result[key] = value;
    }];

    return result;
}

@end

@implementation NSMutableDictionary (PandaKit)

+ (NSMutableDictionary*)pd_nonRetainDictionary;
{
    return (__bridge_transfer NSMutableDictionary*)CFDictionaryCreateMutable(nil, 0, &kCFCopyStringDictionaryKeyCallBacks, NULL);
}

- (void)pd_setObject:(id)anObject forKey:(id<NSCopying>)key;
{
    key ? self[key] = anObject : nil;
}

- (void)pd_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key;
{
    key ? [self setObject:obj forKeyedSubscript:key] : nil;
}

- (void)pd_removeObjectForKey:(id<NSCopying>)key;
{
    key ? [self removeObjectForKey:key] : nil;
}

@end
