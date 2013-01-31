//
//  Card.h
//  Matchismo
//
//  Created by Michael Seganti on 1/27/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong,nonatomic) NSString *contents;

@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnPlayable) BOOL unplayable;

- (int)match:(NSArray *)otherCards;
@end
