//
//  AppDelegate.m
//  VipVideo-iPhone
//
//  Created by LHL on 2017/10/26.
//  Copyright © 2017年 SV. All rights reserved.
//

#import "AppDelegate.h"
#import "VipURLManager.h"
#import "QSPDownloadTool.h"
#import "NSURLProtocol+WKWebVIew.h"
#import <Bugly/Bugly.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HLVideoIphoneUAisOn];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"UserAgent": HLiPhoneUA}];
    [[NSUserDefaults standardUserDefaults] setObject:@"2020/08/01" forKey:LoginDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [Bugly startWithAppId:@"51511e6dc5"];
    [VipURLManager sharedInstance];
    [[QSPDownloadTool shareInstance] startAllTask];
    //向网络请求所有Vip的信息。用于进行判断本机用户是不是会员。
    [self initVipList];
    return YES;
}

-(void)initVipList{
    NSString * urlStr = @"https://hunduanxinggemi.github.io/vvList.github.io/VipList";
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2.创建请求 并：设置缓存策略为每次都从网络加载 超时时间30秒
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];

       // 3.采用苹果提供的共享session
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    // 4.由系统直接返回一个dataTask任务
     NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         // 网络请求完成之后就会执行，NSURLSession自动实现多线程
         NSLog(@"%@",[NSThread currentThread]);
         if (data && (error == nil)) {
             // 网络访问成功
             NSString * resultStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             resultStr = [resultStr stringByReplacingOccurrencesOfString:@"<p>“" withString:@""];
             resultStr = [resultStr stringByReplacingOccurrencesOfString:@"”</p>" withString:@""];

             [VipURLManager sharedInstance].vipArray = [self dataHanleWithJsonString:resultStr];
             #pragma Mark 发送通知
             //发送通知
             [[NSNotificationCenter defaultCenter] postNotificationName:VipLoadFinish object:nil userInfo:nil];
             NSLog(@"%@",[VipURLManager sharedInstance].vipArray);
         } else {
             // 网络访问失败
             [SVProgressHUD showErrorWithStatus:@"网络请求失败，无法获取服务器上的名单！"];
             
         }
     }];
     
     // 5.每一个任务默认都是挂起的，需要调用 resume 方法
     [dataTask resume];
}

-(NSMutableArray *)dataHanleWithJsonString:(NSString *)str{
    
    NSMutableArray * nameArr = [NSMutableArray array];
    NSMutableArray * valiteDates = [NSMutableArray array];
    NSMutableArray * phones = [NSMutableArray array];
    NSMutableArray * resultArr = [NSMutableArray array];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSArray * contentArr = [str componentsSeparatedByString:@"DHRWMKK"];
    for (int i = 0;i < contentArr.count; i++) {
       
        NSMutableArray * viper = [NSMutableArray arrayWithArray:[contentArr[i] componentsSeparatedByString:@","]];

       [nameArr addObject:[[[viper firstObject] componentsSeparatedByString:@":"] lastObject]];
       [valiteDates addObject:[[viper[1] componentsSeparatedByString:@":"] lastObject]];
       [phones addObject:[[[viper lastObject] componentsSeparatedByString:@":"] lastObject]];
    }
    [VipURLManager sharedInstance].vipNameArray = nameArr;
    [VipURLManager sharedInstance].validateArr  = valiteDates;
    [VipURLManager sharedInstance].phoneArray   = phones;

    NSString * validate = [LoginModel getUserValidate];
    [[NSUserDefaults standardUserDefaults] setObject:validate forKey:LoginDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
  
    if (nameArr.count == valiteDates.count == phones.count) {
        for (int j = 0; j < nameArr.count; j++) {
            NSDictionary * dic = @{
                @"name":nameArr[j],
                @"validateDate":nameArr[j],
                @"phoneNum":nameArr[j],
            };
            [resultArr addObject:dic];
        }
    }
    return resultArr;
}

-(NSString *)changeStringWith:(NSString *)resultStr{
  
    NSString * result = [resultStr stringByReplacingOccurrencesOfString:@"“" withString:@"\""];
    result = [result stringByReplacingOccurrencesOfString:@"”" withString:@"\""];
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[QSPDownloadTool shareInstance] stopAllTask];
}

@end
