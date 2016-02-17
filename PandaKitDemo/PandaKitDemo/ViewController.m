//
//  ViewController.m
//  PandaKitDemo
//
//  Created by Ricky on 16/1/21.
//  Copyright © 2016年 panda. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView* tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [self autoHideNav:self.navigationController.navigationBar bar:self.tabBarController.tabBar withScroll:self.tableView];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

@end
