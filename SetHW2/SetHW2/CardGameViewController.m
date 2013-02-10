//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Michael Seganti on 1/27/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame * game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameSelector;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                         usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (void) setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnPlayable;
        cardButton.alpha = (card.isUnPlayable ? 0.3 : 1.0);
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultLabel.text = self.game.resultString;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;

    // Disable the UISegmentedControl here
    if (self.gameSelector.userInteractionEnabled) {
        self.gameSelector.userInteractionEnabled = NO;
        self.gameSelector.alpha = 0.3;
    }
    
    [self updateUI];
}

// Deal Button Action to reset the game
- (IBAction)dealCards:(UIButton *)sender
{
    self.game = nil;
    self.flipCount = 0;
    
    // Enable the UISegmentedControl here
    if (!self.gameSelector.userInteractionEnabled) {
        self.gameSelector.userInteractionEnabled = YES;
        self.gameSelector.alpha = 1.0;
    }

    [self updateUI];
}

// This selects the 2 Card or 3 Card Game
- (IBAction)selectGame:(UISegmentedControl *)sender
{
    self.resultLabel.text = [[NSString alloc] initWithFormat:@"Selected %@", (sender.selectedSegmentIndex == 0) ? @"2 Card Game" : @"3 Card Game"];
    
    self.game.gameMode = sender.selectedSegmentIndex;
}


@end
