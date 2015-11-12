//
//  LANHelper.h
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^myBlock)(void);

@interface LANHelper : NSObject

@property(nonatomic,strong)NSMutableArray *allDataArray;

+(instancetype)shareHelper;

-(void)requestData;



@end
