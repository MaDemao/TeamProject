//
//  BJ_FirstTableViewController.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "BJ_FirstTableViewController.h"
#import "IanScrollView.h"
#import "BJ_HomeTableViewCell.h"
#import "Networking.h"
#import "BJ_Homepage.h"
#import "BJ_projectTableViewCell.h"
#import "SDRefresh.h"
#import "BJ_HaveProjectTableViewController.h"
#import "BJ_detailsPageViewController.h"
#import "SDRefreshFooterView.h"
#import "SDRefreshView.h"






@interface BJ_FirstTableViewController ()
@property (nonatomic, copy) ianScrollViewCurrentIndex ianCurrentIndex;

@property(nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic ,strong)NSMutableArray *titleArray;

@property (nonatomic, assign)NSInteger special_id;

@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)NSArray *titles;
//获取网址
@property (nonatomic ,strong)NSString *urlString;
#pragma mark --1--
//第三方
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
//总页数
@property (nonatomic ,strong)NSString *total_pages;
//当前页数
@property(nonatomic,assign)NSInteger pageIndex;

//
@property(nonatomic,strong) BJ_Homepage *model;


@end

@implementation BJ_FirstTableViewController
static NSString *const cellID = @"cell";
static NSString *const cellTwiID = @"cellTwo";
//重写初始化方法
- (instancetype)initWithURLString:(NSString *)url{
    
    if (self = [super init]) {
        
        self.urlString = url;
        

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.tableView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 49 - 64 - 40 );
    //关闭默认的44高度
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:28/255.0 green:187/255.0 blue:45/255.0 alpha:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BJ_HomeTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"BJ_projectTableViewCell" bundle:nil] forCellReuseIdentifier:cellTwiID];
   
    [self loadData];
    [self setExtraCellLineHidden:self.tableView];
    [self addHeader];
    
    
    
    
    
#pragma mark --2--
    //默认为1
    _pageIndex = 1;
    //加载第三方
    //添加头部控件
    //
    [self setupHeader];
    [self setupFooter];
}

//tableView初始加载无数据时，不显示单元格线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
  UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --解析数据
- (void)loadData
{

        [[Networking shareNetworking]networkingGetWithURL:self.urlString Block:^(id object) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *dict1 = dict[@"data"];
            self.total_pages = dict1[@"total_pages"];
           
            NSArray *array = dict1[@"items"];
            
            for (NSDictionary *dic in array) {
                BJ_Homepage *model = [BJ_Homepage new];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
                [self.refreshFooter endRefreshing];
            });
            
            
            
            }];
  
}
- (void)setupHeader
{

    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    __weak typeof(self) weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
            [weakSelf.tableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader autoRefreshWhenViewDidAppear];
    
}

- (void)setupFooter
{
   
    
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}


- (void)footerRefresh
{
    
#pragma mark --3--
    
    _pageIndex ++;
   
    //判断当pageindex 大于总页数的时候结束
    if (_pageIndex > [self.total_pages intValue]) {
        [self.refreshFooter endRefreshing];
        
        return;
    }
 
    NSString *url = [NSString stringWithFormat:@"http://dxy.com/app/i/columns/article/recommend?ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&items_per_page=10&mc=8c86141d0947ea82472ff29157b5783b8a996503&page_index=%ld&vc=4.0.8",(long)_pageIndex];
    
    self.urlString = url;
    [self loadData];

    }

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BJ_Homepage *model;
    model = self.dataArray[indexPath.row];
    _model = model;
    if (_model.special_id) {
        BJ_projectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTwiID forIndexPath:indexPath];
        cell.model = _model;
        
        return cell;
    }else{
        BJ_HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.model = _model;
        return cell;
    }
    

  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
#pragma mark --添加区头
- (void)addHeader
{
    IanScrollView *scrollView = [[IanScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"http://img.dxycdn.com/dotcom/2015/06/15/59/oispicfs.jpg"]];
    [array addObject:[NSString stringWithFormat:@"http://img.dxycdn.com/dotcom/2015/11/04/57/qpjzoeio.gif"]];
    [array addObject:[NSString stringWithFormat:@"http://img.dxycdn.com/dotcom/2015/11/09/23/jhegmxfg.png"]];
    [array addObject:[NSString stringWithFormat:@"http://img.dxycdn.com/dotcom/2015/10/23/44/qekwlwae.jpg"]];
    scrollView.slideImagesArray = array;
    
    scrollView.ianCurrentIndex = ^(NSInteger index) {
        self.currentIndex = index;
        [self.label removeFromSuperview];
        [self drawLable];
    };
    //点击了哪张图片
    scrollView.userInteractionEnabled = YES;
    scrollView.ianEcrollViewSelectAction = ^(NSInteger i){
   
        if (i == 0) {
            _special_id = 194;
        }else if (i == 1){
            _special_id = 9;
        }else if (i == 2){
            _special_id = 184;
        }else{
            _special_id = 129;
        }
        NSString *str = [NSString stringWithFormat:@"http://dxy.com/app/i/columns/article/list?ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&items_per_page=10&mc=8c86141d0947ea82472ff29157b5783b8a996503&order=publishTime&page_index=%d&special_id=%ld&vc=4.0.8",1,(long)_special_id];
        BJ_HaveProjectTableViewController *haveProjectVC = [[BJ_HaveProjectTableViewController alloc]initWithURL:str];
        
        
        
        haveProjectVC.special_id = _special_id;
        
        haveProjectVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:haveProjectVC animated:YES];
        
    };
    scrollView.PageControlPageIndicatorTintColor = [UIColor colorWithRed:255/255.0f green:244/255.0f blue:227/255.0f alpha:1];
    scrollView.pageControlCurrentPageIndicatorTintColor = [UIColor colorWithRed:67/255.0f green:174/255.0f blue:168/255.0f alpha:1];
    scrollView.autoTime = [NSNumber numberWithFloat:4.0f];
    [scrollView startLoading];
    self.tableView.tableHeaderView = scrollView;
    [self drawLable];
    
}

- (void)drawLable{
    NSArray *array = @[@"孩子发烧问题",@"关爱老年人健康",@"糖尿病怎么治疗",@"宝宝吃饭香"];
    self.titleArray = [[NSMutableArray alloc]initWithArray:array];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(20, 160, 200, 40)];
    self.label.numberOfLines = 3 ;
    self.label.font =[UIFont systemFontOfSize:20];
    self.label.textColor = [UIColor whiteColor];
//        self.titleLable.textAlignment = nste
    self.label.text = self.titleArray[_currentIndex];
  
    [self.tableView addSubview:self.label];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _model = self.dataArray[indexPath.row];
    if (_model.special_id) {
        
        NSString *str = [NSString stringWithFormat:@"http://dxy.com/app/i/columns/article/list?ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&items_per_page=10&mc=8c86141d0947ea82472ff29157b5783b8a996503&order=publishTime&page_index=%d&special_id=%ld&vc=4.0.8",1,_model.special_id];
        BJ_HaveProjectTableViewController *haveProjectVC = [[BJ_HaveProjectTableViewController alloc]initWithURL:str];
        
      
        
        haveProjectVC.special_id = _model.special_id;
        
        haveProjectVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:haveProjectVC animated:YES];
    }else{
        BJ_detailsPageViewController *detailsPageVC = [[BJ_detailsPageViewController alloc]init];
        detailsPageVC.ID = _model.ID;
        
        detailsPageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailsPageVC animated:YES];
   
}
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]initWithCapacity:20];
        
    }
    return _dataArray;
}

@end
