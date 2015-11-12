//
//  MDMUserInfo.h
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/10.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "AVObject.h"
#import <AVOSCloud/AVOSCloud.h>

@interface MDMUserInfo : AVObject <AVSubclassing>

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) AVFile *image;
@property (nonatomic, copy) NSString *personality;

@end
