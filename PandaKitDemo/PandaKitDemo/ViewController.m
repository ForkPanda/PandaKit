//
//  ViewController.m
//  PandaKitDemo
//
//  Created by Ricky on 16/1/21.
//  Copyright © 2016年 panda. All rights reserved.
//

//#import "PandaKit.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray* arr1 = @[];
    NSArray* arr2 = @[ @(1) ];
    NSArray* arr3 = @[ @(1), @(2) ];

    NSLog(@"%@ %@ %@", arr1.firstObject, arr2.firstObject, arr3.firstObject);
}

@end
