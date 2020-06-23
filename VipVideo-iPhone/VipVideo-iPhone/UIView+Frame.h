//
//  AppDelegate.h
//  ProjectFrame
//
//  Created by Swift on 2018/2/2.
//  Copyright © 2018年 Swift. All rights reserved.
//  直接获取/调整view的各尺寸

#import <UIKit/UIKit.h>

@interface UIView (Frame)
/**
 *  宽
 */
@property (nonatomic, assign) CGFloat width;
/**
 *  高
 */
@property (nonatomic, assign) CGFloat height;
/**
 *  x
 */
@property (nonatomic, assign) CGFloat x;
/**
 *  y
 */
@property (nonatomic, assign) CGFloat y;

/**
 *  尺寸
 */
@property (nonatomic, assign) CGSize size;

/**
 *  自身的y+height
 */
@property (nonatomic, readonly) CGFloat sumHeight;

/**
 *  自身的x+width
 */
@property (nonatomic, readonly) CGFloat sumWidth;
/** UIView 的中心点X值 */
@property (nonatomic, assign) CGFloat centerX;
/** UIView 的中心点Y值 */
@property (nonatomic, assign) CGFloat centerY;
/**UIView的做边距和上边距 **/
@property (nonatomic, assign) CGPoint xy;

/**
 *  计算文字的需要的label尺寸
 *
 *  @param text     文字内容
 *  @param maxSize  最大宽和高
 *  @param fontSize 字号
 *
 *  @return label的size
 */
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize;
/**
 *  计算文字的需要的label尺寸
 *
 *  @param text     文字内容
 *  @param maxSize  最大宽和高
 *  @param font 字体font
 *
 *  @return label的size
 */
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font;
/**
 *  计算相view相对于屏幕的Y值
 *
 *  @param view  view
 *  @param viewY view.y
 *
 *  @return view相对于屏幕的Y值
 */
+(CGFloat)getYAtScreenWithView:(UIView *)view viewY:(CGFloat)viewY;

/**
 *  计算相view相对于屏幕的X值
 *
 *  @param view  view
 *  @param viewX view.x
 *
 *  @return view相对于屏幕的X值
 */
+(CGFloat)getXAtScreenWithView:(UIView *)view viewX:(CGFloat)viewX;


/**
 设置圆角

 @param corner 需要圆角的位置
 @param size 大小
 */
-(void)setCordiusWithUIRectCorner:(UIRectCorner)corner andCornerRadii:(CGSize)size;


/**
 复制适用于宽高均和参数相等

 @param view 参数view
 */
-(void)isEqualToView:(UIView *)view;


/**
 设置边框

 @param view 需要添加边框的控件
 @param top s上
 @param left 左下
 @param bottom 下
 @param right 又
 @param color 颜色
 @param width 宽度
 */
- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;


/**
 找出显示的view

 @param className view的名字
 @return 返回uiview
 */
- (UIView*)subViewOfClassName:(NSString*)className;


/**
 添加手势

 @param target 目标
 @param action 方法
 */
- (void)addTapGestureWithTarget:(id)target action:(SEL)action;

/**
 添加手势

 @param aBlock 响应方法是block
 */
- (void)addTapGestureWithBlock:(void (^)(UIView *gestureView))aBlock;

/**
 移除所有手势
 */
- (void)removeTapGesture;

/**
 添加tap手势

 @param aBlock 回调参数是手势
 */
- (void)addTapWithGestureBlock:(void (^)(UITapGestureRecognizer *gesture))aBlock;

/**
 添加手势

 @param delegate 手势的代理需要调用的对象来当
 @param aBlock 回调参数是手势
 */
- (void)addTapWithDelegate:(id<UIGestureRecognizerDelegate>)delegate gestureBlock:(void (^)(UITapGestureRecognizer *gesture))aBlock;

@end
