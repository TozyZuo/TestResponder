//
//  ViewController.m
//  TestResponder
//
//  Created by TozyZuo on 16/4/14.
//  Copyright © 2016年 TozyZuo. All rights reserved.
//

#import "ViewController1.h"
#import "VC1BottomViewController.h"

@interface ViewController1 ()
@property (nonatomic, strong) VC1BottomViewController *mainVC;
@property (nonatomic, assign) BOOL isRootVC;
@end

@implementation ViewController1

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSStringFromClass(self.class);

    self.mainVC = [[VC1BottomViewController alloc] init];
    self.mainVC.view.frame = self.view.bounds;
    self.mainVC.view.height += self.mainVC.panBar.height;
    self.mainVC.view.bottom = self.view.height;
    [self.view addSubview:self.mainVC.view];
    [self addChildViewController:self.mainVC];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.mainVC.view addGestureRecognizer:pan];

    self.isRootVC = self.navigationController.viewControllers.count == 1;

    if (self.isRootVC) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"╳" style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
        self.navigationItem.leftBarButtonItem = backItem;

        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.mainVC.view.top = [UIScreen mainScreen].bounds.size.height;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.isRootVC) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView animateWithDuration:.25 animations:^{
            self.mainVC.view.top = [UIScreen mainScreen].bounds.size.height * .5 - 66;
        }];
    }  
}

#pragma mark - Action

- (void)backAction:(UIButton *)button
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [UIView animateWithDuration:.25 animations:^{
        self.mainVC.view.top = [UIScreen mainScreen].bounds.size.height;
    } completion:^(BOOL finished) {
        [self.navigationController.view removeFromSuperview];
        [self.navigationController removeFromParentViewController];
    }];
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    UIView *view = pan.view;

    CGPoint translation = [pan translationInView:view];

    view.top += translation.y;

    [pan setTranslation:CGPointZero inView:view];

    if (view.top > (self.view.height - self.mainVC.panBar.height)) {
        view.top = (self.view.height - self.mainVC.panBar.height);
    }
    else if (view.bottom < self.view.height) {
        view.bottom = self.view.height;
    }
}

@end
