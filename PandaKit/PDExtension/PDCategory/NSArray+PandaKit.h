//
//  NSArray+PandaKit.h
//  PandaKitDemo
//
//  Created by Ricky on 16/1/21.
//  Copyright © 2016年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSArray (PandaKit)

#pragma QuickKit
- (id)pk_firstObject;

- (NSArray*)pk_leadN:(NSUInteger)amount;
- (NSArray*)pk_trailN:(NSUInteger)amount;

- (id)pk_objectAtIndex:(NSInteger)index;
- (NSArray*)pk_subArrayWithRange:(NSRange)range;
- (NSArray*)pk_subArrayFromIndex:(NSUInteger)index;
- (NSArray*)pk_subArrayToIndex:(NSUInteger)index;

#pragma BlockKit

/**
 *  同步顺序遍历数组中的元素
 *
 *  @param block 匿名函数体。
 */
- (void)pk_each:(void (^)(id obj))block;

/**
 *  异步顺序遍历数组中的元素
 *
 *  @param block 匿名函数体。
 */
- (void)pk_apply:(void (^)(id obj))block;

/**
 *  首个匹配的值。
 *
 *  @param block 匿名函数体。
 *
 *  @return 当 block 返回 YES 时，返回当前的元素并停止遍历。
 */
- (id)pk_match:(BOOL (^)(id obj))block;

/**
 *  全部匹配的值。
 *
 *  @param block 匿名函数体。
 *
 *  @return 当 block 返回 YES 时，记录当前的元素，遍历结束时返回包含全部记录元素的数组。
 */
- (NSArray*)pk_select:(BOOL (^)(id obj))block;

/**
 *  返回全部不匹配的值。
 *
 *  @param block 匿名函数体。
 *
 *  @return 当 block 返回 NO 时，记录当前元素，遍历结束时返回包含全部记录元素的数组。
 */
- (NSArray*)pk_reject:(BOOL (^)(id obj))block;

/**
 *  将旧的数组元素，通过一个 block 映射到新的数组中。
 *
 *  @param block 匿名函数体。
 *
 *  @return 所有 block 返回的值将会形成一个新的数组，遍历结束时返回该数组。
 */
- (NSArray*)pk_map:(id (^)(id obj))block;

/**
 *  遍历旧的数组，将返回的结果继续和序列的下一个元素做累积计算。
 *
 *  @param initial 累算元素初始值
 *  @param block   匿名函数体。
 *
 *  @return 遍历结束后，返回 block 中累算元素 sum 的值。
 */
- (id)pk_reduce:(id)initial withBlock:(id (^)(id sum, id obj))block;
- (NSInteger)pk_reduceInteger:(NSInteger)initial withBlock:(NSInteger (^)(NSInteger result, id obj))block;
- (CGFloat)pk_reduceFloat:(CGFloat)inital withBlock:(CGFloat (^)(CGFloat result, id obj))block;

@end

@interface NSMutableArray (PandaKit)

/**
 *  返回一个不会使元素增加引用计数的数组，如用于多路代理。
 *
 *  @return 返回不会使元素增加引用计数的数组。
 */
+ (NSMutableArray*)pk_nonRetainingArray;

/**
 *  对可变数组进行操作。
 *
 *  @return 对这个可变数组进行相对应的操作，并将可变数组返回。
 */
- (NSMutableArray*)pk_pushLead:(NSObject*)obj;
- (NSMutableArray*)pk_pushLeadN:(NSArray*)all;
- (NSMutableArray*)pk_popLead;
- (NSMutableArray*)pk_popLeadN:(NSUInteger)n;

- (NSMutableArray*)pk_pushTrail:(NSObject*)obj;
- (NSMutableArray*)pk_pushTrailN:(NSArray*)all;
- (NSMutableArray*)pk_popTrail;
- (NSMutableArray*)pk_popTrailN:(NSUInteger)n;

- (NSMutableArray*)pk_keepLead:(NSUInteger)n;
- (NSMutableArray*)pk_keepTrail:(NSUInteger)n;

@end