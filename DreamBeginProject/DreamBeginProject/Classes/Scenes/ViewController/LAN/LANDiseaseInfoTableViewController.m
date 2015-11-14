//
//  LANDiseaseInfoTableViewController.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "LANDiseaseInfoTableViewController.h"
#import "LANDiseaseInfoCell.h"
#import "LANDiseaseTypeModel.h"
#import "LANGrugModel.h"
#import "LANInfoModel.h"

#import "LANDrugVC.h"
#import "LANInfoVC.h"


#import <UIImageView+WebCache.h>

@interface LANDiseaseInfoTableViewController ()

@property(nonatomic,strong)NSMutableArray *drugArray;

@property(nonatomic,strong)NSMutableArray *infoArray;


@end

@implementation LANDiseaseInfoTableViewController


static NSString *const cellID1 = @"DiseaseInfo";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LANDiseaseInfoCell" bundle:nil] forCellReuseIdentifier:cellID1];
    //self.tableView.showsVerticalScrollIndicator = NO;
    [self requestData];
    
    [self setExtraCellLineHidden:self.tableView];
    
    [self.tableView reloadData];
    
}


//tableView参数为要隐藏单元格线的tableView
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)requestData{
    

    NSString *urlStr = [NSString stringWithFormat:
                        @"http://api.lkhealth.net/index.php?r=drug/diseaseown&diseaseId=%@&uid=&lat=40.036326&lng=116.350313",self.diseaseTypeModel.dataId];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
       // NSLog(@"=============%@",rootDict);
        
        NSDictionary *dict = [rootDict objectForKey:@"data"];
        for (NSDictionary *dic1 in dict[@"drugList"]) {
            
            LANGrugModel *model = [LANGrugModel new];
            [model setValuesForKeysWithDictionary:dic1];
            [self.drugArray addObject:model];
            
        }
        
        
        
        for (NSDictionary *dic2 in dict[@"newsList"]) {
          
            LANInfoModel *model = [LANInfoModel new];
            [model setValuesForKeysWithDictionary:dic2];
            [self.infoArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    
            
    }];
    
        
        
         [dataTask resume];
        
        
        
    
}
    






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return @"注意事项";
    }
    if (section == 1) {
        return @"相关用药";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return self.infoArray.count;
    }else if (section == 1){
        return self.drugArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LANDiseaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1 forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        LANInfoModel *model = self.infoArray[indexPath.row];
        cell.LANDiseaseInfoTitleLabel.text = model.infoTitle;
        cell.LANDiseaseInfoDetailLabel.text= model.infoContent;
        [cell.LANDiseaseInfoImageView sd_setImageWithURL:[NSURL URLWithString:model.infoLogo]];
        
          return cell;
    }else if (indexPath.section == 1) {
        
        
        LANGrugModel *model = self.drugArray[indexPath.row];
        cell.LANDiseaseInfoTitleLabel.text = model.drugName;
        [cell.LANDiseaseInfoImageView sd_setImageWithURL:[NSURL URLWithString:model.drugPic]];
        cell.LANDiseaseInfoDetailLabel.text = model.promotionInfo;
       
        return cell;
        
    }
    
    
    
    return nil;
    
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }if (indexPath.section == 1) {
        return 110;
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //点击效果
     [[tableView cellForRowAtIndexPath:indexPath]setSelected:NO animated:YES];
    
    if (indexPath.section == 0) {
        
        LANInfoModel *model = self.infoArray[indexPath.row];
        LANInfoVC *infoVC = [[LANInfoVC alloc]init];
        infoVC.infoModel = model;
        
        UINavigationController *infoNC = [[UINavigationController alloc]initWithRootViewController:infoVC];
        
        [self.navigationController presentViewController:infoNC animated:YES completion:nil];
       
    } else if (indexPath.section == 1) {
        
        LANGrugModel *model = self.drugArray[indexPath.row];
        LANDrugVC *drugVC = [[LANDrugVC alloc]init];
        drugVC.drugModel = model;
        
        UINavigationController *drugNC = [[UINavigationController alloc]initWithRootViewController:drugVC];
        
        
        
        [self.navigationController presentViewController:drugNC animated:YES completion:nil];
        
        
    }
    
    
    
    
    
}

- (NSMutableArray *)drugArray{
    
    
    if (_drugArray == nil) {
        self.drugArray = [NSMutableArray array];
    }
    return _drugArray;
}

- (NSMutableArray *)infoArray{
    
    if (_infoArray == nil) {
        self.infoArray = [NSMutableArray array];
    }
    return _infoArray;
}
 


@end
