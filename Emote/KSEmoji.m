//
//  KSEmoji.m
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import "KSEmoji.h"

@implementation KSEmoji

-(instancetype)initWithName:(NSString*)name URL:(NSURL*)URL
{
    if (self = [super init])
    {
        self.name = name;
        self.URL = URL;
    }
    
    return self;
}

@end
