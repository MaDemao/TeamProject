//
//  BJ_allTableViewController.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/11.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "BJ_allTableViewController.h"
#import "Networking.h"
#import "BJ_HomeTableViewCell.h"
#import "BJ_projectTableViewCell.h"

@interface BJ_allTableViewController ()
@property(nonatomic, strong)NSMutableArray *dataArray;
//第三方
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property(nonatomic,assign)NSInteger pageIndex;
//总页数
@property (nonatomic ,strong)NSString *total_pages;

@property (nonatomic, strong)BJ_Homepage *model;
@end

@implementation BJ_allTableViewController
static NSString *const cellID = @"cell";
static NSString *const cellSeconID = @"cellTwo";
-(instancetype)initWithUrl:(NSString *)url{
    if (self =[super init]) {
        _url = url;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.tableView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 49 - 64 - 40 );
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"BJ_HomeTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    _pageIndex = 1;
    [self.tableView registerNib:[UINib nibWithNibName:@"BJ_projectTableViewCell" bundle:nil] forCellReuseIdentifier:cellSeconID];
    [self loadData];
    //加载第三方
    //添加头部控件
    //
    [self setupHeader];
    [self setupFooter];
   
}
- (void)loadData{
    [[Networking shareNetworking]networkingGetWithURL:[_url stringByAppendingFormat:@"%ld",self.pageIndex] Block:^(id object) {
        
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
    _pageIndex ++;
    
    
    if (_pageIndex > [self.total_pages intValue]) {
        [self.refreshFooter endRefreshing];
        return;
    }
    
    
   
    
    
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
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _model = self.dataArray[indexPath.row];
    if (_model.special_id) {
         BJ_projectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellSeconID forIndexPath:indexPath];
        cell.model = _model;
        return cell;
    }
    else{
        BJ_HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.model = _model;
         return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _model = self.dataArray[indexPath.row];
    
    if (_model.special_id) {
        
        NSString *str = [NSString stringWithFormat:@"http://dxy.com/app/i/columns/article/list?ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&items_per_page=10&mc=8c86141d0947ea82472ff29157b5783b8a996503&order=publishTime&page_index=1&special_id=%ld&vc=4.0.8",_model.special_id];
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
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
@end
