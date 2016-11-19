//
//  KSEmojiDetailViewController.m
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import "KSEmojiDetailViewController.h"

@interface KSEmojiDetailViewController ()<CAAnimationDelegate>

@property(nonatomic, strong)  UIImageView *emojiImageView;
@property (weak, nonatomic) IBOutlet UILabel *emojiLabel;

@end

@implementation KSEmojiDetailViewController

static NSString * const emojiPositionAnimationKey = @"emojiImagePositionBasicAnimation";
static NSString * const emojiScaleAnimationKey = @"setupEmojiImageScaleAnimation";

#pragma mark - View controller life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupEmojiImage];
    [self setupEmojiLabel];
    [self setupEmojiImagePositionAnimationWhilePresenting:YES];
    [self setupEmojiImageScaleAnimationWhilePresenting:YES];
    [self setupEmojiLabelOpacityAnimationWhilePresenting:YES];
}

#pragma mark - View setup
-(void)setupEmojiImage
{
    _emojiImageView = [[UIImageView alloc] initWithFrame:_emojiRootPostion];
    _emojiImageView.image = _emoji.image;
    [self.view addSubview:_emojiImageView];
}

-(void)setupEmojiLabel
{
    self.emojiLabel.text = _emoji.name;
}

-(void)setupEmojiImagePositionAnimationWhilePresenting:(BOOL)presenting
{
    CABasicAnimation *emojiImageBasicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    CGPoint fromValue;
    CGPoint toValue;
    
    if (presenting)
    {
        fromValue = CGPointMake(_emojiRootPostion.origin.x, _emojiRootPostion.origin.y);
        toValue = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    }
    else
    {
        fromValue = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        toValue = CGPointMake(_emojiRootPostion.origin.x, _emojiRootPostion.origin.y);
    }
    
    emojiImageBasicAnimation.delegate = self;
    emojiImageBasicAnimation.fromValue = [NSValue valueWithCGPoint:fromValue];
    emojiImageBasicAnimation.toValue = [NSValue valueWithCGPoint:toValue];
    emojiImageBasicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    emojiImageBasicAnimation.duration = 0.8;
    emojiImageBasicAnimation.removedOnCompletion = NO;
    [emojiImageBasicAnimation setValue:@(presenting) forKey:emojiPositionAnimationKey];
    [_emojiImageView.layer addAnimation:emojiImageBasicAnimation forKey:nil];
    
    _emojiImageView.layer.position = toValue;
}

-(void)setupEmojiImageScaleAnimationWhilePresenting:(BOOL)presenting
{
    CABasicAnimation *emojiImageBasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    CGFloat fromValue;
    CGFloat toValue;
    
    if (presenting)
    {
        fromValue = 1.0f;
        toValue = 2.0f;
    }
    else
    {
        fromValue = 2.0f;
        toValue = 0.0f;
    }
    
    emojiImageBasicAnimation.delegate = self;
    emojiImageBasicAnimation.fromValue = @(fromValue);
    emojiImageBasicAnimation.toValue = @(toValue);
    emojiImageBasicAnimation.duration = 0.8;
    emojiImageBasicAnimation.fillMode = kCAFillModeForwards;
    emojiImageBasicAnimation.removedOnCompletion = NO;
    emojiImageBasicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [emojiImageBasicAnimation setValue:@(presenting) forKey:emojiScaleAnimationKey];
    
    [_emojiImageView.layer addAnimation:emojiImageBasicAnimation forKey:nil];
    _emojiImageView.contentScaleFactor = toValue;
}

-(void)setupEmojiLabelOpacityAnimationWhilePresenting:(BOOL)presenting
{
    CGFloat fromValue;
    CGFloat toValue;
    
    if (presenting)
    {
        fromValue = 0.0f;
        toValue = 1.0f;
    }
    else
    {
        fromValue = 1.0f;
        toValue = 0.0f;
    }

    CABasicAnimation *emojiImageBasicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    emojiImageBasicAnimation.fromValue = @(fromValue);
    emojiImageBasicAnimation.toValue = @(toValue);
    emojiImageBasicAnimation.duration = 0.8;
    emojiImageBasicAnimation.fillMode = kCAFillModeForwards;
    emojiImageBasicAnimation.removedOnCompletion = NO;
    emojiImageBasicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [_emojiLabel.layer addAnimation:emojiImageBasicAnimation forKey:nil];
    
}

#pragma mark - IBAction
- (IBAction)closeButtonAction:(id)sender {
    
    [self setupEmojiImagePositionAnimationWhilePresenting:NO];
    [self setupEmojiImageScaleAnimationWhilePresenting:NO];
    [self setupEmojiLabelOpacityAnimationWhilePresenting:NO];
}

#pragma mark - CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if([[anim valueForKey:emojiPositionAnimationKey] isEqual:@(NO)])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
