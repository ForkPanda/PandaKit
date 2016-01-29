//
//  NSDictionary+PandaKit.h
//  PandaKitDemo
//
//  Created by Ricky on 16/1/27.
//  Copyright © 2016年 panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (PandaKit)

- (id)pd_ObjectForKey:(id<NSCopying>)key;

/**
 *  同步顺序遍历字典中的元素
 *
 *  @param block 匿名函数体。
 */
- (void)pd_each:(void (^)(id key, id obj))block;

/**
 *  异步顺序遍历字典中的元素
 *
 *  @param block 匿名函数体。
 */
- (void)pd_apply:(void (^)(id key, id obj))block;

/**
 *  首个匹配的值。
 *
 *  @param block 匿名函数体。
 *
 *  @return 当 block 返回 YES 时，返回当前的元素并停止遍历。
 */
- (id)pd_match:(BOOL (^)(id key, id obj))block;

/**
 *  全部匹配的值。
 *
 *  @param block 匿名函数体。
 *
 *  @return 当 block 返回 YES 时，记录当前的元素，遍历结束时返回包含全部记录元素的字典。
 */
- (NSDictionary*)pd_select:(BOOL (^)(id key, id obj))block;

/**
 *  返回全部不匹配的值。
 *
 *  @param block 匿名函数体。
 *
 *  @return 当 block 返回 NO 时，记录当前元素，遍历结束时返回包含全部记录元素的字典。
 */
- (NSDictionary*)pd_reject:(BOOL (^)(id key, id obj))block;

/**
 *  将旧的数组元素，通过一个 block 映射到新的字典中。
 *
 *  @param block 匿名函数体。
 *
 *  @return 所有 block 返回的值将会形成一个新的字典，遍历结束时返回该字典。
 */
- (NSDictionary*)pd_map:(id (^)(id key, id obj))block;

@end

@interface NSMutableDictionary (PandaKit)

+ (NSMutableDictionary*)pd_nonRetainDictionary;
- (void)pd_setObject:(id)anObject forKey:(id<NSCopying>)key;
- (void)pd_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key;
- (void)pd_removeObjectForKey:(id<NSCopying>)key;

@end
