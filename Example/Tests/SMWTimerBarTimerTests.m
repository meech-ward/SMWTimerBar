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
#import "SMWTimerBarViewDelegateMockObject.h"

SpecBegin(TimerBarTimer)

static NSMutableSet *strongSet;

beforeAll(^{
    strongSet = [NSMutableSet set];
});

describe(@"Timer bar timing", ^{
    
    describe(@"when animating", ^{
        
        __block SMWTimerBarSection *barSection;
        __block CGRect sectionFrame;
        __block SMWTimerBarView *barView;
        
        beforeEach(^{
            sectionFrame = CGRectMake(0, 0, 30.0, 10.0);
            barView = [[SMWTimerBarView alloc] initWithFrame:CGRectZero numberOfSections:3];
            barSection = [[SMWTimerBarSection alloc] initWithFrame:sectionFrame barView:barView];
            barView.time = 9;
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
//        });

        
        it(@"will be animating", ^{
            expect(barView.state).to.equal(SMWTimerBarViewStateAnimating);
            expect(barView.animatingSection.timerLayer.speed).to.equal(1.0);
        });
        
        describe(@"when pausing and un pausing", ^{
            
            beforeEach(^{
                [barView pauseAnimations];
            });
            
            it(@"will be able to be paused", ^{
                expect(barView.animatingSection.timerLayer.speed).to.equal(0.0);
                
                for (SMWTimerBarSection *section in barView.sections) {
                    expect(section.timerLayer.speed).to.equal(0.0);
                }
                
                expect(barView.sections[0].timerLayer.speed).to.equal(0.0);
                expect(barView.sections[1].timerLayer.speed).to.equal(0.0);
                expect(barView.sections[2].timerLayer.speed).to.equal(0.0);
                
                expect(barView.state).to.equal(SMWTimerBarViewStatePaused);
            });
            
            it(@"will be able to be un paused", ^{
                [barView resumeAnimations];
                expect(barView.state).to.equal(SMWTimerBarViewStateAnimating);
                expect(barView.animatingSection.timerLayer.speed).to.equal(1.0);
                
            });
        });
        
        
        
        it(@"will be able to be stopped", ^{
            [barView stopAnimations];
            [strongSet addObject:barView];
            for (SMWTimerBarSection *section in barView.sections) {
                expect(section.timerLayer.animationKeys).to.equal(nil);
            }
            expect(barView.state).to.equal(SMWTimerBarViewStateNormal);
            expect(barView.animatingSection).to.equal(nil);
        });
        
        describe(@"and has a delegate", ^{
        
            it(@"will call the will countdown section delegate method", ^{
                waitUntil(^(DoneCallback done) {
                    
                    // Setup the bar
                    NSInteger numberOfSections = 3;
                    SMWTimerBarView *bar = [[SMWTimerBarView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 50.0) numberOfSections:numberOfSections];
                    bar.time = 3;
                    
                    // Setup the mock
                    SMWTimerBarViewDelegateMockObject *delegateMock = [[SMWTimerBarViewDelegateMockObject alloc] initWithBarView:bar];
                    [strongSet addObject:delegateMock];
                    [strongSet addObject:bar];
                    
                    // Make sure the delegate method is called
                    __block NSInteger sectionsLeft = numberOfSections;
                    [delegateMock setWillCountdownSection:^(NSInteger section) {
                        expect(section).to.equal(sectionsLeft-1);
                        expect(bar.animatingSection).to.equal(bar.sections[section]);
                        if (--sectionsLeft == 0) {
                            done();
                        }
                    }];
                
                    [bar startAnimating];
                    
                });
            });
            
            it(@"will call the did countdown section delegate method", ^{
                waitUntil(^(DoneCallback done) {
                    
                    // Setup the bar
                    NSInteger numberOfSections = 3;
                    SMWTimerBarView *bar = [[SMWTimerBarView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 50.0) numberOfSections:numberOfSections];
                    bar.time = 3;
                    
                    // Setup the mock
                    SMWTimerBarViewDelegateMockObject *delegateMock = [[SMWTimerBarViewDelegateMockObject alloc] initWithBarView:bar];
                    [strongSet addObject:delegateMock];

                    // Make sure the delegate method is called
                    __block NSInteger sectionsLeft = numberOfSections;
                    [delegateMock setDidCountdownSection:^(NSInteger section) {
                        expect(section).to.equal(sectionsLeft-1);
                        if (--sectionsLeft == 0) {
                            done();
                        }
                    }];
                    
                    [bar startAnimating];
                });
            });
            
            it(@"will call the did finish delegate method", ^{
                waitUntil(^(DoneCallback done) {
                    
                    // Setup the bar
                    NSInteger numberOfSections = 3;
                    SMWTimerBarView *bar = [[SMWTimerBarView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 50.0) numberOfSections:numberOfSections];
                    bar.time = 3;
                    
                    // Setup the mock
                    SMWTimerBarViewDelegateMockObject *delegateMock = [[SMWTimerBarViewDelegateMockObject alloc] initWithBarView:bar];
                    [strongSet addObject:delegateMock];
                    
                    // Make sure the delegate method is called
                    [delegateMock setDidFinishCountdown:^() {
                        expect(YES);
                        done();
                    }];
                    
                    [bar startAnimating];
                });
            });
        });
    });
    
    describe(@"when completed animation", ^{
        
        it(@"will not be animating", ^{
            waitUntil(^(DoneCallback done) {
                // Setup the bar
                SMWTimerBarView *bar = [[SMWTimerBarView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 50.0) numberOfSections:3];
                bar.time = 3;
                
                // Setup the mock
                SMWTimerBarViewDelegateMockObject *delegateMock = [[SMWTimerBarViewDelegateMockObject alloc] initWithBarView:bar];
                [strongSet addObject:delegateMock];
                [strongSet addObject:bar];
                
                //
                [delegateMock setDidFinishCountdown:^() {
                    expect(bar.state).to.equal(SMWTimerBarViewStateCompletedAnimation);
                    expect(bar.animatingSection).to.equal(nil);
                    done();
                }];
                
                [bar startAnimating];
            });
        });
        
        it(@"can reset all sections", ^{
            waitUntil(^(DoneCallback done) {
                
                // Setup the bar
                NSInteger numberOfSections = 3;
                SMWTimerBarView *bar = [[SMWTimerBarView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 50.0) numberOfSections:numberOfSections];
                bar.time = 3;
                SMWTimerBarView *barCopy = [[SMWTimerBarView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 50.0) numberOfSections:numberOfSections];
                barCopy.time = 3;
                
                // Setup the mock
                SMWTimerBarViewDelegateMockObject *delegateMock = [[SMWTimerBarViewDelegateMockObject alloc] initWithBarView:bar];
                [strongSet addObject:delegateMock];
                [strongSet addObject:bar];
                
                //
                [delegateMock setDidFinishCountdown:^() {
                    [bar reset];
                    expect(bar.state).to.equal(SMWTimerBarViewStateNormal);
                    
                    // Make sure the sections are reset
                    [bar.sections enumerateObjectsUsingBlock:^(SMWTimerBarSection * _Nonnull barSection, NSUInteger idx, BOOL * _Nonnull stop) {
                        SMWTimerBarSection *barCopySection = barCopy.sections[idx];
                        expect(barCopySection.timerLayer.frame).to.equal(barSection.timerLayer.frame);
                        expect(barCopySection.backgroundLayer.frame).to.equal(barSection.backgroundLayer.frame);
                        expect(barCopySection.dividerLayer.frame).to.equal(barSection.dividerLayer.frame);
                        done();
                    }];
                }];
                
                [bar startAnimating];
            });
        });
    });
});

SpecEnd
