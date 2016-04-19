//
//  TransparentViewProtocol.h
//  TestResponder
//
//  Created by TozyZuo on 16/4/18.
//  Copyright © 2016年 TozyZuo. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const TransparentViewTransparentAeraChangedNotification;

@protocol TransparentViewProtocol <NSObject>
- (CGRect)transparentAeraConvertToView:(UIView *)view;
- (CGRect)opaqueAeraConvertToView:(UIView *)view;
@end