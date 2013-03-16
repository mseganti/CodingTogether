//
//  NetworkIndicatorHelper.h
//  SPoTCD
//
//  Created by Michael Seganti on 3/12/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkIndicatorHelper : NSObject

+ (void) setNetworkActivityIndicatorVisible:(BOOL) visible;
+ (BOOL) networkActivityIndicatorVisible;

@end
