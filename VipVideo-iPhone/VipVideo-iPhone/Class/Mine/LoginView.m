//
//  LoginView.m
//  VipVideo-iPhone
//
//  Created by swift on 2020/6/23.
//  Copyright © 2020 SV. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()<UITextFieldDelegate>

/**
 backView
 */
@property (nonatomic,strong)UIView *  backView;

/**
 titleLabel
 */
@property (nonatomic,strong)UILabel *  titleLabel;

/**
 userNameTextField
 */
@property (nonatomic,strong)UITextField *  nameField;

/**
 pwdField
 */
@property (nonatomic,strong)UITextField *  pwdField;

/**
 UIButton
 */
@property (nonatomic,strong)UIButton *  loginBtn;

/**
 登录按钮响应
 */
@property (nonatomic,copy)LoginActionBlock  loginBlock;

@end

@implementation LoginView

/**
 创建单利
 
 @return    返回单利对象
 */
+ (instancetype)shareLoginView {
    
    static LoginView * loginView = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        loginView = [[self alloc] init];
        loginView.frame = [[UIScreen mainScreen] bounds];
    });
    
    return loginView;
}

+(void)showLoginViewActionCompleteBlcok:(LoginActionCompleteBlock)completeBlock{
    
    LoginView * loginV = [LoginView shareLoginView];
    [loginV initWithUI];
    [loginV setUIFrame];
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:loginV];
    [window bringSubviewToFront:loginV];
    completeBlock();
}

+(void)dimissLoginView:(Dimiss)dimissBlock{
    
    //弱引用
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        LoginView * loginV  = [weakSelf shareLoginView];
        [loginV removeFromSuperview];
        loginV = nil;
        [loginV dismiss];
    }];

}

-(void)initWithUI{
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.nameField];
    [self.backView addSubview:self.pwdField];
    [self.backView addSubview:self.loginBtn];
    [self.loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
}

-(void)loginAction:(UIButton *)loginBtn{
    LoginView * loginV = [LoginView shareLoginView];
    self.loginBlock(loginV.nameField.text, loginV.pwdField.text);
    [self dismiss];
}

-(void)dismiss{
      [self removeFromSuperview];
}

-(void)setUIFrame{
    self.titleLabel.size    = CGSizeMake(150, 30);
    self.titleLabel.font    = [UIFont systemFontOfSize:29 weight:(UIFontWeightRegular)];
    self.titleLabel.centerX = kScreenWidth/2.0;
    self.titleLabel.y       = 150;
    self.centerX            = kScreenWidth /2.0;
    self.y                  = self.backView.sumHeight+20;
    
    
}



/**
 懒加载布局
 所有的都可以改写
 @return 布局
 */
-(UIView *)backView
{
    if (!_backView)
    {
        _backView                 = [[UIView alloc] initWithFrame:self.bounds];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
    }
    return _backView;
}

/**
 懒加载布局
 所有的都可以改写
 @return 布局
 */
-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel               = [[UILabel alloc] init];
        _titleLabel.textColor     = [UIColor orangeColor];
        _titleLabel.font          = [UIFont systemFontOfSize:26 weight:(UIFontWeightBold)];
        _titleLabel.text          = @"登 录";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

/**
 懒加载布局
 所有的都可以改写
 @return 布局
 */
-(UITextField *)nameField
{
    if (!_nameField)
    {
        _nameField             = [[UITextField alloc] init];
        _nameField.delegate    = self;
        _nameField.placeholder = @"请输入用户手机号";
        _nameField.textColor   = [UIColor blackColor];
        _nameField.font        = [UIFont systemFontOfSize:18 weight:(UIFontWeightHeavy)];
        _nameField.tintColor   = [UIColor orangeColor];
        _nameField.layer.cornerRadius = 15;
        _nameField.clipsToBounds = YES;
    }
    return _nameField;
}

-(UITextField *)pwdField
{
    if (!_pwdField)
    {
        _pwdField             = [[UITextField alloc] init];
        _pwdField.delegate    = self;
        _pwdField.placeholder = @"请输入用户密码";
        _pwdField.textColor   = [UIColor blackColor];
        _pwdField.font        = [UIFont systemFontOfSize:18 weight:(UIFontWeightHeavy)];
        _pwdField.tintColor   = [UIColor orangeColor];
        _pwdField.layer.cornerRadius = 15;
        _pwdField.clipsToBounds = YES;

    }
    return _pwdField;
}

/**
 懒加载布局
 所有的都可以改写
 @return 布局
 */
-(UIButton *)loginBtn
{
    if (!_loginBtn)
    {
        _loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_loginBtn setTitle:@"登 录" forState:(UIControlStateNormal)];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightHeavy)];
        _loginBtn.backgroundColor = [UIColor cyanColor];
        _loginBtn.layer.cornerRadius = 15;
        [_loginBtn setClipsToBounds:YES];
    }
    return _loginBtn;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
