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
 UIButton
 */
@property (nonatomic,strong)UIButton *  loginBtn;

/**
 登录按钮响应
 */
@property (nonatomic,copy)LoginActionBlock  loginBlock;

@property (nonatomic,strong)UITapGestureRecognizer *  tap;

/**
 descriptionLabel
 */
@property (nonatomic,strong)UILabel *  descriptionLabel;

@end

@implementation LoginView

static LoginView * loginView = nil;

/**
 创建单利
 
 @return    返回单利对象
 */
+ (instancetype)shareLoginView {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          
        loginView = [[self alloc] init];
    });
    loginView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return loginView;
}

+(void)showLoginViewActionCompleteBlcok:(LoginActionCompleteBlock)completeBlock{
    
    [[self shareLoginView] initWithUI];
    [[self shareLoginView] setUIFrame];
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:[self shareLoginView]];
    [window bringSubviewToFront:[self shareLoginView]];
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

+(void)clearUserPwd{
    LoginView * loginV    = [self shareLoginView];
    loginV.nameField.text = @"";
    loginV.pwdField.text  = @"";
    
}

-(void)initWithUI{
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.nameField];
    [self.backView addSubview:self.pwdField];
    [self.backView addSubview:self.loginBtn];
    [self.backView addSubview:self.descriptionLabel];
    [self.loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.backView addGestureRecognizer:self.tap];
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    
    if (self.nameField.isEditing) {
        [self.nameField resignFirstResponder];
    }
    if (self.pwdField.isEditing) {
        [self.pwdField resignFirstResponder];
    }
}

-(void)loginAction:(UIButton *)loginBtn{
    if (![self.nameField.text isEqual:self.pwdField.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"请确定两次输入一样！"];
        return;
    }
    if ([self.nameField.text isEqualToString:@""] || [self.pwdField.text isEqualToString:@""]) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入手机号。"];
        return;
    }
    self.commitBlock([self getUserPhone]);
    [self dismiss];
}

-(NSString *)getUserPhone{
    return [self.nameField.text isEqualToString:self.pwdField.text]?self.nameField.text:@"";
}

+(void)commitActionBlock:(LoginActionBlock)commitActionBlock
{
    loginView.commitBlock([loginView getUserPhone]);
}

-(void)dismiss{
    [self removeFromSuperview];
    [self.tap removeTarget:self action:@selector(tapAction:)];
}

-(void)setUIFrame{
    
    self.titleLabel.size           = CGSizeMake(150, 30);
    self.titleLabel.font           = [UIFont systemFontOfSize:29 weight:(UIFontWeightRegular)];
    self.titleLabel.centerX        = kScreenWidth/2.0;
    self.titleLabel.y              = 150;
    self.centerX                   = kScreenWidth /2.0;
    self.y                         = self.backView.sumHeight+20;
    self.nameField.size            = CGSizeMake(kScreenWidth/3.0*2, 45);
    self.nameField.y               = self.titleLabel.sumHeight+45;
    self.nameField.backgroundColor = [UIColor cyanColor];
    self.nameField.centerX         = kScreenWidth/2.0;
    self.pwdField.size             = self.nameField.size;
    self.pwdField.y                = self.nameField.sumHeight+15;
    self.pwdField.backgroundColor  = [UIColor cyanColor];
    self.pwdField.centerX          = self.nameField.centerX;
    self.loginBtn.size             = CGSizeMake(180, 45);
    self.loginBtn.backgroundColor  = [UIColor orangeColor];
    self.loginBtn.y                = self.pwdField.sumHeight+55;
    self.loginBtn.centerX          = self.nameField.centerX;
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
        _backView                 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
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
        _titleLabel.font          = [UIFont systemFontOfSize:30 weight:(UIFontWeightHeavy)];
        _titleLabel.text          = @"用户信息";
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
        _nameField.placeholder = @"    请输入用户手机号";
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
        _pwdField.placeholder = @"    请再次输入手机号";
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
        [_loginBtn setTitle:@"提 交" forState:(UIControlStateNormal)];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightHeavy)];
        _loginBtn.backgroundColor = [UIColor cyanColor];
        _loginBtn.layer.cornerRadius = 15;
        [_loginBtn setClipsToBounds:YES];
    }
    return _loginBtn;
}

/**
 懒加载布局
 所有的都可以改写
 @return 布局
 */
-(UILabel *)descriptionLabel
{
    if (!_descriptionLabel)
    {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightThin)];
        _descriptionLabel.textColor = [UIColor redColor];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.text = @"请慎重输入手机号，因为该号码是你vip唯一凭证的重要因素，并且已经提交后便不可再次修改。所以请确认无误后点击提交按钮";
    }
    return _descriptionLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
