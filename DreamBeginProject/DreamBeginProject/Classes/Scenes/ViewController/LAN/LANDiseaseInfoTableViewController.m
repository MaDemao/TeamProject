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

#import <UIImageView+WebCache.h>

@interface LANDiseaseInfoTableViewController ()

@property(nonatomic,strong)NSMutableArray *drugArray;

@property(nonatomic,strong)NSMutableArray *infoArray;


@end

@implementation LANDiseaseInfoTableViewController


static NSString *const cellID1 = @"DiseaseInfo";

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self requestData];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LANDiseaseInfoCell" bundle:nil] forCellReuseIdentifier:cellID1];
    //[self requestData];
    
    
    [self.tableView reloadData];
    
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
        NSLog(@"=============%@",rootDict);
        
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
