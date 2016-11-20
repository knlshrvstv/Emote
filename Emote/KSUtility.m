//
//  KSUtility.m
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import "KSUtility.h"
#import "Reachability.h"

@implementation KSUtility

+(BOOL)isInternetAvailable
{
    return [Reachability reachabilityForInternetConnection].currentReachabilityStatus != NotReachable;
}

+(void)showErrorWithMessage:(NSString*)errorMessage onViewController:(UIViewController*)viewController
{
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [errorAlert addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:errorAlert animated:YES completion:nil];
    });
}

@end
