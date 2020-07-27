//
//  LoginModel.h
//  VipVideo-iPhone
//
//  Created by swift on 2020/6/29.
//  Copyright © 2020 SV. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginModel : NSObject


/// 检验vip是否到期
+(BOOL)checkVipDate;

+(NSString *)getUserValidate;

@end

NS_ASSUME_NONNULL_END
