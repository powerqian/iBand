//
//  OctaveRangeSelectionView.h
//  iBand
//
//  Created by Li QIAN on 5/9/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OctaveRangeDelegate

- (void) rangeChanged: (NSRange) newRange;

@end

@protocol OctaveRangeDataSource <NSObject>

- (NSRange)initialRange;

@end

@interface OctaveRangeSelectionView : UIView

@property (nonatomic, weak) id <OctaveRangeDelegate> delegate;
@property (nonatomic, weak) id <OctaveRangeDataSource> dataSource;
@end
