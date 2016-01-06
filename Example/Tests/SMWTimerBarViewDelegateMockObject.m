//
//  SMWTimerBarViewDelegateMockObject.m
//  SMWTimerBar
//
//  Created by Sam Meech Ward on 2016-01-05.
//  Copyright © 2016 Sam Meech-Ward. All rights reserved.
//

#import "SMWTimerBarViewDelegateMockObject.h"

const NSInteger kNumberOfSection = 5;

@interface SMWTimerBarViewDelegateMockObject()

@property (strong, nonatomic) SMWTimerBarView *barView;

@end

@implementation SMWTimerBarViewDelegateMockObject

- (instancetype)initWithBarView:(SMWTimerBarView *)barView
{
    self = [super init];
    if (self) {
        _barView = barView;
        _barView.delegate = self;
    }
    return self;
}

- (void)timerBarView:(SMWTimerBarView *)timerBarView didCountdownSection:(NSInteger)section {
    if (_didCountdownSection) {
        _didCountdownSection(section);
    }
}

- (void)timerBarView:(SMWTimerBarView *)timerBarView willCountdownSection:(NSInteger)section {
    if (_willCountdownSection) {
        _willCountdownSection(section);
    }
}

- (void)timerBarViewDidFinishCountdown:(SMWTimerBarView *)timerBarView {
    if (_didFinishCountdown) {
        _didFinishCountdown();
    }
}

@end
