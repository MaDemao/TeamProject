//
//  MDMCollect.h
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/17.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "AVObject.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MDMUserInfo.h"

@interface MDMCollect : AVObject <AVSubclassing>

@property (nonatomic, copy) NSString *theId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) MDMUserInfo *info;
@property (nonatomic, copy) NSString *title;

@end
