//
//  NetworkIndicatorHelper.m
//  SPoTCD
//
//  Created by Michael Seganti on 3/12/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "NetworkIndicatorHelper.h"

@interface NetworkIndicatorHelper()
@property (readwrite, atomic) NSUInteger count; // use atomic to make sure it's thread safe
@end

@implementation NetworkIndicatorHelper
static NetworkIndicatorHelper *networkIndicatorHelper;

+ (void) setNetworkActivityIndicatorVisible:(BOOL) visible{
    if(!networkIndicatorHelper){
        networkIndicatorHelper = [[NetworkIndicatorHelper alloc]init];
    }
    if(visible){
        networkIndicatorHelper.count++;
    }else{
        networkIndicatorHelper.count--;
        networkIndicatorHelper.count= networkIndicatorHelper.count<0 ? 0:networkIndicatorHelper.count;
    }
    if(networkIndicatorHelper.count > 0){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }else{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

+ (BOOL) networkActivityIndicatorVisible{
    return networkIndicatorHelper.count > 0 ? YES : NO;
}

@end
