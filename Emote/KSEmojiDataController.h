//
//  KSEmojiDataController.h
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSEmojiDataController : NSObject

-(void)fetchEmojisFromAPIWithCompletion:(void (^)(NSArray *emojis, NSError *error))completion;

@end
