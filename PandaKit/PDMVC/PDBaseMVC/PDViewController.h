//
//  PDViewController.h
//  PandaKitDemo
//
//  Created by Ricky on 16/2/16.
//  Copyright © 2016年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDViewController : UIViewController

/**
 *  滚动时隐藏导航栏和标签栏。
 *  如果需要全屏隐藏导航栏和标签栏，则需要将 scroll 视图全屏并设置 ViewController 的 AdjustScrollViewInsets 属性为 YES。
 */
@property (nonatomic, assign) CGFloat navMinHeight; //default 20.f

- (void)autoHideNav:(UIView*)nav bar:(UIView*)bar withScroll:(UIScrollView*)scroll;

@end
