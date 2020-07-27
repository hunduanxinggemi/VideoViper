//
//  LoginView.h
//  VipVideo-iPhone
//
//  Created by swift on 2020/6/23.
//  Copyright © 2020 SV. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LoginActionBlock)(NSString * userPhone);

typedef void(^LoginActionCompleteBlock)(void);

typedef void(^Dimiss)(void);

/// LoginView
@interface LoginView : UIView

/**
 userNameTextField
 */
@property (nonatomic,strong)UITextField *  nameField;

/**
 pwdField
 */
@property (nonatomic,strong)UITextField *  pwdField;



+ (instancetype)shareLoginView;


/// 展示登录页面并登录按钮操作
/// @param completeBlock 带的参数block回调
+(void)showLoginViewActionCompleteBlcok:(LoginActionCompleteBlock)completeBlock;


/**
 commitBlock
 */
@property (nonatomic,copy)LoginActionBlock  commitBlock;


/// 点击登录按钮的响应回调
/// @param commitActionBlock 提交
+(void)commitActionBlock:(LoginActionBlock)commitActionBlock;


/// 小时的登录页面
/// @param dimissBlock 小时登录页面带回调
+(void)dimissLoginView:(Dimiss)dimissBlock;


/// 清楚用户名和密码
+(void)clearUserPwd;

@end

NS_ASSUME_NONNULL_END
