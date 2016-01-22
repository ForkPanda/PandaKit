//
//  NSArray+PandaKit.m
//  PandaKitDemo
//
//  Created by Ricky on 16/1/21.
//  Copyright © 2016年 panda. All rights reserved.
//

#import "NSArray+PandaKit.h"

@implementation NSArray (PandaKit)

- (id)firstObject;
{
    return self.count > 0 ? self[0] : nil;
}

@end
