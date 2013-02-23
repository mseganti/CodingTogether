//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Michael Seganti on 2/23/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic)   NSString *suit;

@property (nonatomic) BOOL faceUp;

@end
