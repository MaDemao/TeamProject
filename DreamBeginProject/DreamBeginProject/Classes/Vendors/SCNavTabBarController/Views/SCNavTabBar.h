//
//  SCNavTabBar.h
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCNavTabBarDelegate <NSObject>
//声明协议
@optional
/**
 *  When NavTabBar Item Is Pressed Call Back
 *  当NavTabBar项按回电话
 *  @param index - pressed item's index 按项的索引
 */
- (void)itemDidSelectedWithIndex:(NSInteger)index;

/**
 *  When Arrow Pressed Will Call Back
 *
 *  @param pop    - is needed pop menu
 *  @param height - menu height
 
 
 */
- (void)shouldPopNavgationItemMenu:(BOOL)pop height:(CGFloat)height;

@end

@interface SCNavTabBar : UIView

//代理属性
@property (nonatomic, weak)     id          <SCNavTabBarDelegate>delegate;

@property (nonatomic, assign)   NSInteger   currentItemIndex;           // current selected item's index 当前选中的分段按钮
@property (nonatomic, strong)   NSArray     *itemTitles;                // all items' title  所有项目的标题

@property (nonatomic, strong)   UIColor     *lineColor;                 // set the underscore color //下划线颜色
@property (nonatomic, strong)   UIImage     *arrowImage;                // set arrow button's image 箭头按钮

/**
 *  Initialize Methods
 *
 *  @param frame - SCNavTabBar frame
 *  @param show  - is show Arrow Button
 *
 *  @return Instance
 */
//设置tabbar 大小
- (id)initWithFrame:(CGRect)frame canPopAllItemMenu:(BOOL)can;

/**
 *  Update Item Data
 */
//更新tabbar
- (void)updateData;

/**
 *  Refresh All Subview
 */
//跟新所有控制器试图
- (void)refresh;

@end
