//
//  MDMPost.h
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/11.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "AVObject.h"
#import "MDMUserInfo.h"
#import <AVOSCloud/AVOSCloud.h>

@interface MDMPost : AVObject<AVSubclassing>

@property (nonatomic, strong) MDMUserInfo *info;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSMutableArray *images;

@end
