//
//  SCPopView.h
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCPopViewDelegate <NSObject>

@optional

- (void)viewHeight:(CGFloat)height;
//代理方法  关联按钮 通过获取tag值 相应事件
- (void)itemPressedWithIndex:(NSInteger)index;

@end


@interface SCPopView : UIView
//代理属性
@property (nonatomic, weak)     id      <SCPopViewDelegate>delegate;
//创建标题数组属性
@property (nonatomic, strong)   NSArray *itemNames;

@end
