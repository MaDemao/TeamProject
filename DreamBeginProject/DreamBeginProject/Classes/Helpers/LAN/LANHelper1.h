//
//  LANHelper1.h
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^myBlock)(NSDictionary *);

@interface LANHelper1 : NSObject

@property(nonatomic,copy)myBlock result;
@property(nonatomic,strong)NSDictionary *dataDict;

+(instancetype)shareHelper1;


-(void)requestDataWithUrl:(NSString *)url;

//-(NSDictionary *)requestDataWithUrl:(NSString *)url result:(myBlock)result;


    



@end
