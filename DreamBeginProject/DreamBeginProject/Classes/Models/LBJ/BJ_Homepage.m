//
//  BJ_Homepage.m
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "BJ_Homepage.h"

@implementation BJ_Homepage
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        
        self.ID = [value intValue];
//        self.ID =(int)value;;
        
        
//        NSLog(@"bbbbbb%ld",_special_id);
    }
    
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,%ld", _title,_ID];
}
@end
