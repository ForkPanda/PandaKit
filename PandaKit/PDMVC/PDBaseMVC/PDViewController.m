//
//  PDViewController.m
//  PandaKitDemo
//
//  Created by Ricky on 16/2/16.
//  Copyright © 2016年 panda. All rights reserved.
//

#import "JDFPeekabooCoordinator.h"
#import "PDViewController.h"

@interface PDViewController ()

@property (nonatomic, strong) JDFPeekabooCoordinator* scrollCoordinator;

@end

@implementation PDViewController

- (void)autoHideNav:(UIView*)nav bar:(UIView*)bar withScroll:(UIScrollView*)scroll;
{
    self.scrollCoordinator.scrollView = scroll;
    self.scrollCoordinator.topView = nav;
    self.scrollCoordinator.bottomView = bar;
    self.scrollCoordinator.topViewMinimisedHeight = self.navMinHeight;
}

#pragma mark - life
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.scrollCoordinator disable];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.scrollCoordinator enable];
}

#pragma mark - getter
- (JDFPeekabooCoordinator*)scrollCoordinator
{
    if (!_scrollCoordinator) {
        _scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
    }
    return _scrollCoordinator;
}

- (CGFloat)navMinHeight
{
    return _navMinHeight < 1 ? 20.f : _navMinHeight;
}

@end
