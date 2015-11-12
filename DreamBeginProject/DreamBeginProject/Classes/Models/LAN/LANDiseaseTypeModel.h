//
//  LANDiseaseTypeModel.h
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LANDiseaseTypeModel : NSObject


//获取key值：科目分类中的twoType

@property(nonatomic,copy)NSString *dataId;//具体疾病id
@property(nonatomic,copy)NSString *dataName;//具体疾病名称：如内科中的急性上呼吸道感染

@property(nonatomic,copy)NSString *dataType;
@property(nonatomic,copy)NSString *isWetHu;





@end
