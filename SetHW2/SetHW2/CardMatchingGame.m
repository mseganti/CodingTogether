//
//  CardMatchingGame.m
//  MatchismoHW1
//
//  Created by Michael Seganti on 1/30/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) NSMutableString *resultString;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}


#define MATCH_BONUS 10
#define MISMATCH_PENALTY 2
#define FLIP_COST 1



- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    
    if (card && !card.isUnPlayable){
        self.resultString =  [[NSMutableString alloc] initWithFormat:@"Flipped up %@", card.contents];
        
        if (!card.isFaceUp){  // Don't try to match if your turning card face down
            
            NSMutableArray *cardsToCompare = [[NSMutableArray alloc] init];
            [cardsToCompare addObject:card];
            
            // Look for any Playable cards that are face up and add them to the comparison array
            for (Card *otherCard in self.cards)
            {
                if (otherCard.isFaceUp && !otherCard.isUnPlayable)
                    [cardsToCompare addObject:otherCard];
            }
            
            // gameMode is 0 for 2 cards, 1 for 3 cards
            if (cardsToCompare.count == self.gameMode + 2) {
                
                int matchScore = [card match:cardsToCompare];  // Create an Array out of othercard
                
                if (matchScore){
                    
                    self.score += matchScore * MATCH_BONUS;
                    self.resultString =  [[NSMutableString alloc] initWithFormat:@"Match Bonus for %d points", matchScore * MATCH_BONUS];
                    
                    for (Card *matchedCard in cardsToCompare) // We have some Matches, make all cards unplayable
                        matchedCard.unplayable = YES;
                    
                    /*
                    // Check remaining Cards for a match, if no matches then Game over!
                    NSMutableArray *remainingCards = [[NSMutableArray alloc] init];
                    for (Card *remainingCard in self.cards){
                        if (!remainingCard.isUnPlayable)
                            [remainingCards addObject:remainingCard];
                    }
                    
                    if (![card match:remainingCards]){
                        for (Card *lastCard in self.cards){
                            if (!lastCard.isUnPlayable){
                                lastCard.unplayable = YES;
                                lastCard.faceUp = YES;
                            }
                        }
                        
                     // No More Matches, end the game!
                        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"All out of cards to Match!"
                                                                          message:nil
                                                                         delegate:self
                                                                cancelButtonTitle:nil
                                                                otherButtonTitles:@"Deal again!", nil];
                        
                        [myAlert show]; 

                    }*/
                    
                } else {
                    
                    self.score -= MISMATCH_PENALTY;
                    self.resultString =  [[NSMutableString alloc] initWithFormat:@"Mismatch Penalty! %d points", MISMATCH_PENALTY];
                    
                    for (Card *otherCard in cardsToCompare) // Only Flip cards other than the current Card
                        if (otherCard != card) otherCard.faceUp = !otherCard.isFaceUp;
                }
                
            }
            
            
        }
        self.score -= FLIP_COST;
            
    }
    card.faceUp = !card.isFaceUp;
}
    

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i=0; i < count; i++) {
            
            Card *card = [deck drawRandomCard];
            
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

@end
