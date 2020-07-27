//
//  HLMineViewController.m
//  VipVideo-iPhone
//
//  Created by LHL on 2018/9/17.
//  Copyright © 2018 SV. All rights reserved.
//

#import "HLMineViewController.h"
#import "Masonry.h"
#import "LoginView.h"

@interface HLMineViewController ()
/**
 titleLAbel
 */
@property (nonatomic,strong)UILabel * titleLabel;

/**
 loginBtn
 */
@property (nonatomic,strong)UIButton * loginBtn;

/**
 headerImgView
 */
@property (nonatomic,strong)UIImageView * headerImgV;

@end

@implementation HLMineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"我的";
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.headerImgV];
    [self.view addSubview:self.titleLabel];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:(UIBarButtonItemStylePlain) target:self action:@selector(loginOutAction:)];
    [rightButton setTintColor:[UIColor orangeColor]];
    self.navigationItem.rightBarButtonItem = rightButton;
   
}

-(void)loginOutAction:(UIBarButtonItem *)rightBtn{
    
    NSString * isLogin = [[NSUserDefaults standardUserDefaults] objectForKey:IsLogin];
    if ([isLogin isEqual:@"0"] || [isLogin isEqual:nil]) {
        return;
    }
    NSLog(@"退出登录");

    NSArray * notClearArr = @[
                                HLVideoIphoneUAChange,
                                HLVideoIphoneUAisOn,
                                 ];//退出登录不需要清除的资料
       
       NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
       for(NSString *key in [dictionary allKeys]){
           if(![notClearArr containsObject:key])
           {
               [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
               [[NSUserDefaults standardUserDefaults] synchronize];
           }
       }
    [LoginView clearUserPwd];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:IsLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    isLogin = @"0";
    [self refreshMainUI:isLogin];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString * loginState = [[NSUserDefaults standardUserDefaults] objectForKey:IsLogin];
    if ([loginState isEqualToString:@"1"]) {
       self.loginBtn.hidden   = YES;
       self.titleLabel.hidden = NO;
       self.headerImgV.hidden = NO;
       NSString * validate = [[NSUserDefaults standardUserDefaults] objectForKey:LoginDate];
       self.titleLabel.text = [NSString stringWithFormat:@"您的会员截止日期为%@到期，为了不影响您的使用，请及时续费哦！",validate?validate:@"1990/01/01"];
       return;
    }
    self.loginBtn.hidden   = NO;
    self.titleLabel.hidden = YES;
    self.headerImgV.hidden = YES;

}
          
-(void)loginAction:(UIButton *)btn{
    [LoginView showLoginViewActionCompleteBlcok:^{
        NSLog(@"已经展示完了");
    }];

    //弱引用
    __weak typeof(self) weakSelf = self;
    [LoginView shareLoginView].commitBlock = ^(NSString * _Nonnull userPhone) {
        NSLog(@"我的手机号是%@",userPhone);
        [[NSUserDefaults standardUserDefaults] setValue:userPhone forKey:MyPhone];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:IsLogin];
        NSString * validata = [LoginModel getUserValidate];
        [[NSUserDefaults standardUserDefaults] setObject:validata forKey:LoginDate];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [weakSelf refreshMainUI:@"1"];
    };
}

-(void)refreshMainUI:(NSString *)isLogin{
    if ([isLogin isEqual:@"1"]) {
        self.loginBtn.hidden = YES;
        self.titleLabel.hidden = NO;
        self.headerImgV.hidden = NO;
        NSString * validate = [[NSUserDefaults standardUserDefaults] objectForKey:LoginDate];
        self.titleLabel.text = [NSString stringWithFormat:@"您的会员截止日期为%@到期，为了不影响您的使用，请及时续费哦！",validate?validate:@"1990/01/01"];
    }else
    {
        self.loginBtn.hidden = NO;
        self.titleLabel.hidden = YES;
        self.headerImgV.hidden = YES;
    }
}

/**
 懒加载布局
 所有的都可以改写
 @return 布局
 */
-(UIImageView *)headerImgV
{
    if (!_headerImgV)
    {
        _headerImgV                    = [[UIImageView alloc] init];
        _headerImgV.size               = CGSizeMake(120, 120);
        _headerImgV.centerX            = kScreenWidth/2.0;
        _headerImgV.y                  = 140;
        _headerImgV.layer.cornerRadius = 60;
        _headerImgV.image              = [UIImage imageNamed:@"nihaojiushiguang13.jpg"];
        _headerImgV.contentMode = UIViewContentModeScaleAspectFill;
        [_headerImgV setClipsToBounds:YES];
    }
    return _headerImgV;
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
        _titleLabel.size          = CGSizeMake(200, 100);
        _titleLabel.centerX       = kScreenWidth/2.0;
        _titleLabel.y             = _headerImgV.sumHeight+15;
        _titleLabel.font          = [UIFont systemFontOfSize:18 weight:(UIFontWeightHeavy)];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.textColor     = [UIColor orangeColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text          = @"";
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
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
        _loginBtn                    = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _loginBtn.size               = CGSizeMake(160, 45);
        _loginBtn.centerX            = kScreenWidth/2.0;
        _loginBtn.y                  =  200;
        [_loginBtn setTitle:@"登 录" forState:(UIControlStateNormal)];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _loginBtn.titleLabel.font    = [UIFont systemFontOfSize:18 weight:(UIFontWeightRegular)];
        _loginBtn.layer.cornerRadius = 15;
        [_loginBtn setClipsToBounds:YES];
        _loginBtn.backgroundColor    = [UIColor orangeColor];
        [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _loginBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)swichChange:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:HLVideoIphoneUAisOn];
    [[NSNotificationCenter defaultCenter] postNotificationName:HLVideoIphoneUAChange object:nil];
}


@end
