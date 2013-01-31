//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Michael Seganti on 1/27/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingCardDeck * deckOfCards;
@end

@implementation CardGameViewController

// getter for the deckOfCards property

- (PlayingCardDeck *) deckOfCards {
    if (!_deckOfCards) _deckOfCards = [[PlayingCardDeck alloc] init];
    return _deckOfCards;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        Card * currentCard = [self.deckOfCards drawRandomCard];
        
        if (currentCard) {
            [sender setTitle:currentCard.contents forState: UIControlStateSelected];
            self.flipCount++;
        }
        else {
            [sender setTitle:@"🚫" forState:UIControlStateSelected];
            self.flipsLabel.text = @"The deck is empty";
            
            
            UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"All out of cards!"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"Deal again!", nil];
            
            [myAlert show];
            /* Solution from Piazza
             
             //  Set deck to nil and flipCount back to 0
             self.myDeck = nil;
             [selfsetFlipCount:0];
             */
            
        }
    }
   
}

@end
