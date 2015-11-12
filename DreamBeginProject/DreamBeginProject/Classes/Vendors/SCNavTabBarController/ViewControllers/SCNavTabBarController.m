//
//  SCNavTabBarController.m
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import "SCNavTabBarController.h"
#import "CommonMacro.h"
#import "SCNavTabBar.h"

@interface SCNavTabBarController () <UIScrollViewDelegate, SCNavTabBarDelegate>
{
    NSInteger       _currentIndex;              // current page index  分段的索引值
    
    NSMutableArray  *_titles;                   // array of children view controller's title  标题的数组
    
    SCNavTabBar     *_navTabBar;                // NavTabBar: press item on it to exchange view  自定义TabBar
    UIScrollView    *_mainView;                 // content view  主滚动式图
}

@end

@implementation SCNavTabBarController

#pragma mark - Life Cycle
#pragma mark -

//是否添加下滑菜单的初始化
- (id)initWithCanPopAllItemMenu:(BOOL)can
{
    self = [super init];
    if (self)
    {
        _canPopAllItemMenu = can;
    }
    return self;
}

//初始化赋值 子试图控制器数组
- (id)initWithSubViewControllers:(NSArray *)subViewControllers
{
    self = [super init];
    if (self)
    {
        _subViewControllers = subViewControllers;
    }
    return self;
}

//初始化  指定俯视图
- (id)initWithParentViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self)
    {
        [self addParentController:viewController];
    }
    return self;
}

//初始化 指定自控制器数组 父试图  是否添加下滑按钮
- (id)initWithSubViewControllers:(NSArray *)subControllers andParentViewController:(UIViewController *)viewController canPopAllItemMenu:(BOOL)can;
{
    self = [self initWithSubViewControllers:subControllers];
    
    _canPopAllItemMenu = can;
    [self addParentController:viewController];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initConfig];
    [self viewConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
#pragma mark -
//初始一些数据
- (void)initConfig
{
    // Iinitialize value 初始化分段显示 值1
    _currentIndex = 1;
    //整个自定义tabbar 条的颜色
    _navTabBarColor = _navTabBarColor ? _navTabBarColor : NavTabbarColor;
    
       // Load all title of children view controllers  添加分段标题到数组
    _titles = [[NSMutableArray alloc] initWithCapacity:_subViewControllers.count];
    
    for (UIViewController *viewController in _subViewControllers)
    {
        [_titles addObject:viewController.title];
    }
}

- (void)viewInit
{
    // Load NavTabBar and content view to show on window
    //初始化自定义tabbar
    _navTabBar = [[SCNavTabBar alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, NAV_TAB_BAR_HEIGHT) canPopAllItemMenu:_canPopAllItemMenu];
    //设置代理
    _navTabBar.delegate = self;
    //设置背景颜色
    _navTabBar.backgroundColor = _navTabBarColor;
    //设置导航线的颜色
    _navTabBar.lineColor = _navTabBarLineColor;
    //赋值标题数组
    _navTabBar.itemTitles = _titles;
    //赋值下拉按钮图片
    _navTabBar.arrowImage = _navTabBarArrowImage;
    //跟新tabbar 数据
    [_navTabBar updateData];
    
    
    //主滚动试图
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, _navTabBar.frame.origin.y + _navTabBar.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - _navTabBar.frame.origin.y - _navTabBar.frame.size.height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)];
    //设置代理
    _mainView.delegate = self;
    //整页反动
    _mainView.pagingEnabled = YES;
    //设置是否边界反弹
    _mainView.bounces = _mainViewBounces;
    //设置隐藏滑条
    _mainView.showsHorizontalScrollIndicator = NO;
    //设置内容试图大小
    _mainView.contentSize = CGSizeMake(SCREEN_WIDTH * _subViewControllers.count, DOT_COORDINATE);
    //主试图添加到跟试图
    [self.view addSubview:_mainView];
    //添加自定义的tabbar
    [self.view addSubview:_navTabBar];
}

- (void)viewConfig
{
    [self viewInit];
    
    //
    // Load children view controllers and add to content view  遍历数组  obj 表示遍历的对象  idx循环变量
    [_subViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        
        UIViewController *viewController = (UIViewController *)_subViewControllers[idx];
        viewController.view.frame = CGRectMake(idx * SCREEN_WIDTH, DOT_COORDINATE, SCREEN_WIDTH, _mainView.frame.size.height);
        //图控制器的跟试图 添加都滚动试图
        [_mainView addSubview:viewController.view];
        //添加控制器为子试图控制器
        [self addChildViewController:viewController];
    }];
}

#pragma mark - Public Methods
#pragma mark -
//tabBar颜色
- (void)setNavTabbarColor:(UIColor *)navTabbarColor
{
    // prevent set [UIColor clear], because this set can take error display
    CGFloat red, green, blue, alpha;
    if ([navTabbarColor getRed:&red green:&green blue:&blue alpha:&alpha] && !red && !green && !blue && !alpha)
    {
        navTabbarColor = NavTabbarColor;
    }
    _navTabBarColor = navTabbarColor;
}

//设置父控制器
- (void)addParentController:(UIViewController *)viewController
{
    // Close UIScrollView characteristic on IOS7 and later
    if ([viewController respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
}

#pragma mark - Scroll View Delegate Methods
#pragma mark -
//代理方法  试图滚动结束
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    _navTabBar.currentItemIndex = _currentIndex;
}

#pragma mark - SCNavTabBarDelegate Methods
#pragma mark -
//tabbar 代理方法 index 为下拉栏内的按钮Tag值
- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    
    [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, DOT_COORDINATE) animated:_scrollAnimation];
}

//点击下拉栏内的按钮触犯发 代理事件
- (void)shouldPopNavgationItemMenu:(BOOL)pop height:(CGFloat)height
{
    if (pop)
    {
        [UIView animateWithDuration:0.5f animations:^{
            _navTabBar.frame = CGRectMake(_navTabBar.frame.origin.x, _navTabBar.frame.origin.y, _navTabBar.frame.size.width, height + NAV_TAB_BAR_HEIGHT);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            _navTabBar.frame = CGRectMake(_navTabBar.frame.origin.x, _navTabBar.frame.origin.y, _navTabBar.frame.size.width, NAV_TAB_BAR_HEIGHT);
        }];
    }
    [_navTabBar refresh];
}

@end
