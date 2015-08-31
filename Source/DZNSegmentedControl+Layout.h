//
//  DZNSegmentedControl+Layout.h
//  Pods
//
//  Created by Bogdan Iusco on 31/08/15.
//
//

#import "DZNSegmentedControl.h"

/**
 Helper method for performing custom layouting.
 */
@interface DZNSegmentedControl (Layout)

/**
 Code block to be called for a custom buttons layouting.
 The NSArray type param contains all segment's buttons to be layouted.
 */
@property (nonatomic, copy, nullable) void(^layoutSegmentButtonsCallback)(NSArray *__nonnull);

/**
 Code block to be called for layouting the selection indicator.
 The UIButton type param represents the currently selected item.
 It should return the frame of the selection indicator.
 */
@property (nonatomic, copy, nullable) CGRect(^selectionIndicatorRectCallback)(UIButton *__nonnull);

/**
 Method to be overriden for performing a buttons custom layout.
 Called only if the layoutSegmentButtonsCallback code block is not implemented.
 */
- (void)layoutSegmentButtons;

/**
 Method to be overriden for computing the frame of the selection indicator.
 @return The new frame of the selection indicator.
 */
- (CGRect)selectionIndicatorRect;

@end
