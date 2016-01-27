//
//  NSDictionary+PandaKit.m
//  PandaKitDemo
//
//  Created by Ricky on 16/1/27.
//  Copyright © 2016年 panda. All rights reserved.
//

#import "NSDictionary+PandaKit.h"

@implementation NSDictionary (PandaKit)

- (id)pk_ObjectForKey:(id<NSCopying>)key;
{
    return key ? self[key] : nil;
}

- (void)pk_each:(void (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        block(key, obj);
    }];
}

- (void)pk_apply:(void (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    [self enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL* stop) {
        block(key, obj);
    }];
}

- (id)pk_match:(BOOL (^)(id key, id obj))block
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

- (NSDictionary*)pk_select:(BOOL (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    NSArray* keys = [[self keysOfEntriesPassingTest:^(id key, id obj, BOOL* stop) {
        return block(key, obj);
    }] allObjects];

    NSArray* objects = [self objectsForKeys:keys notFoundMarker:[NSNull null]];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

- (NSDictionary*)pk_reject:(BOOL (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);
    return [self pk_select:^BOOL(id key, id obj) {
        return !block(key, obj);
    }];
}

- (NSDictionary*)pk_map:(id (^)(id key, id obj))block
{
    NSParameterAssert(block != nil);

    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:self.count];

    [self pk_each:^(id key, id obj) {
        id value = block(key, obj) ?: [NSNull null];
        result[key] = value;
    }];

    return result;
}

@end

@implementation NSMutableDictionary (PandaKit)

+ (NSMutableDictionary*)pk_nonRetainDictionary;
{
    return (__bridge_transfer NSMutableDictionary*)CFDictionaryCreateMutable(nil, 0, &kCFCopyStringDictionaryKeyCallBacks, NULL);
}

- (void)pk_setObject:(id)anObject forKey:(id<NSCopying>)key;
{
    key ? self[key] = anObject : nil;
}

- (void)pk_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key;
{
    key ? [self setObject:obj forKeyedSubscript:key] : nil;
}

- (void)pk_removeObjectForKey:(id<NSCopying>)key;
{
    key ? [self removeObjectForKey:key] : nil;
}

@end
