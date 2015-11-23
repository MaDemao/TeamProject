//
//  LGIntroductionViewController.h
//
//  Created by square on 15/1/21.
//  Copyright (c) 2015年 square. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectedEnter)();

@interface ZWIntroductionViewController : UIViewController

//滚动试图
@property (nonatomic, strong) UIScrollView *pagingScrollView;
//进入按钮
@property (nonatomic, strong) UIButton *enterButton;
//回调的Block
@property (nonatomic, copy) DidSelectedEnter didSelectedEnter;

/**
 @[@"image1", @"image2"]
 */
//背景图片
@property (nonatomic, strong) NSArray *backgroundImageNames;
/**
 @[@"coverImage1", @"coverImage2"]
 */
//内容图
@property (nonatomic, strong) NSArray *coverImageNames;

- (id)initWithCoverImageNames:(NSArray*)coverNames;

- (id)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames;

- (id)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames button:(UIButton*)button;

- (id)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames titleArray:(NSArray *)titles;

@end
