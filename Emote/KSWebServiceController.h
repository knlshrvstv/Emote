//
//  KSWebServiceController.h
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSWebServiceController : NSObject

-(void)httpGetFromURL:(NSURL*)URL completion:(void(^)(NSData *data, NSError *error))completion;

@end
