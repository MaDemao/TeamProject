//
//  LANCommonDiseaseListModel.h
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LANCommonDiseaseListModel : NSObject
//请求key值：commonDiseaseList 返回数组

@property(nonatomic,copy)NSString *dataId;//医学科目分类id 通过分类id获取具体疾病分类
@property(nonatomic,copy)NSString *dataName;//医学科目名：比如内科，外科

@property(nonatomic,copy)NSString *Pic;

//@property(nonatomic,copy)NSString *twoType;//该key值返回一个数组，里面装字典，各种属于所点科目的疾病分类
@property(nonatomic,strong)NSMutableArray *twoTypeArray;










@end
