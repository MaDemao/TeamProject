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
#define kURL(i)    [NSString stringWithFormat:@"http://dxy.com/app/i/columns/article/list?ac=1d6c96d5-9a53-4fe1-9537-85a33de916f1&items_per_page=10&mc=8c86141d0947ea82472ff29157b5783b8a996503&order=publishTime&page_index=1&special_id=%ld&vc=4.0.8",i]
@interface BJ_HaveProjectTableViewController ()
@property (nonatomic, strong)NSMutableArray *allArray;
@property (nonatomic ,strong)BJ_Homepage *model;
@end

@implementation BJ_HaveProjectTableViewController
static NSString *const cellID = @"cell";
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.tableView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 49 - 64 - 40 );
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self loadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"BJ_HomeTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
   

}

- (void)loadData{
   
   
    
    [[Networking shareNetworking]networkingGetWithURL:kURL(_special_id) Block:^(id object) {
       
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dict1 = dict[@"data"];
        NSArray *array = dict1[@"items"];
        
        for (NSDictionary *dic in array) {
            BJ_Homepage *model = [BJ_Homepage new];
            [model setValuesForKeysWithDictionary:dic];
            [self.allArray addObject:model];
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
    BJ_detailsPageViewController *detailsVC = [[BJ_detailsPageViewController alloc]init];
    detailsVC.ID = _model.ID;
    detailsVC.hidesBottomBarWhenPushed = YES;
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
