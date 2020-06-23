//
//  AppDelegate+Chat.m
//  ProjectFrame
//
//  Created by Swift on 2018/2/2.
//  Copyright © 2018 Swift. All rights reserved.
//  直接获取/调整view的各尺寸

#import "UIView+Frame.h"
#import <objc/runtime.h>

#define UIView_key_tapBlock       "UIView.tapBlock"
#define UITapGesture_key_tapBlock   @"UITapGesture_key_tapBlock"

@implementation UIView (Frame)
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x       = centerX;
    self.center    = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y       = centerY;
    self.center    = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}
- (CGFloat)width
{
    return self.frame.size.width;
}

-(void)isEqualToView:(UIView *)view
{
    self.width = view.width;
    
    self.height = view.height;
}

- (CGPoint)xy{
    return CGPointMake(self.x, self.y);
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame     = self.frame;
    frame.size.width = width;
    self.frame       = frame;
}

- (void)setXy:(CGPoint)xy{
    CGRect   rc = self.frame;
    rc.origin   = xy;
    self.frame  = rc;
}

- (void)setSize:(CGSize)size{
    CGRect   rc = self.frame;
    rc.size     = size;
    self.frame  = rc;
}
-(void)setCordiusWithUIRectCorner:(UIRectCorner)corner andCornerRadii:(CGSize)size
{
    UIBezierPath *maskPath  = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
}

- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}


- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame      = self.frame;
    frame.size.height = height;
    self.frame        = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame   = self.frame;
    frame.origin.x = x;
    self.frame     = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame   = self.frame;
    frame.origin.y = y;
    self.frame     = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

-(CGFloat)sumHeight{
    
    return self.y + self.height;
}

-(CGFloat)sumWidth{
    
    return self.x + self.width;
}

//计算文字的大小
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font{
    
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return nameSize;
}

//计算文字的大小
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize{
    
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return nameSize;
}
/**
 *  计算相view相对于屏幕的Y值
 *
 *  @param view  view
 *  @param viewY view.y
 *
 *  @return view相对于屏幕的Y值
 */
+(CGFloat)getYAtScreenWithView:(UIView *)view viewY:(CGFloat)viewY{
    
    if (view.superview!=nil) {
        
        if ([view isKindOfClass:[UIScrollView class]]) {

            UIScrollView *tableView = (UITableView *)view;
            CGFloat changeY         = tableView.contentOffset.y;
//            CLog(@"%s\n %f",__func__,changeY);
            viewY                   = view.superview.y+viewY-changeY;

        }else{
            
            viewY=view.superview.y+viewY;
        }
        
        
        viewY=[self getYAtScreenWithView:view.superview viewY:viewY];
        
    }else{
        
        return viewY;
    }
    
    return viewY;
}
/**
 *  计算相view相对于屏幕的X值
 *
 *  @param view  view
 *  @param viewX view.x
 *
 *  @return view相对于屏幕的X值
 */
+(CGFloat)getXAtScreenWithView:(UIView *)view viewX:(CGFloat)viewX{
    
    if (view.superview!=nil) {

        if ([view isKindOfClass:[UIScrollView class]]) {

            UIScrollView *tableView = (UITableView *)view;
            CGFloat changeX         = tableView.contentOffset.x;
            viewX                   = view.superview.x+viewX-changeX;

        }else{
            
            viewX=view.superview.x+viewX;
        }
        
        
        viewX=[self getXAtScreenWithView:view.superview viewX:viewX];
        
    }else{
        
        return viewX;
    }
    
    return viewX;
}


- (UIView*)subViewOfClassName:(NSString*)className {
    for (UIView* subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }
        
        UIView* resultFound = [subView subViewOfClassName:className];
        if (resultFound) {
            return resultFound;
        }
    }
    return nil;
}


- (void)addTapGestureWithTarget:(id)target action:(SEL)action{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

- (void)removeTapGesture{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers){
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]){
            [self removeGestureRecognizer:gesture];
        }
    }
}

- (void)addTapGestureWithBlock:(void (^)(UIView *gestureView))aBlock;{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap)];
    [self addGestureRecognizer:tap];
    
    objc_setAssociatedObject(self, UIView_key_tapBlock, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)actionTap{
    void (^block)(UIView *)  = objc_getAssociatedObject(self, UIView_key_tapBlock);
    if (block){
        block(self);
    }
}

- (void)addTapWithGestureBlock:(void (^)(UITapGestureRecognizer *gesture))aBlock{
    [self addTapWithDelegate:nil gestureBlock:aBlock];
}

- (void)addTapWithDelegate:(id<UIGestureRecognizerDelegate>)delegate gestureBlock:(void (^)(UITapGestureRecognizer *))aBlock {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    tap.delegate = delegate;
    [self addGestureRecognizer:tap];
    objc_setAssociatedObject(self, UITapGesture_key_tapBlock, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)actionTap:(UITapGestureRecognizer *)aGesture{
    __weak UITapGestureRecognizer *weakGesture = aGesture;
    void (^block)(UITapGestureRecognizer *)  = objc_getAssociatedObject(self, UITapGesture_key_tapBlock);
    if (block){
        block(weakGesture);
    }
}

@end
