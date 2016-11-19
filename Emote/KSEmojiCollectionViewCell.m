//
//  KSEmojiCollectionViewCell.m
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import "KSEmojiCollectionViewCell.h"

@interface KSEmojiCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *emojiImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation KSEmojiCollectionViewCell


#pragma mark - Collection view cell setup
-(void)updateCellWithEmoji:(KSEmoji*)emoji
{
    _emojiImageView.image = emoji.image;
}

-(void)updateCellWithPlaceholder
{
    _emojiImageView.image = [UIImage imageNamed:@"placeholder.png"];
}

#pragma mark - Activity indicator
-(void)showActivityIndicator
{
    [_activityIndicator startAnimating];
}

-(void)hideActivityIndicator
{
    [_activityIndicator stopAnimating];
}

@end
