//
//  LANDiseaseInfoModel.h
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LANDiseaseInfoModel : NSObject

//疾病信息，字典
//@property(nonatomic,strong)NSDictionary *deseaseInfoDic;



@property(nonatomic,copy)NSString *content;//例如：黄疸临床上表现为巩膜、黏膜、皮肤及其他组织被染成黄色
@property(nonatomic,copy)NSString *deseaseId;//
@property(nonatomic,copy)NSString *deseaseName;//疾病名称 例如：黄疸
@property(nonatomic,copy)NSString *employeeNum;
@property(nonatomic,copy)NSString *oldDiseaseId;




//药品，返回数组
//@property(nonatomic,strong)NSMutableArray *drugListArray;

//@property(nonatomic,copy)NSString *drugId;//药品id
//@property(nonatomic,copy)NSString *drugName;//药品名
//
//@property(nonatomic,copy)NSString *drugPic;//药品图片
//@property(nonatomic,copy)NSString *promotionInfo;//药品介绍



//
//@property(nonatomic,copy)NSString *newsList;//疾病的相关 数组
//@property(nonatomic,strong)NSMutableArray *newsListArray;
//@property(nonatomic,copy)NSString *infoContent;//例如：临床上表现为巩膜、黏膜、皮肤及其他组织被染成黄色
//@property(nonatomic,copy)NSString *infoId;
//@property(nonatomic,copy)NSString *infoLogo;
//@property(nonatomic,copy)NSString *infoTitle;//例如：什么是黄疸
//
//@property(nonatomic,copy)NSString *infoType;















@end
