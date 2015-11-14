//
//  BJ_projectTableViewController.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/11.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "BJ_projectTableViewController.h"
#import "Networking.h"
#import "BJ_Project.h"
#import "BJ_SecondProjectTableViewCell.h"
#import "SDRefresh.h"



@interface BJ_projectTableViewController ()
@property(nonatomic ,strong)NSMutableArray *dataArray;
//第三方
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property(nonatomic,assign)NSInteger pageIndex;
//总页数
@property (nonatomic ,strong)NSString *total_pages;
@end

@implementation BJ_projectTableViewController
static NSString *const cellID = @"cell";
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.tableView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 49 - 64 - 40 );
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
   _pageIndex = 1;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BJ_SecondProjectTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];

    //加载第三方
    //添加头部控件
    //
    [self setupHeader];
    [self setupFooter];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 49 - 64 - 40 );
//}

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
    NSLog(@"aa%d",a);
    
    if (_pageIndex > a) {
        [self.refreshFooter endRefreshing];
        return;
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *url = [NSString stringWithFormat:@"http://dxy.com/app/i/columns/special/list?ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&items_per_page=10&mc=8c86141d0947ea82472ff29157b5783b8a996503&page_index=%ld&vc=4.0.8",(long)_pageIndex];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
           
            NSDictionary *dic = dict[@"data"];
            
            NSArray *array = dic[@"items"];
            for (NSDictionary *dict in array) {
                BJ_Project *project = [BJ_Project new];
                [project setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:project];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
            
            
        }];
        
        [self.refreshFooter endRefreshing];
        
        
        [dataTask resume];
    });
}

- (void)loadData{
    [[Networking shareNetworking]networkingGetWithURL:kBaseUrlWithProject Block:^(id object) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dic = dict[@"data"];
        self.total_pages = dic[@"total_pages"];
        
       
        NSArray *array = dic[@"items"];
        for (NSDictionary *dict in array) {
            BJ_Project *project = [BJ_Project new];
            [project setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:project];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
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
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   BJ_SecondProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    
    

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BJ_detailsPageViewController *details = [BJ_detailsPageViewController new];
    
//    details.ID = [self.dataArray[indexPath.row] ID];
    
    details.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:details animated:YES];
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
        self.dataArray = [[NSMutableArray alloc]initWithCapacity:20];
    }
    return _dataArray;
}
@end
