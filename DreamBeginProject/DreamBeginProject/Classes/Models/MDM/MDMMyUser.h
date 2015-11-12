//
//  MDMMyUser.h
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/10.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "AVObject.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MDMUserInfo.h"
@interface MDMMyUser : AVUser<AVSessionDelegate>

@property (nonatomic, strong) MDMUserInfo *info;

@end
