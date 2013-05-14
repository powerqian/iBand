//
//  BBTickView.m
//  BeatBuilder
//
//  Created by Parker Wightman on 7/27/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import "BBTickView.h"

@interface BBTickView ()

@property (nonatomic, strong) UIView *tick;

@end

@implementation BBTickView

- (void) awakeFromNib
{
    self.currentTick = 0;
    self.tick = [[UIView alloc] init];
    self.tick.backgroundColor = [UIColor blackColor];
    [self addSubview:self.tick];
}

- (void) layoutSubviews {
    NSUInteger ticks = [self.delegate ticksForTickView:self];
    
    CGRect rect = self.frame;
    
    float width  = rect.size.width / ticks;
    float height = rect.size.height;
    float x      = width * self.currentTick;
    float y      = 0;
    
    self.tick.frame = CGRectMake(x, y, width, height);
}

@end
