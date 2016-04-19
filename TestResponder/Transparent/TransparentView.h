//
//  TRView.h
//  TestResponder
//
//  Created by TozyZuo on 16/4/14.
//  Copyright © 2016年 TozyZuo. All rights reserved.
//

#import "TRView.h"
#import "TransparentViewProtocol.h"

UIKIT_EXTERN NSString *const TransparentViewTransparentAeraChangedNotification;

@interface TransparentView : TRView
<TransparentViewProtocol>
@property (nonatomic, assign) BOOL transparent; // default YES
@end
