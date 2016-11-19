//
//  KSEmojiImageDownloader.h
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSEmoji.h"

@interface KSEmojiImageDownloader : NSObject

-(void)startEmojiImageDownloadWithURL:(NSURL*)URL WithCompletion:(void (^)(NSData *data, NSError *error))completion;
-(void)cancelEmojiImageDownload;

@end
