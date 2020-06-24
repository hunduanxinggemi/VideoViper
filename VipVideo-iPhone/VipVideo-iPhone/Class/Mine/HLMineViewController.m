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
@property (weak, nonatomic) IBOutlet UISwitch *uaSwitch;

@end

@implementation HLMineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"我的";
    
    if ([IsLogin isEqualToString:@"0"]) {
        [self creatUserValidateUI];
        return;
    }
    [self showLoginView];
    
}
-(void)creatUserValidateUI{

    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.size = CGSizeMake(200, 100);
    titleLabel.centerX = kScreenWidth/2.0;
    titleLabel.y = 250;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"您的会员截止日期为2020-7-20到期，为了不影响您的使用，请及时续费哦！";
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
                                                                        
}
             
-(void)loginAction:(UIButton *)btn{
    
    [LoginView showLoginViewActionCompleteBlcok:^{
        NSLog(@"已经展示完了");
    }];

    [LoginView loginActionBlock:^(NSString * _Nonnull userPhone) {
        NSLog(@"我的手机号是%@",userPhone);
    }];
}
                                                            
-(void)showLoginView{
    
    
    UIButton * loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    loginBtn.size = CGSizeMake(160, 45);
    loginBtn.centerX = kScreenWidth/2.0;
    loginBtn.y =  200;
    [loginBtn setTitle:@"登 录" forState:(UIControlStateNormal)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightRegular)];
    loginBtn.layer.cornerRadius = 15;
    [loginBtn setClipsToBounds:YES];
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    loginBtn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:loginBtn];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)swichChange:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:HLVideoIphoneUAisOn];
    [[NSNotificationCenter defaultCenter] postNotificationName:HLVideoIphoneUAChange object:nil];
}


@end
