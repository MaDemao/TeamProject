//
//  LANCommonDiseaseListModel.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "LANCommonDiseaseListModel.h"
#import "LANDiseaseTypeModel.h"


@implementation LANCommonDiseaseListModel



-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
  
    if ([key isEqualToString:@"twoType"]) {
    
        for (NSDictionary *dic in value) {
            LANDiseaseTypeModel *typeModel = [LANDiseaseTypeModel new];
            
            [typeModel setValuesForKeysWithDictionary:dic];
            [self.twoTypeArray addObject:typeModel];
            
        }
        
    }
    
    //NSLog(@"%@",key);
    
}


//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"%@", _dataName];
//}


-(NSMutableArray *)twoTypeArray{
    
    
    if (_twoTypeArray == nil) {
        self.twoTypeArray = [NSMutableArray array];
    }
    
    return _twoTypeArray;
}




@end
