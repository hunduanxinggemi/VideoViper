#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HLAdditions.h"
#import "HLUtilities.h"
#import "NSArray+.h"
#import "NSData+Additions.h"
#import "NSDate+.h"
#import "NSDictionary+.h"
#import "NSString+Extend.h"
#import "UIColor+.h"
#import "UIImage+.h"
#import "UIView+Additions.h"
#import "UIViewController+.h"
#import "EXTScope.h"
#import "metamacros.h"

FOUNDATION_EXPORT double HLAdditionsVersionNumber;
FOUNDATION_EXPORT const unsigned char HLAdditionsVersionString[];

