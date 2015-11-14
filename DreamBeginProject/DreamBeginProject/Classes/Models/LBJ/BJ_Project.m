//
//  BJ_Project.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "BJ_Project.h"

@implementation BJ_Project
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = [value intValue];
        
      
    }
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%ld", _ID];
}
@end
