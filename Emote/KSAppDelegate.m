//
//  KSAppDelegate.m
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import "KSAppDelegate.h"

@implementation KSAppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [UIView animateWithDuration:0.5 animations:^{
        self.window.alpha = 0;
    }];
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIView animateWithDuration:0.5 animations:^{
        self.window.alpha = 1;
    }];
}

@end
