//
//  CALayer+SMWUtility.h
//  Pods
//
//  Created by Sam Meech Ward on 2016-01-05.
//
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (SMWUtility)

/// Pause any animations on the current layer.
- (void)pauseAnimations;

/// Resume any paused animations on the current layer
- (void)resumeAniamtions;

@end
