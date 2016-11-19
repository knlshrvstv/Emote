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
    dispatch_async(dispatch_get_main_queue(), ^{
        _emojiImageView.image = emoji.image;
    });
}

-(void)updateCellWithPlaceholder
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _emojiImageView.image = [UIImage imageNamed:@"placeholder.png"];
    });
}

#pragma mark - Activity indicator
-(void)showActivityIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_activityIndicator startAnimating];
    });
    
}

-(void)hideActivityIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_activityIndicator stopAnimating];
    });
}

@end
