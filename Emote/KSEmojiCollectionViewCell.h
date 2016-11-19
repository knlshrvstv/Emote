//
//  KSEmojiCollectionViewCell.h
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSEmoji.h"

@interface KSEmojiCollectionViewCell : UICollectionViewCell

-(void)updateCellWithEmoji:(KSEmoji*)emoji;

-(void)updateCellWithPlaceholder;

-(void)showActivityIndicator;
-(void)hideActivityIndicator;

@end
