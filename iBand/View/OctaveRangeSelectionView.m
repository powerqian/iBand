//
//  OctaveRangeSelectionView.h
//  iBand
//
//  Created by Li QIAN on 5/9/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import "OctaveRangeSelectionView.h"

@interface OctaveRangeSelectionView()
@property (nonatomic, strong) UIImageView *keyboardBackground;
@property (nonatomic, strong) UIImageView *maskView;

@property (nonatomic) CGFloat translatedAmount;
@property (nonatomic) CGFloat lastScale;
@property (nonatomic) BOOL needInitialize;
@end


@implementation OctaveRangeSelectionView

#pragma mark - Gesture Handler
static NSUInteger const WHITE_KEYS_NUMBER = 52;
static NSUInteger const MIN_KEY_NUMBER = 4;

- (NSRange)currentRange
{
    int key_count = lround((self.maskView.frame.size.width / self.keyboardBackground.frame.size.width) * WHITE_KEYS_NUMBER);
    int offset = lround( ( (self.maskView.frame.origin.x - self.keyboardBackground.frame.origin.x) / self.keyboardBackground.frame.size.width) * 52);
    return NSMakeRange(offset, key_count);
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{    
    if (gesture.state == UIGestureRecognizerStateChanged) {
//        CGPoint pt = [gesture locationInView:self.maskView];
        CGRect myFrame = self.maskView.frame;
        CGFloat xTranslation = [gesture translationInView:self.maskView].x;
        CGFloat deltaX = xTranslation - self.translatedAmount;
        myFrame.origin.x += deltaX;
        
        if (xTranslation > 0 && (myFrame.origin.x + myFrame.size.width) <= (self.bounds.origin.x + self.bounds.size.width)){
            self.maskView.frame = myFrame;
        } else if (xTranslation > 0) {
            myFrame.origin.x = (self.bounds.origin.x + self.bounds.size.width) - myFrame.size.width;
            self.maskView.frame = myFrame;
        } else if (xTranslation < 0 && myFrame.origin.x >= self.bounds.origin.x) {
            self.maskView.frame = myFrame;
        } else if (xTranslation < 0) {
            myFrame.origin.x = self.bounds.origin.x;
            self.maskView.frame = myFrame;
        }
        self.translatedAmount = xTranslation;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.translatedAmount = 0;
        if (self.delegate != nil) {
            [self.delegate rangeChanged:[self currentRange]];
        }
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.lastScale = gesture.scale;
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGRect newFrame = self.maskView.frame;
        CGPoint center = self.maskView.center;
        CGFloat deltaScale = gesture.scale - self.lastScale;
        newFrame.size.width += deltaScale * 50;
        
        //Bound Checking
        if (newFrame.origin.x < self.keyboardBackground.frame.origin.x) {
            newFrame.origin.x = self.keyboardBackground.frame.origin.x;
        }
        if (newFrame.origin.x + newFrame.size.width > self.keyboardBackground.frame.origin.x + self.keyboardBackground.frame.size.width) {
            newFrame.size.width = self.keyboardBackground.frame.size.width - newFrame.origin.x;
        }
        if (newFrame.size.width < MIN_KEY_NUMBER * self.keyboardBackground.bounds.size.width / WHITE_KEYS_NUMBER) {
            newFrame.size.width = MIN_KEY_NUMBER * self.keyboardBackground.bounds.size.width / WHITE_KEYS_NUMBER;
        }
        
        self.maskView.frame = newFrame;
        self.maskView.center = center;
        self.lastScale = gesture.scale;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.lastScale = 1;
        if (self.delegate != nil) {
            [self.delegate rangeChanged:[self currentRange]];
        }
    }
}

#pragma mark - View Related
- (void) internalInit{
    self.delegate = nil;
    [self setBackgroundColor:[UIColor yellowColor]];
    
    self.keyboardBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keyboardRange.png"]];
    [self addSubview:self.keyboardBackground];

    self.maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1px-translucent.png"]];
    [self addSubview:self.maskView];
    
    //*
    //* Initialize the position of those two view.
    //* This require bounds and frame information,
    //* which is not available at this stage.
    //* Leave the initialization to layoutSubviews.
    //*
    self.needInitialize = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self addGestureRecognizer:pinch];
}

- (void)layoutSubviews
{
    // Some initialization requires frame and bounds information
    if (self.needInitialize) {
        self.keyboardBackground.frame = self.bounds;
        CGRect maskFrame = CGRectZero;
        NSUInteger leftKey = [self.dataSource initialRange].location;
        NSUInteger keyNumber = [self.dataSource initialRange].length;
        CGFloat singleKeyWidth = self.keyboardBackground.bounds.size.width / WHITE_KEYS_NUMBER;
        
        maskFrame.origin.y = 0;
        maskFrame.size.width = singleKeyWidth * keyNumber;
        maskFrame.origin.x = self.frame.origin.x + singleKeyWidth * leftKey;
        maskFrame.size.height = self.frame.size.height;
        self.maskView.frame = maskFrame;
        
        self.needInitialize = NO;
    }
    
    [super layoutSubviews];
}

- (void)awakeFromNib
{
    [self internalInit];
}

- (id) initWithCoder:(NSCoder *)aCoder {
    if( self = [super initWithCoder:aCoder]){
        [self internalInit];
    }
    return self;
}

- (id) initWithFrame:(CGRect)rect{
    if (self = [super initWithFrame:rect]) {
        [self internalInit];
    }
    return self;
}

@end
