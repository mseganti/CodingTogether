//
//  PlayingCard.h
//  Matchismo
//
//  Created by Michael Seganti on 1/27/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
