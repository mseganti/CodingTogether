//
//  SuperCardViewController.m
//  SuperCard
//
//  Created by Michael Seganti on 2/23/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "SuperCardViewController.h"
#import "PlayingCardView.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface SuperCardViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@property (strong, nonatomic) Deck *deck;
@end

@implementation SuperCardViewController


- (Deck *)deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (void)setPlayingCardView:(PlayingCardView *)playingCardView
{
    _playingCardView = playingCardView;
    [self drawRandomPlayingCard];
    
    // Add the Gesture for Pinch
    [playingCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]
                                           initWithTarget:playingCardView action:@selector(pinch:)]];
}

- (void)drawRandomPlayingCard
{
    Card *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[PlayingCard class]]){
        PlayingCard *playingCard = (PlayingCard *)card;
        self.playingCardView.rank = playingCard.rank;
        self.playingCardView.suit = playingCard.suit;
    }
}
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    
    // Added an Animated Flip
    [UIView transitionWithView:self.playingCardView
                      duration:0.5
                      options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{   // The Code Block to be executed between the two flip states
                        if (!self.playingCardView.faceUp) [self drawRandomPlayingCard];
                        self.playingCardView.faceUp =- !self.playingCardView.faceUp;
                    } completion:NULL];
    
    
}
@end
