//
//  LoginModel.m
//  VipVideo-iPhone
//
//  Created by swift on 2020/6/29.
//  Copyright © 2020 SV. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

+(BOOL)checkVipDate{
    NSDate *currentDate            = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentTime          = [dateFormatter stringFromDate:currentDate];
    NSLog(@"datestring             = %@",currentTime);
    
    NSString * vipDate             = [[NSUserDefaults standardUserDefaults] objectForKey:LoginDate];
    NSArray *  currentArr          = [currentTime componentsSeparatedByString:@"/"];
    NSArray *  vipArr              = [vipDate componentsSeparatedByString:@"/"];
    
    //比较两组数组日期的大小
    if (currentArr.count == 3 && vipArr.count == 3) {
        
         NSInteger year     = [[currentArr firstObject] integerValue];
         NSInteger vipYear  = [[vipArr firstObject] integerValue];
         NSInteger month    = [[currentArr objectAtIndex:1] integerValue];
         NSInteger vipMonth = [[vipArr objectAtIndex:1] integerValue];
         NSInteger day      = [[currentArr lastObject] integerValue];
         NSInteger vipDay   = [[vipArr lastObject] integerValue];
        if (year < vipYear) {
            return YES;
        }
        if (year == vipYear) {
            
            if (month < vipMonth) {
                return YES;
            }
            
            if (month == vipMonth ) {
                
                if (day <= vipDay) {
                    
                    return YES;
                }
            }
        }
    }
    return NO;
}

+(NSString *)getUserValidate{
    
    NSString * myPhone = [[NSUserDefaults standardUserDefaults] objectForKey:MyPhone];
    NSString * reslut = nil;
    
    NSArray * phones = [VipURLManager sharedInstance].phoneArray;
    NSArray * valiDates = [VipURLManager sharedInstance].validateArr;
    for (int i = 0; i < phones.count; i++) {
        
        if ([phones[i] isEqual:myPhone]) {
            reslut = valiDates[i];
            break;
        }
    }
    return reslut;
}

@end
