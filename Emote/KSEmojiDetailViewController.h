//
//  KSEmojiDetailViewController.h
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSEmoji.h"

@interface KSEmojiDetailViewController : UIViewController

@property(nonatomic, strong) KSEmoji *emoji;
@property(nonatomic, assign) CGRect emojiRootPostion;

@end
