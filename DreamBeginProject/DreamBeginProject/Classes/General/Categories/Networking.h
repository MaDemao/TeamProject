//
//  Networking.h
//  DouBanTest
//
//  Created by 李响 on 15/6/19.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Block)(id object);

@interface Networking : NSObject


+(Networking *)shareNetworking;

//GET异步请求

-(void)networkingGetWithURL:(NSString *)urlString Block:(Block)block;



@end
