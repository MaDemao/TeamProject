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
#import "MDMCollect.h"

typedef void(^postBlock)(void);

@interface MDMUserHelper : NSObject

@property (nonatomic, strong) MDMMyUser *currentUser;

@property (nonatomic, strong) NSMutableArray *postArray;
@property (nonatomic, strong) postBlock thePostBlock;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totilPage;

+ (instancetype)sharedMDMUserHelper;

- (void)requestPostDataWithPage:(NSInteger)page;

+ (void)collectOfBJ:(NSInteger)theId
              title:(NSString *)title;

+ (BOOL)isCollectOfBJ:(NSInteger)theId;

+ (void)collectOfLAN:(NSString *)theId
               title:(NSString *)title;

+ (BOOL)isCollectOfLAN:(NSString *)theId;

@end
