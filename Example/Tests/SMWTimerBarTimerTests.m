//
//  SMWTimerBarTimerTests.m
//  SMWTimerBar
//
//  Created by Sam Meech Ward on 2016-01-05.
//  Copyright © 2016 Sam Meech-Ward. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <SMWTimerBar/SMWTimerBarView.h>
#import <SMWTimerBar/SMWTimerBarSection.h>

SpecBegin(TimerBarTimer)

describe(@"Timer bar timing", ^{
    
    describe(@"when animating", ^{
        
        __block SMWTimerBarSection *barSection;
        __block CGRect sectionFrame;
        __block SMWTimerBarView *barView;
        
        beforeAll(^{
            sectionFrame = CGRectMake(0, 0, 30.0, 10.0);
            barView = [[SMWTimerBarView alloc] initWithFrame:CGRectZero numberOfSections:3];
            barSection = [[SMWTimerBarSection alloc] initWithFrame:sectionFrame barView:barView];
            barView.time = 12;
            [barView startAnimating];
        });
        
//        it(@"should be animating", ^{
//            waitUntil(^(DoneCallback done) {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    done();
//                    SMWTimerBarSection *lastSection = barView.sections.lastObject;
//                    expect(lastSection.timerLayer.animationKeys).toNot.equal(nil);
//                    expect(lastSection.timerLayer.animationKeys.count).toNot.beGreaterThan(0);
//                });
//            });
//            
//        });
    });
});

SpecEnd
