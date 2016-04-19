//
//  TRView.m
//  TestResponder
//
//  Created by TozyZuo on 16/4/14.
//  Copyright © 2016年 TozyZuo. All rights reserved.
//

#import "TransparentView.h"
#import <objc/runtime.h>

NSString * const TransparentViewTransparentAeraChangedNotification =
@"TransparentViewTransparentAeraChangedNotification";

@interface TransparentView ()
@property (nonatomic, strong) NSMutableSet *observedViews;
@end

@implementation TransparentView

#pragma mark - Life cycle

- (instancetype)init
{
    if (self = [super init]) {
        self.transparent = YES;
        self.observedViews = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)dealloc
{
    while (self.observedViews.count) {
        [self removeObservationForView:self.observedViews.anyObject];
    }
}

#pragma mark - Override

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self respondsToSelector:@selector(transparent)] && !self.transparent) {
        return [super pointInside:point withEvent:event];
    } else {
        for (UIView *subview in self.subviews) {
            if ([subview pointInside:[subview convertPoint:point fromView:self] withEvent:event]) {
                return YES;
            }
        }
        return NO;
    }
}

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    [self addObservationForView:subview];
}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];
    [self removeObservationForView:subview];
}

#pragma mark - Private

- (void)addObservationForView:(UIView *)view
{
    if (![self.observedViews containsObject:view]) {
        [view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [self.observedViews addObject:view];

        if ([view isKindOfClass:[TransparentView class]]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transparentAeraChangedNotification:) name:TransparentViewTransparentAeraChangedNotification object:view];
        }
    }
}

- (void)removeObservationForView:(UIView *)view
{
    if ([self.observedViews containsObject:view]) {
        [view removeObserver:self forKeyPath:@"frame"];
        [self.observedViews removeObject:view];

        if ([view isKindOfClass:[TransparentView class]]) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:TransparentViewTransparentAeraChangedNotification object:view];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (self.transparent) {
        CGRect new = [change[NSKeyValueChangeNewKey] CGRectValue];
        CGRect old = [change[NSKeyValueChangeOldKey] CGRectValue];
        // new old 有一个没有覆盖全，那就会产生透明区域变化
        if (!(CGRectContainsRect(new, self.bounds) &&
              CGRectContainsRect(old, self.bounds))) {
            [self notifyTransparentAeraChanged];
        }
    }
}

- (void)transparentAeraChangedNotification:(NSNotification *)notification
{
    [self notifyTransparentAeraChanged];
}

- (void)notifyTransparentAeraChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TransparentViewTransparentAeraChangedNotification object:self];
}

#pragma mark - Public

- (CGRect)transparentAeraConvertToView:(UIView *)view
{
    CGRect bounds = self.bounds;
    CGRect intersection = CGRectIntersection(bounds, [self opaqueAeraConvertToView:self]);

    if (CGRectIsNull(intersection)) {
        return bounds;
    }

    if (CGRectEqualToRect(intersection, bounds)) {
        return CGRectZero;
    }

    if (CGRectGetMinX(intersection) > CGRectGetMinX(bounds))
    {
        bounds.size.width = CGRectGetMinX(intersection) - CGRectGetMinX(bounds);
    }
    else if (CGRectGetWidth(intersection) < CGRectGetWidth(bounds))
    {
        bounds.origin.x = CGRectGetMaxX(intersection);
        bounds.size.width = CGRectGetWidth(bounds) - CGRectGetWidth(intersection);
    }
    else
    {
        // 重合，什么都不做
    }

    if (CGRectGetMinY(intersection) > CGRectGetMinY(bounds))
    {
        bounds.size.height = CGRectGetMinY(intersection) - CGRectGetMinY(bounds);
    }
    else if (CGRectGetHeight(intersection) < CGRectGetHeight(bounds))
    {
        bounds.origin.y = CGRectGetMaxY(intersection);
        bounds.size.height = CGRectGetHeight(bounds) - CGRectGetHeight(intersection);
    }
    else
    {
        // 重合，什么都不做
    }

    return [self convertRect:bounds toView:view];
}

- (CGRect)opaqueAeraConvertToView:(UIView *)view
{
    CGRect unionRect = self.subviews.firstObject.frame;

    for (UIView *subview in self.subviews) {
        CGRect subviewFrame = subview.frame;
        if ([subview isKindOfClass:[TransparentView class]]) {
            subviewFrame = [(TransparentView *)subview opaqueAeraConvertToView:self];

        }
        unionRect = CGRectUnion(unionRect, subview.frame);
    }

    return [self convertRect:unionRect toView:view];
}

@end
