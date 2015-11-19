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

- (void)requestPostDataWithPage:(NSInteger)page
{
    if (page == 0) {
        [self.myPostArray removeAllObjects];

        AVQuery *query = [MDMPost query];
        [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
            self.totilPage = number / 7;
//            self.currentPage = 0;
        }];
    }
    
    
    self.currentPage++;

    
    AVQuery *query = [MDMPost query];
    [query orderByDescending:@"date"];
    [query includeKey:@"images"];
    query.limit = 7;
    query.skip = 7 * (self.currentPage - 1);
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        [self.myPostArray removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myPostArray addObjectsFromArray:objects];
            self.thePostBlock();
        });
    }];
}

+ (void)collectOfBJ:(NSInteger)theId title:(NSString *)title
{
    MDMCollect *collect = [MDMCollect object];
    collect.theId = [NSString stringWithFormat:@"%ld", theId];
    collect.type = @"BJ";
    collect.info = [MDMUserHelper sharedMDMUserHelper].currentUser.info;
    collect.title = title;
    [collect save];
}

+ (BOOL)isCollectOfBJ:(NSInteger)theId
{
    AVQuery *query1 = [MDMCollect query];
    [query1 whereKey:@"type" equalTo:@"BJ"];
    
    AVQuery *query2 = [MDMCollect query];
    [query2 whereKey:@"info" equalTo:[MDMUserHelper sharedMDMUserHelper].currentUser.info];
    
    AVQuery *query3 = [MDMCollect query];
    [query3 whereKey:@"theId" equalTo:[NSString stringWithFormat:@"%ld", theId]];
    
    AVQuery *query = [AVQuery andQueryWithSubqueries:@[query1, query2, query3]];
    NSMutableArray *array = [NSMutableArray array];
    NSError *error = nil;
    [array addObjectsFromArray:[query findObjects:&error]];
    if (error) {
        return NO;
    }
    if (array.count > 0) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)collectOfLAN:(NSString *)theId title:(NSString *)title
{
    MDMCollect *collect = [MDMCollect object];
    collect.theId = theId;
    collect.type = @"LAN";
    collect.info = [MDMUserHelper sharedMDMUserHelper].currentUser.info;
    collect.title = title;
    [collect save];
}

+ (BOOL)isCollectOfLAN:(NSString *)theId
{
    AVQuery *query1 = [MDMCollect query];
    [query1 whereKey:@"type" equalTo:@"LAN"];
    
    AVQuery *query2 = [MDMCollect query];
    [query2 whereKey:@"info" equalTo:[MDMUserHelper sharedMDMUserHelper].currentUser.info];
    
    AVQuery *query3 = [MDMCollect query];
    [query3 whereKey:@"theId" equalTo:theId];
    
    AVQuery *query = [AVQuery andQueryWithSubqueries:@[query1, query2, query3]];
    NSMutableArray *array = [NSMutableArray array];
    NSError *error = nil;
    [array addObjectsFromArray:[query findObjects:&error]];
    if (error) {
        return NO;
    }
    if (array.count > 0) {
        return YES;
    }else{
        return NO;
    }
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
