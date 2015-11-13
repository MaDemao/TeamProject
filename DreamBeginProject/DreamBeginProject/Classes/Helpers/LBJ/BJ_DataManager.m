//
//  BJ_DataManager.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "BJ_DataManager.h"
#import "BJ_Homepage.h"
@interface BJ_DataManager()
@property (nonatomic ,strong)NSMutableArray *dataArray;

@end
@implementation BJ_DataManager
+ (instancetype)shareDataManager{
    static BJ_DataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [BJ_DataManager new];
    });
    return manager;
}

- (void)requestWithUrlString:(NSString *)urlString withBlock:(void(^)(NSMutableArray *allArray))result{
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
 
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dict1 = dict[@"data"];
        NSArray *array = dict1[@"items"];
        
        for (NSDictionary *dic in array) {
            BJ_Homepage *model = [BJ_Homepage new];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
            
        }
        result(self.dataArray);
        
    }];
    [dataTask resume];

    
}


- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

@end
