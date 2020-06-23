//
//  LoginView.h
//  VipVideo-iPhone
//
//  Created by swift on 2020/6/23.
//  Copyright © 2020 SV. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LoginActionBlock)(NSString * userName,NSString * password);

typedef void(^LoginActionCompleteBlock)(void);

typedef void(^Dimiss)(void);

@interface LoginView : UIView

/// 展示登录页面并登录按钮操作
/// @param loginTapBlock 带的参数block回调
+(void)showLoginViewActionCompleteBlcok:(LoginActionCompleteBlock)completeBlock;


/// 小时的登录页面
/// @param dimissBlock 小时登录页面带回调
+(void)dimissLoginView:(Dimiss)dimissBlock;

@end

NS_ASSUME_NONNULL_END
