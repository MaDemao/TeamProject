//
//  BJ_HaveProjectTableViewController.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "BJ_HaveProjectTableViewController.h"
#import "BJ_DataManager.h"
#import "BJ_HomeTableViewCell.h"
#import "BJ_detailsPageViewController.h"
#define kURL(q)    [NSString stringWithFormat:@"http://dxy.com/app/i/columns/article/list?ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&items_per_page=10&mc=8c86141d0947ea82472ff29157b5783b8a996503&order=publishTime&page_index=1&special_id=%ld&vc=4.0.8",q]
@interface BJ_HaveProjectTableViewController ()
@property (nonatomic, strong)NSMutableArray *allArray;
@property (nonatomic ,strong)BJ_Homepage *model;

//获取网址
@property (nonatomic ,strong)NSString *urlString;
@property(nonatomic,strong)NSString *urlTwo;
//第三方
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property(nonatomic,assign)NSInteger pageIndex;
//总页数
@property (nonatomic ,strong)NSString *total_pages;
@end

@implementation BJ_HaveProjectTableViewController
static NSString *const cellID = @"cell";

- (instancetype)initWithURL:(NSString *)str{
    if (self = [super init]) {
        self.urlString = str;
      
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 1;
    [self loadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"BJ_HomeTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    //加载第三方
    //添加头部控件
    //
    [self setupHeader];
    [self setupFooter];
//    self.navigationController.navigationBar.translucent = NO;

}

- (void)loadData{
   
    [[Networking shareNetworking]networkingGetWithURL:self.urlString Block:^(id object) {
       
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dict1 = dict[@"data"];
        NSArray *array = dict1[@"items"];
        self.total_pages = dict1[@"total_pages"];
        for (NSDictionary *dic in array) {
            BJ_Homepage *model = [BJ_Homepage new];
            [model setValuesForKeysWithDictionary:dic];
            [self.allArray addObject:model];
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
    _pageIndex ++;
    int a = [self.total_pages intValue];
   
    if (_pageIndex > a) {
        [self.refreshFooter endRefreshing];
        return;
    }
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    NSString *url = [NSString stringWithFormat:@"http://dxy.com/app/i/columns/article/list?ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&appsign=5600319daf6619ba95cbe07af6d0b270&appuid=1447466343200420322&items_per_page=10&mc=8c86141d0947ea82472ff29157b5783b8a996503&noncestr=166259C93DBA4CFEA16E12839DE12DB0&order=publishTime&page_index=%ld&special_id=%ld&timestamp=1447485246&vc=4.0.8",(long)_pageIndex,(long)_special_id];
   
    
    self.urlString = url;
    [self loadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BJ_HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    _model = self.allArray[indexPath.row];
    cell.model = _model;
  
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //需要重新接收一下model的值 很重要否则会出现刷新同一个页面的现象
    _model = self.allArray[indexPath.row];
    BJ_detailsPageViewController *detailsVC = [[BJ_detailsPageViewController alloc]init];
    detailsVC.ID = _model.ID;
    
//    detailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVC animated:YES];
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
- (NSMutableArray *)allArray{
    if (!_allArray) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
}
@end
