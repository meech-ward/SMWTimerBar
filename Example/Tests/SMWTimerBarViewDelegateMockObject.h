//
//  SMWTimerBarViewDelegateMockObject.h
//  SMWTimerBar
//
//  Created by Sam Meech Ward on 2016-01-05.
//  Copyright © 2016 Sam Meech-Ward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SMWTimerBar/SMWTimerBar.h>

@interface SMWTimerBarViewDelegateMockObject : NSObject <SMWTimerBarViewDelegate>

- (instancetype)initWithBarView:(SMWTimerBarView *)barView;

/// Called when a section will start it's countdown animation.
@property (nonatomic, copy) void (^willCountdownSection)(NSInteger);

/// Called when a section has finished it's countdown animation.
@property (copy, nonatomic) void (^didCountdownSection)(NSInteger);

/// Called when the entire view has finished it's countdown animation.
@property (copy, nonatomic) void (^didFinishCountdown)(void);

@end
