//
//  ShowMemeryTool.m
//  VipVideo-iPhone
//
//  Created by 杜浩然 on 2020/12/16.
//  Copyright © 2020 SV. All rights reserved.
//

#import "ShowMemeryTool.h"
#import <mach/mach.h>

@implementation ShowMemeryTool

// 当前 app 内存使用量
+ (NSInteger)useMemoryForApp {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if (kernelReturn == KERN_SUCCESS) {
        int64_t memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        return memoryUsageInByte / 1024 / 1024;
    } else {
        return -1;
    }
}
@end
