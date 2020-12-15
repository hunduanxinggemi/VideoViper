//
//  VipListModel.m
//  VipVideo-iPhone
//
//  Created by 魂断星戈幂 on 2020/9/4.
//  Copyright © 2020 SV. All rights reserved.
//

#import "VipListModel.h"

@implementation VipListModel

+ (void)initVipList {
    NSString *urlStr =
        @"https://hunduanxinggemi.github.io/vvList.github.io/VipList";
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:
                         [NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2.创建请求 并：设置缓存策略为每次都从网络加载 超时时间30秒
    NSURLRequest *request =
        [NSURLRequest requestWithURL:url
                         cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                     timeoutInterval:30];

    // 3.采用苹果提供的共享session
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    // 4.由系统直接返回一个dataTask任务
    NSURLSessionDataTask *dataTask = [sharedSession
        dataTaskWithRequest:request
          completionHandler:^(NSData *_Nullable data,
                              NSURLResponse *_Nullable response,
                              NSError *_Nullable error) {
              // 网络请求完成之后就会执行，NSURLSession自动实现多线程
              NSLog(@"%@", [NSThread currentThread]);
              if (data && (error == nil)) {
                  // 网络访问成功
                  NSString *resultStr =
                      [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
                  resultStr =
                      [resultStr stringByReplacingOccurrencesOfString:@"<p>“"
                                                           withString:@""];
                  resultStr =
                      [resultStr stringByReplacingOccurrencesOfString:@"”</p>"
                                                           withString:@""];

                  [VipURLManager sharedInstance].vipArray =
                      [self dataHanleWithJsonString:resultStr];
#pragma Mark 发送通知
                  //发送通知
                  [[NSNotificationCenter defaultCenter]
                      postNotificationName:VipLoadFinish
                                    object:nil
                                  userInfo:nil];
                  NSLog(@"%@", [VipURLManager sharedInstance].vipArray);
              } else {
                  // 网络访问失败
                  [SVProgressHUD showErrorWithStatus:@"网"
                                                     @"络请求失败，无法获取服"
                                                     @"务器上的名单！"];
              }
          }];

    // 5.每一个任务默认都是挂起的，需要调用 resume 方法
    [dataTask resume];
}

+ (NSMutableArray *)dataHanleWithJsonString:(NSString *)str {
    NSMutableArray *nameArr     = [NSMutableArray array];
    NSMutableArray *valiteDates = [NSMutableArray array];
    NSMutableArray *phones      = [NSMutableArray array];
    NSMutableArray *resultArr   = [NSMutableArray array];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSArray *contentArr = [str componentsSeparatedByString:@"DHRWMKK"];
    for (int i = 0; i < contentArr.count; i++) {
        NSMutableArray *viper = [NSMutableArray
            arrayWithArray:[contentArr[i] componentsSeparatedByString:@","]];

        [nameArr addObject:[[[viper firstObject]
                               componentsSeparatedByString:@":"] lastObject]];
        [valiteDates
            addObject:[[viper[1] componentsSeparatedByString:@":"] lastObject]];
        [phones addObject:[[[viper lastObject] componentsSeparatedByString:@":"]
                              lastObject]];
    }
    [VipURLManager sharedInstance].vipNameArray = nameArr;
    [VipURLManager sharedInstance].validateArr  = valiteDates;
    [VipURLManager sharedInstance].phoneArray   = phones;

    NSString *validate = [LoginModel getUserValidate];
    [[NSUserDefaults standardUserDefaults] setObject:validate forKey:LoginDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (nameArr.count == valiteDates.count && nameArr.count == phones.count) {
        for (int j = 0; j < nameArr.count; j++) {
            NSDictionary *dic = @{
                @"name" : nameArr[j],
                @"validateDate" : nameArr[j],
                @"phoneNum" : nameArr[j],
            };
            [resultArr addObject:dic];
        }
    }
    NSLog(@"所有的会员名单 = %@", resultArr);
    return resultArr;
}

@end
