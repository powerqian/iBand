//
//  BBGridView.h
//  BeatBuilder
//
//  Created by Parker Wightman on 7/26/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBGridViewDelegate;
@protocol BBGridViewDataSource;

@interface BBGridView : UIView

@property (nonatomic, weak) IBOutlet id<BBGridViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet id <BBGridViewDataSource> datasource;

@end

@protocol BBGridViewDelegate <NSObject>

- (void)gridView:(BBGridView *)gridView wasSelectedAtRow:(NSUInteger)row column:(NSUInteger)column;

- (BOOL)gridView:(BBGridView *)gridView isSelectedAtRow:(NSUInteger)row column:(NSUInteger)column;

@end

@protocol BBGridViewDataSource <NSObject>

- (NSUInteger)rowsForGridView:(BBGridView *)gridView;

- (NSUInteger)gridView:(BBGridView *)gridView columnsForRow:(NSUInteger)row;

@end