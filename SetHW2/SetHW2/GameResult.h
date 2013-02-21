//
//  GameResult.h
//  Set
//
//  Created by Michael Seganti on 2/20/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults; // of GameResult

@property (readonly, nonatomic)NSDate *start;
@property (readonly, nonatomic)NSDate *end;
@property (readonly, nonatomic)NSTimeInterval duration;
@property (nonatomic) int score;

@end
