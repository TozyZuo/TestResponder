//
//  ViewController2.m
//  TestResponder
//
//  Created by TozyZuo on 16/4/14.
//  Copyright © 2016年 TozyZuo. All rights reserved.
//

#import "ViewController2.h"
#import "ViewController1.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSStringFromClass(self.class);

    self.view.backgroundColor = [UIColor greenColor];
    self.view.transparent = NO;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 100, 50);
    [button setTitle:@"openVC1" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openVC1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)openVC1Action:(UIButton *)button
{
    [self.navigationController pushViewController:[[ViewController1 alloc] init] animated:YES];
}

@end
