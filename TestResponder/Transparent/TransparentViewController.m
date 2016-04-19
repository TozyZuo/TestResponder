//
//  TRViewController.m
//  TestResponder
//
//  Created by TozyZuo on 16/4/14.
//  Copyright © 2016年 TozyZuo. All rights reserved.
//

#import "TransparentViewController.h"
#import "TransparentView.h"

@interface TransparentViewController ()

@end

@implementation TransparentViewController

@dynamic view;

- (void)loadView
{
    NSString *nibName = self.nibName ?: NSStringFromClass(self.class);
    NSBundle *nibBundle = self.nibBundle ?: [NSBundle mainBundle];
    UINib *nib = [UINib nibWithNibName:nibName bundle:nibBundle];

    NSArray *array;
    @try {
        array = [nib instantiateWithOwner:self options:nil];
    } @catch (NSException *exception) {

    } @finally {
        if (array.count)
        {
            self.view = array.firstObject;
            if (![self.view isKindOfClass:[TransparentView class]]) {
                NSLog(@"error: %@(%p)'s view is not transparentView.", self.class, self);
            }
        }
        else
        {
            self.view = [[TransparentView alloc] init];
        }
    }
    self.view.frame = [UIScreen mainScreen].applicationFrame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.view.backgroundColor isEqual:[UIColor whiteColor]]) {
        self.view.backgroundColor = [UIColor clearColor];
    }
}

@end
