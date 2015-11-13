//
//  Networking.m
//  DouBanTest
//
//  Created by 李响 on 15/6/19.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "Networking.h"


static Networking *network;

@implementation Networking


+(Networking *)shareNetworking{
    
    @synchronized(self){
        
        if (network == nil) {
            
            network = [[Networking alloc]init];
            
        }
        
        return network;
    }
}

-(void)networkingGetWithURL:(NSString *)urlString Block:(Block)block{
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        block(data);
        
    }];
    [dataTask resume];
}


@end
