//
//  CMMotionManager+Shared.h
//  KitchenSinkCM
//
//  Created by Michael Seganti on 3/27/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

@interface CMMotionManager (Shared)
+ (CMMotionManager *)sharedMotionManager;
@end
