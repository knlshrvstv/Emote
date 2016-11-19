//
//  KSEmoji.h
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KSEmoji : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSURL *URL;
@property(nonatomic, strong) UIImage *image;

-(instancetype)initWithName:(NSString*)name URL:(NSURL*)URL;

@end
