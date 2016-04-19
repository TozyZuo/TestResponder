//
//  VC1BottomViewController.m
//  TestResponder
//
//  Created by TozyZuo on 16/4/14.
//  Copyright © 2016年 TozyZuo. All rights reserved.
//

#import "VC1BottomViewController.h"
#import "ViewController2.h"

@interface VC1BottomViewController ()

@end

@implementation VC1BottomViewController

/* use autolayout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
 */

- (IBAction)openVC2Action:(UIButton *)sender
{
    [self.navigationController pushViewController:[[ViewController2 alloc] init] animated:YES];
}

@end
