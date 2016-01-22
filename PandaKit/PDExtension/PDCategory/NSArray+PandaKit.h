//
//  NSArray+PandaKit.h
//  PandaKitDemo
//
//  Created by Ricky on 16/1/21.
//  Copyright © 2016年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSArray (PandaKit)

- (id)pk_firstObject;

#pragma BlockKit

/**
 *  同步顺序遍历数组中的元素
 *
 *  @param block <#block description#>
 */
- (void)pk_each:(void (^)(id obj))block;

/**
 *  异步顺序遍历数组中的元素
 *
 *  @param block <#block description#>
 */
- (void)pk_apply:(void (^)(id obj))block;

/**
 *  首个匹配的值。
 *
 *  @param block <#block description#>
 *
 *  @return 当 block 返回 YES 时，返回当前的元素并停止遍历。
 */
- (id)pk_match:(BOOL (^)(id obj))block;

/**
 *  全部匹配的值。
 *
 *  @param block <#block description#>
 *
 *  @return 当 block 返回 YES 时，记录当前的元素，遍历结束时返回包含全部记录元素的数组。
 */
- (NSArray*)pk_select:(BOOL (^)(id obj))block;

/**
 *  返回全部不匹配的值。
 *
 *  @param block <#block description#>
 *
 *  @return 当 block 返回 NO 时，记录当前元素，遍历结束时返回包含全部记录元素的数组。
 */
- (NSArray*)pk_reject:(BOOL (^)(id obj))block;

/**
 *  将旧的数组元素，通过一个 block 映射到新的数组中。
 *
 *  @param block <#block description#>
 *
 *  @return 所有 block 返回的值将会形成一个新的数组，遍历结束时返回该数组。
 */
- (NSArray*)pk_map:(id (^)(id obj))block;

/**
 *  遍历旧的数组，将返回的结果继续和序列的下一个元素做累积计算。
 *
 *  @param initial 累算元素初始值
 *  @param block   <#block description#>
 *
 *  @return 便利结束后，返回 block 中累算元素 sum 的值。
 */
- (id)pk_reduce:(id)initial withBlock:(id (^)(id sum, id obj))block;
- (NSInteger)pk_reduceInteger:(NSInteger)initial withBlock:(NSInteger (^)(NSInteger result, id obj))block;
- (CGFloat)pk_reduceFloat:(CGFloat)inital withBlock:(CGFloat (^)(CGFloat result, id obj))block;

@end
