//
//  TRNavigationController.m
//  TestResponder
//
//  Created by TozyZuo on 16/4/14.
//  Copyright © 2016年 TozyZuo. All rights reserved.
//

#import "TPNavigationController.h"
#import "TransparentView.h"
#import <objc/runtime.h>


@interface TPNavigationController ()

@end

@implementation TPNavigationController

#pragma mark - Prepare for class swizzle

+ (void)load
{
    [self creatSubClass:@"UIViewControllerWrapperView"];
    [self creatSubClass:@"UINavigationTransitionView"];
    [self creatSubClass:@"UILayoutContainerView"];
}

+ (void)creatSubClass:(NSString *)superClass
{
    Class subClass = objc_allocateClassPair(NSClassFromString(superClass), [@"TP" stringByAppendingString:superClass].UTF8String, 0);
    objc_registerClassPair(subClass);

    // 实现透传
    Method myMethod = class_getInstanceMethod([TransparentView class], @selector(pointInside:withEvent:));

    class_addMethod(subClass, @selector(pointInside:withEvent:), method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
}

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    if ([self.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        [self classSwizzleWithView:self.view];
    }

    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UINavigationTransitionView")]) {
            [self classSwizzleWithView:view];
            break;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"TPUINavigationTransitionView")]) {
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:NSClassFromString(@"UIViewControllerWrapperView")]) {
                    [self classSwizzleWithView:subview];
                    return;
                }
            }
        }
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];

    if ([viewController.view isKindOfClass:[TransparentView class]]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyTransparentAeraChanged) name:TransparentViewTransparentAeraChangedNotification object:viewController.view];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *viewController = [super popViewControllerAnimated:animated];

    if ([viewController.view isKindOfClass:[TransparentView class]]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:TransparentViewTransparentAeraChangedNotification object:viewController.view];
    }

    return viewController;
}

#pragma mark - Private

- (void)notifyTransparentAeraChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TransparentViewTransparentAeraChangedNotification object:self];
}

- (void)classSwizzleWithView:(UIView *)view
{
    object_setClass(view, NSClassFromString([@"TP" stringByAppendingString:NSStringFromClass([view class])]));
}

#pragma mark - TransparentViewProtocol

- (CGRect)transparentAeraConvertToView:(UIView *)view
{
    if ([self.visibleViewController.view isKindOfClass:[TransparentView class]]) {
        return [(TransparentView *)self.visibleViewController.view transparentAeraConvertToView:view];
    }
    return CGRectNull;
}

- (CGRect)opaqueAeraConvertToView:(UIView *)view
{
    if ([self.visibleViewController.view isKindOfClass:[TransparentView class]]) {
        return [(TransparentView *)self.visibleViewController.view opaqueAeraConvertToView:view];
    }
    return CGRectNull;
}

@end
