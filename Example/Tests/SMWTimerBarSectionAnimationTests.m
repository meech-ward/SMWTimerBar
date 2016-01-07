//
//  SMWTimerBarSectionAnimationTests.m
//  SMWTimerBar
//
//  Created by Sam Meech Ward on 2016-01-06.
//  Copyright © 2016 Sam Meech-Ward. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <SMWTimerBar/SMWTimerBarView.h>
#import <SMWTimerBar/SMWTimerBarSection.h>
//#import <SMWTimerBar/CALayer+SMWUtility.h>

SpecBegin(TimerBarSectionAnimating)

describe(@"Timer bar section", ^{
    
    describe(@"when animating", ^{
        
        __block SMWTimerBarSection *barSection;
        
        beforeAll(^{
            SMWTimerBarView *barView = [[SMWTimerBarView alloc] initWithFrame:CGRectZero numberOfSections:3];
            barSection = [[SMWTimerBarSection alloc] initWithFrame:CGRectMake(0, 0, 30.0, 10.0) barView:barView];
        });
        
        it(@"is animating at full speed", ^{
            barSection.timerLayer.speed = 1.0;
        });
        
    });
    
});

SpecEnd