//
//  CacheNSData.h
//  FastSpot
//
//  Created by Michael Seganti on 3/3/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//
// Borrowed heavily from Felix Vigl

#import <Foundation/Foundation.h>

@interface CacheNSData : NSObject

@property (nonatomic) NSUInteger maxCacheSize;
@property (nonatomic) NSString *cacheDirectory;
@property (nonatomic, readonly) NSUInteger cacheSize;

+ (CacheNSData *)sharedInstance;

- (BOOL)cacheData:(NSData *)data withIdentifier:(NSString *)identifier;

- (NSData *)dataInCacheForIdentifier:(NSString *)identifier;

@end
