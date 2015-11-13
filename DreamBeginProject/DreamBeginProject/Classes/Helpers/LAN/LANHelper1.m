//
//  LANHelper1.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "LANHelper1.h"

@interface LANHelper1 ()
@property(nonatomic,strong)NSDictionary *dataDic;

@end


@implementation LANHelper1


+(instancetype)shareHelper1{
    static LANHelper1 *helper = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        helper = [LANHelper1 new];
    });
    return helper;
}


-(void)requestDataWithUrl:(NSString *)url{
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURL *Url = [NSURL URLWithString:url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
         NSLog(@"=============%@",rootDict);
        
        self.dataDic = rootDict;
        
        self.result(self.dataDict);
        
        
    }];
    
    
    
    [dataTask resume];

    
    
    
}

//-(NSDictionary *)requestDataWithUrl:(NSString *)url result:(myBlock)result{
//    
//    
//    
//    
//    
//}


-(NSDictionary *)dataDict{
    
    return [_dataDic copy];
    
}

-(NSDictionary *)dataDic{
    if (_dataDic == nil) {
        self.dataDic = [[NSDictionary alloc]init];
    }
    return _dataDic;
}




@end
