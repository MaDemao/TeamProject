//
//  LANInfoModel.h
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LANInfoModel : NSObject

//
//@property(nonatomic,copy)NSString *newsList;//疾病的相关 数组

@property(nonatomic,copy)NSString *infoContent;//例如：临床上表现为巩膜、黏膜、皮肤及其他组织被染成黄色
@property(nonatomic,copy)NSString *infoId;
@property(nonatomic,copy)NSString *infoLogo;
@property(nonatomic,copy)NSString *infoTitle;//例如：什么是黄疸

@property(nonatomic,copy)NSString *infoType;



@end
