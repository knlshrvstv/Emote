//
//  KSWebServiceController.m
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import "KSWebServiceController.h"

@implementation KSWebServiceController

-(void)httpGetFromURL:(NSURL*)URL completionHandler:(void(^)(NSData *data, NSError *error))completion
{
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completion(data, error);
    }];
    
    [dataTask resume];
}

@end
