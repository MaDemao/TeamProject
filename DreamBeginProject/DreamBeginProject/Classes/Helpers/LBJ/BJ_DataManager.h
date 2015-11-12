//
//  BJ_DataManager.h
//  DreamBeginProject
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BJ_DataManager : NSObject
+ (instancetype)shareDataManager;

- (void)requestWithUrlString:(NSString *)urlString;
@end
