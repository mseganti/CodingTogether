//
//  CMMotionManager+Shared.m
//  KitchenSinkCM
//
//  Created by Michael Seganti on 3/27/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "CMMotionManager+Shared.h"

@implementation CMMotionManager (Shared)

// Created a Category on the CMMotionManager Class called Shared.
// Extended the class to include this Class Method

+ (CMMotionManager *)sharedMotionManager
{
    /* Non - Thread safe version
    static CMMotionManager *shared = nil;
    if (!shared) shared = [[CMMotionManager alloc] init];
    return shared;
     */
    
    // Use dispatch_once instead
    static CMMotionManager *shared = nil;
    
    // All threads will block until one thread succeeds
    // The rest will get the shared instance
    
    if (!shared) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shared = [[CMMotionManager alloc] init];
        });
    }
    return shared;
   
}

@end
