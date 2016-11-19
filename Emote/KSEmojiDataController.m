//
//  KSEmojiDataController.m
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import "KSEmojiDataController.h"
#import "KSWebServiceController.h"
#import "KSEmoji.h"

@implementation KSEmojiDataController

static NSString * const fetchEmojisURL = @"https://api.github.com/emojis";

-(void)fetchEmojisFromAPIWithCompletion:(void (^)(NSArray *emojis, NSError *error))completion
{
    KSWebServiceController *webServiceController = [[KSWebServiceController alloc] init];
    [webServiceController httpGetFromURL:[NSURL URLWithString:fetchEmojisURL] completion:^(NSData *data, NSError *error) {
        if (data)
        {
            NSArray *emojis = [self convertEmojiDataToArray:data];
            
            if (emojis)
            {
                if (completion) completion(emojis, nil);
            }
            else
            {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: NSLocalizedString(@"Data provided by the web service was invalid.", nil)
                                           };
                error = [NSError errorWithDomain:@"KSEmoteJSONDataErrorDomain"
                                                     code:101
                                                 userInfo:userInfo];
                
                if (completion) completion(nil, nil);
            }
        }
        else if (error)
        {
            if (completion) completion(nil, error);
        }
    }];
}

-(NSArray*)convertEmojiDataToArray:(NSData*)emojiData
{
    NSError *jsonSerializationError = nil;
    NSMutableArray *emojisArray = [NSMutableArray new];
    
    NSDictionary *emojisDictionary = [NSJSONSerialization JSONObjectWithData:emojiData options:NSJSONReadingMutableContainers error:&jsonSerializationError];
    
    if (jsonSerializationError)
    {
        return nil;
    }
    else
    {
        for (NSString *emojiName in emojisDictionary.allKeys)
        {
            [emojisArray addObject:[[KSEmoji alloc] initWithName:emojiName URL:[NSURL URLWithString:emojisDictionary[emojiName]]]];
        }
    }
    
    return emojisArray;
}

@end
