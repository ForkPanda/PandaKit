//
//  NSArray+PandaKit.m
//  PandaKitDemo
//
//  Created by Ricky on 16/1/21.
//  Copyright © 2016年 panda. All rights reserved.
//

#import "NSArray+PandaKit.h"

@implementation NSArray (PandaKit)

- (id)pd_firstObject;
{
    return self.count > 0 ? self[0] : nil;
}

- (id)pd_lastObject;
{
    return self.count > 0 ? self[self.count - 1] : nil;
}

- (id)pd_objectAtIndex:(NSInteger)index
{
    return index > 0 && index < self.count ? self[index] : nil;
}

- (NSArray*)pd_leadN:(NSUInteger)amount;
{
    return self.count < amount ? self : [self subarrayWithRange:NSMakeRange(0, amount)];
}

- (NSArray*)pd_trailN:(NSUInteger)amount;
{
    return self.count < amount ? self : [self subarrayWithRange:NSMakeRange(self.count - amount, amount)];
}

- (NSArray*)pd_subArrayWithRange:(NSRange)range;
{
    return self.count < range.length + range.location ? self : [self subarrayWithRange:range];
}

- (NSArray*)pd_subArrayFromIndex:(NSUInteger)index;
{
    return self.count > index ? [self subarrayWithRange:NSMakeRange(index, self.count - index)] : self;
}

- (NSArray*)pd_subArrayToIndex:(NSUInteger)index;
{
    return self.count > index ? [self subarrayWithRange:NSMakeRange(0, index)] : self;
}

#pragma - BlockKit

- (void)pd_each:(void (^)(id obj))block
{
    NSParameterAssert(block != nil);

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        block(obj);
    }];
}

- (void)pd_apply:(void (^)(id obj))block
{
    NSParameterAssert(block != nil);

    [self enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        block(obj);
    }];
}

- (id)pd_match:(BOOL (^)(id obj))block
{
    NSParameterAssert(block != nil);

    NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL* stop) {
        return block(obj);
    }];

    if (index == NSNotFound)
        return nil;

    return self[index];
}

- (NSArray*)pd_select:(BOOL (^)(id obj))block
{
    NSParameterAssert(block != nil);
    return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL* stop) {
                     return block(obj);
                 }]];
}

- (NSArray*)pd_reject:(BOOL (^)(id obj))block
{
    NSParameterAssert(block != nil);
    return [self pd_select:^BOOL(id obj) {
        return !block(obj);
    }];
}

- (NSArray*)pd_map:(id (^)(id obj))block
{
    NSParameterAssert(block != nil);

    NSMutableArray* result = [NSMutableArray arrayWithCapacity:self.count];

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        id value = block(obj) ?: [NSNull null];
        [result addObject:value];
    }];

    return result;
}

- (id)pd_reduce:(id)initial withBlock:(id (^)(id sum, id obj))block
{
    NSParameterAssert(block != nil);

    __block id result = initial;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        result = block(result, obj);
    }];

    return result;
}

- (NSInteger)pd_reduceInteger:(NSInteger)initial withBlock:(NSInteger (^)(NSInteger, id))block
{
    NSParameterAssert(block != nil);

    __block NSInteger result = initial;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        result = block(result, obj);
    }];

    return result;
}

- (CGFloat)pd_reduceFloat:(CGFloat)inital withBlock:(CGFloat (^)(CGFloat, id))block
{
    NSParameterAssert(block != nil);

    __block CGFloat result = inital;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        result = block(result, obj);
    }];

    return result;
}

@end

@implementation NSMutableArray (PandaKit)

+ (NSMutableArray*)pd_nonRetainingArray;
{
    CFArrayCallBacks callbacks = { 0, NULL, NULL, CFCopyDescription, CFEqual };
    return (__bridge_transfer NSMutableArray*)(CFArrayCreateMutable(0, 0, &callbacks));
}

- (void)pd_pushLead:(NSObject*)obj;
{

    if (obj) {
        [self insertObject:obj atIndex:0];
    }
    else {
        //log
    }
}

- (void)pd_pushLeadN:(NSArray*)all;
{
    NSParameterAssert(all != nil);

    if (all) {
        [self insertObjects:all atIndexes:[NSIndexSet indexSetWithIndex:0]];
    }
}
- (void)pd_pushTrail:(NSObject*)obj;
{
    if (obj) {
        [self addObject:obj];
    }
}
- (void)pd_pushTrailN:(NSArray*)all;
{
    if ([all count]) {
        [self addObjectsFromArray:all];
    }
}

- (id)pd_popLead;
{
    id temp = nil;
    if (self.count > 0) {
        temp = self.firstObject;
        [self removeObjectAtIndex:0];
    }
    return temp;
}

- (NSArray*)pd_popLeadN:(NSUInteger)n;
{
    NSMutableArray* temp = @[].mutableCopy;
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        if (idx < n) {
            [temp addObject:obj];
        }
        else {
            *stop = YES;
        }
    }];

    [self removeObjectsInArray:temp];
    return temp;
}

- (id)pd_popTrail;
{
    id temp = nil;
    if (self.count > 0) {
        temp = self.lastObject;
        [self removeLastObject];
    }
    return temp;
}

- (NSArray*)pd_popTrailN:(NSUInteger)n;
{
    NSMutableArray* temp = @[].mutableCopy;
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        NSInteger index = self.count - idx;
        if (index < n) {
            [temp addObject:obj];
        }
        else {
            *stop = YES;
        }
    }];
    return temp;
}

- (NSMutableArray*)pd_keepLead:(NSUInteger)n;
{
    if ([self count] > n) {
        NSRange range;
        range.location = n;
        range.length = [self count] - n;

        [self removeObjectsInRange:range];
    }

    return self;
}

- (NSMutableArray*)pd_keepTrail:(NSUInteger)n;
{
    if ([self count] > n) {
        NSRange range;
        range.location = 0;
        range.length = [self count] - n;

        [self removeObjectsInRange:range];
    }

    return self;
}
@end
