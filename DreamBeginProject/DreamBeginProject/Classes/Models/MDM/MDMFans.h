//
//  MDMFans.h
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/14.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "AVObject.h"
#import <AVSubclassing.h>
#import "MDMUserInfo.h"

@interface MDMFans : AVObject <AVSubclassing>

@property (nonatomic, strong) MDMUserInfo *fromInfo;
@property (nonatomic, strong) MDMUserInfo *toInfo;
@property (nonatomic, copy) NSString *date;

@end
