//
//  KSSplashViewController.m
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import "KSSplashViewController.h"
#import "KSFallingEmojisView.h"

@interface KSSplashViewController()

@property (weak, nonatomic) IBOutlet UILabel *appTitleLabel;

@end

@implementation KSSplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    KSFallingEmojisView *emojisView = [[KSFallingEmojisView alloc] initWithFrame:self.view.bounds];
    
    [self.view insertSubview:emojisView belowSubview:_appTitleLabel];
}

@end
