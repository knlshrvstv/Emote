//
//  KSEmojiImageDownloader.m
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import "KSEmojiImageDownloader.h"
#import "KSWebServiceController.h"

@interface KSEmojiImageDownloader()

@property(nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation KSEmojiImageDownloader

-(void)startEmojiImageDownloadWithURL:(NSURL*)URL WithCompletion:(void (^)(NSData *data, NSError *error))completion
{
    KSWebServiceController *webServiceController = [[KSWebServiceController alloc] init];
    _dataTask = [webServiceController httpGetFromURL:URL completion:^(NSData *data, NSError *error) {
        if (completion) completion(data, error);
    }];
}

-(void)cancelEmojiImageDownload
{
    [_dataTask cancel];
    _dataTask = nil;
}

@end
