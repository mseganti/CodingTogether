//
//  CardMatchingGame.h
//  MatchismoHW1
//
//  Created by Michael Seganti on 1/30/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

// Designated Initializer - must use to initialize
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) NSMutableString *resultString;
@property (nonatomic) NSUInteger gameMode;

@end
