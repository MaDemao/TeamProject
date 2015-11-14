//
//  LANTableViewController.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "LANTableViewController.h"
#import "LANHelper.h"
#import "LANCommonDiseaseListModel.h"
#import "LANDiseaseTypeModel.h"
#import "LANDiseaseTypeCell.h"

#import "LANDiseaseInfoTableViewController.h"



@interface LANTableViewController ()

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *dataArray2;



@end



@implementation LANTableViewController


static NSString *const cellID = @"DiseaseType";

- (instancetype)init
{
    if (self  = [super init]) {
        self.title = @"常见病症";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"4.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
     [self.tableView registerNib:[UINib nibWithNibName:@"LANDiseaseTypeCell"bundle:nil] forCellReuseIdentifier:cellID];

    [[LANHelper shareHelper]requestData];
    
    self.dataArray = [LANHelper shareHelper].allDataArray;
    self.dataArray2 = ((LANCommonDiseaseListModel *)[self.dataArray objectAtIndex:0]).twoTypeArray;
    //tableView分割线颜色
    [self.tableView setSeparatorColor:[UIColor blackColor]];
        
    [self.tableView reloadData];
    
   
    
    
}




-(void)showMenu{
    
    if (_menu.isOpen)
        return [_menu close];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.dataArray.count; i++) {
        LANCommonDiseaseListModel *model = [self.dataArray objectAtIndex:i];
        REMenuItem *item = [[REMenuItem alloc]initWithTitle:model.dataName image:nil highlightedImage:nil action:^(REMenuItem *item) {
            self.navigationItem.title = model.dataName;
            self.dataArray2 = model.twoTypeArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
            
        }];
       
        [array addObject:item];
        
    }
    

    _menu = [[REMenu alloc] initWithItems:array];
    _menu.cornerRadius = 4;
    _menu.shadowColor = [UIColor blackColor];
    _menu.shadowOffset = CGSizeMake(0, 1);
    _menu.shadowOpacity = 1;
    _menu.imageOffset = CGSizeMake(5, -1);
    
    [_menu showFromNavigationController:self.navigationController];
    
}




- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
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

    return self.dataArray2.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LANDiseaseTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    LANDiseaseTypeModel *model =[self.dataArray2 objectAtIndex:indexPath.row];
    
    
    
    cell.LANTitleLabel.text = model.dataName;
    //
//    if (indexPath.row %2 == 0) {
//        
//         cell.backgroundColor= [UIColor orangeColor];
//    } else {
//        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    LANDiseaseTypeModel *model = [self.dataArray2 objectAtIndex:indexPath.row];
    
    LANDiseaseInfoTableViewController *disInfoVC = [[LANDiseaseInfoTableViewController alloc]init];
    disInfoVC.diseaseTypeModel = model;
    
    //push时隐藏tabbar
    disInfoVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:disInfoVC animated:YES];
    
}


-(NSMutableArray *)dataArray2{
    
    if (_dataArray2 == nil) {
        self.dataArray2 = [NSMutableArray array];
    }
    return _dataArray2;
}

@end
