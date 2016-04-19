//
//  TRViewController.m
//  TestResponder
//
//  Created by TozyZuo on 16/4/18.
//  Copyright © 2016年 TozyZuo. All rights reserved.
//

#import "TRViewController.h"

@interface TRViewController ()

@end

@implementation TRViewController

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
            if (![self.view isKindOfClass:[TRView class]]) {
                NSLog(@"error: %@(%p)'s view is not TRView.", self.class, self);
            }
        }
        else
        {
            self.view = [[TRView alloc] init];
        }
    }
    self.view.frame = [UIScreen mainScreen].applicationFrame;
}

@end
