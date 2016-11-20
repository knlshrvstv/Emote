//
//  KSUtility.h
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KSUtility : NSObject

+(BOOL)isInternetAvailable;
+(void)showErrorWithMessage:(NSString*)errorMessage onViewController:(UIViewController*)viewController;

@end
