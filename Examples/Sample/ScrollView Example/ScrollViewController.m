//
//  ScrollViewController.m
//  Sample
//
//  Created by Wenchao Ding on 1/24/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

#import "ScrollViewController.h"

#import <DZNSegmentedControl/DZNSegmentedControl.h>
#import <DZNSegmentedControl/UIScrollView+DZNSegmentedControl.h>
#import <DZNSegmentedControl/DZNSegmentedControl+Layout.h>

@interface ScrollViewController () <DZNSegmentedControlDelegate>
@end

@implementation ScrollViewController

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    self.title = NSStringFromClass([DZNSegmentedControl class]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.segmentedControl.items = @[@"Page #1", @"Page #2", @"Page #3"];
    self.segmentedControl.showsCount = NO;
    self.segmentedControl.autoAdjustSelectionIndicatorWidth = NO;
    self.segmentedControl.height = 30;
    

//    Uncomment for performing a custom layout
//    [self useSegmentedControlCustomLayout];

    self.scrollView.segmentedControl = self.segmentedControl;
    self.scrollView.scrollDirection = DZNScrollDirectionVertical;
    self.scrollView.scrollOnSegmentChange = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.clipsToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = [UIScreen mainScreen].bounds;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    __block CGFloat offsetValue = 0.0;
    __block CGSize contentSize = CGSizeZero;

    if (self.scrollView.scrollDirection == DZNScrollDirectionHorizontal) {
        [self.segmentedControl.items enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
            CGRect frame = [UIScreen mainScreen].bounds;
            frame.origin.x = offsetValue;
            
            [self addLabel:idx withFrame:frame];
            
            offsetValue += CGRectGetWidth(frame);
        }];
        
        contentSize = CGSizeMake(offsetValue, self.scrollView.frame.size.height);
    }
    else {
        [self.segmentedControl.items enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
            CGRect frame = [UIScreen mainScreen].bounds;
            frame.origin.y = offsetValue;
            
            [self addLabel:idx withFrame:frame];
            
            offsetValue += CGRectGetHeight(frame);
        }];
        
        contentSize = CGSizeMake(self.scrollView.frame.size.width, offsetValue);
    }
    
    self.scrollView.contentSize = contentSize;
}

- (void)addLabel:(NSInteger)idx withFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    label.backgroundColor = (idx%2 == 0) ? [UIColor redColor] : [UIColor blueColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:40];
    label.text = self.segmentedControl.items[idx];
    
    [self.scrollView addSubview:label];
}


#pragma mark - Events

- (IBAction)didChangeSegment:(id)sender
{
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - View Auto-Rotation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


#pragma mark - View lifeterm

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    
}

#pragma mark - Private methods

- (void)useSegmentedControlCustomLayout {
    __weak typeof(self) weakself = self;

    // Layout buttons
    self.segmentedControl.layoutSegmentButtonsCallback = ^(NSArray *__nonnull buttons) {
        CGFloat padding = 10.f;
        __block CGFloat xCoord = padding;
        [buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            CGSize sizeThatFits = [button sizeThatFits:weakself.segmentedControl.bounds.size];
            CGRect rect = CGRectMake(xCoord, .0f, sizeThatFits.width, CGRectGetHeight(weakself.segmentedControl.bounds));
            [button setFrame:rect];
            xCoord = CGRectGetMaxX(rect) + padding;
            if (idx == weakself.segmentedControl.selectedSegmentIndex) {
                button.selected = YES;
            }
        }];
    };

    // Layout selection indicator
    self.segmentedControl.selectionIndicatorRectCallback = ^(UIButton *__nonnull button) {
        CGRect frame = CGRectZero;
        frame.origin.y = (weakself.segmentedControl.barPosition > UIBarPositionBottom) ? 0.0f : (button.frame.size.height-weakself.segmentedControl.selectionIndicatorHeight);
        frame.size = CGSizeMake(CGRectGetWidth(button.frame), weakself.segmentedControl.selectionIndicatorHeight);
        frame.origin.x = CGRectGetMinX(button.frame);
        return frame;
    };
}

@end
