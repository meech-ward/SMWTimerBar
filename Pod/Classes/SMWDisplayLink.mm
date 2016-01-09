//
//  SMWCADisplayLink.m
//  SMWCADisplayLink
//
//  Created by Sam Meech Ward on 2016-01-08.
//  Copyright © 2016 Meech-Ward. All rights reserved.
//

#import "SMWDisplayLink.h"
#include <queue>

@interface SMWDisplayLink() {
    CFTimeInterval _lastStep;
    
    /// Any time increments to be added to the current time offset for fast forward purposes.
    std::queue<CFTimeInterval> _timeOffsetIncrements;
}

@property (strong, nonatomic) CADisplayLink *timer;

/// An array of the run loop modes to add the timer to.
@property (strong, nonatomic) NSArray<NSString *> *runLoopModes;

/// The current time spent on the animation.
@property (nonatomic) CFTimeInterval currentDuration;

/// The frame interval of the timer.
@property (nonatomic) NSInteger frameInterval;

@end

@implementation SMWDisplayLink

@synthesize duration = _duration;

- (instancetype)init {
    return [self initWithDuration:0.0 frameInterval:1 stepBlock:nil runLoopModes:nil];
}

- (instancetype)initWithDuration:(CFTimeInterval)duration frameInterval:(NSInteger)frameInterval stepBlock:(SMWDisplayLinkStep)stepBlock runLoopModes:(NSArray<NSString *> *)runLoopModes {
    self = [super init];
    if (self) {
        self.duration = duration;
        self.stepBlock = stepBlock;
        self.runLoopModes = runLoopModes;
        self.frameInterval = frameInterval;
    }
    return self;
}

- (void)startTimer {
    // Stop the timer if it's already running
    [self stopTimer];
    
    // Start the timer
    _lastStep = CACurrentMediaTime();
    self.currentDuration = 0;
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(step:)];
    _timer.frameInterval = _frameInterval;
    
    // Add the timer to the passed in run loops, or the default if none are passed in
    if (!_runLoopModes) {
        self.runLoopModes = @[NSDefaultRunLoopMode];
    }
    for (NSString *runLoopMode in _runLoopModes) {
        [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:runLoopMode];
    }
}

- (void)updateTimeOffset {
    // Calculate the time change
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - _lastStep;
    _lastStep = thisStep;
    
    // Update the time offset
    self.currentDuration = MIN(_currentDuration + stepDuration, _duration);
    
    // Check for any time offset increments
    if (!_timeOffsetIncrements.empty()) {
        self.currentDuration += _timeOffsetIncrements.front();
        _timeOffsetIncrements.pop();
    }
}

- (void)step:(CADisplayLink *)timer {
    [self updateTimeOffset];
    
    // Get the percentage of animation completion
    CGFloat percent = (_currentDuration / _duration)*100.0;
    
    // Perform animation updates
    if (_stepBlock) {
        _stepBlock(percent);
    }
    
    // Stop the timer if we've reached the end
    if (_currentDuration >= _duration) {
        if ([_delegate respondsToSelector:@selector(displayLink:didCompleteAnimationWithDuration:)]) {
            [_delegate displayLink:self didCompleteAnimationWithDuration:_duration];
        }
        [self stopTimer];
    }
}

- (void)stopTimer {
    [_timer invalidate];
    self.timer = nil;
}

- (void)pauseTimer {
    _timer.paused = YES;
}

- (void)resumeTimer {
    _lastStep = CACurrentMediaTime();
    _timer.paused = NO;
}

- (void)fastForward:(CFTimeInterval)duration animated:(BOOL)animated {
    if (!animated) {
        self.currentDuration+=duration;
        return;
    }
    
    // Animate over quater of a second
    CGFloat framesPerSecond = 60.0/_timer.frameInterval;
    CGFloat frames = framesPerSecond/4.0;
    for (int i = 0; i < frames; ++i) {
        _timeOffsetIncrements.emplace(duration/frames);
    }
}

@end
