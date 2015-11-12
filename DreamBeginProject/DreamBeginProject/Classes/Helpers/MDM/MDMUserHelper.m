//
//  MDMUserHelper.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/10.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "MDMUserHelper.h"
#import "MDMPost.h"

@interface MDMUserHelper ()
@property (nonatomic, strong) NSMutableArray *myPostArray;
@end

@implementation MDMUserHelper

+ (instancetype)sharedMDMUserHelper
{
    static MDMUserHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[MDMUserHelper alloc] init];
    });
    return helper;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.currentUser = nil;
    }
    return self;
}

- (void)requestPostData
{
    AVQuery *query = [MDMPost query];
    [query orderByDescending:@"date"];
    [query includeKey:@"images"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.myPostArray removeAllObjects];
        [self.myPostArray addObjectsFromArray:objects];
        self.thePostBlock();
    }];
}

- (NSMutableArray *)postArray
{
    return [self.myPostArray mutableCopy];
}

- (void)dealloc
{
    [MDMMyUser logOut];
}

- (NSMutableArray *)myPostArray
{
    if (_myPostArray == nil) {
        self.myPostArray = [NSMutableArray array];
    }
    return _myPostArray;
}
@end
