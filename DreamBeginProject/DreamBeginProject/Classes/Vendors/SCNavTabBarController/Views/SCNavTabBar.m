//
//  SCNavTabBar.m
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import "SCNavTabBar.h"
#import "CommonMacro.h"
#import "SCPopView.h"

@interface SCNavTabBar () <SCPopViewDelegate>
{
    UIScrollView    *_navgationTabBar;      // all items on this scroll view 标题滚动试图
    UIImageView     *_arrowButton;          // arrow button 箭头按钮
    
    UIView          *_line;                 // underscore show which item selected  导航线
    SCPopView       *_popView;              // when item menu, will show this view 下拉显示图
    
    NSMutableArray  *_items;                // SCNavTabBar pressed item 标题数组
    NSArray         *_itemsWidth;           // an array of items' width 标题宽度
    BOOL            _canPopAllItemMenu;     // is showed arrow button 判定是否显示下拉按钮
    
    BOOL            _popItemMenu;           // is needed pop item menu 判断下拉菜单的显示
}

@end

@implementation SCNavTabBar

//初始化 参数下拉按钮是否显示
- (id)initWithFrame:(CGRect)frame canPopAllItemMenu:(BOOL)can
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //初始化下拉按钮的Bool值
        _canPopAllItemMenu = can;
        //布局
        [self initConfig];
    }
    
    return self;
}

#pragma mark -
#pragma mark - Private Methods

//布局
- (void)initConfig
{
    //初始化数组
    _items = [@[] mutableCopy];
    
    //下拉按钮图片
    _arrowImage = [UIImage imageNamed:SCNavTabbarSourceName(@"arrow.png")];
    //布局滚动试图/下滑按钮
    [self viewConfig];
    //为下滑按钮添加手势
    [self addTapGestureRecognizer];
}
//布局滚动试图/下滑按钮
- (void)viewConfig
{
    //获取宽度
    CGFloat functionButtonX = _canPopAllItemMenu ? (SCREEN_WIDTH - ARROW_BUTTON_WIDTH) : SCREEN_WIDTH;
    
    //判断是否加载下滑按钮
    if (_canPopAllItemMenu)
    {
        //按钮大小设置
        _arrowButton = [[UIImageView alloc] initWithFrame:CGRectMake(functionButtonX, DOT_COORDINATE, ARROW_BUTTON_WIDTH, ARROW_BUTTON_WIDTH)];
        //设置边界颜色
        _arrowButton.layer.shadowColor = [UIColor whiteColor].CGColor;
        //设置图片
        _arrowButton.image = _arrowImage;
        //打开图片用户交互
        _arrowButton.userInteractionEnabled = YES;
        //添加到自定义TabBar
        [self addSubview:_arrowButton];
        
        //设置影子半径  以及不透明度
        [self viewShowShadow:_arrowButton shadowRadius:20.0f shadowOpacity:20.0f];
        
        //创建点击手势
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(functionButtonPressed)];
        //添加手势
        [_arrowButton addGestureRecognizer:tapGestureRecognizer];
    }

    //设置自定义tabBar滚动试图大小 (0 , 0, 全屏宽或减去下滑按钮宽,tabBar高19)
    _navgationTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, functionButtonX, NAV_TAB_BAR_HEIGHT)];
    //设置滚动试图导航线条隐藏
    _navgationTabBar.showsHorizontalScrollIndicator = NO;
    //添加到tabBar主视图
    [self addSubview:_navgationTabBar];
    //设置滚动试图的阴影半径和 阴影不透明度
    [self viewShowShadow:self shadowRadius:10.0f shadowOpacity:10.0f];
}

//显示导航线条 输入一个标题按钮的宽度
- (void)showLineWithButtonWidth:(CGFloat)width
{
    //初始化导航线条的 大小(2,tabBarWidth - 3,按钮宽-4,高3);
    _line = [[UIView alloc] initWithFrame:CGRectMake(2.0f, NAV_TAB_BAR_HEIGHT - 3.0f, width - 4.0f, 3.0f)];
    //设置颜色 rgb
    
    if (_lineColor) {
        _line.backgroundColor = _lineColor;
    }else{
            _line.backgroundColor = UIColorWithRGBA(20.0f, 80.0f, 200.0f, 0.7f);}
    //添加到滚动试图
    [_navgationTabBar addSubview:_line];
}

//添加 标题按钮 参数为
- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    //按钮初始 {0,}
    CGFloat buttonX = DOT_COORDINATE;
    //遍历标题按钮宽度 数组 设置按钮
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, DOT_COORDINATE, [widths[index] floatValue], NAV_TAB_BAR_HEIGHT);
        //添加标题
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        //设置标题颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //关联事件
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        //添加到滚动试图
        [_navgationTabBar addSubview:button];
        //将按钮添加到一个数组内
        [_items addObject:button];
        //改变下一个按钮的偏移量
        buttonX += [widths[index] floatValue];
    }
    
    //初始显示导航线为1
    [self showLineWithButtonWidth:[widths[0] floatValue]];
    //返回滚动试图总宽
    return buttonX;
}

//为下滑按钮添加手势
- (void)addTapGestureRecognizer
{
    //创建点击事件
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(functionButtonPressed)];
    //添加点击事件
    [_arrowButton addGestureRecognizer:tapGestureRecognizer];
}

- (void)itemPressed:(UIButton *)button
{
    NSInteger index = [_items indexOfObject:button];
    [_delegate itemDidSelectedWithIndex:index];
}

//变更菜单栏的BOOL 并执行代理方法
- (void)functionButtonPressed
{
    //变更菜单栏的BOOL值
    _popItemMenu = !_popItemMenu;
    //代理参数 菜单栏显示的BOOL 菜单栏的高度
    [_delegate shouldPopNavgationItemMenu:_popItemMenu height:[self popMenuHeight]];
}
//获取标题按钮的宽度数组
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles)
    {
        //通过字体获取大小
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        //获取宽度
        NSNumber *width = [NSNumber numberWithFloat:size.width + 40.0f];
        [widths addObject:width];
    }
    
    return widths;
}

//设置试图的影子半径 以及不透明度
//radius 半径  opacity 不透明度
- (void)viewShowShadow:(UIView *)view shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity
{
    //设置试图 影子半径
    view.layer.shadowRadius = shadowRadius;
    //设置试图 影子透明度
    view.layer.shadowOpacity = shadowOpacity;
}
//判断 返回一个菜单栏的高度
- (CGFloat)popMenuHeight
{
    //0
    CGFloat buttonX = DOT_COORDINATE;
    //44
    CGFloat buttonY = ITEM_HEIGHT;
    //窗口高度 - 20 - 44 - 44
    CGFloat maxHeight = SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - NAV_TAB_BAR_HEIGHT;
    
    for (NSInteger index = 0; index < [_itemsWidth count]; index++)
    {
        buttonX += [_itemsWidth[index] floatValue];
        
        @try {
            if ((buttonX + [_itemsWidth[index + 1] floatValue]) >= SCREEN_WIDTH)
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
    
    buttonY = (buttonY > maxHeight) ? maxHeight : buttonY;
    return buttonY;
}

//下拉按钮
- (void)popItemMenu:(BOOL)pop
{
    //判断下拉栏是否为空
    if (pop)
    {
        [self viewShowShadow:_arrowButton shadowRadius:DOT_COORDINATE shadowOpacity:DOT_COORDINATE];
        //动画开始
        [UIView animateWithDuration:0.5f animations:^{
            //隐藏滚动试图
            _navgationTabBar.hidden = YES;
            //旋转图片向上
            _arrowButton.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f animations:^{
                //判断下拉菜单 若为空开始加载
                if (!_popView)
                {
                    //大小(0,navigationBar高度,屏幕宽度,?)
                    _popView = [[SCPopView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, self.frame.size.height - NAVIGATION_BAR_HEIGHT)];
                    //设置代理
                    _popView.delegate = self;
                    //赋值按钮标题数组 同时会触发 SCPopViewDelegate 方法
                    _popView.itemNames = _itemTitles;
                    //将下拉栏添加到自定义table 主视图上
                    [self addSubview:_popView];
                }
                //显隐性设置 NO 显示
                _popView.hidden = NO;
            }];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            //设置显隐性
            _popView.hidden = !_popView.hidden;
            //旋转下拉按钮图片
            _arrowButton.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //设置tabBar滚动试图显隐性
            _navgationTabBar.hidden = !_navgationTabBar.hidden;
            //设置下滑按钮的 阴影
            [self viewShowShadow:_arrowButton shadowRadius:20.0f shadowOpacity:20.0f];
        }];
    }
}

#pragma mark -
#pragma mark - Public Methods
//外界自定义下滑按钮图片
- (void)setArrowImage:(UIImage *)arrowImage
{
    //设置下滑按钮图片 (若图片为空保持原有的)
    _arrowImage = arrowImage ? arrowImage : _arrowImage;
    _arrowButton.image = _arrowImage;
}



//外界改变选中按钮的索引值
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    //获取按钮
    UIButton *button = _items[currentItemIndex];
    //判断是否存在下滑按钮  获取滚动试图的宽度
    CGFloat flag = _canPopAllItemMenu ? (SCREEN_WIDTH - ARROW_BUTTON_WIDTH) : SCREEN_WIDTH;
    
    //如所以按钮 未在显示区域 执行滚动
    if (button.frame.origin.x + button.frame.size.width > flag)
    {
        //计算偏移量
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
        //判断是否为最后一个按钮 不是偏移量多移动40
        if (_currentItemIndex < [_itemTitles count] - 1)
        {
            offsetX = offsetX + 40.0f;
        }
        //滚动试图进行偏移 YES动画
        [_navgationTabBar setContentOffset:CGPointMake(offsetX, DOT_COORDINATE) animated:YES];
    }
    else
    {
        //不做改变
        [_navgationTabBar setContentOffset:CGPointMake(DOT_COORDINATE, DOT_COORDINATE) animated:YES];
    }
    
    //动画导航线条执行动画
    [UIView animateWithDuration:0.2f animations:^{
        //重新设置导航线条位置
        _line.frame = CGRectMake(button.frame.origin.x + 2.0f, _line.frame.origin.y, [_itemsWidth[currentItemIndex] floatValue] - 4.0f, _line.frame.size.height);
    }];
}


//更新数据tabBar 数据
- (void)updateData
{
    //下滑按钮的颜色
    _arrowButton.backgroundColor = self.backgroundColor;
    
//获取标题按钮的宽度数组
    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
    //判断数组是否为空
    if (_itemsWidth.count)
    {
        //布局按钮 并获取滚动试图总宽
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        //设置滚动试图内容 试图大小
        _navgationTabBar.contentSize = CGSizeMake(contentWidth, DOT_COORDINATE);
    }
}

#warning --疑问判定BOOL 是否有效
//点击下拉按钮 触发事件
- (void)refresh
{
    //加载下滑栏
    [self popItemMenu:_popItemMenu];
}

#pragma mark - SCFunctionView Delegate Methods
#pragma mark -
//代理方法 下滑栏的代理方法
- (void)itemPressedWithIndex:(NSInteger)index
{
    //执行代理方法
    [self functionButtonPressed];
    //执行代理方法  输入菜单栏按钮的tag值
    [_delegate itemDidSelectedWithIndex:index];
}

@end
