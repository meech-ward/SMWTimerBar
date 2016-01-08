//
//  SMWTimerBarView.h
//  Pods
//
//  Created by Sam Meech Ward on 2016-01-04.
//
//

#import <UIKit/UIKit.h>

@class SMWTimerBarSection;
@protocol SMWTimerBarViewDelegate;

typedef NS_ENUM(NSUInteger, SMWTimerBarViewState) {
    SMWTimerBarViewStateNormal, // Setup and ready to animate
    SMWTimerBarViewStateAnimating, // Animating
    SMWTimerBarViewStatePaused, // Animation paused
    SMWTimerBarViewStateCompletedAnimation, // Animation complete
};

IB_DESIGNABLE

NS_ASSUME_NONNULL_BEGIN

/// The view that displays the countdown animations.
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

/// Reset the sections.
- (void)reset;

/// The number of sections that appear in the bar.
@property (nonatomic) IBInspectable NSInteger numberOfSections;

/// An array of the section objects.
@property (strong, nonatomic, readonly) NSArray<SMWTimerBarSection *> *sections;


/// The colors of each background segment.
@property (strong, nonatomic) NSArray<UIColor *> *backgroundColors;
/// The colors of each forground segment, the peice that animates down.
@property (strong, nonatomic) NSArray<UIColor *> *timerColors;
/// The color of each divider between the segments.
@property (strong, nonatomic) NSArray<UIColor *> *dividerColors;
/// The image of each segments.
@property (strong, nonatomic) NSArray<UIImage *> *images;


/// The section that is currently being animated
@property (strong, nonatomic, nullable) SMWTimerBarSection *animatingSection;

/// @name Timer

/// The total countdown time, in seconds.
@property (nonatomic) NSTimeInterval time;

/// YES when the bar is animating its countdown. NO otherwise.
@property (nonatomic) SMWTimerBarViewState state;

/// Start the countdown animation
- (void)startAnimating;

/// Pause any of the section animations.
- (void)pauseAnimations;

/// Un pause any of the section animations.
- (void)resumeAnimations;

/// Stop any of the section animations.
- (void)stopAnimations;


/// @name Protocols

@property (weak, nonatomic) id <SMWTimerBarViewDelegate> delegate;

@end


/// The protocol used to notify objects of happenings in the timer bar view.
@protocol SMWTimerBarViewDelegate <NSObject>

/**
 Called when a section will start it's countdown animation.
 @param timerBarView The view controling the countdown.
 @param section The number of the section that will count down.
 */
- (void)timerBarView:(SMWTimerBarView *)timerBarView willCountdownSection:(NSInteger)section;
/**
 Called when a section has finished it's countdown animation.
 @param timerBarView The view controling the countdown.
 @param section The number of the section that just counted down.
 */
- (void)timerBarView:(SMWTimerBarView *)timerBarView didCountdownSection:(NSInteger)section;
/**
 Called when the entire view has finished it's countdown animation.
 @param timerBarView The view controling the countdown.
 */
- (void)timerBarViewDidFinishCountdown:(SMWTimerBarView *)timerBarView;

@end

NS_ASSUME_NONNULL_END