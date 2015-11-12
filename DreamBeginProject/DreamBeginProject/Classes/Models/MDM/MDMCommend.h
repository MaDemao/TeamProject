//
//  MDMCommend.h
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/12.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "AVObject.h"
#import "MDMPost.h"
#import "MDMUserInfo.h"
#import <AVOSCloud/AVOSCloud.h>
@interface MDMCommend : AVObject<AVSubclassing>
@property (nonatomic, strong) MDMPost *post;
@property (nonatomic, strong) MDMUserInfo *info;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *date;
@end
