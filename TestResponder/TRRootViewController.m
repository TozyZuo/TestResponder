//
//  TRRootViewController.m
//  TestResponder
//
//  Created by TozyZuo on 16/4/14.
//  Copyright © 2016年 TozyZuo. All rights reserved.
//

#import "TRRootViewController.h"
#import "TPNavigationController.h"
#import "ViewController1.h"

@interface TRRootViewController ()

@property (weak, nonatomic) IBOutlet UILabel *levitatingView;

@property (nonatomic, strong) TPNavigationController *navigationController;

@end

@implementation TRRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Action

- (IBAction)addNavigationAction:(UIButton *)sender
{
    if (self.navigationController) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:TransparentViewTransparentAeraChangedNotification object:self.navigationController];
    }

    TPNavigationController *nc = [[TPNavigationController alloc] initWithRootViewController:[[ViewController1 alloc] init]];
    [self.view addSubview:nc.view];
    [self addChildViewController:nc];

    self.navigationController = nc;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transparentAeraChangedNotification:) name:TransparentViewTransparentAeraChangedNotification object:nc];
}

- (IBAction)buttonAction:(UIButton *)sender
{
    NSLog(@"%s(%d)", __PRETTY_FUNCTION__, __LINE__);
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"%s(%d)", __PRETTY_FUNCTION__, __LINE__);
}

- (void)transparentAeraChangedNotification:(NSNotification *)notification
{
    CGRect transparentAera = [self.navigationController transparentAeraConvertToView:self.view];

    if (!CGRectIsNull(transparentAera)) {

        self.levitatingView.bottom = CGRectGetMaxY(transparentAera) - 10;

        CGFloat height = CGRectGetHeight(transparentAera);
        if (height < self.view.height * .5)
        {
            self.levitatingView.alpha = height / self.view.height / .5;
        }
        else
        {
            self.levitatingView.alpha = 1;
        }
    }
}

#if 0
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s(%d)", __PRETTY_FUNCTION__, __LINE__);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s(%d)", __PRETTY_FUNCTION__, __LINE__);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s(%d)", __PRETTY_FUNCTION__, __LINE__);
}
#endif

@end
