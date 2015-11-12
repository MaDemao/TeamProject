//
//  SCPopView.m
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import "SCPopView.h"
#import "CommonMacro.h"

@implementation SCPopView

#pragma mark - Private Methods
#pragma mark -
//私有方法
//传入标题数组
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    //初始化数组
    NSMutableArray *widths = [@[] mutableCopy];
    
    //循环遍历标题数组
    for (NSString *title in titles)
    {
        //获取字体大小
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];

        //返回宽度
        NSNumber *width = [NSNumber numberWithFloat:size.width + 40.0f];
        //添加到返回数组
        [widths addObject:width];
    }
    
    //返回标题宽度数组
    return widths;
}


- (void)updateSubViewsWithItemWidths:(NSArray *)itemWidths;
{
    //原最标点 (0,0)
    CGFloat buttonX = DOT_COORDINATE;
    CGFloat buttonY = DOT_COORDINATE;
    
    //循环次数 有标题个数决定
    for (NSInteger index = 0; index < [itemWidths count]; index++)
    {
        //初始化按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //关联Tag值
        button.tag = index;
        //按钮大小
        button.frame = CGRectMake(buttonX, buttonY, [itemWidths[index] floatValue], ITEM_HEIGHT);
        //按钮标题
        [button setTitle:_itemNames[index] forState:UIControlStateNormal];
        //设值标题字体颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //关联按钮事件
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        //添加按钮
        [self addSubview:button];
        //获取下一个按钮的X坐标  按钮宽度转化格式为Float
        buttonX += [itemWidths[index] floatValue];
        
        @try {
            //判断是否超出屏幕边缘  超出换行
            if ((buttonX + [itemWidths[index + 1] floatValue]) >= SCREEN_WIDTH)
            {
                buttonX = DOT_COORDINATE;
                buttonY += ITEM_HEIGHT;
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}

//按钮关联方法
- (void)itemPressed:(UIButton *)button
{
    //点击执行代理方法  出入按钮的tag值
    [_delegate itemPressedWithIndex:button.tag];
}

#pragma mark - Public Methods
#pragma marl -

//重写赋值方法
- (void)setItemNames:(NSArray *)itemNames
{
    _itemNames = itemNames;
    
    //获取标题宽度数组
    NSArray *itemWidths = [self getButtonsWidthWithTitles:itemNames];
    //
    [self updateSubViewsWithItemWidths:itemWidths];
}

@end
