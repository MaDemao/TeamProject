//
//  MDMUserHelper.h
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/10.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDMMyUser.h"
#import "MDMUserInfo.h"

typedef void(^postBlock)(void);

@interface MDMUserHelper : NSObject

@property (nonatomic, strong) MDMMyUser *currentUser;

@property (nonatomic, strong) NSMutableArray *postArray;
@property (nonatomic, strong) postBlock thePostBlock;

+ (instancetype)sharedMDMUserHelper;

- (void)requestPostData;

@end
