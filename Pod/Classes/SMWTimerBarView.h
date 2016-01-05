//
//  SMWTimerBarView.h
//  Pods
//
//  Created by Sam Meech Ward on 2016-01-04.
//
//

#import <UIKit/UIKit.h>

@class SMWTimerBarSection;

IB_DESIGNABLE

NS_ASSUME_NONNULL_BEGIN

@interface SMWTimerBarView : UIView

/**
 Create a new instance of SMWTimerBarView.
 @param frame The frame to set the view.
 @param section The number of sections that appear in the bar.
 @return A new `SMWTimerBarView` instace.
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfSections:(NSInteger)sections NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

/// @name Sections

/// The number of sections that appear in the bar.
@property (nonatomic) IBInspectable NSInteger numberOfSections;

/// An array of the section objects.
@property (strong, nonatomic, readonly) NSArray<SMWTimerBarSection *> *sections;


/// The colors of each background segment.
@property (strong, nonatomic) NSArray<UIColor *> *backgroundColors;
/// The image that sits on the background.
//@property (strong, nonatomic) NSArray<UIColor *> *backgroundImages;
/// The colors of each forground segment, the peice that animates down.
@property (strong, nonatomic) NSArray<UIColor *> *timerColors;
/// The color of each divider between the segments.
@property (strong, nonatomic) NSArray<UIColor *> *dividerColors;


/// @name Timer

/// The total countdown time, in seconds.
@property (nonatomic) NSTimeInterval time;

/// Start the countdown animation
- (void)startAnimating;


@end

NS_ASSUME_NONNULL_END