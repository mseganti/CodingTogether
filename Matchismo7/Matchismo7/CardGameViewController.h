//
//  CardGameViewController.h
//  Matchismo7
//
//  Created by Michael Seganti on 2/23/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

// all of the following methods must be overriden by concrete subclasses
- (Deck *)createDeck; // abstract
@property (readonly, nonatomic) NSUInteger startingCardCount; // abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card; // abstract

@end
