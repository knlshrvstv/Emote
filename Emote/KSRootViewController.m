//
//  KSRootViewController.m
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import "KSRootViewController.h"
#import "KSSplashViewController.h"

@interface KSRootViewController ()

@property(nonatomic, strong) UIViewController *rootViewController;

@end

@implementation KSRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showSplashViewController];
}

-(void)showSplashViewController
{
    KSSplashViewController *splashViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"KSSplashViewController"];
    _rootViewController = splashViewController;
    [splashViewController willMoveToParentViewController:self];
    [self addChildViewController:splashViewController];
    [self.view addSubview:splashViewController.view];
    [splashViewController didMoveToParentViewController:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self loadMainNavigationStack];
    });
}

-(void)loadMainNavigationStack
{
    UIViewController *mainNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"KSMainNavigationController"];
    
    [mainNavigationController willMoveToParentViewController:self];
    [self addChildViewController:mainNavigationController];
    
    [self transitionFromViewController:_rootViewController toViewController:mainNavigationController duration:0.65 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        
    } completion:^(BOOL finished) {
        [mainNavigationController didMoveToParentViewController:self];
    }];
}

@end
