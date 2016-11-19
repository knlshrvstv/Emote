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

#pragma mark - View controller life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupEmojiImage];
    [self setupEmojiImageAnimationWhilePresenting:YES];
    [self setupEmojiImageScaleAnimationWhilePresenting:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.emojiLabel.text = _emoji.name;
}

#pragma mark - View setup
-(void)setupEmojiImage
{
    _emojiImageView = [[UIImageView alloc] initWithFrame:_emojiRootPostion];
    _emojiImageView.image = _emoji.image;
    [self.view addSubview:_emojiImageView];
}

-(void)setupEmojiImageAnimationWhilePresenting:(BOOL)presenting
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
    [emojiImageBasicAnimation setValue:@(presenting) forKey:@"emojiImageBasicAnimation"];
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
    [emojiImageBasicAnimation setValue:@(presenting) forKey:@"setupEmojiImageScaleAnimation"];
    
    [_emojiImageView.layer addAnimation:emojiImageBasicAnimation forKey:nil];
    _emojiImageView.contentScaleFactor = toValue;
}

#pragma mark - IBAction
- (IBAction)closeButtonAction:(id)sender {
    
    [self setupEmojiImageAnimationWhilePresenting:NO];
    [self setupEmojiImageScaleAnimationWhilePresenting:NO];
}

#pragma mark - CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if([[anim valueForKey:@"emojiImageBasicAnimation"] isEqual:@(NO)])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
