//
//  SMWTimerBarSection.h
//  Pods
//
//  Created by Sam Meech Ward on 2016-01-04.
//
//

#import <Foundation/Foundation.h>

@class SMWTimerBarView;

NS_ASSUME_NONNULL_BEGIN

@interface SMWTimerBarSection : NSObject

/**
 Create a new `SMWTimerBarSection` instance.
 @param frame The frame of the section layers.
 @param barView The bar view to add the section to.
 @return The new `SMWTimerBarSection` instance.
 */
- (instancetype)initWithFrame:(CGRect)frame barView:(SMWTimerBarView *)barView NS_DESIGNATED_INITIALIZER;

/// The bar view to add the layers to
@property (weak, nonatomic) SMWTimerBarView *barView;

/// The layer that controls the color and image of the background.
@property (strong, nonatomic, readonly) CALayer *backgroundLayer;
/// The layer that controls The color and animation of the timer.
@property (strong, nonatomic, readonly) CAShapeLayer *timerLayer;
/// The layer that sets the divider.
@property (strong, nonatomic, readonly) CAShapeLayer *dividerLayer;

/// The frame of the section.
@property (nonatomic) CGRect frame;


/// Remove the current section layers from the bar view.
- (void)removeFromBar;

/// Reset all the layers to their original appearance.
- (void)reset;


- (void)animateTimerLayerWithDuration:(NSTimeInterval)time key:(nullable NSString *)key completion:(nullable void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END