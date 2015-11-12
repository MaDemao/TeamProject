//
//  LANHelper.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "LANHelper.h"
#import "LANCommonDiseaseListModel.h"

@interface LANHelper ()

@property(nonatomic,strong)NSMutableArray *allData;

@end


@implementation LANHelper


+(instancetype)shareHelper{
 
    static LANHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [LANHelper new];
    });
    return helper;
}

-(void)requestData{
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LANData" ofType:@"txt"]];
    
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
    
    NSDictionary *dic = [rootDic objectForKey:@"data"];
    NSArray *array = [dic objectForKey:@"commonDiseaseList"];
    
    for (NSDictionary *dict in array) {
        LANCommonDiseaseListModel *model = [LANCommonDiseaseListModel new];
        [model setValuesForKeysWithDictionary:dict];
        [self.allData addObject:model];
        
        
    }
    
    
}


-(NSMutableArray *)allDataArray{
    
    return [self.allData copy];
    
}

-(NSMutableArray *)allData{
    
    if (_allData == nil) {
        self.allData = [NSMutableArray array];
    }
    return _allData;
    
}

@end
