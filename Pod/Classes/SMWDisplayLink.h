//
//  SMWCADisplayLink.h
//  SMWCADisplayLink
//
//  Created by Sam Meech Ward on 2016-01-08.
//  Copyright © 2016 Meech-Ward. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

/// A block that should be called upon each interval.
typedef void (^SMWDisplayLinkStep)(CGFloat percentComplete);

NS_ASSUME_NONNULL_BEGIN

@interface SMWDisplayLink : NSObject

/** 
 Create a new SMWDisplayLink instance.
 @param duration The duration of the entire animaiton.
 @param frameInterval The frame interval of the CADisplayLink, set to 1 for 60 fps.
 @param stepBlock The block that will be called upon each screen refresh.
 @param runLoopModes An array of the run loop modes to add the timer to.
 @return A new SMWDisplayLink instance.
 */
- (instancetype)initWithDuration:(CFTimeInterval)duration frameInterval:(NSInteger)frameInterval stepBlock:(nullable SMWDisplayLinkStep)stepBlock runLoopModes:(nullable NSArray<NSString *> *)runLoopModes NS_DESIGNATED_INITIALIZER;

/// The CADisplayLink that controls the timing.
@property (strong, nonatomic, readonly, nullable) CADisplayLink *timer;

/// The block that will be called upon each screen refresh.
@property (strong, nonatomic, nullable) SMWDisplayLinkStep stepBlock;

/// The duration of the entire animaiton.
@property (nonatomic) CFTimeInterval duration;

/// Start / Restart the animation timer.
- (void)startTimer;

/// Stop the animation timer.
- (void)stopTimer;

/// Fast forward the animation by a certain number of seconds.
- (void)fastForward:(CFTimeInterval)duration animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END