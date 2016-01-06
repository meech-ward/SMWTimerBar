//
//  CALayer+SMWUtility.m
//  Pods
//
//  Created by Sam Meech Ward on 2016-01-05.
//
//

#import "CALayer+SMWUtility.h"

@implementation CALayer (SMWUtility)

- (void)pauseAnimations {
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}

- (void)resumeAniamtions {
    CFTimeInterval pausedTime = [self timeOffset];
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}

@end
